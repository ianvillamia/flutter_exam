# Flutter Exam — Location Tracker

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

A Flutter application that polls the device GPS every 5 seconds, calculates the distance to a hidden target coordinate, and persists every reading locally using Hive.

<p align="center">
  <img src="assets/demo.gif" alt="App demo" width="320"/>
</p>

---

## Quick Start

All common tasks are available via `make`. Run `make help` to see the full list.

### First-time setup

```sh
make rebuild   # clean → flutter pub get → code generation
```

---

## Architecture Overview

The project follows **Clean Architecture**, separating code into three concentric layers that depend strictly inward:

```
Presentation  →  Domain  ←  Data
```

- **Presentation** knows about Domain — it calls use cases and reads entities.
- **Data** knows about Domain — it implements repository contracts and maps models to entities.
- **Domain** knows nothing about the outside world — no Flutter, no Hive, no Geolocator.

---

## Project Structure

```
lib/
├── app/
│   ├── app.dart                        # Barrel export
│   ├── app_module.dart                 # Dependency injection (flutter_modular)
│   └── view/
│       └── app.dart                    # AppWidget — MultiBlocProvider + MaterialApp
│
├── features/
│   └── tracking/
│       ├── data/
│       │   ├── datasources/
│       │   │   ├── tracking_remote_datasource.dart   # API contract + stub impl
│       │   │   ├── location_local_datasource.dart    # Geolocator wrapper
│       │   │   └── tracking_storage_service.dart     # Hive read/write datasource
│       │   ├── models/
│       │   │   ├── location_reading_hive_model.dart  # Hive object + TypeAdapter
│       │   │   └── target_location_model.dart        # dart_mappable model, extends entity
│       │   └── repositories/
│       │       └── tracking_repository_impl.dart     # Implements domain contract
│       │
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── target_location_entity.dart      # Pure target data (Equatable)
│       │   │   └── location_reading_entity.dart     # GPS reading snapshot (Equatable)
│       │   ├── repositories/
│       │   │   └── tracking_repository.dart         # Abstract contract
│       │   └── usecases/
│       │       └── get_target_location_usecase.dart
│       │
│       └── presentation/
│           ├── cubit/
│           │   ├── tracking_cubit.dart   # Business logic + timer
│           │   └── tracking_state.dart   # Single copyWith state class
│           ├── pages/
│           │   └── tracking_page.dart    # Scaffold + AppBar action
│           └── widgets/
│               ├── toggle_card.dart
│               ├── filter_row.dart
│               ├── readings_list.dart
│               ├── reading_card.dart
│               ├── empty_state.dart
│               ├── status_banner.dart
│               └── clear_confirmation_dialog.dart
│
└── bootstrap.dart   # Hive init, nb_utils init, BlocObserver
```

---

## Domain Layer

The domain layer is pure Dart with zero dependencies on Flutter, packages, or infrastructure.

### Entities

Entities are the core data objects of the application. They extend `Equatable` so that value comparison works correctly with BLoC state management.

**`TargetLocationEntity`** — the hidden target fetched from the API.
```dart
class TargetLocationEntity extends Equatable {
  final String id;
  final double targetLat;
  final double targetLng;
}
```

**`LocationReadingEntity`** — a single GPS snapshot captured during tracking.
```dart
class LocationReadingEntity extends Equatable {
  final DateTime timestamp;
  final double lat;
  final double lng;
  final double distanceMeters;
}
```

### Repository Contract

The domain defines *what* the data layer must provide, not *how*.

```dart
abstract class TrackingRepository {
  Future<TargetLocationEntity> getTargetLocation();
  Future<bool> requestLocationPermission();
  Future<LocationReadingEntity> getLocationReading(TargetLocationEntity target);
  Future<List<LocationReadingEntity>> getSavedReadings();
  Future<void> clearReadings();
}
```

The domain owns this interface. The data layer implements it. This is the **Dependency Inversion Principle** — high-level policy (domain) does not depend on low-level detail (data).

### Use Cases

A use case represents a single business action. It accepts a repository via constructor injection and exposes a `call()` method so it can be invoked like a function.

```dart
class GetTargetLocationUsecase {
  const GetTargetLocationUsecase(this._repository);
  final TrackingRepository _repository;

  Future<TargetLocationEntity> call() => _repository.getTargetLocation();
}
```

---

## Data Layer

The data layer implements the domain contracts and handles all external concerns: HTTP, GPS, and local storage.

### Data Sources

Data sources are the lowest level — each one talks to exactly one external system.

| Class | Responsibility |
|---|---|
| `TrackingRemoteDatasource` | Fetches the target location JSON from the remote API |
| `LocationLocalDatasource` | Wraps `Geolocator` — permission requests and `getCurrentPosition()` |
| `TrackingStorageService` | Wraps the Hive box — `saveReading`, `getAllReadings`, `clearAll` |

