// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resolve_alert_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ResolveAlertDto extends ResolveAlertDto {
  @override
  final String? note;

  factory _$ResolveAlertDto([void Function(ResolveAlertDtoBuilder)? updates]) =>
      (ResolveAlertDtoBuilder()..update(updates))._build();

  _$ResolveAlertDto._({this.note}) : super._();
  @override
  ResolveAlertDto rebuild(void Function(ResolveAlertDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ResolveAlertDtoBuilder toBuilder() => ResolveAlertDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ResolveAlertDto && note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ResolveAlertDto')..add('note', note))
        .toString();
  }
}

class ResolveAlertDtoBuilder
    implements Builder<ResolveAlertDto, ResolveAlertDtoBuilder> {
  _$ResolveAlertDto? _$v;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  ResolveAlertDtoBuilder() {
    ResolveAlertDto._defaults(this);
  }

  ResolveAlertDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ResolveAlertDto other) {
    _$v = other as _$ResolveAlertDto;
  }

  @override
  void update(void Function(ResolveAlertDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ResolveAlertDto build() => _build();

  _$ResolveAlertDto _build() {
    final _$result = _$v ??
        _$ResolveAlertDto._(
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
