// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_exception.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AppException {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() entryNotFound,
    required TResult Function() timeRangesOverlap,
    required TResult Function() projectNotFound,
    required TResult Function() groupNotFound,
    required TResult Function(String status) unexpected,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? entryNotFound,
    TResult? Function()? timeRangesOverlap,
    TResult? Function()? projectNotFound,
    TResult? Function()? groupNotFound,
    TResult? Function(String status)? unexpected,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? entryNotFound,
    TResult Function()? timeRangesOverlap,
    TResult Function()? projectNotFound,
    TResult Function()? groupNotFound,
    TResult Function(String status)? unexpected,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(EntryNotFound value) entryNotFound,
    required TResult Function(TimeRangesOverlap value) timeRangesOverlap,
    required TResult Function(ProjectNotFound value) projectNotFound,
    required TResult Function(GroupNotFound value) groupNotFound,
    required TResult Function(Unexpected value) unexpected,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(EntryNotFound value)? entryNotFound,
    TResult? Function(TimeRangesOverlap value)? timeRangesOverlap,
    TResult? Function(ProjectNotFound value)? projectNotFound,
    TResult? Function(GroupNotFound value)? groupNotFound,
    TResult? Function(Unexpected value)? unexpected,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(EntryNotFound value)? entryNotFound,
    TResult Function(TimeRangesOverlap value)? timeRangesOverlap,
    TResult Function(ProjectNotFound value)? projectNotFound,
    TResult Function(GroupNotFound value)? groupNotFound,
    TResult Function(Unexpected value)? unexpected,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppExceptionCopyWith<$Res> {
  factory $AppExceptionCopyWith(
          AppException value, $Res Function(AppException) then) =
      _$AppExceptionCopyWithImpl<$Res, AppException>;
}

/// @nodoc
class _$AppExceptionCopyWithImpl<$Res, $Val extends AppException>
    implements $AppExceptionCopyWith<$Res> {
  _$AppExceptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$EntryNotFoundCopyWith<$Res> {
  factory _$$EntryNotFoundCopyWith(
          _$EntryNotFound value, $Res Function(_$EntryNotFound) then) =
      __$$EntryNotFoundCopyWithImpl<$Res>;
}

/// @nodoc
class __$$EntryNotFoundCopyWithImpl<$Res>
    extends _$AppExceptionCopyWithImpl<$Res, _$EntryNotFound>
    implements _$$EntryNotFoundCopyWith<$Res> {
  __$$EntryNotFoundCopyWithImpl(
      _$EntryNotFound _value, $Res Function(_$EntryNotFound) _then)
      : super(_value, _then);
}

/// @nodoc

class _$EntryNotFound implements EntryNotFound {
  const _$EntryNotFound();

  @override
  String toString() {
    return 'AppException.entryNotFound()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$EntryNotFound);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() entryNotFound,
    required TResult Function() timeRangesOverlap,
    required TResult Function() projectNotFound,
    required TResult Function() groupNotFound,
    required TResult Function(String status) unexpected,
  }) {
    return entryNotFound();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? entryNotFound,
    TResult? Function()? timeRangesOverlap,
    TResult? Function()? projectNotFound,
    TResult? Function()? groupNotFound,
    TResult? Function(String status)? unexpected,
  }) {
    return entryNotFound?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? entryNotFound,
    TResult Function()? timeRangesOverlap,
    TResult Function()? projectNotFound,
    TResult Function()? groupNotFound,
    TResult Function(String status)? unexpected,
    required TResult orElse(),
  }) {
    if (entryNotFound != null) {
      return entryNotFound();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(EntryNotFound value) entryNotFound,
    required TResult Function(TimeRangesOverlap value) timeRangesOverlap,
    required TResult Function(ProjectNotFound value) projectNotFound,
    required TResult Function(GroupNotFound value) groupNotFound,
    required TResult Function(Unexpected value) unexpected,
  }) {
    return entryNotFound(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(EntryNotFound value)? entryNotFound,
    TResult? Function(TimeRangesOverlap value)? timeRangesOverlap,
    TResult? Function(ProjectNotFound value)? projectNotFound,
    TResult? Function(GroupNotFound value)? groupNotFound,
    TResult? Function(Unexpected value)? unexpected,
  }) {
    return entryNotFound?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(EntryNotFound value)? entryNotFound,
    TResult Function(TimeRangesOverlap value)? timeRangesOverlap,
    TResult Function(ProjectNotFound value)? projectNotFound,
    TResult Function(GroupNotFound value)? groupNotFound,
    TResult Function(Unexpected value)? unexpected,
    required TResult orElse(),
  }) {
    if (entryNotFound != null) {
      return entryNotFound(this);
    }
    return orElse();
  }
}