### Models

**`TargetLocationModel`** extends `TargetLocationEntity` and adds JSON serialization via `dart_mappable`. Because it extends the entity, the repository can return it directly without a manual conversion step.

```dart
@MappableClass(caseStyle: CaseStyle.snakeCase)
class TargetLocationModel extends TargetLocationEntity
    with TargetLocationModelMappable { ... }
```

`CaseStyle.snakeCase` automatically maps `targetLat` ↔ `target_lat` in JSON. `GenerateMethods.equals` is excluded so `Equatable` (inherited from the entity) keeps ownership of `==` and `hashCode`.

### Local Storage — Hive

**`LocationReadingHiveModel`** is a `HiveObject` that mirrors `LocationReadingEntity`. Timestamp is stored as `int` (millisecondsSinceEpoch) to avoid relying on Hive's built-in DateTime adapter across versions. A hand-written `TypeAdapter` handles binary serialization using field-index encoding. It lives in `models/` alongside the other data-layer models.

**`TrackingStorageService`** wraps the Hive box and exposes three methods — `saveReading`, `getAllReadings`, and `clearAll` — keeping all Hive-specific code in one place. It lives in `datasources/` alongside the other datasources.

### Repository Implementation

`TrackingRepositoryImpl` is the glue between domain and data. It holds references to all three data sources and converts raw data into domain entities.

```
TrackingRepositoryImpl
  ├── TrackingRemoteDatasource  → fetches target from API
  ├── LocationLocalDatasource   → reads GPS via Geolocator
  └── TrackingStorageService    → persists/loads readings via Hive
```

On each `getLocationReading()` call it:
1. Gets the device position from `LocationLocalDatasource`
2. Calculates distance using `Geolocator.distanceBetween()`
3. Saves the new `LocationReadingEntity` to Hive via `TrackingStorageService`
4. Returns the entity to the caller

---

## Presentation Layer — BLoC / Cubit

### State

`TrackingState` is a single immutable class with a `copyWith` method. All UI-relevant values live here.

| Field | Type | Purpose |
|---|---|---|
| `isTracking` | `bool` | Whether the toggle is on |
| `status` | `TrackingStatus` | initial / loading / active / stopped / permissionDenied / error |
| `readings` | `List<LocationReadingEntity>` | Full list of captured readings |
| `filterCount` | `int` | How many readings to display (5 / 10 / 15 / 20) |
| `errorMessage` | `String?` | Surfaces errors to the UI |

`filteredReadings` is a computed getter (`readings.take(filterCount)`) — derived from state, not stored separately.

### Cubit

`TrackingCubit` owns the polling timer and orchestrates the tracking lifecycle.

```
constructor     → unawaited(_loadPersistedReadings())  # loads Hive data on start
toggleTracking  → _startTracking() or _stopTracking()
_startTracking  → request permission → fetch target → emit active → first tick → Timer.periodic
_tick           → _isPolling guard → getLocationReading → emit updated readings list
_stopTracking   → cancel timer → emit stopped
updateFilter    → emit new filterCount
clearReadings   → repository.clearReadings() → emit empty list
close           → cancel timer (cleanup)
```

The `_isPolling` boolean prevents overlapping ticks if a GPS read takes longer than 5 seconds.

### Global Access via MultiBlocProvider

All cubits are registered as singletons in `AppModule` (flutter_modular) and provided at the root of the widget tree via `MultiBlocProvider` inside `AppWidget`. Any widget anywhere in the tree can call `context.read<TrackingCubit>()` without a local `BlocProvider`.

```dart
MultiBlocProvider(
  providers: [
    BlocProvider<TrackingCubit>(
      create: (_) => Modular.get<TrackingCubit>(),
    ),
  ],
  child: MaterialApp(...),
)
```

### BlocObserver

`AppBlocObserver` logs the full cubit lifecycle to the Flutter DevTools console:

| Hook | Output |
|---|---|
| `onCreate` | `[CREATE] TrackingCubit` |
| `onChange` | `[CHANGE]` current state → next state |
| `onTransition` | `[TRANSITION]` event + current + next (Blocs only) |
| `onError` | `[ERROR]` + exception |
| `onClose` | `[CLOSE] TrackingCubit` |

---

## UI Layer

The UI only reads state — it never contains business logic.

### Page

`TrackingPage` is a thin scaffold that uses `BlocBuilder` to rebuild on state changes and composes six dedicated widget files. The AppBar shows a delete icon (via a scoped `BlocBuilder`) only when readings exist.

### Widgets

