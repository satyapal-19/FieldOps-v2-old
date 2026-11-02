// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'effective_shift_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const EffectiveShiftDtoShiftTypeEnum _$effectiveShiftDtoShiftTypeEnum_MORNING =
    const EffectiveShiftDtoShiftTypeEnum._('MORNING');
const EffectiveShiftDtoShiftTypeEnum _$effectiveShiftDtoShiftTypeEnum_EVENING =
    const EffectiveShiftDtoShiftTypeEnum._('EVENING');
const EffectiveShiftDtoShiftTypeEnum _$effectiveShiftDtoShiftTypeEnum_NIGHT =
    const EffectiveShiftDtoShiftTypeEnum._('NIGHT');
const EffectiveShiftDtoShiftTypeEnum
    _$effectiveShiftDtoShiftTypeEnum_GENERAL_OFFICE =
    const EffectiveShiftDtoShiftTypeEnum._('GENERAL_OFFICE');

EffectiveShiftDtoShiftTypeEnum _$effectiveShiftDtoShiftTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'MORNING':
      return _$effectiveShiftDtoShiftTypeEnum_MORNING;
    case 'EVENING':
      return _$effectiveShiftDtoShiftTypeEnum_EVENING;
    case 'NIGHT':
      return _$effectiveShiftDtoShiftTypeEnum_NIGHT;
    case 'GENERAL_OFFICE':
      return _$effectiveShiftDtoShiftTypeEnum_GENERAL_OFFICE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<EffectiveShiftDtoShiftTypeEnum>
    _$effectiveShiftDtoShiftTypeEnumValues = BuiltSet<
        EffectiveShiftDtoShiftTypeEnum>(const <EffectiveShiftDtoShiftTypeEnum>[
  _$effectiveShiftDtoShiftTypeEnum_MORNING,
  _$effectiveShiftDtoShiftTypeEnum_EVENING,
  _$effectiveShiftDtoShiftTypeEnum_NIGHT,
  _$effectiveShiftDtoShiftTypeEnum_GENERAL_OFFICE,
]);

const EffectiveShiftDtoSource_Enum _$effectiveShiftDtoSourceEnum_OVERRIDE =
    const EffectiveShiftDtoSource_Enum._('OVERRIDE');
const EffectiveShiftDtoSource_Enum _$effectiveShiftDtoSourceEnum_DEFAULT =
    const EffectiveShiftDtoSource_Enum._('DEFAULT');

