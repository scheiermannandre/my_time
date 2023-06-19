// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tab_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tabPageControllerHash() => r'645d1d5a3111e31204e7b01d6bf5a48ad2435473';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$TabPageController
    extends BuildlessAutoDisposeNotifier<TabPageState> {
  late final String arg1;

  TabPageState build(
    String arg1,
  );
}

/// See also [TabPageController].
@ProviderFor(TabPageController)
const tabPageControllerProvider = TabPageControllerFamily();

/// See also [TabPageController].
class TabPageControllerFamily extends Family<TabPageState> {
  /// See also [TabPageController].
  const TabPageControllerFamily();

  /// See also [TabPageController].
  TabPageControllerProvider call(
    String arg1,
  ) {
    return TabPageControllerProvider(
      arg1,
    );
  }

  @override
  TabPageControllerProvider getProviderOverride(
    covariant TabPageControllerProvider provider,
  ) {
    return call(
      provider.arg1,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'tabPageControllerProvider';
}

/// See also [TabPageController].
class TabPageControllerProvider
    extends AutoDisposeNotifierProviderImpl<TabPageController, TabPageState> {
  /// See also [TabPageController].
  TabPageControllerProvider(
    this.arg1,
  ) : super.internal(
          () => TabPageController()..arg1 = arg1,
          from: tabPageControllerProvider,
          name: r'tabPageControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tabPageControllerHash,
          dependencies: TabPageControllerFamily._dependencies,
          allTransitiveDependencies:
              TabPageControllerFamily._allTransitiveDependencies,
        );

  final String arg1;

  @override
  bool operator ==(Object other) {
    return other is TabPageControllerProvider && other.arg1 == arg1;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, arg1.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  TabPageState runNotifierBuild(
    covariant TabPageController notifier,
  ) {
    return notifier.build(
      arg1,
    );
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
