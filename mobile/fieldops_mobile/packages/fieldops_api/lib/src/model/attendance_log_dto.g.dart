// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_log_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AttendanceLogDtoStatusEnum _$attendanceLogDtoStatusEnum_PRESENT =
    const AttendanceLogDtoStatusEnum._('PRESENT');
const AttendanceLogDtoStatusEnum _$attendanceLogDtoStatusEnum_ABSENT =
    const AttendanceLogDtoStatusEnum._('ABSENT');
const AttendanceLogDtoStatusEnum _$attendanceLogDtoStatusEnum_LATE =
    const AttendanceLogDtoStatusEnum._('LATE');
const AttendanceLogDtoStatusEnum _$attendanceLogDtoStatusEnum_HALF_DAY =
    const AttendanceLogDtoStatusEnum._('HALF_DAY');
const AttendanceLogDtoStatusEnum _$attendanceLogDtoStatusEnum_HOLIDAY_OFF =
    const AttendanceLogDtoStatusEnum._('HOLIDAY_OFF');
const AttendanceLogDtoStatusEnum _$attendanceLogDtoStatusEnum_ON_LEAVE =
    const AttendanceLogDtoStatusEnum._('ON_LEAVE');
const AttendanceLogDtoStatusEnum _$attendanceLogDtoStatusEnum_REGULARIZED =
    const AttendanceLogDtoStatusEnum._('REGULARIZED');

