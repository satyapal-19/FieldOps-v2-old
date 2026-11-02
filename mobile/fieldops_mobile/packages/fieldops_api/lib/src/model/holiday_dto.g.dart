// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'holiday_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const HolidayDtoHolidayTypeEnum _$holidayDtoHolidayTypeEnum_GAZETTE =
    const HolidayDtoHolidayTypeEnum._('GAZETTE');
const HolidayDtoHolidayTypeEnum _$holidayDtoHolidayTypeEnum_OPTIONAL =
    const HolidayDtoHolidayTypeEnum._('OPTIONAL');

HolidayDtoHolidayTypeEnum _$holidayDtoHolidayTypeEnumValueOf(String name) {
  switch (name) {
    case 'GAZETTE':
      return _$holidayDtoHolidayTypeEnum_GAZETTE;
    case 'OPTIONAL':
      return _$holidayDtoHolidayTypeEnum_OPTIONAL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<HolidayDtoHolidayTypeEnum> _$holidayDtoHolidayTypeEnumValues =
    BuiltSet<HolidayDtoHolidayTypeEnum>(const <HolidayDtoHolidayTypeEnum>[
  _$holidayDtoHolidayTypeEnum_GAZETTE,
  _$holidayDtoHolidayTypeEnum_OPTIONAL,
]);

Serializer<HolidayDtoHolidayTypeEnum> _$holidayDtoHolidayTypeEnumSerializer =
    _$HolidayDtoHolidayTypeEnumSerializer();

class _$HolidayDtoHolidayTypeEnumSerializer
    implements PrimitiveSerializer<HolidayDtoHolidayTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'GAZETTE': 'GAZETTE',
    'OPTIONAL': 'OPTIONAL',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'GAZETTE': 'GAZETTE',
    'OPTIONAL': 'OPTIONAL',
  };

  @override
  final Iterable<Type> types = const <Type>[HolidayDtoHolidayTypeEnum];
  @override
  final String wireName = 'HolidayDtoHolidayTypeEnum';

  @override
  Object serialize(Serializers serializers, HolidayDtoHolidayTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  HolidayDtoHolidayTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      HolidayDtoHolidayTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$HolidayDto extends HolidayDto {
  @override
  final String id;
  @override
  final String date;
  @override
  final String name;
  @override
  final String? nameMr;
  @override
  final HolidayDtoHolidayTypeEnum holidayType;
  @override
  final num version;

  factory _$HolidayDto([void Function(HolidayDtoBuilder)? updates]) =>
      (HolidayDtoBuilder()..update(updates))._build();

  _$HolidayDto._(
      {required this.id,
      required this.date,
      required this.name,
      this.nameMr,
      required this.holidayType,
      required this.version})
      : super._();
  @override
  HolidayDto rebuild(void Function(HolidayDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HolidayDtoBuilder toBuilder() => HolidayDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HolidayDto &&
        id == other.id &&
        date == other.date &&
        name == other.name &&
        nameMr == other.nameMr &&
        holidayType == other.holidayType &&
        version == other.version;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, nameMr.hashCode);
    _$hash = $jc(_$hash, holidayType.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'HolidayDto')
          ..add('id', id)
          ..add('date', date)
          ..add('name', name)
          ..add('nameMr', nameMr)
          ..add('holidayType', holidayType)
          ..add('version', version))
        .toString();
  }
}

class HolidayDtoBuilder implements Builder<HolidayDto, HolidayDtoBuilder> {
  _$HolidayDto? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _date;
  String? get date => _$this._date;
  set date(String? date) => _$this._date = date;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _nameMr;
  String? get nameMr => _$this._nameMr;
  set nameMr(String? nameMr) => _$this._nameMr = nameMr;

  HolidayDtoHolidayTypeEnum? _holidayType;
  HolidayDtoHolidayTypeEnum? get holidayType => _$this._holidayType;
  set holidayType(HolidayDtoHolidayTypeEnum? holidayType) =>
      _$this._holidayType = holidayType;

  num? _version;
  num? get version => _$this._version;
  set version(num? version) => _$this._version = version;

  HolidayDtoBuilder() {
    HolidayDto._defaults(this);
  }

  HolidayDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _date = $v.date;
      _name = $v.name;
      _nameMr = $v.nameMr;
      _holidayType = $v.holidayType;
      _version = $v.version;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HolidayDto other) {
    _$v = other as _$HolidayDto;
  }

  @override
  void update(void Function(HolidayDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  HolidayDto build() => _build();

  _$HolidayDto _build() {
    final _$result = _$v ??
        _$HolidayDto._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'HolidayDto', 'id'),
          date: BuiltValueNullFieldError.checkNotNull(
              date, r'HolidayDto', 'date'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'HolidayDto', 'name'),
          nameMr: nameMr,
          holidayType: BuiltValueNullFieldError.checkNotNull(
              holidayType, r'HolidayDto', 'holidayType'),
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'HolidayDto', 'version'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