abstract class EntryNotFound implements AppException {
  const factory EntryNotFound() = _$EntryNotFound;
}

/// @nodoc
abstract class _$$TimeRangesOverlapCopyWith<$Res> {
  factory _$$TimeRangesOverlapCopyWith(
          _$TimeRangesOverlap value, $Res Function(_$TimeRangesOverlap) then) =
      __$$TimeRangesOverlapCopyWithImpl<$Res>;
}

/// @nodoc
class __$$TimeRangesOverlapCopyWithImpl<$Res>
    extends _$AppExceptionCopyWithImpl<$Res, _$TimeRangesOverlap>
    implements _$$TimeRangesOverlapCopyWith<$Res> {
  __$$TimeRangesOverlapCopyWithImpl(
      _$TimeRangesOverlap _value, $Res Function(_$TimeRangesOverlap) _then)
      : super(_value, _then);
}

/// @nodoc

class _$TimeRangesOverlap implements TimeRangesOverlap {
  const _$TimeRangesOverlap();

  @override
  String toString() {
    return 'AppException.timeRangesOverlap()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$TimeRangesOverlap);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() entryNotFound,
    required TResult Function() timeRangesOverlap,
    required TResult Function() projectNotFound,
    required TResult Function() groupNotFound,
    required TResult Function(String status) unexpected,
  }) {
    return timeRangesOverlap();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? entryNotFound,
    TResult? Function()? timeRangesOverlap,
    TResult? Function()? projectNotFound,
    TResult? Function()? groupNotFound,
    TResult? Function(String status)? unexpected,
  }) {
    return timeRangesOverlap?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? entryNotFound,
    TResult Function()? timeRangesOverlap,
    TResult Function()? projectNotFound,
    TResult Function()? groupNotFound,
    TResult Function(String status)? unexpected,
    required TResult orElse(),
  }) {
    if (timeRangesOverlap != null) {
      return timeRangesOverlap();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(EntryNotFound value) entryNotFound,
    required TResult Function(TimeRangesOverlap value) timeRangesOverlap,
    required TResult Function(ProjectNotFound value) projectNotFound,
    required TResult Function(GroupNotFound value) groupNotFound,
    required TResult Function(Unexpected value) unexpected,
  }) {
    return timeRangesOverlap(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(EntryNotFound value)? entryNotFound,
    TResult? Function(TimeRangesOverlap value)? timeRangesOverlap,
    TResult? Function(ProjectNotFound value)? projectNotFound,
    TResult? Function(GroupNotFound value)? groupNotFound,
    TResult? Function(Unexpected value)? unexpected,
  }) {
    return timeRangesOverlap?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(EntryNotFound value)? entryNotFound,
    TResult Function(TimeRangesOverlap value)? timeRangesOverlap,
    TResult Function(ProjectNotFound value)? projectNotFound,
    TResult Function(GroupNotFound value)? groupNotFound,
    TResult Function(Unexpected value)? unexpected,
    required TResult orElse(),
  }) {
    if (timeRangesOverlap != null) {
      return timeRangesOverlap(this);
    }
    return orElse();
  }
}

abstract class TimeRangesOverlap implements AppException {
  const factory TimeRangesOverlap() = _$TimeRangesOverlap;
}

