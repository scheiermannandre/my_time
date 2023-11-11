.PHONY: test ci-test lint generate help run locale coverage buildRunner watchRunner gitHooks language

.DEFAULT_GOAL := help

help: ## show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

test: ## run tests
	dlcov --lcov-gen="flutter test --coverage"

ci-test: ## run tests with CI environment flag
	flutter test --coverage --dart-define=CI=true

golden: ## update golden tests
	flutter test --update-goldens

lint: ## lint and autoformat this project
	flutter analyze
	flutter format --set-exit-if-changed .

run: ## run the app with hot reload
	flutter run --flavor development --target lib/main_development.dart --pid-file=${FLUTTER_PID_FILE}

locale: ## generate locale files
	flutter gen-l10n

coverage: ## generate coverage report
	flutter test --coverage
	genhtml coverage/lcov.info -o coverage/html
	open coverage/html/index.html

buildRunner: ## run build runner
	dart run build_runner build

watchRunner: ## run build runner in watch mode
	dart run build_runner watch -d

gitHooks: ## initialize git hooks
	dart pub global activate git_hooks
	git_hooks create tools/git_hooks.dart

language: ## generate language files
	flutter gen-l10n