// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regularization_request_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RegularizationRequestDtoStatusEnum
    _$regularizationRequestDtoStatusEnum_PENDING =
    const RegularizationRequestDtoStatusEnum._('PENDING');
const RegularizationRequestDtoStatusEnum
    _$regularizationRequestDtoStatusEnum_APPROVED =
    const RegularizationRequestDtoStatusEnum._('APPROVED');
const RegularizationRequestDtoStatusEnum
    _$regularizationRequestDtoStatusEnum_REJECTED =
    const RegularizationRequestDtoStatusEnum._('REJECTED');
const RegularizationRequestDtoStatusEnum
    _$regularizationRequestDtoStatusEnum_CANCELLED =
    const RegularizationRequestDtoStatusEnum._('CANCELLED');

RegularizationRequestDtoStatusEnum _$regularizationRequestDtoStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'PENDING':
      return _$regularizationRequestDtoStatusEnum_PENDING;
    case 'APPROVED':
      return _$regularizationRequestDtoStatusEnum_APPROVED;
    case 'REJECTED':
      return _$regularizationRequestDtoStatusEnum_REJECTED;
    case 'CANCELLED':
      return _$regularizationRequestDtoStatusEnum_CANCELLED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RegularizationRequestDtoStatusEnum>
    _$regularizationRequestDtoStatusEnumValues = BuiltSet<
        RegularizationRequestDtoStatusEnum>(const <RegularizationRequestDtoStatusEnum>[
  _$regularizationRequestDtoStatusEnum_PENDING,
  _$regularizationRequestDtoStatusEnum_APPROVED,
  _$regularizationRequestDtoStatusEnum_REJECTED,
  _$regularizationRequestDtoStatusEnum_CANCELLED,
]);

const RegularizationRequestDtoReasonTypeEnum
    _$regularizationRequestDtoReasonTypeEnum_BATTERY_DEAD =
    const RegularizationRequestDtoReasonTypeEnum._('BATTERY_DEAD');
const RegularizationRequestDtoReasonTypeEnum
    _$regularizationRequestDtoReasonTypeEnum_APP_CRASH =
    const RegularizationRequestDtoReasonTypeEnum._('APP_CRASH');
const RegularizationRequestDtoReasonTypeEnum
    _$regularizationRequestDtoReasonTypeEnum_FIELD_RESCUE_DUTY =
    const RegularizationRequestDtoReasonTypeEnum._('FIELD_RESCUE_DUTY');
const RegularizationRequestDtoReasonTypeEnum
    _$regularizationRequestDtoReasonTypeEnum_OUT_OF_NETWORK =
    const RegularizationRequestDtoReasonTypeEnum._('OUT_OF_NETWORK');
const RegularizationRequestDtoReasonTypeEnum
    _$regularizationRequestDtoReasonTypeEnum_OTHER =
    const RegularizationRequestDtoReasonTypeEnum._('OTHER');

