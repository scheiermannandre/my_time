# Generate Provider with riverpod_generator

1. prepare necessary provider classes

```
AsyncNotifier
// 1. import this
import 'package:riverpod_annotation/riverpod_annotation.dart';

// 2. declare a part file
part 'auth_controller.g.dart';

// 3. annotate
@riverpod
// 4. extend like this
class AuthController extends _$AuthController {
  // 5. override the [build] method to return a [FutureOr]
  @override
  FutureOr<YourState> build() {
    // 6. return a value (or do nothing if the return type is void)
    await someThing();
    return YourState();
  }

  Future<void> signInAnonymously() async {
    // 7. read the repository using ref
    final authRepository = ref.read(authRepositoryProvider);
    // 8. set the loading state
    state = const AsyncLoading();
    // 9. sign in and update the state (data or error)
    state = await AsyncValue.guard(authRepository.signInAnonymously);
  }
}

// 1. import this
import 'package:riverpod_annotation/riverpod_annotation.dart';

// 2. declare a part file
part 'auth_controller.g.dart';

// 3. annotate
@riverpod
// 4. extend like this
class AuthController extends _$AuthController {
  // 5. override the [build] method to return a [FutureOr]
  @override
  YourState build() {
    // 6. return a value (or do nothing if the return type is void)
    return YourState();
  }

  Future<void> signInAnonymously() async {
    // 7. read the repository using ref
    final authRepository = ref.read(authRepositoryProvider);
    // 8. set the loading state
    state = const AsyncLoading();
    // 9. sign in and update the state (data or error)
    state = await AsyncValue.guard(authRepository.signInAnonymously);
  }
}
// https://codewithandrea.com/articles/flutter-riverpod-async-notifier/
```
2. run `dart run build_runner build` or `dart run build_runner watch -d`
