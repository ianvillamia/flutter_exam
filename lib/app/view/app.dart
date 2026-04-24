import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exam/features/tracking/presentation/cubit/tracking_cubit.dart';
import 'package:flutter_exam/features/tracking/presentation/pages/tracking_page.dart';
import 'package:flutter_exam/l10n/l10n.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:nb_utils/nb_utils.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  static const _orange = Color(0xFFD97757);
  static const _warmBackground = Color(0xFFF5F4F0);
  static const _warmSurface = Color(0xFFFAF9F7);
  static const _darkText = Color(0xFF1A1915);
  static const _mutedText = Color(0xFF6B6860);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TrackingCubit>(
          create: (_) => Modular.get<TrackingCubit>(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        theme: ThemeData(
          colorScheme: ColorScheme.light(
            primary: _orange,
            primaryContainer: _orange.withValues(alpha: 0.12),
            onPrimaryContainer: _orange,
            secondary: _orange,
            surface: _warmSurface,
            onSurface: _darkText,
            onSurfaceVariant: _mutedText,
            outline: const Color(0xFFE0DDD8),
          ),
          scaffoldBackgroundColor: _warmBackground,
          appBarTheme: const AppBarTheme(
            backgroundColor: _warmSurface,
            foregroundColor: _darkText,
            elevation: 0,
            scrolledUnderElevation: 1,
            titleTextStyle: TextStyle(
              color: _darkText,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          cardTheme: CardThemeData(
            color: _warmSurface,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFFE0DDD8)),
            ),
          ),
          dividerTheme: const DividerThemeData(
            color: Color(0xFFE0DDD8),
            thickness: 1,
          ),
          textTheme: const TextTheme(
            titleMedium: TextStyle(
              color: _darkText,
              fontWeight: FontWeight.w600,
            ),
            bodyMedium: TextStyle(color: _darkText),
            bodySmall: TextStyle(color: _mutedText),
            labelMedium: TextStyle(color: _darkText),
            titleSmall: TextStyle(
              color: _orange,
              fontWeight: FontWeight.w700,
            ),
          ),
          switchTheme: SwitchThemeData(
            thumbColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
                  ? _orange
                  : const Color(0xFFCBC9C4),
            ),
            trackColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
                  ? _orange.withValues(alpha: 0.25)
                  : const Color(0xFFE8E6E1),
            ),
          ),
          dropdownMenuTheme: const DropdownMenuThemeData(
            textStyle: TextStyle(color: _darkText),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: _orange,
            foregroundColor: Colors.white,
          ),
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const TrackingPage(),
      ),
    );
  }
}