/// @nodoc
abstract class _$$ProjectNotFoundCopyWith<$Res> {
  factory _$$ProjectNotFoundCopyWith(
          _$ProjectNotFound value, $Res Function(_$ProjectNotFound) then) =
      __$$ProjectNotFoundCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ProjectNotFoundCopyWithImpl<$Res>
    extends _$AppExceptionCopyWithImpl<$Res, _$ProjectNotFound>
    implements _$$ProjectNotFoundCopyWith<$Res> {
  __$$ProjectNotFoundCopyWithImpl(
      _$ProjectNotFound _value, $Res Function(_$ProjectNotFound) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ProjectNotFound implements ProjectNotFound {
  const _$ProjectNotFound();

  @override
  String toString() {
    return 'AppException.projectNotFound()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ProjectNotFound);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() entryNotFound,
    required TResult Function() timeRangesOverlap,
    required TResult Function() projectNotFound,
    required TResult Function() groupNotFound,
    required TResult Function(String status) unexpected,
  }) {
    return projectNotFound();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? entryNotFound,
    TResult? Function()? timeRangesOverlap,
    TResult? Function()? projectNotFound,
    TResult? Function()? groupNotFound,
    TResult? Function(String status)? unexpected,
  }) {
    return projectNotFound?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? entryNotFound,
    TResult Function()? timeRangesOverlap,
    TResult Function()? projectNotFound,
    TResult Function()? groupNotFound,
    TResult Function(String status)? unexpected,
    required TResult orElse(),
  }) {
    if (projectNotFound != null) {
      return projectNotFound();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(EntryNotFound value) entryNotFound,
    required TResult Function(TimeRangesOverlap value) timeRangesOverlap,
    required TResult Function(ProjectNotFound value) projectNotFound,
    required TResult Function(GroupNotFound value) groupNotFound,
    required TResult Function(Unexpected value) unexpected,
  }) {
    return projectNotFound(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(EntryNotFound value)? entryNotFound,
    TResult? Function(TimeRangesOverlap value)? timeRangesOverlap,
    TResult? Function(ProjectNotFound value)? projectNotFound,
    TResult? Function(GroupNotFound value)? groupNotFound,
    TResult? Function(Unexpected value)? unexpected,
  }) {
    return projectNotFound?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(EntryNotFound value)? entryNotFound,
    TResult Function(TimeRangesOverlap value)? timeRangesOverlap,
    TResult Function(ProjectNotFound value)? projectNotFound,
    TResult Function(GroupNotFound value)? groupNotFound,
    TResult Function(Unexpected value)? unexpected,
    required TResult orElse(),
  }) {
    if (projectNotFound != null) {
      return projectNotFound(this);
    }
    return orElse();
  }
}

abstract class ProjectNotFound implements AppException {
  const factory ProjectNotFound() = _$ProjectNotFound;
}

/// @nodoc
abstract class _$$GroupNotFoundCopyWith<$Res> {
  factory _$$GroupNotFoundCopyWith(
          _$GroupNotFound value, $Res Function(_$GroupNotFound) then) =
      __$$GroupNotFoundCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GroupNotFoundCopyWithImpl<$Res>
    extends _$AppExceptionCopyWithImpl<$Res, _$GroupNotFound>
    implements _$$GroupNotFoundCopyWith<$Res> {
  __$$GroupNotFoundCopyWithImpl(
      _$GroupNotFound _value, $Res Function(_$GroupNotFound) _then)
      : super(_value, _then);
}

/// @nodoc

class _$GroupNotFound implements GroupNotFound {
  const _$GroupNotFound();

  @override
  String toString() {
    return 'AppException.groupNotFound()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$GroupNotFound);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() entryNotFound,
    required TResult Function() timeRangesOverlap,
    required TResult Function() projectNotFound,
    required TResult Function() groupNotFound,
    required TResult Function(String status) unexpected,
  }) {
    return groupNotFound();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? entryNotFound,
    TResult? Function()? timeRangesOverlap,
    TResult? Function()? projectNotFound,
    TResult? Function()? groupNotFound,
    TResult? Function(String status)? unexpected,
  }) {
    return groupNotFound?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? entryNotFound,
    TResult Function()? timeRangesOverlap,
    TResult Function()? projectNotFound,
    TResult Function()? groupNotFound,
    TResult Function(String status)? unexpected,
    required TResult orElse(),
  }) {
    if (groupNotFound != null) {
      return groupNotFound();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(EntryNotFound value) entryNotFound,
    required TResult Function(TimeRangesOverlap value) timeRangesOverlap,
    required TResult Function(ProjectNotFound value) projectNotFound,
    required TResult Function(GroupNotFound value) groupNotFound,
    required TResult Function(Unexpected value) unexpected,
  }) {
    return groupNotFound(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(EntryNotFound value)? entryNotFound,
    TResult? Function(TimeRangesOverlap value)? timeRangesOverlap,
    TResult? Function(ProjectNotFound value)? projectNotFound,
    TResult? Function(GroupNotFound value)? groupNotFound,
    TResult? Function(Unexpected value)? unexpected,
  }) {
    return groupNotFound?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(EntryNotFound value)? entryNotFound,
    TResult Function(TimeRangesOverlap value)? timeRangesOverlap,
    TResult Function(ProjectNotFound value)? projectNotFound,
    TResult Function(GroupNotFound value)? groupNotFound,
    TResult Function(Unexpected value)? unexpected,
    required TResult orElse(),
  }) {
    if (groupNotFound != null) {
      return groupNotFound(this);
    }
    return orElse();
  }
}