AttendanceLogDtoStatusEnum _$attendanceLogDtoStatusEnumValueOf(String name) {
  switch (name) {
    case 'PRESENT':
      return _$attendanceLogDtoStatusEnum_PRESENT;
    case 'ABSENT':
      return _$attendanceLogDtoStatusEnum_ABSENT;
    case 'LATE':
      return _$attendanceLogDtoStatusEnum_LATE;
    case 'HALF_DAY':
      return _$attendanceLogDtoStatusEnum_HALF_DAY;
    case 'HOLIDAY_OFF':
      return _$attendanceLogDtoStatusEnum_HOLIDAY_OFF;
    case 'ON_LEAVE':
      return _$attendanceLogDtoStatusEnum_ON_LEAVE;
    case 'REGULARIZED':
      return _$attendanceLogDtoStatusEnum_REGULARIZED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AttendanceLogDtoStatusEnum> _$attendanceLogDtoStatusEnumValues =
    BuiltSet<AttendanceLogDtoStatusEnum>(const <AttendanceLogDtoStatusEnum>[
  _$attendanceLogDtoStatusEnum_PRESENT,
  _$attendanceLogDtoStatusEnum_ABSENT,
  _$attendanceLogDtoStatusEnum_LATE,
  _$attendanceLogDtoStatusEnum_HALF_DAY,
  _$attendanceLogDtoStatusEnum_HOLIDAY_OFF,
  _$attendanceLogDtoStatusEnum_ON_LEAVE,
  _$attendanceLogDtoStatusEnum_REGULARIZED,
]);

const AttendanceLogDtoCheckoutTypeEnum
    _$attendanceLogDtoCheckoutTypeEnum_MANUAL =
    const AttendanceLogDtoCheckoutTypeEnum._('MANUAL');
const AttendanceLogDtoCheckoutTypeEnum
    _$attendanceLogDtoCheckoutTypeEnum_AUTO_GPS_LAST_SEEN =
    const AttendanceLogDtoCheckoutTypeEnum._('AUTO_GPS_LAST_SEEN');
const AttendanceLogDtoCheckoutTypeEnum
    _$attendanceLogDtoCheckoutTypeEnum_AUTO_OFFICE_SCHEDULED =
    const AttendanceLogDtoCheckoutTypeEnum._('AUTO_OFFICE_SCHEDULED');
const AttendanceLogDtoCheckoutTypeEnum
    _$attendanceLogDtoCheckoutTypeEnum_SUPERVISOR_OVERRIDE =
    const AttendanceLogDtoCheckoutTypeEnum._('SUPERVISOR_OVERRIDE');

AttendanceLogDtoCheckoutTypeEnum _$attendanceLogDtoCheckoutTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'MANUAL':
      return _$attendanceLogDtoCheckoutTypeEnum_MANUAL;
    case 'AUTO_GPS_LAST_SEEN':
      return _$attendanceLogDtoCheckoutTypeEnum_AUTO_GPS_LAST_SEEN;
    case 'AUTO_OFFICE_SCHEDULED':
      return _$attendanceLogDtoCheckoutTypeEnum_AUTO_OFFICE_SCHEDULED;
    case 'SUPERVISOR_OVERRIDE':
      return _$attendanceLogDtoCheckoutTypeEnum_SUPERVISOR_OVERRIDE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AttendanceLogDtoCheckoutTypeEnum>
    _$attendanceLogDtoCheckoutTypeEnumValues = BuiltSet<
        AttendanceLogDtoCheckoutTypeEnum>(const <AttendanceLogDtoCheckoutTypeEnum>[
  _$attendanceLogDtoCheckoutTypeEnum_MANUAL,
  _$attendanceLogDtoCheckoutTypeEnum_AUTO_GPS_LAST_SEEN,
  _$attendanceLogDtoCheckoutTypeEnum_AUTO_OFFICE_SCHEDULED,
  _$attendanceLogDtoCheckoutTypeEnum_SUPERVISOR_OVERRIDE,
]);

Serializer<AttendanceLogDtoStatusEnum> _$attendanceLogDtoStatusEnumSerializer =
    _$AttendanceLogDtoStatusEnumSerializer();
Serializer<AttendanceLogDtoCheckoutTypeEnum>
    _$attendanceLogDtoCheckoutTypeEnumSerializer =
    _$AttendanceLogDtoCheckoutTypeEnumSerializer();

class _$AttendanceLogDtoStatusEnumSerializer
    implements PrimitiveSerializer<AttendanceLogDtoStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PRESENT': 'PRESENT',
    'ABSENT': 'ABSENT',
    'LATE': 'LATE',
    'HALF_DAY': 'HALF_DAY',
    'HOLIDAY_OFF': 'HOLIDAY_OFF',
    'ON_LEAVE': 'ON_LEAVE',
    'REGULARIZED': 'REGULARIZED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PRESENT': 'PRESENT',
    'ABSENT': 'ABSENT',
    'LATE': 'LATE',
    'HALF_DAY': 'HALF_DAY',
    'HOLIDAY_OFF': 'HOLIDAY_OFF',
    'ON_LEAVE': 'ON_LEAVE',
    'REGULARIZED': 'REGULARIZED',
  };

  @override
  final Iterable<Type> types = const <Type>[AttendanceLogDtoStatusEnum];
  @override
  final String wireName = 'AttendanceLogDtoStatusEnum';

  @override
  Object serialize(Serializers serializers, AttendanceLogDtoStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AttendanceLogDtoStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AttendanceLogDtoStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AttendanceLogDtoCheckoutTypeEnumSerializer
    implements PrimitiveSerializer<AttendanceLogDtoCheckoutTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'MANUAL': 'MANUAL',
    'AUTO_GPS_LAST_SEEN': 'AUTO_GPS_LAST_SEEN',
    'AUTO_OFFICE_SCHEDULED': 'AUTO_OFFICE_SCHEDULED',
    'SUPERVISOR_OVERRIDE': 'SUPERVISOR_OVERRIDE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'MANUAL': 'MANUAL',
    'AUTO_GPS_LAST_SEEN': 'AUTO_GPS_LAST_SEEN',
    'AUTO_OFFICE_SCHEDULED': 'AUTO_OFFICE_SCHEDULED',
    'SUPERVISOR_OVERRIDE': 'SUPERVISOR_OVERRIDE',
  };

  @override
  final Iterable<Type> types = const <Type>[AttendanceLogDtoCheckoutTypeEnum];
  @override
  final String wireName = 'AttendanceLogDtoCheckoutTypeEnum';

  @override
  Object serialize(
          Serializers serializers, AttendanceLogDtoCheckoutTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AttendanceLogDtoCheckoutTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AttendanceLogDtoCheckoutTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AttendanceLogDto extends AttendanceLogDto {
  @override
  final String id;
  @override
  final String staffId;
  @override
  final String date;
  @override
  final AttendanceLogDtoStatusEnum status;
  @override
  final String? wardId;
  @override
  final String? officeId;
  @override
  final String? assignmentId;
  @override
  final bool isLate;
  @override
  final num lateMinutes;
  @override
  final num? workedMinutes;
  @override
  final PunchDetailsDto? checkin;
  @override
  final num? checkinDistanceM;
  @override
  final num? checkinFaceScore;
  @override
  final PunchDetailsDto? checkout;
  @override
  final AttendanceLogDtoCheckoutTypeEnum? checkoutType;
  @override
  final bool isSuspicious;
  @override
  final num version;

  factory _$AttendanceLogDto(
          [void Function(AttendanceLogDtoBuilder)? updates]) =>
      (AttendanceLogDtoBuilder()..update(updates))._build();

  _$AttendanceLogDto._(
      {required this.id,
      required this.staffId,
      required this.date,
      required this.status,
      this.wardId,
      this.officeId,
      this.assignmentId,
      required this.isLate,
      required this.lateMinutes,
      this.workedMinutes,
      this.checkin,
      this.checkinDistanceM,
      this.checkinFaceScore,
      this.checkout,
      this.checkoutType,
      required this.isSuspicious,
      required this.version})
      : super._();
  @override
  AttendanceLogDto rebuild(void Function(AttendanceLogDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AttendanceLogDtoBuilder toBuilder() =>
      AttendanceLogDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AttendanceLogDto &&
        id == other.id &&
        staffId == other.staffId &&
        date == other.date &&
        status == other.status &&
        wardId == other.wardId &&
        officeId == other.officeId &&
        assignmentId == other.assignmentId &&
        isLate == other.isLate &&
        lateMinutes == other.lateMinutes &&
        workedMinutes == other.workedMinutes &&
        checkin == other.checkin &&
        checkinDistanceM == other.checkinDistanceM &&
        checkinFaceScore == other.checkinFaceScore &&
        checkout == other.checkout &&
        checkoutType == other.checkoutType &&
        isSuspicious == other.isSuspicious &&
        version == other.version;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, staffId.hashCode);
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, wardId.hashCode);
    _$hash = $jc(_$hash, officeId.hashCode);
    _$hash = $jc(_$hash, assignmentId.hashCode);
    _$hash = $jc(_$hash, isLate.hashCode);
    _$hash = $jc(_$hash, lateMinutes.hashCode);
    _$hash = $jc(_$hash, workedMinutes.hashCode);
    _$hash = $jc(_$hash, checkin.hashCode);
    _$hash = $jc(_$hash, checkinDistanceM.hashCode);
    _$hash = $jc(_$hash, checkinFaceScore.hashCode);
    _$hash = $jc(_$hash, checkout.hashCode);
    _$hash = $jc(_$hash, checkoutType.hashCode);
    _$hash = $jc(_$hash, isSuspicious.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AttendanceLogDto')
          ..add('id', id)
          ..add('staffId', staffId)
          ..add('date', date)
          ..add('status', status)
          ..add('wardId', wardId)
          ..add('officeId', officeId)
          ..add('assignmentId', assignmentId)
          ..add('isLate', isLate)
          ..add('lateMinutes', lateMinutes)
          ..add('workedMinutes', workedMinutes)
          ..add('checkin', checkin)
          ..add('checkinDistanceM', checkinDistanceM)
          ..add('checkinFaceScore', checkinFaceScore)
          ..add('checkout', checkout)
          ..add('checkoutType', checkoutType)
          ..add('isSuspicious', isSuspicious)
          ..add('version', version))
        .toString();
  }
}

class AttendanceLogDtoBuilder
    implements Builder<AttendanceLogDto, AttendanceLogDtoBuilder> {
  _$AttendanceLogDto? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _staffId;
  String? get staffId => _$this._staffId;
  set staffId(String? staffId) => _$this._staffId = staffId;

  String? _date;
  String? get date => _$this._date;
  set date(String? date) => _$this._date = date;

  AttendanceLogDtoStatusEnum? _status;
  AttendanceLogDtoStatusEnum? get status => _$this._status;
  set status(AttendanceLogDtoStatusEnum? status) => _$this._status = status;

  String? _wardId;
  String? get wardId => _$this._wardId;
  set wardId(String? wardId) => _$this._wardId = wardId;

  String? _officeId;
  String? get officeId => _$this._officeId;
  set officeId(String? officeId) => _$this._officeId = officeId;

  String? _assignmentId;
  String? get assignmentId => _$this._assignmentId;
  set assignmentId(String? assignmentId) => _$this._assignmentId = assignmentId;

  bool? _isLate;
  bool? get isLate => _$this._isLate;
  set isLate(bool? isLate) => _$this._isLate = isLate;

  num? _lateMinutes;
  num? get lateMinutes => _$this._lateMinutes;
  set lateMinutes(num? lateMinutes) => _$this._lateMinutes = lateMinutes;

  num? _workedMinutes;
  num? get workedMinutes => _$this._workedMinutes;
  set workedMinutes(num? workedMinutes) =>
      _$this._workedMinutes = workedMinutes;

  PunchDetailsDtoBuilder? _checkin;
  PunchDetailsDtoBuilder get checkin =>
      _$this._checkin ??= PunchDetailsDtoBuilder();
  set checkin(PunchDetailsDtoBuilder? checkin) => _$this._checkin = checkin;

  num? _checkinDistanceM;
  num? get checkinDistanceM => _$this._checkinDistanceM;
  set checkinDistanceM(num? checkinDistanceM) =>
      _$this._checkinDistanceM = checkinDistanceM;

  num? _checkinFaceScore;
  num? get checkinFaceScore => _$this._checkinFaceScore;
  set checkinFaceScore(num? checkinFaceScore) =>
      _$this._checkinFaceScore = checkinFaceScore;

  PunchDetailsDtoBuilder? _checkout;
  PunchDetailsDtoBuilder get checkout =>
      _$this._checkout ??= PunchDetailsDtoBuilder();
  set checkout(PunchDetailsDtoBuilder? checkout) => _$this._checkout = checkout;

  AttendanceLogDtoCheckoutTypeEnum? _checkoutType;
  AttendanceLogDtoCheckoutTypeEnum? get checkoutType => _$this._checkoutType;
  set checkoutType(AttendanceLogDtoCheckoutTypeEnum? checkoutType) =>
      _$this._checkoutType = checkoutType;

  bool? _isSuspicious;
  bool? get isSuspicious => _$this._isSuspicious;
  set isSuspicious(bool? isSuspicious) => _$this._isSuspicious = isSuspicious;

  num? _version;
  num? get version => _$this._version;
  set version(num? version) => _$this._version = version;

  AttendanceLogDtoBuilder() {
    AttendanceLogDto._defaults(this);
  }

  AttendanceLogDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _staffId = $v.staffId;
      _date = $v.date;
      _status = $v.status;
      _wardId = $v.wardId;
      _officeId = $v.officeId;
      _assignmentId = $v.assignmentId;
      _isLate = $v.isLate;
      _lateMinutes = $v.lateMinutes;
      _workedMinutes = $v.workedMinutes;
      _checkin = $v.checkin?.toBuilder();
      _checkinDistanceM = $v.checkinDistanceM;
      _checkinFaceScore = $v.checkinFaceScore;
      _checkout = $v.checkout?.toBuilder();
      _checkoutType = $v.checkoutType;
      _isSuspicious = $v.isSuspicious;
      _version = $v.version;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AttendanceLogDto other) {
    _$v = other as _$AttendanceLogDto;
  }

  @override
  void update(void Function(AttendanceLogDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AttendanceLogDto build() => _build();

  _$AttendanceLogDto _build() {
    _$AttendanceLogDto _$result;
    try {
      _$result = _$v ??
          _$AttendanceLogDto._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'AttendanceLogDto', 'id'),
            staffId: BuiltValueNullFieldError.checkNotNull(
                staffId, r'AttendanceLogDto', 'staffId'),
            date: BuiltValueNullFieldError.checkNotNull(
                date, r'AttendanceLogDto', 'date'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'AttendanceLogDto', 'status'),
            wardId: wardId,
            officeId: officeId,
            assignmentId: assignmentId,
            isLate: BuiltValueNullFieldError.checkNotNull(
                isLate, r'AttendanceLogDto', 'isLate'),
            lateMinutes: BuiltValueNullFieldError.checkNotNull(
                lateMinutes, r'AttendanceLogDto', 'lateMinutes'),
            workedMinutes: workedMinutes,
            checkin: _checkin?.build(),
            checkinDistanceM: checkinDistanceM,
            checkinFaceScore: checkinFaceScore,
            checkout: _checkout?.build(),
            checkoutType: checkoutType,
            isSuspicious: BuiltValueNullFieldError.checkNotNull(
                isSuspicious, r'AttendanceLogDto', 'isSuspicious'),
            version: BuiltValueNullFieldError.checkNotNull(
                version, r'AttendanceLogDto', 'version'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'checkin';
        _checkin?.build();

        _$failedField = 'checkout';
        _checkout?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AttendanceLogDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
