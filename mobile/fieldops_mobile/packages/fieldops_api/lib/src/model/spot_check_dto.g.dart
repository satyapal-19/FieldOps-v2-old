// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spot_check_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SpotCheckDtoTriggerEnum _$spotCheckDtoTriggerEnum_RANDOM =
    const SpotCheckDtoTriggerEnum._('RANDOM');
const SpotCheckDtoTriggerEnum _$spotCheckDtoTriggerEnum_SENIOR_MANUAL =
    const SpotCheckDtoTriggerEnum._('SENIOR_MANUAL');

SpotCheckDtoTriggerEnum _$spotCheckDtoTriggerEnumValueOf(String name) {
  switch (name) {
    case 'RANDOM':
      return _$spotCheckDtoTriggerEnum_RANDOM;
    case 'SENIOR_MANUAL':
      return _$spotCheckDtoTriggerEnum_SENIOR_MANUAL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SpotCheckDtoTriggerEnum> _$spotCheckDtoTriggerEnumValues =
    BuiltSet<SpotCheckDtoTriggerEnum>(const <SpotCheckDtoTriggerEnum>[
  _$spotCheckDtoTriggerEnum_RANDOM,
  _$spotCheckDtoTriggerEnum_SENIOR_MANUAL,
]);

const SpotCheckDtoStatusEnum _$spotCheckDtoStatusEnum_SCHEDULED =
    const SpotCheckDtoStatusEnum._('SCHEDULED');
const SpotCheckDtoStatusEnum _$spotCheckDtoStatusEnum_NOTIFIED =
    const SpotCheckDtoStatusEnum._('NOTIFIED');
const SpotCheckDtoStatusEnum _$spotCheckDtoStatusEnum_SNOOZED =
    const SpotCheckDtoStatusEnum._('SNOOZED');
const SpotCheckDtoStatusEnum _$spotCheckDtoStatusEnum_VERIFIED =
    const SpotCheckDtoStatusEnum._('VERIFIED');
const SpotCheckDtoStatusEnum _$spotCheckDtoStatusEnum_MISSED =
    const SpotCheckDtoStatusEnum._('MISSED');
const SpotCheckDtoStatusEnum _$spotCheckDtoStatusEnum_FACE_MISMATCH =
    const SpotCheckDtoStatusEnum._('FACE_MISMATCH');
const SpotCheckDtoStatusEnum _$spotCheckDtoStatusEnum_OUT_OF_GEOFENCE =
    const SpotCheckDtoStatusEnum._('OUT_OF_GEOFENCE');
const SpotCheckDtoStatusEnum _$spotCheckDtoStatusEnum_UNREACHABLE =
    const SpotCheckDtoStatusEnum._('UNREACHABLE');
const SpotCheckDtoStatusEnum _$spotCheckDtoStatusEnum_CANCELLED =
    const SpotCheckDtoStatusEnum._('CANCELLED');

SpotCheckDtoStatusEnum _$spotCheckDtoStatusEnumValueOf(String name) {
  switch (name) {
    case 'SCHEDULED':
      return _$spotCheckDtoStatusEnum_SCHEDULED;
    case 'NOTIFIED':
      return _$spotCheckDtoStatusEnum_NOTIFIED;
    case 'SNOOZED':
      return _$spotCheckDtoStatusEnum_SNOOZED;
    case 'VERIFIED':
      return _$spotCheckDtoStatusEnum_VERIFIED;
    case 'MISSED':
      return _$spotCheckDtoStatusEnum_MISSED;
    case 'FACE_MISMATCH':
      return _$spotCheckDtoStatusEnum_FACE_MISMATCH;
    case 'OUT_OF_GEOFENCE':
      return _$spotCheckDtoStatusEnum_OUT_OF_GEOFENCE;
    case 'UNREACHABLE':
      return _$spotCheckDtoStatusEnum_UNREACHABLE;
    case 'CANCELLED':
      return _$spotCheckDtoStatusEnum_CANCELLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SpotCheckDtoStatusEnum> _$spotCheckDtoStatusEnumValues =
    BuiltSet<SpotCheckDtoStatusEnum>(const <SpotCheckDtoStatusEnum>[
  _$spotCheckDtoStatusEnum_SCHEDULED,
  _$spotCheckDtoStatusEnum_NOTIFIED,
  _$spotCheckDtoStatusEnum_SNOOZED,
  _$spotCheckDtoStatusEnum_VERIFIED,
  _$spotCheckDtoStatusEnum_MISSED,
  _$spotCheckDtoStatusEnum_FACE_MISMATCH,
  _$spotCheckDtoStatusEnum_OUT_OF_GEOFENCE,
  _$spotCheckDtoStatusEnum_UNREACHABLE,
  _$spotCheckDtoStatusEnum_CANCELLED,
]);

Serializer<SpotCheckDtoTriggerEnum> _$spotCheckDtoTriggerEnumSerializer =
    _$SpotCheckDtoTriggerEnumSerializer();
Serializer<SpotCheckDtoStatusEnum> _$spotCheckDtoStatusEnumSerializer =
    _$SpotCheckDtoStatusEnumSerializer();

class _$SpotCheckDtoTriggerEnumSerializer
    implements PrimitiveSerializer<SpotCheckDtoTriggerEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'RANDOM': 'RANDOM',
    'SENIOR_MANUAL': 'SENIOR_MANUAL',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'RANDOM': 'RANDOM',
    'SENIOR_MANUAL': 'SENIOR_MANUAL',
  };

  @override
  final Iterable<Type> types = const <Type>[SpotCheckDtoTriggerEnum];
  @override
  final String wireName = 'SpotCheckDtoTriggerEnum';

  @override
  Object serialize(Serializers serializers, SpotCheckDtoTriggerEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SpotCheckDtoTriggerEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SpotCheckDtoTriggerEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SpotCheckDtoStatusEnumSerializer
    implements PrimitiveSerializer<SpotCheckDtoStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SCHEDULED': 'SCHEDULED',
    'NOTIFIED': 'NOTIFIED',
    'SNOOZED': 'SNOOZED',
    'VERIFIED': 'VERIFIED',
    'MISSED': 'MISSED',
    'FACE_MISMATCH': 'FACE_MISMATCH',
    'OUT_OF_GEOFENCE': 'OUT_OF_GEOFENCE',
    'UNREACHABLE': 'UNREACHABLE',
    'CANCELLED': 'CANCELLED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SCHEDULED': 'SCHEDULED',
    'NOTIFIED': 'NOTIFIED',
    'SNOOZED': 'SNOOZED',
    'VERIFIED': 'VERIFIED',
    'MISSED': 'MISSED',
    'FACE_MISMATCH': 'FACE_MISMATCH',
    'OUT_OF_GEOFENCE': 'OUT_OF_GEOFENCE',
    'UNREACHABLE': 'UNREACHABLE',
    'CANCELLED': 'CANCELLED',
  };

  @override
  final Iterable<Type> types = const <Type>[SpotCheckDtoStatusEnum];
  @override
  final String wireName = 'SpotCheckDtoStatusEnum';

  @override
  Object serialize(Serializers serializers, SpotCheckDtoStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SpotCheckDtoStatusEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SpotCheckDtoStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SpotCheckDto extends SpotCheckDto {
  @override
  final String id;
  @override
  final String staffId;
  @override
  final String? wardId;
  @override
  final String date;
  @override
  final SpotCheckDtoTriggerEnum trigger;
  @override
  final String? initiatedById;
  @override
  final String? reason;
  @override
  final SpotCheckDtoStatusEnum status;
  @override
  final DateTime? notifiedAt;
  @override
  final DateTime? dueAt;
  @override
  final bool snoozed;
  @override
  final DateTime? respondedAt;
  @override
  final bool? inGeofence;
  @override
  final num? faceScore;
  @override
  final DateTime? escalatedAt;
  @override
  final num version;

  factory _$SpotCheckDto([void Function(SpotCheckDtoBuilder)? updates]) =>
      (SpotCheckDtoBuilder()..update(updates))._build();

  _$SpotCheckDto._(
      {required this.id,
      required this.staffId,
      this.wardId,
      required this.date,
      required this.trigger,
      this.initiatedById,
      this.reason,
      required this.status,
      this.notifiedAt,
      this.dueAt,
      required this.snoozed,
      this.respondedAt,
      this.inGeofence,
      this.faceScore,
      this.escalatedAt,
      required this.version})
      : super._();
  @override
  SpotCheckDto rebuild(void Function(SpotCheckDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SpotCheckDtoBuilder toBuilder() => SpotCheckDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SpotCheckDto &&
        id == other.id &&
        staffId == other.staffId &&
        wardId == other.wardId &&
        date == other.date &&
        trigger == other.trigger &&
        initiatedById == other.initiatedById &&
        reason == other.reason &&
        status == other.status &&
        notifiedAt == other.notifiedAt &&
        dueAt == other.dueAt &&
        snoozed == other.snoozed &&
        respondedAt == other.respondedAt &&
        inGeofence == other.inGeofence &&
        faceScore == other.faceScore &&
        escalatedAt == other.escalatedAt &&
        version == other.version;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, staffId.hashCode);
    _$hash = $jc(_$hash, wardId.hashCode);
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, trigger.hashCode);
    _$hash = $jc(_$hash, initiatedById.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, notifiedAt.hashCode);
    _$hash = $jc(_$hash, dueAt.hashCode);
    _$hash = $jc(_$hash, snoozed.hashCode);
    _$hash = $jc(_$hash, respondedAt.hashCode);
    _$hash = $jc(_$hash, inGeofence.hashCode);
    _$hash = $jc(_$hash, faceScore.hashCode);
    _$hash = $jc(_$hash, escalatedAt.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SpotCheckDto')
          ..add('id', id)
          ..add('staffId', staffId)
          ..add('wardId', wardId)
          ..add('date', date)
          ..add('trigger', trigger)
          ..add('initiatedById', initiatedById)
          ..add('reason', reason)
          ..add('status', status)
          ..add('notifiedAt', notifiedAt)
          ..add('dueAt', dueAt)
          ..add('snoozed', snoozed)
          ..add('respondedAt', respondedAt)
          ..add('inGeofence', inGeofence)
          ..add('faceScore', faceScore)
          ..add('escalatedAt', escalatedAt)
          ..add('version', version))
        .toString();
  }
}

class SpotCheckDtoBuilder
    implements Builder<SpotCheckDto, SpotCheckDtoBuilder> {
  _$SpotCheckDto? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _staffId;
  String? get staffId => _$this._staffId;
  set staffId(String? staffId) => _$this._staffId = staffId;

  String? _wardId;
  String? get wardId => _$this._wardId;
  set wardId(String? wardId) => _$this._wardId = wardId;

  String? _date;
  String? get date => _$this._date;
  set date(String? date) => _$this._date = date;

  SpotCheckDtoTriggerEnum? _trigger;
  SpotCheckDtoTriggerEnum? get trigger => _$this._trigger;
  set trigger(SpotCheckDtoTriggerEnum? trigger) => _$this._trigger = trigger;

  String? _initiatedById;
  String? get initiatedById => _$this._initiatedById;
  set initiatedById(String? initiatedById) =>
      _$this._initiatedById = initiatedById;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  SpotCheckDtoStatusEnum? _status;
  SpotCheckDtoStatusEnum? get status => _$this._status;
  set status(SpotCheckDtoStatusEnum? status) => _$this._status = status;

  DateTime? _notifiedAt;
  DateTime? get notifiedAt => _$this._notifiedAt;
  set notifiedAt(DateTime? notifiedAt) => _$this._notifiedAt = notifiedAt;

  DateTime? _dueAt;
  DateTime? get dueAt => _$this._dueAt;
  set dueAt(DateTime? dueAt) => _$this._dueAt = dueAt;

  bool? _snoozed;
  bool? get snoozed => _$this._snoozed;
  set snoozed(bool? snoozed) => _$this._snoozed = snoozed;

  DateTime? _respondedAt;
  DateTime? get respondedAt => _$this._respondedAt;
  set respondedAt(DateTime? respondedAt) => _$this._respondedAt = respondedAt;

  bool? _inGeofence;
  bool? get inGeofence => _$this._inGeofence;
  set inGeofence(bool? inGeofence) => _$this._inGeofence = inGeofence;

  num? _faceScore;
  num? get faceScore => _$this._faceScore;
  set faceScore(num? faceScore) => _$this._faceScore = faceScore;

  DateTime? _escalatedAt;
  DateTime? get escalatedAt => _$this._escalatedAt;
  set escalatedAt(DateTime? escalatedAt) => _$this._escalatedAt = escalatedAt;

  num? _version;
  num? get version => _$this._version;
  set version(num? version) => _$this._version = version;

  SpotCheckDtoBuilder() {
    SpotCheckDto._defaults(this);
  }

  SpotCheckDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _staffId = $v.staffId;
      _wardId = $v.wardId;
      _date = $v.date;
      _trigger = $v.trigger;
      _initiatedById = $v.initiatedById;
      _reason = $v.reason;
      _status = $v.status;
      _notifiedAt = $v.notifiedAt;
      _dueAt = $v.dueAt;
      _snoozed = $v.snoozed;
      _respondedAt = $v.respondedAt;
      _inGeofence = $v.inGeofence;
      _faceScore = $v.faceScore;
      _escalatedAt = $v.escalatedAt;
      _version = $v.version;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SpotCheckDto other) {
    _$v = other as _$SpotCheckDto;
  }

  @override
  void update(void Function(SpotCheckDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SpotCheckDto build() => _build();

  _$SpotCheckDto _build() {
    final _$result = _$v ??
        _$SpotCheckDto._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'SpotCheckDto', 'id'),
          staffId: BuiltValueNullFieldError.checkNotNull(
              staffId, r'SpotCheckDto', 'staffId'),
          wardId: wardId,
          date: BuiltValueNullFieldError.checkNotNull(
              date, r'SpotCheckDto', 'date'),
          trigger: BuiltValueNullFieldError.checkNotNull(
              trigger, r'SpotCheckDto', 'trigger'),
          initiatedById: initiatedById,
          reason: reason,
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'SpotCheckDto', 'status'),
          notifiedAt: notifiedAt,
          dueAt: dueAt,
          snoozed: BuiltValueNullFieldError.checkNotNull(
              snoozed, r'SpotCheckDto', 'snoozed'),
          respondedAt: respondedAt,
          inGeofence: inGeofence,
          faceScore: faceScore,
          escalatedAt: escalatedAt,
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'SpotCheckDto', 'version'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
