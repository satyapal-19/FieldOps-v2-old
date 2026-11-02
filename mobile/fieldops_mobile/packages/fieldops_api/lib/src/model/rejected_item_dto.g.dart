// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rejected_item_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RejectedItemDto extends RejectedItemDto {
  @override
  final String clientUuid;
  @override
  final String reason;

  factory _$RejectedItemDto([void Function(RejectedItemDtoBuilder)? updates]) =>
      (RejectedItemDtoBuilder()..update(updates))._build();

  _$RejectedItemDto._({required this.clientUuid, required this.reason})
      : super._();
  @override
  RejectedItemDto rebuild(void Function(RejectedItemDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RejectedItemDtoBuilder toBuilder() => RejectedItemDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RejectedItemDto &&
        clientUuid == other.clientUuid &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, clientUuid.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RejectedItemDto')
          ..add('clientUuid', clientUuid)
          ..add('reason', reason))
        .toString();
  }
}

class RejectedItemDtoBuilder
    implements Builder<RejectedItemDto, RejectedItemDtoBuilder> {
  _$RejectedItemDto? _$v;

  String? _clientUuid;
  String? get clientUuid => _$this._clientUuid;
  set clientUuid(String? clientUuid) => _$this._clientUuid = clientUuid;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  RejectedItemDtoBuilder() {
    RejectedItemDto._defaults(this);
  }

  RejectedItemDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _clientUuid = $v.clientUuid;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RejectedItemDto other) {
    _$v = other as _$RejectedItemDto;
  }

  @override
  void update(void Function(RejectedItemDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RejectedItemDto build() => _build();

  _$RejectedItemDto _build() {
    final _$result = _$v ??
        _$RejectedItemDto._(
          clientUuid: BuiltValueNullFieldError.checkNotNull(
              clientUuid, r'RejectedItemDto', 'clientUuid'),
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'RejectedItemDto', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
