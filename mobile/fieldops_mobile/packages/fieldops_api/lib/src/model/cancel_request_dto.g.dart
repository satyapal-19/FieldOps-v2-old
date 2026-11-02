// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancel_request_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CancelRequestDto extends CancelRequestDto {
  @override
  final num expectedVersion;

  factory _$CancelRequestDto(
          [void Function(CancelRequestDtoBuilder)? updates]) =>
      (CancelRequestDtoBuilder()..update(updates))._build();

  _$CancelRequestDto._({required this.expectedVersion}) : super._();
  @override
  CancelRequestDto rebuild(void Function(CancelRequestDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CancelRequestDtoBuilder toBuilder() =>
      CancelRequestDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CancelRequestDto &&
        expectedVersion == other.expectedVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, expectedVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CancelRequestDto')
          ..add('expectedVersion', expectedVersion))
        .toString();
  }
}

class CancelRequestDtoBuilder
    implements Builder<CancelRequestDto, CancelRequestDtoBuilder> {
  _$CancelRequestDto? _$v;

  num? _expectedVersion;
  num? get expectedVersion => _$this._expectedVersion;
  set expectedVersion(num? expectedVersion) =>
      _$this._expectedVersion = expectedVersion;

  CancelRequestDtoBuilder() {
    CancelRequestDto._defaults(this);
  }

  CancelRequestDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _expectedVersion = $v.expectedVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CancelRequestDto other) {
    _$v = other as _$CancelRequestDto;
  }

  @override
  void update(void Function(CancelRequestDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CancelRequestDto build() => _build();

  _$CancelRequestDto _build() {
    final _$result = _$v ??
        _$CancelRequestDto._(
          expectedVersion: BuiltValueNullFieldError.checkNotNull(
              expectedVersion, r'CancelRequestDto', 'expectedVersion'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
