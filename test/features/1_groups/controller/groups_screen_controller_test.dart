import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_time/features/1_groups/1_groups.dart';

void main() {
  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(
      overrides: [],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('groupScreenController', () {
    test('get groupScreenController', () {
      final container = makeProviderContainer();
      final controller =
          container.read(groupsScreenControllerProvider.notifier);
      expect(controller, isA<GroupsScreenController>());
    });
  });

  group('GroupsScreenState', () {
    test('copy with changes value', () {
      final container = makeProviderContainer();
      var state = container.read(groupsScreenControllerProvider);
      expect(state.value!.isPlaying, false);
      state = AsyncData(state.value!.copyWith(isPlaying: true));
      expect(state.value!.isPlaying, true);
    });

    test('copy with with null value -> only copying', () {
      final container = makeProviderContainer();
      var state = container.read(groupsScreenControllerProvider);
      state = AsyncData(state.value!.copyWith());
      expect(state.value!.isPlaying, false);
    });
  });
}
