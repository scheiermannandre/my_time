# Check Test Coverage on PrePush with githooks

## Preconditions
1. `git_hooks` is installed see `conventional_commits.md` for more infos

## Implementation
1. install `process_run` https://pub.dev/packages/process_run  in dev dependencies
`flutter pub add -d process_run`
2. install `dlcov` https://pub.dev/packages/dlcov/install in dev dependencies 
`flutter pub add -d dlcov`
3. in `tools/git_hooks.dart` exchange the existing method `_prePush()` with the following:
```
Future<bool> _prePush() async {
  const coverageThreshhold = 10;
  final shell = Shell(throwOnError: false);
  // run shellScript to generate test coverage and check if it
  // passes the threshold
  final results = await shell.run(
    'dlcov --coverage=$coverageThreshhold --lcov-gen="flutter test --coverage"',
  );
  return results.first.exitCode == 0;
}
```

4. it will instantiate a shell, run the `dlcov` script in order to run Tests and check Coverage Report, check if tests and coverage are passed (based on the percentage threshhold you set above)