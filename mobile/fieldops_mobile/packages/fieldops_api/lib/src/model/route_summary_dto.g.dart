// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_summary_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RouteSummaryDtoSource_Enum _$routeSummaryDtoSourceEnum_LIVE =
    const RouteSummaryDtoSource_Enum._('LIVE');
const RouteSummaryDtoSource_Enum _$routeSummaryDtoSourceEnum_NIGHTLY =
    const RouteSummaryDtoSource_Enum._('NIGHTLY');

RouteSummaryDtoSource_Enum _$routeSummaryDtoSourceEnumValueOf(String name) {
  switch (name) {
    case 'LIVE':
      return _$routeSummaryDtoSourceEnum_LIVE;
    case 'NIGHTLY':
      return _$routeSummaryDtoSourceEnum_NIGHTLY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RouteSummaryDtoSource_Enum> _$routeSummaryDtoSourceEnumValues =
    BuiltSet<RouteSummaryDtoSource_Enum>(const <RouteSummaryDtoSource_Enum>[
  _$routeSummaryDtoSourceEnum_LIVE,
  _$routeSummaryDtoSourceEnum_NIGHTLY,
]);

Serializer<RouteSummaryDtoSource_Enum> _$routeSummaryDtoSourceEnumSerializer =
    _$RouteSummaryDtoSource_EnumSerializer();

class _$RouteSummaryDtoSource_EnumSerializer
    implements PrimitiveSerializer<RouteSummaryDtoSource_Enum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'LIVE': 'LIVE',
    'NIGHTLY': 'NIGHTLY',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'LIVE': 'LIVE',
    'NIGHTLY': 'NIGHTLY',
  };

  @override
  final Iterable<Type> types = const <Type>[RouteSummaryDtoSource_Enum];
  @override
  final String wireName = 'RouteSummaryDtoSource_Enum';

  @override
  Object serialize(Serializers serializers, RouteSummaryDtoSource_Enum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RouteSummaryDtoSource_Enum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RouteSummaryDtoSource_Enum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RouteSummaryDto extends RouteSummaryDto {
  @override
  final RouteSummaryDtoSource_Enum source_;
  @override
  final num pingCount;
  @override
  final num distanceM;
  @override
  final DateTime? firstPingAt;
  @override
  final DateTime? lastPingAt;
  @override
  final num inWardPings;
  @override
  final num outWardPings;
  @override
  final num stationaryPings;
  @override
  final num mockedPings;
  @override
  final num offlinePings;
  @override
  final num? maxGapMinutes;
  @override
  final num tamperEvents;

  factory _$RouteSummaryDto([void Function(RouteSummaryDtoBuilder)? updates]) =>
      (RouteSummaryDtoBuilder()..update(updates))._build();

  _$RouteSummaryDto._(
      {required this.source_,
      required this.pingCount,
      required this.distanceM,
      this.firstPingAt,
      this.lastPingAt,
      required this.inWardPings,
      required this.outWardPings,
      required this.stationaryPings,
      required this.mockedPings,
      required this.offlinePings,
      this.maxGapMinutes,
      required this.tamperEvents})
      : super._();
  @override
  RouteSummaryDto rebuild(void Function(RouteSummaryDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RouteSummaryDtoBuilder toBuilder() => RouteSummaryDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RouteSummaryDto &&
        source_ == other.source_ &&
        pingCount == other.pingCount &&
        distanceM == other.distanceM &&
        firstPingAt == other.firstPingAt &&
        lastPingAt == other.lastPingAt &&
        inWardPings == other.inWardPings &&
        outWardPings == other.outWardPings &&
        stationaryPings == other.stationaryPings &&
        mockedPings == other.mockedPings &&
        offlinePings == other.offlinePings &&
        maxGapMinutes == other.maxGapMinutes &&
        tamperEvents == other.tamperEvents;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jc(_$hash, pingCount.hashCode);
    _$hash = $jc(_$hash, distanceM.hashCode);
    _$hash = $jc(_$hash, firstPingAt.hashCode);
    _$hash = $jc(_$hash, lastPingAt.hashCode);
    _$hash = $jc(_$hash, inWardPings.hashCode);
    _$hash = $jc(_$hash, outWardPings.hashCode);
    _$hash = $jc(_$hash, stationaryPings.hashCode);
    _$hash = $jc(_$hash, mockedPings.hashCode);
    _$hash = $jc(_$hash, offlinePings.hashCode);
    _$hash = $jc(_$hash, maxGapMinutes.hashCode);
    _$hash = $jc(_$hash, tamperEvents.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RouteSummaryDto')
          ..add('source_', source_)
          ..add('pingCount', pingCount)
          ..add('distanceM', distanceM)
          ..add('firstPingAt', firstPingAt)
          ..add('lastPingAt', lastPingAt)
          ..add('inWardPings', inWardPings)
          ..add('outWardPings', outWardPings)
          ..add('stationaryPings', stationaryPings)
          ..add('mockedPings', mockedPings)
          ..add('offlinePings', offlinePings)
          ..add('maxGapMinutes', maxGapMinutes)
          ..add('tamperEvents', tamperEvents))
        .toString();
  }
}

class RouteSummaryDtoBuilder
    implements Builder<RouteSummaryDto, RouteSummaryDtoBuilder> {
  _$RouteSummaryDto? _$v;

  RouteSummaryDtoSource_Enum? _source_;
  RouteSummaryDtoSource_Enum? get source_ => _$this._source_;
  set source_(RouteSummaryDtoSource_Enum? source_) => _$this._source_ = source_;

  num? _pingCount;
  num? get pingCount => _$this._pingCount;
  set pingCount(num? pingCount) => _$this._pingCount = pingCount;

  num? _distanceM;
  num? get distanceM => _$this._distanceM;
  set distanceM(num? distanceM) => _$this._distanceM = distanceM;

  DateTime? _firstPingAt;
  DateTime? get firstPingAt => _$this._firstPingAt;
  set firstPingAt(DateTime? firstPingAt) => _$this._firstPingAt = firstPingAt;

  DateTime? _lastPingAt;
  DateTime? get lastPingAt => _$this._lastPingAt;
  set lastPingAt(DateTime? lastPingAt) => _$this._lastPingAt = lastPingAt;

  num? _inWardPings;
  num? get inWardPings => _$this._inWardPings;
  set inWardPings(num? inWardPings) => _$this._inWardPings = inWardPings;

  num? _outWardPings;
  num? get outWardPings => _$this._outWardPings;
  set outWardPings(num? outWardPings) => _$this._outWardPings = outWardPings;

  num? _stationaryPings;
  num? get stationaryPings => _$this._stationaryPings;
  set stationaryPings(num? stationaryPings) =>
      _$this._stationaryPings = stationaryPings;

  num? _mockedPings;
  num? get mockedPings => _$this._mockedPings;
  set mockedPings(num? mockedPings) => _$this._mockedPings = mockedPings;

  num? _offlinePings;
  num? get offlinePings => _$this._offlinePings;
  set offlinePings(num? offlinePings) => _$this._offlinePings = offlinePings;

  num? _maxGapMinutes;
  num? get maxGapMinutes => _$this._maxGapMinutes;
  set maxGapMinutes(num? maxGapMinutes) =>
      _$this._maxGapMinutes = maxGapMinutes;

  num? _tamperEvents;
  num? get tamperEvents => _$this._tamperEvents;
  set tamperEvents(num? tamperEvents) => _$this._tamperEvents = tamperEvents;

  RouteSummaryDtoBuilder() {
    RouteSummaryDto._defaults(this);
  }

  RouteSummaryDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _source_ = $v.source_;
      _pingCount = $v.pingCount;
      _distanceM = $v.distanceM;
      _firstPingAt = $v.firstPingAt;
      _lastPingAt = $v.lastPingAt;
      _inWardPings = $v.inWardPings;
      _outWardPings = $v.outWardPings;
      _stationaryPings = $v.stationaryPings;
      _mockedPings = $v.mockedPings;
      _offlinePings = $v.offlinePings;
      _maxGapMinutes = $v.maxGapMinutes;
      _tamperEvents = $v.tamperEvents;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RouteSummaryDto other) {
    _$v = other as _$RouteSummaryDto;
  }

  @override
  void update(void Function(RouteSummaryDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RouteSummaryDto build() => _build();

  _$RouteSummaryDto _build() {
    final _$result = _$v ??
        _$RouteSummaryDto._(
          source_: BuiltValueNullFieldError.checkNotNull(
              source_, r'RouteSummaryDto', 'source_'),
          pingCount: BuiltValueNullFieldError.checkNotNull(
              pingCount, r'RouteSummaryDto', 'pingCount'),
          distanceM: BuiltValueNullFieldError.checkNotNull(
              distanceM, r'RouteSummaryDto', 'distanceM'),
          firstPingAt: firstPingAt,
          lastPingAt: lastPingAt,
          inWardPings: BuiltValueNullFieldError.checkNotNull(
              inWardPings, r'RouteSummaryDto', 'inWardPings'),
          outWardPings: BuiltValueNullFieldError.checkNotNull(
              outWardPings, r'RouteSummaryDto', 'outWardPings'),
          stationaryPings: BuiltValueNullFieldError.checkNotNull(
              stationaryPings, r'RouteSummaryDto', 'stationaryPings'),
          mockedPings: BuiltValueNullFieldError.checkNotNull(
              mockedPings, r'RouteSummaryDto', 'mockedPings'),
          offlinePings: BuiltValueNullFieldError.checkNotNull(
              offlinePings, r'RouteSummaryDto', 'offlinePings'),
          maxGapMinutes: maxGapMinutes,
          tamperEvents: BuiltValueNullFieldError.checkNotNull(
              tamperEvents, r'RouteSummaryDto', 'tamperEvents'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