abstract class GroupNotFound implements AppException {
  const factory GroupNotFound() = _$GroupNotFound;
}

/// @nodoc
abstract class _$$UnexpectedCopyWith<$Res> {
  factory _$$UnexpectedCopyWith(
          _$Unexpected value, $Res Function(_$Unexpected) then) =
      __$$UnexpectedCopyWithImpl<$Res>;
  @useResult
  $Res call({String status});
}

/// @nodoc
class __$$UnexpectedCopyWithImpl<$Res>
    extends _$AppExceptionCopyWithImpl<$Res, _$Unexpected>
    implements _$$UnexpectedCopyWith<$Res> {
  __$$UnexpectedCopyWithImpl(
      _$Unexpected _value, $Res Function(_$Unexpected) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
  }) {
    return _then(_$Unexpected(
      null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$Unexpected implements Unexpected {
  const _$Unexpected(this.status);

  @override
  final String status;

  @override
  String toString() {
    return 'AppException.unexpected(status: $status)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Unexpected &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UnexpectedCopyWith<_$Unexpected> get copyWith =>
      __$$UnexpectedCopyWithImpl<_$Unexpected>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() entryNotFound,
    required TResult Function() timeRangesOverlap,
    required TResult Function() projectNotFound,
    required TResult Function() groupNotFound,
    required TResult Function(String status) unexpected,
  }) {
    return unexpected(status);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? entryNotFound,
    TResult? Function()? timeRangesOverlap,
    TResult? Function()? projectNotFound,
    TResult? Function()? groupNotFound,
    TResult? Function(String status)? unexpected,
  }) {
    return unexpected?.call(status);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? entryNotFound,
    TResult Function()? timeRangesOverlap,
    TResult Function()? projectNotFound,
    TResult Function()? groupNotFound,
    TResult Function(String status)? unexpected,
    required TResult orElse(),
  }) {
    if (unexpected != null) {
      return unexpected(status);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(EntryNotFound value) entryNotFound,
    required TResult Function(TimeRangesOverlap value) timeRangesOverlap,
    required TResult Function(ProjectNotFound value) projectNotFound,
    required TResult Function(GroupNotFound value) groupNotFound,
    required TResult Function(Unexpected value) unexpected,
  }) {
    return unexpected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(EntryNotFound value)? entryNotFound,
    TResult? Function(TimeRangesOverlap value)? timeRangesOverlap,
    TResult? Function(ProjectNotFound value)? projectNotFound,
    TResult? Function(GroupNotFound value)? groupNotFound,
    TResult? Function(Unexpected value)? unexpected,
  }) {
    return unexpected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(EntryNotFound value)? entryNotFound,
    TResult Function(TimeRangesOverlap value)? timeRangesOverlap,
    TResult Function(ProjectNotFound value)? projectNotFound,
    TResult Function(GroupNotFound value)? groupNotFound,
    TResult Function(Unexpected value)? unexpected,
    required TResult orElse(),
  }) {
    if (unexpected != null) {
      return unexpected(this);
    }
    return orElse();
  }
}

abstract class Unexpected implements AppException {
  const factory Unexpected(final String status) = _$Unexpected;

  String get status;
  @JsonKey(ignore: true)
  _$$UnexpectedCopyWith<_$Unexpected> get copyWith =>
      throw _privateConstructorUsedError;
}