| Widget | Responsibility |
|---|---|
| `ToggleCard` | Start/stop switch with loading indicator |
| `FilterRow` | Dropdown to show last 5 / 10 / 15 / 20 readings |
| `ReadingsList` | `StatefulWidget` with `ListView.separated` and auto-scroll to newest entry |
| `ReadingCard` | Single reading — index badge, timestamp, lat/lng, distance to target |
| `EmptyState` | Placeholder when no readings exist |
| `StatusBanner` | Reusable coloured banner for permission denial and errors |
| `ClearConfirmationDialog` | Requires typing `"yes i do"` before wiping all Hive data |

---

## Dependency Injection

`flutter_modular` is used purely for DI — navigation is handled by `nb_utils`. All singletons are registered in `AppModule.binds()` using constructor tear-offs (`.new`), which modular auto-resolves.

```
TrackingRemoteDatasource  ┐
LocationLocalDatasource   ├──▶  TrackingRepositoryImpl  ──▶  TrackingRepository
TrackingStorageService    ┘

GetTargetLocationUsecase  ┐
TrackingRepository        ┘──▶  TrackingCubit
```

---

## Key Packages

| Package | Purpose |
|---|---|
| `flutter_bloc` | State management |
| `equatable` | Value equality for entities and states |
| `flutter_modular` | Dependency injection |
| `geolocator` | GPS position + `distanceBetween()` |
| `hive_flutter` | Local persistence |
| `dart_mappable` | JSON serialization via code generation |
| `google_fonts` | Jua typeface |
| `nb_utils` | App initialisation helpers |

---

## Running Code Generation

After modifying any `dart_mappable` annotated model, regenerate the `.mapper.dart` files:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Getting Started 🚀

This project contains 3 flavors:

- development
- staging
- production

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
# Development
$ flutter run --flavor development --target lib/main_development.dart

# Staging
$ flutter run --flavor staging --target lib/main_staging.dart

# Production
$ flutter run --flavor production --target lib/main_production.dart
```

_\*Flutter Exam works on iOS, Android, Web, and Windows._

---

## Running Tests 🧪

To run all unit and widget tests use the following command:

```sh
$ very_good test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

---

## Bloc Lints 🔍

This project uses the [bloc_lint](https://pub.dev/packages/bloc_lint) package to enforce best practices using [bloc](https://pub.dev/packages/bloc).

To validate linter errors, run

```bash
dart run bloc_tools:bloc lint .
```

You can also validate with VSCode-based IDEs using the [official bloc extension](https://marketplace.visualstudio.com/items?itemName=FelixAngelov.bloc).

To learn more, visit https://bloclibrary.dev/lint/

---

## Working with Translations 🌐

This project follows the [official internationalization guide for Flutter][internationalization_link] using [ARB files][arb_documentation_link] for translations.

### Adding Strings

1. To add a new localizable string, open the `app_en.arb` file at `lib/l10n/arb/app_en.arb` and add a new key/value pair with the relevant description (optional):

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    },
    "helloWorld": "Hello World",
    "@helloWorld": {
        "description": "Hello World greeting."
    }
}
```

1. Use the new string:

```dart
import 'package:flutter_exam/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

### Adding Supported Locales

Update the `CFBundleLocalizations` array in the `Info.plist` at `ios/Runner/Info.plist` to include the new locale.

```xml
    ...

    <key>CFBundleLocalizations</key>
	<array>
		<string>en</string>
		<string>es</string>
	</array>

    ...
```

### Adding Translations

1. For each supported locale, add a new ARB file in `lib/l10n/arb`:

```
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   └── app_es.arb
```

1. Add the translated strings to the new `.arb` file:

`app_es.arb`

```arb
{
    "@@locale": "es",
    "counterAppBarTitle": "Contador",
    "@counterAppBarTitle": {
        "description": "Texto mostrado en la AppBar de la página del contador"
    },
    "helloWorld": "Hola Mundo",
    "@helloWorld": {
        "description": "Saludo Hola Mundo."
    }    
}
```

### Generating Translations

To use the latest translations changes, you will need to generate them:

```sh
flutter gen-l10n --arb-dir="lib/l10n/arb"
```

Alternatively, run `flutter run` and code generation will take place automatically.

---

## Commands Reference

All commands are run via `make`. See `make help` for a quick overview.

### Run the app

```sh
make run-dev       # development flavor
make run-staging   # staging flavor
make run-prod      # production flavor
```

### Code generation

Required after modifying any `dart_mappable` annotated model:

```sh
make codegen
```

### Tests & coverage

```sh
make test        # run all tests with randomized ordering
make coverage    # run tests + generate and open HTML coverage report
```

### Lint

```sh
make lint        # bloc_lint static analysis
```

### Translations

```sh
make l10n        # regenerate ARB translation files
```

### Clean & rebuild

```sh
make clean       # flutter clean + remove build artifacts
make rebuild     # full reset: clean → pub get → codegen
```

---

[coverage_badge]: coverage_badge.svg
[internationalization_link]: https://docs.flutter.dev/ui/internationalization
[arb_documentation_link]: https://github.com/google/app-resource-bundle
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
