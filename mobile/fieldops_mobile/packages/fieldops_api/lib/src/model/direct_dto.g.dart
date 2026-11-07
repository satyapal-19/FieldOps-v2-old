// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'direct_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DirectDto extends DirectDto {
  @override
  final String staffId;

  factory _$DirectDto([void Function(DirectDtoBuilder)? updates]) =>
      (DirectDtoBuilder()..update(updates))._build();

  _$DirectDto._({required this.staffId}) : super._();
  @override
  DirectDto rebuild(void Function(DirectDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DirectDtoBuilder toBuilder() => DirectDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DirectDto && staffId == other.staffId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, staffId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DirectDto')..add('staffId', staffId))
        .toString();
  }
}

class DirectDtoBuilder implements Builder<DirectDto, DirectDtoBuilder> {
  _$DirectDto? _$v;

  String? _staffId;
  String? get staffId => _$this._staffId;
  set staffId(String? staffId) => _$this._staffId = staffId;

  DirectDtoBuilder() {
    DirectDto._defaults(this);
  }

  DirectDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _staffId = $v.staffId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DirectDto other) {
    _$v = other as _$DirectDto;
  }

  @override
  void update(void Function(DirectDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DirectDto build() => _build();

  _$DirectDto _build() {
    final _$result = _$v ??
        _$DirectDto._(
          staffId: BuiltValueNullFieldError.checkNotNull(
              staffId, r'DirectDto', 'staffId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
