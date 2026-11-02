// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_holiday_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreateHolidayDtoHolidayTypeEnum
    _$createHolidayDtoHolidayTypeEnum_GAZETTE =
    const CreateHolidayDtoHolidayTypeEnum._('GAZETTE');
const CreateHolidayDtoHolidayTypeEnum
    _$createHolidayDtoHolidayTypeEnum_OPTIONAL =
    const CreateHolidayDtoHolidayTypeEnum._('OPTIONAL');

CreateHolidayDtoHolidayTypeEnum _$createHolidayDtoHolidayTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'GAZETTE':
      return _$createHolidayDtoHolidayTypeEnum_GAZETTE;
    case 'OPTIONAL':
      return _$createHolidayDtoHolidayTypeEnum_OPTIONAL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CreateHolidayDtoHolidayTypeEnum>
    _$createHolidayDtoHolidayTypeEnumValues = BuiltSet<
        CreateHolidayDtoHolidayTypeEnum>(const <CreateHolidayDtoHolidayTypeEnum>[
  _$createHolidayDtoHolidayTypeEnum_GAZETTE,
  _$createHolidayDtoHolidayTypeEnum_OPTIONAL,
]);

Serializer<CreateHolidayDtoHolidayTypeEnum>
    _$createHolidayDtoHolidayTypeEnumSerializer =
    _$CreateHolidayDtoHolidayTypeEnumSerializer();

class _$CreateHolidayDtoHolidayTypeEnumSerializer
    implements PrimitiveSerializer<CreateHolidayDtoHolidayTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'GAZETTE': 'GAZETTE',
    'OPTIONAL': 'OPTIONAL',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'GAZETTE': 'GAZETTE',
    'OPTIONAL': 'OPTIONAL',
  };

  @override
  final Iterable<Type> types = const <Type>[CreateHolidayDtoHolidayTypeEnum];
  @override
  final String wireName = 'CreateHolidayDtoHolidayTypeEnum';

  @override
  Object serialize(
          Serializers serializers, CreateHolidayDtoHolidayTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreateHolidayDtoHolidayTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreateHolidayDtoHolidayTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreateHolidayDto extends CreateHolidayDto {
  @override
  final String date;
  @override
  final String name;
  @override
  final String? nameMr;
  @override
  final CreateHolidayDtoHolidayTypeEnum? holidayType;

  factory _$CreateHolidayDto(
          [void Function(CreateHolidayDtoBuilder)? updates]) =>
      (CreateHolidayDtoBuilder()..update(updates))._build();

  _$CreateHolidayDto._(
      {required this.date, required this.name, this.nameMr, this.holidayType})
      : super._();
  @override
  CreateHolidayDto rebuild(void Function(CreateHolidayDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateHolidayDtoBuilder toBuilder() =>
      CreateHolidayDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateHolidayDto &&
        date == other.date &&
        name == other.name &&
        nameMr == other.nameMr &&
        holidayType == other.holidayType;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, nameMr.hashCode);
    _$hash = $jc(_$hash, holidayType.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateHolidayDto')
          ..add('date', date)
          ..add('name', name)
          ..add('nameMr', nameMr)
          ..add('holidayType', holidayType))
        .toString();
  }
}

class CreateHolidayDtoBuilder
    implements Builder<CreateHolidayDto, CreateHolidayDtoBuilder> {
  _$CreateHolidayDto? _$v;

  String? _date;
  String? get date => _$this._date;
  set date(String? date) => _$this._date = date;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _nameMr;
  String? get nameMr => _$this._nameMr;
  set nameMr(String? nameMr) => _$this._nameMr = nameMr;

  CreateHolidayDtoHolidayTypeEnum? _holidayType;
  CreateHolidayDtoHolidayTypeEnum? get holidayType => _$this._holidayType;
  set holidayType(CreateHolidayDtoHolidayTypeEnum? holidayType) =>
      _$this._holidayType = holidayType;

  CreateHolidayDtoBuilder() {
    CreateHolidayDto._defaults(this);
  }

  CreateHolidayDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _name = $v.name;
      _nameMr = $v.nameMr;
      _holidayType = $v.holidayType;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateHolidayDto other) {
    _$v = other as _$CreateHolidayDto;
  }

  @override
  void update(void Function(CreateHolidayDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateHolidayDto build() => _build();

  _$CreateHolidayDto _build() {
    final _$result = _$v ??
        _$CreateHolidayDto._(
          date: BuiltValueNullFieldError.checkNotNull(
              date, r'CreateHolidayDto', 'date'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'CreateHolidayDto', 'name'),
          nameMr: nameMr,
          holidayType: holidayType,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
