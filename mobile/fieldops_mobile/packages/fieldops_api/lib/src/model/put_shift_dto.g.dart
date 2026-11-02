// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'put_shift_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PutShiftDtoShiftTypeEnum _$putShiftDtoShiftTypeEnum_MORNING =
    const PutShiftDtoShiftTypeEnum._('MORNING');
const PutShiftDtoShiftTypeEnum _$putShiftDtoShiftTypeEnum_EVENING =
    const PutShiftDtoShiftTypeEnum._('EVENING');
const PutShiftDtoShiftTypeEnum _$putShiftDtoShiftTypeEnum_NIGHT =
    const PutShiftDtoShiftTypeEnum._('NIGHT');
const PutShiftDtoShiftTypeEnum _$putShiftDtoShiftTypeEnum_GENERAL_OFFICE =
    const PutShiftDtoShiftTypeEnum._('GENERAL_OFFICE');

PutShiftDtoShiftTypeEnum _$putShiftDtoShiftTypeEnumValueOf(String name) {
  switch (name) {
    case 'MORNING':
      return _$putShiftDtoShiftTypeEnum_MORNING;
    case 'EVENING':
      return _$putShiftDtoShiftTypeEnum_EVENING;
    case 'NIGHT':
      return _$putShiftDtoShiftTypeEnum_NIGHT;
    case 'GENERAL_OFFICE':
      return _$putShiftDtoShiftTypeEnum_GENERAL_OFFICE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PutShiftDtoShiftTypeEnum> _$putShiftDtoShiftTypeEnumValues =
    BuiltSet<PutShiftDtoShiftTypeEnum>(const <PutShiftDtoShiftTypeEnum>[
  _$putShiftDtoShiftTypeEnum_MORNING,
  _$putShiftDtoShiftTypeEnum_EVENING,
  _$putShiftDtoShiftTypeEnum_NIGHT,
  _$putShiftDtoShiftTypeEnum_GENERAL_OFFICE,
]);

Serializer<PutShiftDtoShiftTypeEnum> _$putShiftDtoShiftTypeEnumSerializer =
    _$PutShiftDtoShiftTypeEnumSerializer();

class _$PutShiftDtoShiftTypeEnumSerializer
    implements PrimitiveSerializer<PutShiftDtoShiftTypeEnum> {
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
  final Iterable<Type> types = const <Type>[PutShiftDtoShiftTypeEnum];
  @override
  final String wireName = 'PutShiftDtoShiftTypeEnum';

  @override
  Object serialize(Serializers serializers, PutShiftDtoShiftTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PutShiftDtoShiftTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PutShiftDtoShiftTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PutShiftDto extends PutShiftDto {
  @override
  final String staffId;
  @override
  final String date;
  @override
  final PutShiftDtoShiftTypeEnum shiftType;
  @override
  final String startTime;
  @override
  final String endTime;
  @override
  final num? expectedVersion;

  factory _$PutShiftDto([void Function(PutShiftDtoBuilder)? updates]) =>
      (PutShiftDtoBuilder()..update(updates))._build();

  _$PutShiftDto._(
      {required this.staffId,
      required this.date,
      required this.shiftType,
      required this.startTime,
      required this.endTime,
      this.expectedVersion})
      : super._();
  @override
  PutShiftDto rebuild(void Function(PutShiftDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PutShiftDtoBuilder toBuilder() => PutShiftDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PutShiftDto &&
        staffId == other.staffId &&
        date == other.date &&
        shiftType == other.shiftType &&
        startTime == other.startTime &&
        endTime == other.endTime &&
        expectedVersion == other.expectedVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, staffId.hashCode);
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, shiftType.hashCode);
    _$hash = $jc(_$hash, startTime.hashCode);
    _$hash = $jc(_$hash, endTime.hashCode);
    _$hash = $jc(_$hash, expectedVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PutShiftDto')
          ..add('staffId', staffId)
          ..add('date', date)
          ..add('shiftType', shiftType)
          ..add('startTime', startTime)
          ..add('endTime', endTime)
          ..add('expectedVersion', expectedVersion))
        .toString();
  }
}

class PutShiftDtoBuilder implements Builder<PutShiftDto, PutShiftDtoBuilder> {
  _$PutShiftDto? _$v;

  String? _staffId;
  String? get staffId => _$this._staffId;
  set staffId(String? staffId) => _$this._staffId = staffId;

  String? _date;
  String? get date => _$this._date;
  set date(String? date) => _$this._date = date;

  PutShiftDtoShiftTypeEnum? _shiftType;
  PutShiftDtoShiftTypeEnum? get shiftType => _$this._shiftType;
  set shiftType(PutShiftDtoShiftTypeEnum? shiftType) =>
      _$this._shiftType = shiftType;

  String? _startTime;
  String? get startTime => _$this._startTime;
  set startTime(String? startTime) => _$this._startTime = startTime;

  String? _endTime;
  String? get endTime => _$this._endTime;
  set endTime(String? endTime) => _$this._endTime = endTime;

  num? _expectedVersion;
  num? get expectedVersion => _$this._expectedVersion;
  set expectedVersion(num? expectedVersion) =>
      _$this._expectedVersion = expectedVersion;

  PutShiftDtoBuilder() {
    PutShiftDto._defaults(this);
  }

  PutShiftDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _staffId = $v.staffId;
      _date = $v.date;
      _shiftType = $v.shiftType;
      _startTime = $v.startTime;
      _endTime = $v.endTime;
      _expectedVersion = $v.expectedVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PutShiftDto other) {
    _$v = other as _$PutShiftDto;
  }

  @override
  void update(void Function(PutShiftDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PutShiftDto build() => _build();

  _$PutShiftDto _build() {
    final _$result = _$v ??
        _$PutShiftDto._(
          staffId: BuiltValueNullFieldError.checkNotNull(
              staffId, r'PutShiftDto', 'staffId'),
          date: BuiltValueNullFieldError.checkNotNull(
              date, r'PutShiftDto', 'date'),
          shiftType: BuiltValueNullFieldError.checkNotNull(
              shiftType, r'PutShiftDto', 'shiftType'),
          startTime: BuiltValueNullFieldError.checkNotNull(
              startTime, r'PutShiftDto', 'startTime'),
          endTime: BuiltValueNullFieldError.checkNotNull(
              endTime, r'PutShiftDto', 'endTime'),
          expectedVersion: expectedVersion,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
