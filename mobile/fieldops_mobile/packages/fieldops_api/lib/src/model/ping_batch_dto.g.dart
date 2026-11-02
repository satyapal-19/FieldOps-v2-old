// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ping_batch_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PingBatchDto extends PingBatchDto {
  @override
  final BuiltList<PingDto> pings;

  factory _$PingBatchDto([void Function(PingBatchDtoBuilder)? updates]) =>
      (PingBatchDtoBuilder()..update(updates))._build();

  _$PingBatchDto._({required this.pings}) : super._();
  @override
  PingBatchDto rebuild(void Function(PingBatchDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PingBatchDtoBuilder toBuilder() => PingBatchDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PingBatchDto && pings == other.pings;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, pings.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PingBatchDto')..add('pings', pings))
        .toString();
  }
}

class PingBatchDtoBuilder
    implements Builder<PingBatchDto, PingBatchDtoBuilder> {
  _$PingBatchDto? _$v;

  ListBuilder<PingDto>? _pings;
  ListBuilder<PingDto> get pings => _$this._pings ??= ListBuilder<PingDto>();
  set pings(ListBuilder<PingDto>? pings) => _$this._pings = pings;

  PingBatchDtoBuilder() {
    PingBatchDto._defaults(this);
  }

  PingBatchDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _pings = $v.pings.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PingBatchDto other) {
    _$v = other as _$PingBatchDto;
  }

  @override
  void update(void Function(PingBatchDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PingBatchDto build() => _build();

  _$PingBatchDto _build() {
    _$PingBatchDto _$result;
    try {
      _$result = _$v ??
          _$PingBatchDto._(
            pings: pings.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'pings';
        pings.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PingBatchDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
