.PHONY: help setup clean rebuild codegen run-dev run-staging run-prod test coverage lint l10n

# ─── Setup ────────────────────────────────────────────────────────────────────

setup:
	flutter pub get

codegen:
	dart run build_runner build --delete-conflicting-outputs

rebuild: clean setup codegen

clean:
	flutter clean
	@rm -rf build .dart_tool

# ─── Run ──────────────────────────────────────────────────────────────────────

run-dev:
	flutter run --flavor development --target lib/main_development.dart

run-staging:
	flutter run --flavor staging --target lib/main_staging.dart

run-prod:
	flutter run --flavor production --target lib/main_production.dart

# ─── Test & Quality ───────────────────────────────────────────────────────────

test:
	very_good test --coverage --test-randomize-ordering-seed random

coverage: test
	genhtml coverage/lcov.info -o coverage/
	open coverage/index.html

lint:
	dart run bloc_tools:bloc lint .

# ─── i18n ─────────────────────────────────────────────────────────────────────

l10n:
	flutter gen-l10n --arb-dir="lib/l10n/arb"

# ─── Help ─────────────────────────────────────────────────────────────────────

help:
	@echo ""
	@echo "Flutter Exam — available commands:"
	@echo ""
	@echo "  Setup"
	@echo "    make setup          Install dependencies (flutter pub get)"
	@echo "    make codegen        Run build_runner (code generation)"
	@echo "    make rebuild        Full rebuild: clean → pub get → codegen"
	@echo "    make clean          flutter clean + remove build artifacts"
	@echo ""
	@echo "  Run"
	@echo "    make run-dev        Run development flavor"
	@echo "    make run-staging    Run staging flavor"
	@echo "    make run-prod       Run production flavor"
	@echo ""
	@echo "  Test & Quality"
	@echo "    make test           Run all tests with randomized ordering"
	@echo "    make coverage       Generate and open HTML coverage report"
	@echo "    make lint           Run bloc_lint"
	@echo ""
	@echo "  i18n"
	@echo "    make l10n           Regenerate ARB translations"
	@echo ""