RegularizationRequestDtoReasonTypeEnum
    _$regularizationRequestDtoReasonTypeEnumValueOf(String name) {
  switch (name) {
    case 'BATTERY_DEAD':
      return _$regularizationRequestDtoReasonTypeEnum_BATTERY_DEAD;
    case 'APP_CRASH':
      return _$regularizationRequestDtoReasonTypeEnum_APP_CRASH;
    case 'FIELD_RESCUE_DUTY':
      return _$regularizationRequestDtoReasonTypeEnum_FIELD_RESCUE_DUTY;
    case 'OUT_OF_NETWORK':
      return _$regularizationRequestDtoReasonTypeEnum_OUT_OF_NETWORK;
    case 'OTHER':
      return _$regularizationRequestDtoReasonTypeEnum_OTHER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RegularizationRequestDtoReasonTypeEnum>
    _$regularizationRequestDtoReasonTypeEnumValues = BuiltSet<
        RegularizationRequestDtoReasonTypeEnum>(const <RegularizationRequestDtoReasonTypeEnum>[
  _$regularizationRequestDtoReasonTypeEnum_BATTERY_DEAD,
  _$regularizationRequestDtoReasonTypeEnum_APP_CRASH,
  _$regularizationRequestDtoReasonTypeEnum_FIELD_RESCUE_DUTY,
  _$regularizationRequestDtoReasonTypeEnum_OUT_OF_NETWORK,
  _$regularizationRequestDtoReasonTypeEnum_OTHER,
]);

Serializer<RegularizationRequestDtoStatusEnum>
    _$regularizationRequestDtoStatusEnumSerializer =
    _$RegularizationRequestDtoStatusEnumSerializer();
Serializer<RegularizationRequestDtoReasonTypeEnum>
    _$regularizationRequestDtoReasonTypeEnumSerializer =
    _$RegularizationRequestDtoReasonTypeEnumSerializer();

class _$RegularizationRequestDtoStatusEnumSerializer
    implements PrimitiveSerializer<RegularizationRequestDtoStatusEnum> {
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
  final Iterable<Type> types = const <Type>[RegularizationRequestDtoStatusEnum];
  @override
  final String wireName = 'RegularizationRequestDtoStatusEnum';

  @override
  Object serialize(
          Serializers serializers, RegularizationRequestDtoStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RegularizationRequestDtoStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RegularizationRequestDtoStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RegularizationRequestDtoReasonTypeEnumSerializer
    implements PrimitiveSerializer<RegularizationRequestDtoReasonTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BATTERY_DEAD': 'BATTERY_DEAD',
    'APP_CRASH': 'APP_CRASH',
    'FIELD_RESCUE_DUTY': 'FIELD_RESCUE_DUTY',
    'OUT_OF_NETWORK': 'OUT_OF_NETWORK',
    'OTHER': 'OTHER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BATTERY_DEAD': 'BATTERY_DEAD',
    'APP_CRASH': 'APP_CRASH',
    'FIELD_RESCUE_DUTY': 'FIELD_RESCUE_DUTY',
    'OUT_OF_NETWORK': 'OUT_OF_NETWORK',
    'OTHER': 'OTHER',
  };

  @override
  final Iterable<Type> types = const <Type>[
    RegularizationRequestDtoReasonTypeEnum
  ];
  @override
  final String wireName = 'RegularizationRequestDtoReasonTypeEnum';

  @override
  Object serialize(Serializers serializers,
          RegularizationRequestDtoReasonTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RegularizationRequestDtoReasonTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RegularizationRequestDtoReasonTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RegularizationRequestDto extends RegularizationRequestDto {
  @override
  final String id;
  @override
  final String staffId;
  @override
  final RegularizationRequestDtoStatusEnum status;
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
  final String attendanceDate;
  @override
  final RegularizationRequestDtoReasonTypeEnum reasonType;
  @override
  final String explanation;

  factory _$RegularizationRequestDto(
          [void Function(RegularizationRequestDtoBuilder)? updates]) =>
      (RegularizationRequestDtoBuilder()..update(updates))._build();

  _$RegularizationRequestDto._(
      {required this.id,
      required this.staffId,
      required this.status,
      this.reviewedById,
      this.reviewedAt,
      this.reviewNote,
      required this.version,
      required this.createdAt,
      required this.attendanceDate,
      required this.reasonType,
      required this.explanation})
      : super._();
  @override
  RegularizationRequestDto rebuild(
          void Function(RegularizationRequestDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegularizationRequestDtoBuilder toBuilder() =>
      RegularizationRequestDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegularizationRequestDto &&
        id == other.id &&
        staffId == other.staffId &&
        status == other.status &&
        reviewedById == other.reviewedById &&
        reviewedAt == other.reviewedAt &&
        reviewNote == other.reviewNote &&
        version == other.version &&
        createdAt == other.createdAt &&
        attendanceDate == other.attendanceDate &&
        reasonType == other.reasonType &&
        explanation == other.explanation;
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
    _$hash = $jc(_$hash, attendanceDate.hashCode);
    _$hash = $jc(_$hash, reasonType.hashCode);
    _$hash = $jc(_$hash, explanation.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RegularizationRequestDto')
          ..add('id', id)
          ..add('staffId', staffId)
          ..add('status', status)
          ..add('reviewedById', reviewedById)
          ..add('reviewedAt', reviewedAt)
          ..add('reviewNote', reviewNote)
          ..add('version', version)
          ..add('createdAt', createdAt)
          ..add('attendanceDate', attendanceDate)
          ..add('reasonType', reasonType)
          ..add('explanation', explanation))
        .toString();
  }
}

class RegularizationRequestDtoBuilder
    implements
        Builder<RegularizationRequestDto, RegularizationRequestDtoBuilder> {
  _$RegularizationRequestDto? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _staffId;
  String? get staffId => _$this._staffId;
  set staffId(String? staffId) => _$this._staffId = staffId;

  RegularizationRequestDtoStatusEnum? _status;
  RegularizationRequestDtoStatusEnum? get status => _$this._status;
  set status(RegularizationRequestDtoStatusEnum? status) =>
      _$this._status = status;

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

  String? _attendanceDate;
  String? get attendanceDate => _$this._attendanceDate;
  set attendanceDate(String? attendanceDate) =>
      _$this._attendanceDate = attendanceDate;

  RegularizationRequestDtoReasonTypeEnum? _reasonType;
  RegularizationRequestDtoReasonTypeEnum? get reasonType => _$this._reasonType;
  set reasonType(RegularizationRequestDtoReasonTypeEnum? reasonType) =>
      _$this._reasonType = reasonType;

  String? _explanation;
  String? get explanation => _$this._explanation;
  set explanation(String? explanation) => _$this._explanation = explanation;

  RegularizationRequestDtoBuilder() {
    RegularizationRequestDto._defaults(this);
  }

  RegularizationRequestDtoBuilder get _$this {
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
      _attendanceDate = $v.attendanceDate;
      _reasonType = $v.reasonType;
      _explanation = $v.explanation;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RegularizationRequestDto other) {
    _$v = other as _$RegularizationRequestDto;
  }

  @override
  void update(void Function(RegularizationRequestDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegularizationRequestDto build() => _build();

  _$RegularizationRequestDto _build() {
    final _$result = _$v ??
        _$RegularizationRequestDto._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'RegularizationRequestDto', 'id'),
          staffId: BuiltValueNullFieldError.checkNotNull(
              staffId, r'RegularizationRequestDto', 'staffId'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'RegularizationRequestDto', 'status'),
          reviewedById: reviewedById,
          reviewedAt: reviewedAt,
          reviewNote: reviewNote,
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'RegularizationRequestDto', 'version'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'RegularizationRequestDto', 'createdAt'),
          attendanceDate: BuiltValueNullFieldError.checkNotNull(
              attendanceDate, r'RegularizationRequestDto', 'attendanceDate'),
          reasonType: BuiltValueNullFieldError.checkNotNull(
              reasonType, r'RegularizationRequestDto', 'reasonType'),
          explanation: BuiltValueNullFieldError.checkNotNull(
              explanation, r'RegularizationRequestDto', 'explanation'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
