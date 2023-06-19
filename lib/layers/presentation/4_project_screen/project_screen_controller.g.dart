// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_screen_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$projectScreenControllerHash() =>
    r'91551ad97e5a59c563b8d13e551ee4300b7c44e5';

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

abstract class _$ProjectScreenController
    extends BuildlessAutoDisposeAsyncNotifier<ProjectScreenState> {
  late final String projectId;

  FutureOr<ProjectScreenState> build(
    String projectId,
  );
}

/// See also [ProjectScreenController].
@ProviderFor(ProjectScreenController)
const projectScreenControllerProvider = ProjectScreenControllerFamily();

/// See also [ProjectScreenController].
class ProjectScreenControllerFamily
    extends Family<AsyncValue<ProjectScreenState>> {
  /// See also [ProjectScreenController].
  const ProjectScreenControllerFamily();

  /// See also [ProjectScreenController].
  ProjectScreenControllerProvider call(
    String projectId,
  ) {
    return ProjectScreenControllerProvider(
      projectId,
    );
  }

  @override
  ProjectScreenControllerProvider getProviderOverride(
    covariant ProjectScreenControllerProvider provider,
  ) {
    return call(
      provider.projectId,
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
  String? get name => r'projectScreenControllerProvider';
}

/// See also [ProjectScreenController].
class ProjectScreenControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<ProjectScreenController,
        ProjectScreenState> {
  /// See also [ProjectScreenController].
  ProjectScreenControllerProvider(
    this.projectId,
  ) : super.internal(
          () => ProjectScreenController()..projectId = projectId,
          from: projectScreenControllerProvider,
          name: r'projectScreenControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$projectScreenControllerHash,
          dependencies: ProjectScreenControllerFamily._dependencies,
          allTransitiveDependencies:
              ProjectScreenControllerFamily._allTransitiveDependencies,
        );

  final String projectId;

  @override
  bool operator ==(Object other) {
    return other is ProjectScreenControllerProvider &&
        other.projectId == projectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  FutureOr<ProjectScreenState> runNotifierBuild(
    covariant ProjectScreenController notifier,
  ) {
    return notifier.build(
      projectId,
    );
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
