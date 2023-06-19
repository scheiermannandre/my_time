// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_project_screen_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$addProjectScreenControllerHash() =>
    r'2f7bc10394de08fcde2e3536e5840cda8d8e68f6';

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

abstract class _$AddProjectScreenController
    extends BuildlessAutoDisposeAsyncNotifier<AddProjectState> {
  late final String arg;

  FutureOr<AddProjectState> build(
    String arg,
  );
}

/// See also [AddProjectScreenController].
@ProviderFor(AddProjectScreenController)
const addProjectScreenControllerProvider = AddProjectScreenControllerFamily();

/// See also [AddProjectScreenController].
class AddProjectScreenControllerFamily
    extends Family<AsyncValue<AddProjectState>> {
  /// See also [AddProjectScreenController].
  const AddProjectScreenControllerFamily();

  /// See also [AddProjectScreenController].
  AddProjectScreenControllerProvider call(
    String arg,
  ) {
    return AddProjectScreenControllerProvider(
      arg,
    );
  }

  @override
  AddProjectScreenControllerProvider getProviderOverride(
    covariant AddProjectScreenControllerProvider provider,
  ) {
    return call(
      provider.arg,
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
  String? get name => r'addProjectScreenControllerProvider';
}

/// See also [AddProjectScreenController].
class AddProjectScreenControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<AddProjectScreenController,
        AddProjectState> {
  /// See also [AddProjectScreenController].
  AddProjectScreenControllerProvider(
    this.arg,
  ) : super.internal(
          () => AddProjectScreenController()..arg = arg,
          from: addProjectScreenControllerProvider,
          name: r'addProjectScreenControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$addProjectScreenControllerHash,
          dependencies: AddProjectScreenControllerFamily._dependencies,
          allTransitiveDependencies:
              AddProjectScreenControllerFamily._allTransitiveDependencies,
        );

  final String arg;

  @override
  bool operator ==(Object other) {
    return other is AddProjectScreenControllerProvider && other.arg == arg;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, arg.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  FutureOr<AddProjectState> runNotifierBuild(
    covariant AddProjectScreenController notifier,
  ) {
    return notifier.build(
      arg,
    );
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
