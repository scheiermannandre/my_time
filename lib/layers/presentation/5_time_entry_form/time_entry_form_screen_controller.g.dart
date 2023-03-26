// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_entry_form_screen_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$timeEntryFormScreenControllerHash() =>
    r'92ac718f96a6e1992f18a67b3c940c5b4cce33e1';

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

abstract class _$TimeEntryFormScreenController
    extends BuildlessAutoDisposeAsyncNotifier<TimeEntryFormScreenState> {
  late final String? id;

  FutureOr<TimeEntryFormScreenState> build(
    String? id,
  );
}

/// See also [TimeEntryFormScreenController].
@ProviderFor(TimeEntryFormScreenController)
const timeEntryFormScreenControllerProvider =
    TimeEntryFormScreenControllerFamily();

/// See also [TimeEntryFormScreenController].
class TimeEntryFormScreenControllerFamily
    extends Family<AsyncValue<TimeEntryFormScreenState>> {
  /// See also [TimeEntryFormScreenController].
  const TimeEntryFormScreenControllerFamily();

  /// See also [TimeEntryFormScreenController].
  TimeEntryFormScreenControllerProvider call(
    String? id,
  ) {
    return TimeEntryFormScreenControllerProvider(
      id,
    );
  }

  @override
  TimeEntryFormScreenControllerProvider getProviderOverride(
    covariant TimeEntryFormScreenControllerProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'timeEntryFormScreenControllerProvider';
}

/// See also [TimeEntryFormScreenController].
class TimeEntryFormScreenControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<TimeEntryFormScreenController,
        TimeEntryFormScreenState> {
  /// See also [TimeEntryFormScreenController].
  TimeEntryFormScreenControllerProvider(
    this.id,
  ) : super.internal(
          () => TimeEntryFormScreenController()..id = id,
          from: timeEntryFormScreenControllerProvider,
          name: r'timeEntryFormScreenControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$timeEntryFormScreenControllerHash,
          dependencies: TimeEntryFormScreenControllerFamily._dependencies,
          allTransitiveDependencies:
              TimeEntryFormScreenControllerFamily._allTransitiveDependencies,
        );

  final String? id;

  @override
  bool operator ==(Object other) {
    return other is TimeEntryFormScreenControllerProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  FutureOr<TimeEntryFormScreenState> runNotifierBuild(
    covariant TimeEntryFormScreenController notifier,
  ) {
    return notifier.build(
      id,
    );
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
