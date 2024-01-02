// ignore_for_file: dead_code, avoid_print

import 'package:dart_pre_commit/dart_pre_commit.dart';
import 'package:git_hooks/git_hooks.dart';
import 'package:process_run/shell.dart';

void main(List<String> arguments) {
  final params = <Git, UserBackFun>{
    Git.commitMsg: _conventionalCommitMsg,
    Git.preCommit: _preCommit,
    Git.prePush: _prePush,
  };
  GitHooks.call(arguments, params);
}

Future<bool> _prePush() async {
  const coverageThreshhold = 10;
  final shell = Shell(throwOnError: false);
  // run shellScript to generate test coverage and check if it
  // passes the threshold

  return true;

  final results = await shell.run(
    'dlcov --coverage=$coverageThreshhold --lcov-gen="flutter test --coverage"',
  );
  return results.first.exitCode == 0;
}

Future<bool> _preCommit() async {
  return true;
  // Run dart_pre_commit package function to auto run various flutter commands
  final result = await DartPreCommit.run();
  return result.isSuccess;
}

Future<bool> _conventionalCommitMsg() async {
  return true;
  final commitMsg = Utils.getCommitEditMsg();
  final conventionCommitPattern = RegExp(
    r'''^(feat|fix|refactor|build|chore|perf|ci|docs|revert|style|test|merge){1}(\([\w\-\.]+\))?(!)?:( )?([\w ])+([\s\S]*)''',
  );

  // Check if it matches conventional commit
  if (conventionCommitPattern.hasMatch(commitMsg)) {
    return true; // you can return true let commit go

    // If failed, check if issue is due to invalid tag
  } else if (!RegExp(
    '(feat|fix|refactor|build|chore|perf|ci|docs|revert|style|test|merge)',
  ).hasMatch(commitMsg)) {
    print(
      '🛑 Invalid type used in commit message. It should be one of '
      '(feat|fix|refactor|build|chore|perf|ci|docs|revert|style|test|merge)',
    );

    // else refer the dev to conventional commit site
  } else {
    print(
      '🛑 Commit message should follow conventional commit pattern: https://www.conventionalcommits.org/en/v1.0.0/',
    );
  }

  return false;
}
