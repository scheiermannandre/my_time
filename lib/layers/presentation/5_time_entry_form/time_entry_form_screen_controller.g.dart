// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_entry_form_screen_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$timeEntryFormScreenControllerHash() =>
    r'0aa7b2a4a97fc7d3cd1b86fadea3081e5850aaa0';

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
  late final String projectId;
  late final String? timeEntryId;
  late final bool isEdit;
  late final String invalidMessage;
  late final String languageCode;

  FutureOr<TimeEntryFormScreenState> build(
    String projectId,
    String? timeEntryId,
    bool isEdit,
    String invalidMessage,
    String languageCode,
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
    String projectId,
    String? timeEntryId,
    bool isEdit,
    String invalidMessage,
    String languageCode,
  ) {
    return TimeEntryFormScreenControllerProvider(
      projectId,
      timeEntryId,
      isEdit,
      invalidMessage,
      languageCode,
    );
  }

  @override
  TimeEntryFormScreenControllerProvider getProviderOverride(
    covariant TimeEntryFormScreenControllerProvider provider,
  ) {
    return call(
      provider.projectId,
      provider.timeEntryId,
      provider.isEdit,
      provider.invalidMessage,
      provider.languageCode,
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
    this.projectId,
    this.timeEntryId,
    this.isEdit,
    this.invalidMessage,
    this.languageCode,
  ) : super.internal(
          () => TimeEntryFormScreenController()
            ..projectId = projectId
            ..timeEntryId = timeEntryId
            ..isEdit = isEdit
            ..invalidMessage = invalidMessage
            ..languageCode = languageCode,
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

  final String projectId;
  final String? timeEntryId;
  final bool isEdit;
  final String invalidMessage;
  final String languageCode;

  @override
  bool operator ==(Object other) {
    return other is TimeEntryFormScreenControllerProvider &&
        other.projectId == projectId &&
        other.timeEntryId == timeEntryId &&
        other.isEdit == isEdit &&
        other.invalidMessage == invalidMessage &&
        other.languageCode == languageCode;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);
    hash = _SystemHash.combine(hash, timeEntryId.hashCode);
    hash = _SystemHash.combine(hash, isEdit.hashCode);
    hash = _SystemHash.combine(hash, invalidMessage.hashCode);
    hash = _SystemHash.combine(hash, languageCode.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  FutureOr<TimeEntryFormScreenState> runNotifierBuild(
    covariant TimeEntryFormScreenController notifier,
  ) {
    return notifier.build(
      projectId,
      timeEntryId,
      isEdit,
      invalidMessage,
      languageCode,
    );
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
