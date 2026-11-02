// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_request_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const LeaveRequestDtoStatusEnum _$leaveRequestDtoStatusEnum_PENDING =
    const LeaveRequestDtoStatusEnum._('PENDING');
const LeaveRequestDtoStatusEnum _$leaveRequestDtoStatusEnum_APPROVED =
    const LeaveRequestDtoStatusEnum._('APPROVED');
const LeaveRequestDtoStatusEnum _$leaveRequestDtoStatusEnum_REJECTED =
    const LeaveRequestDtoStatusEnum._('REJECTED');
const LeaveRequestDtoStatusEnum _$leaveRequestDtoStatusEnum_CANCELLED =
    const LeaveRequestDtoStatusEnum._('CANCELLED');

LeaveRequestDtoStatusEnum _$leaveRequestDtoStatusEnumValueOf(String name) {
  switch (name) {
    case 'PENDING':
      return _$leaveRequestDtoStatusEnum_PENDING;
    case 'APPROVED':
      return _$leaveRequestDtoStatusEnum_APPROVED;
    case 'REJECTED':
      return _$leaveRequestDtoStatusEnum_REJECTED;
    case 'CANCELLED':
      return _$leaveRequestDtoStatusEnum_CANCELLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<LeaveRequestDtoStatusEnum> _$leaveRequestDtoStatusEnumValues =
    BuiltSet<LeaveRequestDtoStatusEnum>(const <LeaveRequestDtoStatusEnum>[
  _$leaveRequestDtoStatusEnum_PENDING,
  _$leaveRequestDtoStatusEnum_APPROVED,
  _$leaveRequestDtoStatusEnum_REJECTED,
  _$leaveRequestDtoStatusEnum_CANCELLED,
]);

const LeaveRequestDtoLeaveTypeEnum _$leaveRequestDtoLeaveTypeEnum_CASUAL =
    const LeaveRequestDtoLeaveTypeEnum._('CASUAL');
const LeaveRequestDtoLeaveTypeEnum _$leaveRequestDtoLeaveTypeEnum_SICK =
    const LeaveRequestDtoLeaveTypeEnum._('SICK');
const LeaveRequestDtoLeaveTypeEnum _$leaveRequestDtoLeaveTypeEnum_EARNED =
    const LeaveRequestDtoLeaveTypeEnum._('EARNED');
const LeaveRequestDtoLeaveTypeEnum _$leaveRequestDtoLeaveTypeEnum_WEEKLY_OFF =
    const LeaveRequestDtoLeaveTypeEnum._('WEEKLY_OFF');

LeaveRequestDtoLeaveTypeEnum _$leaveRequestDtoLeaveTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'CASUAL':
      return _$leaveRequestDtoLeaveTypeEnum_CASUAL;
    case 'SICK':
      return _$leaveRequestDtoLeaveTypeEnum_SICK;
    case 'EARNED':
      return _$leaveRequestDtoLeaveTypeEnum_EARNED;
    case 'WEEKLY_OFF':
      return _$leaveRequestDtoLeaveTypeEnum_WEEKLY_OFF;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<LeaveRequestDtoLeaveTypeEnum>
    _$leaveRequestDtoLeaveTypeEnumValues =
    BuiltSet<LeaveRequestDtoLeaveTypeEnum>(const <LeaveRequestDtoLeaveTypeEnum>[
  _$leaveRequestDtoLeaveTypeEnum_CASUAL,
  _$leaveRequestDtoLeaveTypeEnum_SICK,
  _$leaveRequestDtoLeaveTypeEnum_EARNED,
  _$leaveRequestDtoLeaveTypeEnum_WEEKLY_OFF,
]);

Serializer<LeaveRequestDtoStatusEnum> _$leaveRequestDtoStatusEnumSerializer =
    _$LeaveRequestDtoStatusEnumSerializer();
Serializer<LeaveRequestDtoLeaveTypeEnum>
    _$leaveRequestDtoLeaveTypeEnumSerializer =
    _$LeaveRequestDtoLeaveTypeEnumSerializer();

class _$LeaveRequestDtoStatusEnumSerializer
    implements PrimitiveSerializer<LeaveRequestDtoStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PENDING': 'PENDING',
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
    'CANCELLED': 'CANCELLED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PENDING': 'PENDING',
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
    'CANCELLED': 'CANCELLED',
  };

  @override
  final Iterable<Type> types = const <Type>[LeaveRequestDtoStatusEnum];
  @override
  final String wireName = 'LeaveRequestDtoStatusEnum';

  @override
  Object serialize(Serializers serializers, LeaveRequestDtoStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  LeaveRequestDtoStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      LeaveRequestDtoStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$LeaveRequestDtoLeaveTypeEnumSerializer
    implements PrimitiveSerializer<LeaveRequestDtoLeaveTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'CASUAL': 'CASUAL',
    'SICK': 'SICK',
    'EARNED': 'EARNED',
    'WEEKLY_OFF': 'WEEKLY_OFF',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CASUAL': 'CASUAL',
    'SICK': 'SICK',
    'EARNED': 'EARNED',
    'WEEKLY_OFF': 'WEEKLY_OFF',
  };

  @override
  final Iterable<Type> types = const <Type>[LeaveRequestDtoLeaveTypeEnum];
  @override
  final String wireName = 'LeaveRequestDtoLeaveTypeEnum';

  @override
  Object serialize(Serializers serializers, LeaveRequestDtoLeaveTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  LeaveRequestDtoLeaveTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      LeaveRequestDtoLeaveTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$LeaveRequestDto extends LeaveRequestDto {
  @override
  final String id;
  @override
  final String staffId;
  @override
  final LeaveRequestDtoStatusEnum status;
  @override
  final String? reviewedById;
  @override
  final DateTime? reviewedAt;
  @override
  final String? reviewNote;
  @override
  final num version;
  @override
  final DateTime createdAt;
  @override
  final LeaveRequestDtoLeaveTypeEnum leaveType;
  @override
  final String fromDate;
  @override
  final String toDate;
  @override
  final num daysCount;
  @override
  final String? reason;

  factory _$LeaveRequestDto([void Function(LeaveRequestDtoBuilder)? updates]) =>
      (LeaveRequestDtoBuilder()..update(updates))._build();

  _$LeaveRequestDto._(
      {required this.id,
      required this.staffId,
      required this.status,
      this.reviewedById,
      this.reviewedAt,
      this.reviewNote,
      required this.version,
      required this.createdAt,
      required this.leaveType,
      required this.fromDate,
      required this.toDate,
      required this.daysCount,
      this.reason})
      : super._();
  @override
  LeaveRequestDto rebuild(void Function(LeaveRequestDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LeaveRequestDtoBuilder toBuilder() => LeaveRequestDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LeaveRequestDto &&
        id == other.id &&
        staffId == other.staffId &&
        status == other.status &&
        reviewedById == other.reviewedById &&
        reviewedAt == other.reviewedAt &&
        reviewNote == other.reviewNote &&
        version == other.version &&
        createdAt == other.createdAt &&
        leaveType == other.leaveType &&
        fromDate == other.fromDate &&
        toDate == other.toDate &&
        daysCount == other.daysCount &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, staffId.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, reviewedById.hashCode);
    _$hash = $jc(_$hash, reviewedAt.hashCode);
    _$hash = $jc(_$hash, reviewNote.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, leaveType.hashCode);
    _$hash = $jc(_$hash, fromDate.hashCode);
    _$hash = $jc(_$hash, toDate.hashCode);
    _$hash = $jc(_$hash, daysCount.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LeaveRequestDto')
          ..add('id', id)
          ..add('staffId', staffId)
          ..add('status', status)
          ..add('reviewedById', reviewedById)
          ..add('reviewedAt', reviewedAt)
          ..add('reviewNote', reviewNote)
          ..add('version', version)
          ..add('createdAt', createdAt)
          ..add('leaveType', leaveType)
          ..add('fromDate', fromDate)
          ..add('toDate', toDate)
          ..add('daysCount', daysCount)
          ..add('reason', reason))
        .toString();
  }
}

class LeaveRequestDtoBuilder
    implements Builder<LeaveRequestDto, LeaveRequestDtoBuilder> {
  _$LeaveRequestDto? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _staffId;
  String? get staffId => _$this._staffId;
  set staffId(String? staffId) => _$this._staffId = staffId;

  LeaveRequestDtoStatusEnum? _status;
  LeaveRequestDtoStatusEnum? get status => _$this._status;
  set status(LeaveRequestDtoStatusEnum? status) => _$this._status = status;

  String? _reviewedById;
  String? get reviewedById => _$this._reviewedById;
  set reviewedById(String? reviewedById) => _$this._reviewedById = reviewedById;

  DateTime? _reviewedAt;
  DateTime? get reviewedAt => _$this._reviewedAt;
  set reviewedAt(DateTime? reviewedAt) => _$this._reviewedAt = reviewedAt;

  String? _reviewNote;
  String? get reviewNote => _$this._reviewNote;
  set reviewNote(String? reviewNote) => _$this._reviewNote = reviewNote;

  num? _version;
  num? get version => _$this._version;
  set version(num? version) => _$this._version = version;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  LeaveRequestDtoLeaveTypeEnum? _leaveType;
  LeaveRequestDtoLeaveTypeEnum? get leaveType => _$this._leaveType;
  set leaveType(LeaveRequestDtoLeaveTypeEnum? leaveType) =>
      _$this._leaveType = leaveType;

  String? _fromDate;
  String? get fromDate => _$this._fromDate;
  set fromDate(String? fromDate) => _$this._fromDate = fromDate;

  String? _toDate;
  String? get toDate => _$this._toDate;
  set toDate(String? toDate) => _$this._toDate = toDate;

  num? _daysCount;
  num? get daysCount => _$this._daysCount;
  set daysCount(num? daysCount) => _$this._daysCount = daysCount;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  LeaveRequestDtoBuilder() {
    LeaveRequestDto._defaults(this);
  }

  LeaveRequestDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _staffId = $v.staffId;
      _status = $v.status;
      _reviewedById = $v.reviewedById;
      _reviewedAt = $v.reviewedAt;
      _reviewNote = $v.reviewNote;
      _version = $v.version;
      _createdAt = $v.createdAt;
      _leaveType = $v.leaveType;
      _fromDate = $v.fromDate;
      _toDate = $v.toDate;
      _daysCount = $v.daysCount;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LeaveRequestDto other) {
    _$v = other as _$LeaveRequestDto;
  }

  @override
  void update(void Function(LeaveRequestDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LeaveRequestDto build() => _build();

  _$LeaveRequestDto _build() {
    final _$result = _$v ??
        _$LeaveRequestDto._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'LeaveRequestDto', 'id'),
          staffId: BuiltValueNullFieldError.checkNotNull(
              staffId, r'LeaveRequestDto', 'staffId'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'LeaveRequestDto', 'status'),
          reviewedById: reviewedById,
          reviewedAt: reviewedAt,
          reviewNote: reviewNote,
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'LeaveRequestDto', 'version'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'LeaveRequestDto', 'createdAt'),
          leaveType: BuiltValueNullFieldError.checkNotNull(
              leaveType, r'LeaveRequestDto', 'leaveType'),
          fromDate: BuiltValueNullFieldError.checkNotNull(
              fromDate, r'LeaveRequestDto', 'fromDate'),
          toDate: BuiltValueNullFieldError.checkNotNull(
              toDate, r'LeaveRequestDto', 'toDate'),
          daysCount: BuiltValueNullFieldError.checkNotNull(
              daysCount, r'LeaveRequestDto', 'daysCount'),
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
