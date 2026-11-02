// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tamper_batch_result_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TamperBatchResultDto extends TamperBatchResultDto {
  @override
  final num accepted;
  @override
  final num duplicates;
  @override
  final BuiltList<RejectedItemDto> rejected;

  factory _$TamperBatchResultDto(
          [void Function(TamperBatchResultDtoBuilder)? updates]) =>
      (TamperBatchResultDtoBuilder()..update(updates))._build();

  _$TamperBatchResultDto._(
      {required this.accepted,
      required this.duplicates,
      required this.rejected})
      : super._();
  @override
  TamperBatchResultDto rebuild(
          void Function(TamperBatchResultDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TamperBatchResultDtoBuilder toBuilder() =>
      TamperBatchResultDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TamperBatchResultDto &&
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
    return (newBuiltValueToStringHelper(r'TamperBatchResultDto')
          ..add('accepted', accepted)
          ..add('duplicates', duplicates)
          ..add('rejected', rejected))
        .toString();
  }
}

class TamperBatchResultDtoBuilder
    implements Builder<TamperBatchResultDto, TamperBatchResultDtoBuilder> {
  _$TamperBatchResultDto? _$v;

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

  TamperBatchResultDtoBuilder() {
    TamperBatchResultDto._defaults(this);
  }

  TamperBatchResultDtoBuilder get _$this {
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
  void replace(TamperBatchResultDto other) {
    _$v = other as _$TamperBatchResultDto;
  }

  @override
  void update(void Function(TamperBatchResultDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TamperBatchResultDto build() => _build();

  _$TamperBatchResultDto _build() {
    _$TamperBatchResultDto _$result;
    try {
      _$result = _$v ??
          _$TamperBatchResultDto._(
            accepted: BuiltValueNullFieldError.checkNotNull(
                accepted, r'TamperBatchResultDto', 'accepted'),
            duplicates: BuiltValueNullFieldError.checkNotNull(
                duplicates, r'TamperBatchResultDto', 'duplicates'),
            rejected: rejected.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rejected';
        rejected.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TamperBatchResultDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
