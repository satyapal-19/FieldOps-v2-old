// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ping_batch_result_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PingBatchResultDto extends PingBatchResultDto {
  @override
  final num accepted;
  @override
  final num duplicates;
  @override
  final BuiltList<RejectedItemDto> rejected;

  factory _$PingBatchResultDto(
          [void Function(PingBatchResultDtoBuilder)? updates]) =>
      (PingBatchResultDtoBuilder()..update(updates))._build();

  _$PingBatchResultDto._(
      {required this.accepted,
      required this.duplicates,
      required this.rejected})
      : super._();
  @override
  PingBatchResultDto rebuild(
          void Function(PingBatchResultDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PingBatchResultDtoBuilder toBuilder() =>
      PingBatchResultDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PingBatchResultDto &&
        accepted == other.accepted &&
        duplicates == other.duplicates &&
        rejected == other.rejected;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accepted.hashCode);
    _$hash = $jc(_$hash, duplicates.hashCode);
    _$hash = $jc(_$hash, rejected.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PingBatchResultDto')
          ..add('accepted', accepted)
          ..add('duplicates', duplicates)
          ..add('rejected', rejected))
        .toString();
  }
}

class PingBatchResultDtoBuilder
    implements Builder<PingBatchResultDto, PingBatchResultDtoBuilder> {
  _$PingBatchResultDto? _$v;

  num? _accepted;
  num? get accepted => _$this._accepted;
  set accepted(num? accepted) => _$this._accepted = accepted;

  num? _duplicates;
  num? get duplicates => _$this._duplicates;
  set duplicates(num? duplicates) => _$this._duplicates = duplicates;

  ListBuilder<RejectedItemDto>? _rejected;
  ListBuilder<RejectedItemDto> get rejected =>
      _$this._rejected ??= ListBuilder<RejectedItemDto>();
  set rejected(ListBuilder<RejectedItemDto>? rejected) =>
      _$this._rejected = rejected;

  PingBatchResultDtoBuilder() {
    PingBatchResultDto._defaults(this);
  }

  PingBatchResultDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accepted = $v.accepted;
      _duplicates = $v.duplicates;
      _rejected = $v.rejected.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PingBatchResultDto other) {
    _$v = other as _$PingBatchResultDto;
  }

  @override
  void update(void Function(PingBatchResultDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PingBatchResultDto build() => _build();

  _$PingBatchResultDto _build() {
    _$PingBatchResultDto _$result;
    try {
      _$result = _$v ??
          _$PingBatchResultDto._(
            accepted: BuiltValueNullFieldError.checkNotNull(
                accepted, r'PingBatchResultDto', 'accepted'),
            duplicates: BuiltValueNullFieldError.checkNotNull(
                duplicates, r'PingBatchResultDto', 'duplicates'),
            rejected: rejected.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rejected';
        rejected.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PingBatchResultDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
