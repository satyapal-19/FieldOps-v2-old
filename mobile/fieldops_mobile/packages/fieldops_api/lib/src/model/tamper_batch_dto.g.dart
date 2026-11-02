// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tamper_batch_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TamperBatchDto extends TamperBatchDto {
  @override
  final BuiltList<TamperEventDto> events;

  factory _$TamperBatchDto([void Function(TamperBatchDtoBuilder)? updates]) =>
      (TamperBatchDtoBuilder()..update(updates))._build();

  _$TamperBatchDto._({required this.events}) : super._();
  @override
  TamperBatchDto rebuild(void Function(TamperBatchDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TamperBatchDtoBuilder toBuilder() => TamperBatchDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TamperBatchDto && events == other.events;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, events.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TamperBatchDto')
          ..add('events', events))
        .toString();
  }
}

class TamperBatchDtoBuilder
    implements Builder<TamperBatchDto, TamperBatchDtoBuilder> {
  _$TamperBatchDto? _$v;

  ListBuilder<TamperEventDto>? _events;
  ListBuilder<TamperEventDto> get events =>
      _$this._events ??= ListBuilder<TamperEventDto>();
  set events(ListBuilder<TamperEventDto>? events) => _$this._events = events;

  TamperBatchDtoBuilder() {
    TamperBatchDto._defaults(this);
  }

  TamperBatchDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _events = $v.events.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TamperBatchDto other) {
    _$v = other as _$TamperBatchDto;
  }

  @override
  void update(void Function(TamperBatchDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TamperBatchDto build() => _build();

  _$TamperBatchDto _build() {
    _$TamperBatchDto _$result;
    try {
      _$result = _$v ??
          _$TamperBatchDto._(
            events: events.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'events';
        events.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TamperBatchDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
