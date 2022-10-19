// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'temple_search_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$TempleSearchState {
  AsyncValue<List<SearchData>> get record => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TempleSearchStateCopyWith<TempleSearchState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TempleSearchStateCopyWith<$Res> {
  factory $TempleSearchStateCopyWith(
          TempleSearchState value, $Res Function(TempleSearchState) then) =
      _$TempleSearchStateCopyWithImpl<$Res, TempleSearchState>;
  @useResult
  $Res call({AsyncValue<List<SearchData>> record});
}

/// @nodoc
class _$TempleSearchStateCopyWithImpl<$Res, $Val extends TempleSearchState>
    implements $TempleSearchStateCopyWith<$Res> {
  _$TempleSearchStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? record = null,
  }) {
    return _then(_value.copyWith(
      record: null == record
          ? _value.record
          : record // ignore: cast_nullable_to_non_nullable
              as AsyncValue<List<SearchData>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TempleSearchStateCopyWith<$Res>
    implements $TempleSearchStateCopyWith<$Res> {
  factory _$$_TempleSearchStateCopyWith(_$_TempleSearchState value,
          $Res Function(_$_TempleSearchState) then) =
      __$$_TempleSearchStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({AsyncValue<List<SearchData>> record});
}

/// @nodoc
class __$$_TempleSearchStateCopyWithImpl<$Res>
    extends _$TempleSearchStateCopyWithImpl<$Res, _$_TempleSearchState>
    implements _$$_TempleSearchStateCopyWith<$Res> {
  __$$_TempleSearchStateCopyWithImpl(
      _$_TempleSearchState _value, $Res Function(_$_TempleSearchState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? record = null,
  }) {
    return _then(_$_TempleSearchState(
      record: null == record
          ? _value.record
          : record // ignore: cast_nullable_to_non_nullable
              as AsyncValue<List<SearchData>>,
    ));
  }
}

/// @nodoc

class _$_TempleSearchState implements _TempleSearchState {
  const _$_TempleSearchState({required this.record});

  @override
  final AsyncValue<List<SearchData>> record;

  @override
  String toString() {
    return 'TempleSearchState(record: $record)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TempleSearchState &&
            (identical(other.record, record) || other.record == record));
  }

  @override
  int get hashCode => Object.hash(runtimeType, record);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TempleSearchStateCopyWith<_$_TempleSearchState> get copyWith =>
      __$$_TempleSearchStateCopyWithImpl<_$_TempleSearchState>(
          this, _$identity);
}

abstract class _TempleSearchState implements TempleSearchState {
  const factory _TempleSearchState(
          {required final AsyncValue<List<SearchData>> record}) =
      _$_TempleSearchState;

  @override
  AsyncValue<List<SearchData>> get record;
  @override
  @JsonKey(ignore: true)
  _$$_TempleSearchStateCopyWith<_$_TempleSearchState> get copyWith =>
      throw _privateConstructorUsedError;
}