EffectiveShiftDtoSource_Enum _$effectiveShiftDtoSourceEnumValueOf(String name) {
  switch (name) {
    case 'OVERRIDE':
      return _$effectiveShiftDtoSourceEnum_OVERRIDE;
    case 'DEFAULT':
      return _$effectiveShiftDtoSourceEnum_DEFAULT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<EffectiveShiftDtoSource_Enum>
    _$effectiveShiftDtoSourceEnumValues =
    BuiltSet<EffectiveShiftDtoSource_Enum>(const <EffectiveShiftDtoSource_Enum>[
  _$effectiveShiftDtoSourceEnum_OVERRIDE,
  _$effectiveShiftDtoSourceEnum_DEFAULT,
]);

Serializer<EffectiveShiftDtoShiftTypeEnum>
    _$effectiveShiftDtoShiftTypeEnumSerializer =
    _$EffectiveShiftDtoShiftTypeEnumSerializer();
Serializer<EffectiveShiftDtoSource_Enum>
    _$effectiveShiftDtoSourceEnumSerializer =
    _$EffectiveShiftDtoSource_EnumSerializer();

class _$EffectiveShiftDtoShiftTypeEnumSerializer
    implements PrimitiveSerializer<EffectiveShiftDtoShiftTypeEnum> {
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
  final Iterable<Type> types = const <Type>[EffectiveShiftDtoShiftTypeEnum];
  @override
  final String wireName = 'EffectiveShiftDtoShiftTypeEnum';

  @override
  Object serialize(
          Serializers serializers, EffectiveShiftDtoShiftTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  EffectiveShiftDtoShiftTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      EffectiveShiftDtoShiftTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$EffectiveShiftDtoSource_EnumSerializer
    implements PrimitiveSerializer<EffectiveShiftDtoSource_Enum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OVERRIDE': 'OVERRIDE',
    'DEFAULT': 'DEFAULT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OVERRIDE': 'OVERRIDE',
    'DEFAULT': 'DEFAULT',
  };

  @override
  final Iterable<Type> types = const <Type>[EffectiveShiftDtoSource_Enum];
  @override
  final String wireName = 'EffectiveShiftDtoSource_Enum';

  @override
  Object serialize(Serializers serializers, EffectiveShiftDtoSource_Enum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  EffectiveShiftDtoSource_Enum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      EffectiveShiftDtoSource_Enum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$EffectiveShiftDto extends EffectiveShiftDto {
  @override
  final String staffId;
  @override
  final String date;
  @override
  final EffectiveShiftDtoShiftTypeEnum? shiftType;
  @override
  final String startTime;
  @override
  final String endTime;
  @override
  final DateTime startsAt;
  @override
  final DateTime endsAt;
  @override
  final EffectiveShiftDtoSource_Enum source_;

  factory _$EffectiveShiftDto(
          [void Function(EffectiveShiftDtoBuilder)? updates]) =>
      (EffectiveShiftDtoBuilder()..update(updates))._build();

  _$EffectiveShiftDto._(
      {required this.staffId,
      required this.date,
      this.shiftType,
      required this.startTime,
      required this.endTime,
      required this.startsAt,
      required this.endsAt,
      required this.source_})
      : super._();
  @override
  EffectiveShiftDto rebuild(void Function(EffectiveShiftDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EffectiveShiftDtoBuilder toBuilder() =>
      EffectiveShiftDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EffectiveShiftDto &&
        staffId == other.staffId &&
        date == other.date &&
        shiftType == other.shiftType &&
        startTime == other.startTime &&
        endTime == other.endTime &&
        startsAt == other.startsAt &&
        endsAt == other.endsAt &&
        source_ == other.source_;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, staffId.hashCode);
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, shiftType.hashCode);
    _$hash = $jc(_$hash, startTime.hashCode);
    _$hash = $jc(_$hash, endTime.hashCode);
    _$hash = $jc(_$hash, startsAt.hashCode);
    _$hash = $jc(_$hash, endsAt.hashCode);
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EffectiveShiftDto')
          ..add('staffId', staffId)
          ..add('date', date)
          ..add('shiftType', shiftType)
          ..add('startTime', startTime)
          ..add('endTime', endTime)
          ..add('startsAt', startsAt)
          ..add('endsAt', endsAt)
          ..add('source_', source_))
        .toString();
  }
}

class EffectiveShiftDtoBuilder
    implements Builder<EffectiveShiftDto, EffectiveShiftDtoBuilder> {
  _$EffectiveShiftDto? _$v;

  String? _staffId;
  String? get staffId => _$this._staffId;
  set staffId(String? staffId) => _$this._staffId = staffId;

  String? _date;
  String? get date => _$this._date;
  set date(String? date) => _$this._date = date;

  EffectiveShiftDtoShiftTypeEnum? _shiftType;
  EffectiveShiftDtoShiftTypeEnum? get shiftType => _$this._shiftType;
  set shiftType(EffectiveShiftDtoShiftTypeEnum? shiftType) =>
      _$this._shiftType = shiftType;

  String? _startTime;
  String? get startTime => _$this._startTime;
  set startTime(String? startTime) => _$this._startTime = startTime;

  String? _endTime;
  String? get endTime => _$this._endTime;
  set endTime(String? endTime) => _$this._endTime = endTime;

  DateTime? _startsAt;
  DateTime? get startsAt => _$this._startsAt;
  set startsAt(DateTime? startsAt) => _$this._startsAt = startsAt;

  DateTime? _endsAt;
  DateTime? get endsAt => _$this._endsAt;
  set endsAt(DateTime? endsAt) => _$this._endsAt = endsAt;

  EffectiveShiftDtoSource_Enum? _source_;
  EffectiveShiftDtoSource_Enum? get source_ => _$this._source_;
  set source_(EffectiveShiftDtoSource_Enum? source_) =>
      _$this._source_ = source_;

  EffectiveShiftDtoBuilder() {
    EffectiveShiftDto._defaults(this);
  }

  EffectiveShiftDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _staffId = $v.staffId;
      _date = $v.date;
      _shiftType = $v.shiftType;
      _startTime = $v.startTime;
      _endTime = $v.endTime;
      _startsAt = $v.startsAt;
      _endsAt = $v.endsAt;
      _source_ = $v.source_;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EffectiveShiftDto other) {
    _$v = other as _$EffectiveShiftDto;
  }

  @override
  void update(void Function(EffectiveShiftDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EffectiveShiftDto build() => _build();

  _$EffectiveShiftDto _build() {
    final _$result = _$v ??
        _$EffectiveShiftDto._(
          staffId: BuiltValueNullFieldError.checkNotNull(
              staffId, r'EffectiveShiftDto', 'staffId'),
          date: BuiltValueNullFieldError.checkNotNull(
              date, r'EffectiveShiftDto', 'date'),
          shiftType: shiftType,
          startTime: BuiltValueNullFieldError.checkNotNull(
              startTime, r'EffectiveShiftDto', 'startTime'),
          endTime: BuiltValueNullFieldError.checkNotNull(
              endTime, r'EffectiveShiftDto', 'endTime'),
          startsAt: BuiltValueNullFieldError.checkNotNull(
              startsAt, r'EffectiveShiftDto', 'startsAt'),
          endsAt: BuiltValueNullFieldError.checkNotNull(
              endsAt, r'EffectiveShiftDto', 'endsAt'),
          source_: BuiltValueNullFieldError.checkNotNull(
              source_, r'EffectiveShiftDto', 'source_'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
