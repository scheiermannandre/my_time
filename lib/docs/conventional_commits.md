# add Conventional Commits and DartAnalyzer enforcements to the code

found on : https://medium.com/@taosif7/setup-git-hooks-for-your-flutter-project-c007a833175b

1. Add Git Hooks Dependency -> run `dart pub add git_hooks`
2. Add DartAnalyzer Dependency -> run `dart pub add dart_pre_commit`
3. Activate git hooks on your pc -> run `dart pub global activate git_hooks`
4. Add Env Var for git_hooks.exe 
-> on mac: open your `.zshrc` file, it should be in home. Press `cmd + Shift + "."` inside the finder and the invisible files should be visible.
Then open the file and add `export PATH="$PATH":"$HOME/.pub-cache/bin"`. Save and close the file. Restart the terminal
5. Setup git hook files in your repository -> run `git_hooks create tools/git_hooks.dart`
6. Paste the following code in your `git_hooks.dart` file. 
This will configure your repository for automatically running `dart_analyze`, `dartfmt` and it’ll also check whether your commit message follows conventional commit format (that’s optional, you can remove it).

```
// ignore_for_file: avoid_print

import 'package:dart_pre_commit/dart_pre_commit.dart';
import 'package:git_hooks/git_hooks.dart';

void main(List<String> arguments) {
  Map<Git, UserBackFun> params = {
    Git.commitMsg: _conventionalCommitMsg,
    Git.preCommit: _preCommit,
  };
  GitHooks.call(arguments, params);
}

Future<bool> _preCommit() async {
  // Run dart_pre_commit package function to auto run various flutter commands
  final result = await DartPreCommit.run();
  return result.isSuccess;
}

Future<bool> _conventionalCommitMsg() async {
  var commitMsg = Utils.getCommitEditMsg();
  RegExp conventionCommitPattern = RegExp(
      r'''^(feat|fix|refactor|build|chore|perf|ci|docs|revert|style|test|merge){1}(\([\w\-\.]+\))?(!)?:( )?([\w ])+([\s\S]*)''');

  // Check if it matches conventional commit
  if (conventionCommitPattern.hasMatch(commitMsg)) {
    return true; // you can return true let commit go

    // If failed, check if issue is due to invalid tag
  } else if (!RegExp(
          r'(feat|fix|refactor|build|chore|perf|ci|docs|revert|style|test|merge)')
      .hasMatch(commitMsg)) {
    print(
        '🛑 Invalid type used in commit message. It should be one of (feat|fix|refactor|build|chore|perf|ci|docs|revert|style|test|merge)');

    // else refer the dev to conventional commit site
  } else {
    print(
        '🛑 Commit message should follow conventional commit pattern: https://www.conventionalcommits.org/en/v1.0.0/');
  }

  return false;
}

```

7. commit your code as usual `git commit -m "chore: add conventional message"` file. 
