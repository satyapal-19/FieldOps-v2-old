// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_spot_check_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OrderSpotCheckDto extends OrderSpotCheckDto {
  @override
  final String staffId;
  @override
  final String? reason;

  factory _$OrderSpotCheckDto(
          [void Function(OrderSpotCheckDtoBuilder)? updates]) =>
      (OrderSpotCheckDtoBuilder()..update(updates))._build();

  _$OrderSpotCheckDto._({required this.staffId, this.reason}) : super._();
  @override
  OrderSpotCheckDto rebuild(void Function(OrderSpotCheckDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderSpotCheckDtoBuilder toBuilder() =>
      OrderSpotCheckDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderSpotCheckDto &&
        staffId == other.staffId &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, staffId.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderSpotCheckDto')
          ..add('staffId', staffId)
          ..add('reason', reason))
        .toString();
  }
}

class OrderSpotCheckDtoBuilder
    implements Builder<OrderSpotCheckDto, OrderSpotCheckDtoBuilder> {
  _$OrderSpotCheckDto? _$v;

  String? _staffId;
  String? get staffId => _$this._staffId;
  set staffId(String? staffId) => _$this._staffId = staffId;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  OrderSpotCheckDtoBuilder() {
    OrderSpotCheckDto._defaults(this);
  }

  OrderSpotCheckDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _staffId = $v.staffId;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderSpotCheckDto other) {
    _$v = other as _$OrderSpotCheckDto;
  }

  @override
  void update(void Function(OrderSpotCheckDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderSpotCheckDto build() => _build();

  _$OrderSpotCheckDto _build() {
    final _$result = _$v ??
        _$OrderSpotCheckDto._(
          staffId: BuiltValueNullFieldError.checkNotNull(
              staffId, r'OrderSpotCheckDto', 'staffId'),
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
