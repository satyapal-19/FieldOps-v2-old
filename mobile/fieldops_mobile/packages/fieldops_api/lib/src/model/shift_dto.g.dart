// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ShiftDtoShiftTypeEnum _$shiftDtoShiftTypeEnum_MORNING =
    const ShiftDtoShiftTypeEnum._('MORNING');
const ShiftDtoShiftTypeEnum _$shiftDtoShiftTypeEnum_EVENING =
    const ShiftDtoShiftTypeEnum._('EVENING');
const ShiftDtoShiftTypeEnum _$shiftDtoShiftTypeEnum_NIGHT =
    const ShiftDtoShiftTypeEnum._('NIGHT');
const ShiftDtoShiftTypeEnum _$shiftDtoShiftTypeEnum_GENERAL_OFFICE =
    const ShiftDtoShiftTypeEnum._('GENERAL_OFFICE');

ShiftDtoShiftTypeEnum _$shiftDtoShiftTypeEnumValueOf(String name) {
  switch (name) {
    case 'MORNING':
      return _$shiftDtoShiftTypeEnum_MORNING;
    case 'EVENING':
      return _$shiftDtoShiftTypeEnum_EVENING;
    case 'NIGHT':
      return _$shiftDtoShiftTypeEnum_NIGHT;
    case 'GENERAL_OFFICE':
      return _$shiftDtoShiftTypeEnum_GENERAL_OFFICE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ShiftDtoShiftTypeEnum> _$shiftDtoShiftTypeEnumValues =
    BuiltSet<ShiftDtoShiftTypeEnum>(const <ShiftDtoShiftTypeEnum>[
  _$shiftDtoShiftTypeEnum_MORNING,
  _$shiftDtoShiftTypeEnum_EVENING,
  _$shiftDtoShiftTypeEnum_NIGHT,
  _$shiftDtoShiftTypeEnum_GENERAL_OFFICE,
]);

Serializer<ShiftDtoShiftTypeEnum> _$shiftDtoShiftTypeEnumSerializer =
    _$ShiftDtoShiftTypeEnumSerializer();

class _$ShiftDtoShiftTypeEnumSerializer
    implements PrimitiveSerializer<ShiftDtoShiftTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'MORNING': 'MORNING',
    'EVENING': 'EVENING',
    'NIGHT': 'NIGHT',
    'GENERAL_OFFICE': 'GENERAL_OFFICE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'MORNING': 'MORNING',
    'EVENING': 'EVENING',
    'NIGHT': 'NIGHT',
    'GENERAL_OFFICE': 'GENERAL_OFFICE',
  };

  @override
  final Iterable<Type> types = const <Type>[ShiftDtoShiftTypeEnum];
  @override
  final String wireName = 'ShiftDtoShiftTypeEnum';

  @override
  Object serialize(Serializers serializers, ShiftDtoShiftTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ShiftDtoShiftTypeEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ShiftDtoShiftTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ShiftDto extends ShiftDto {
  @override
  final String id;
  @override
  final String staffId;
  @override
  final String date;
  @override
  final ShiftDtoShiftTypeEnum shiftType;
  @override
  final String startTime;
  @override
  final String endTime;
  @override
  final num version;
  @override
  final DateTime updatedAt;

  factory _$ShiftDto([void Function(ShiftDtoBuilder)? updates]) =>
      (ShiftDtoBuilder()..update(updates))._build();

  _$ShiftDto._(
      {required this.id,
      required this.staffId,
      required this.date,
      required this.shiftType,
      required this.startTime,
      required this.endTime,
      required this.version,
      required this.updatedAt})
      : super._();
  @override
  ShiftDto rebuild(void Function(ShiftDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ShiftDtoBuilder toBuilder() => ShiftDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ShiftDto &&
        id == other.id &&
        staffId == other.staffId &&
        date == other.date &&
        shiftType == other.shiftType &&
        startTime == other.startTime &&
        endTime == other.endTime &&
        version == other.version &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, staffId.hashCode);
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, shiftType.hashCode);
    _$hash = $jc(_$hash, startTime.hashCode);
    _$hash = $jc(_$hash, endTime.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ShiftDto')
          ..add('id', id)
          ..add('staffId', staffId)
          ..add('date', date)
          ..add('shiftType', shiftType)
          ..add('startTime', startTime)
          ..add('endTime', endTime)
          ..add('version', version)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class ShiftDtoBuilder implements Builder<ShiftDto, ShiftDtoBuilder> {
  _$ShiftDto? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _staffId;
  String? get staffId => _$this._staffId;
  set staffId(String? staffId) => _$this._staffId = staffId;

  String? _date;
  String? get date => _$this._date;
  set date(String? date) => _$this._date = date;

  ShiftDtoShiftTypeEnum? _shiftType;
  ShiftDtoShiftTypeEnum? get shiftType => _$this._shiftType;
  set shiftType(ShiftDtoShiftTypeEnum? shiftType) =>
      _$this._shiftType = shiftType;

  String? _startTime;
  String? get startTime => _$this._startTime;
  set startTime(String? startTime) => _$this._startTime = startTime;

  String? _endTime;
  String? get endTime => _$this._endTime;
  set endTime(String? endTime) => _$this._endTime = endTime;

  num? _version;
  num? get version => _$this._version;
  set version(num? version) => _$this._version = version;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  ShiftDtoBuilder() {
    ShiftDto._defaults(this);
  }

  ShiftDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _staffId = $v.staffId;
      _date = $v.date;
      _shiftType = $v.shiftType;
      _startTime = $v.startTime;
      _endTime = $v.endTime;
      _version = $v.version;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ShiftDto other) {
    _$v = other as _$ShiftDto;
  }

  @override
  void update(void Function(ShiftDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ShiftDto build() => _build();

  _$ShiftDto _build() {
    final _$result = _$v ??
        _$ShiftDto._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'ShiftDto', 'id'),
          staffId: BuiltValueNullFieldError.checkNotNull(
              staffId, r'ShiftDto', 'staffId'),
          date:
              BuiltValueNullFieldError.checkNotNull(date, r'ShiftDto', 'date'),
          shiftType: BuiltValueNullFieldError.checkNotNull(
              shiftType, r'ShiftDto', 'shiftType'),
          startTime: BuiltValueNullFieldError.checkNotNull(
              startTime, r'ShiftDto', 'startTime'),
          endTime: BuiltValueNullFieldError.checkNotNull(
              endTime, r'ShiftDto', 'endTime'),
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'ShiftDto', 'version'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'ShiftDto', 'updatedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
