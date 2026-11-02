// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_holiday_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UpdateHolidayDtoHolidayTypeEnum
    _$updateHolidayDtoHolidayTypeEnum_GAZETTE =
    const UpdateHolidayDtoHolidayTypeEnum._('GAZETTE');
const UpdateHolidayDtoHolidayTypeEnum
    _$updateHolidayDtoHolidayTypeEnum_OPTIONAL =
    const UpdateHolidayDtoHolidayTypeEnum._('OPTIONAL');

UpdateHolidayDtoHolidayTypeEnum _$updateHolidayDtoHolidayTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'GAZETTE':
      return _$updateHolidayDtoHolidayTypeEnum_GAZETTE;
    case 'OPTIONAL':
      return _$updateHolidayDtoHolidayTypeEnum_OPTIONAL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<UpdateHolidayDtoHolidayTypeEnum>
    _$updateHolidayDtoHolidayTypeEnumValues = BuiltSet<
        UpdateHolidayDtoHolidayTypeEnum>(const <UpdateHolidayDtoHolidayTypeEnum>[
  _$updateHolidayDtoHolidayTypeEnum_GAZETTE,
  _$updateHolidayDtoHolidayTypeEnum_OPTIONAL,
]);

Serializer<UpdateHolidayDtoHolidayTypeEnum>
    _$updateHolidayDtoHolidayTypeEnumSerializer =
    _$UpdateHolidayDtoHolidayTypeEnumSerializer();

class _$UpdateHolidayDtoHolidayTypeEnumSerializer
    implements PrimitiveSerializer<UpdateHolidayDtoHolidayTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'GAZETTE': 'GAZETTE',
    'OPTIONAL': 'OPTIONAL',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'GAZETTE': 'GAZETTE',
    'OPTIONAL': 'OPTIONAL',
  };

  @override
  final Iterable<Type> types = const <Type>[UpdateHolidayDtoHolidayTypeEnum];
  @override
  final String wireName = 'UpdateHolidayDtoHolidayTypeEnum';

  @override
  Object serialize(
          Serializers serializers, UpdateHolidayDtoHolidayTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  UpdateHolidayDtoHolidayTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      UpdateHolidayDtoHolidayTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$UpdateHolidayDto extends UpdateHolidayDto {
  @override
  final num expectedVersion;
  @override
  final String? date;
  @override
  final String? name;
  @override
  final String? nameMr;
  @override
  final UpdateHolidayDtoHolidayTypeEnum? holidayType;

  factory _$UpdateHolidayDto(
          [void Function(UpdateHolidayDtoBuilder)? updates]) =>
      (UpdateHolidayDtoBuilder()..update(updates))._build();

  _$UpdateHolidayDto._(
      {required this.expectedVersion,
      this.date,
      this.name,
      this.nameMr,
      this.holidayType})
      : super._();
  @override
  UpdateHolidayDto rebuild(void Function(UpdateHolidayDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateHolidayDtoBuilder toBuilder() =>
      UpdateHolidayDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateHolidayDto &&
        expectedVersion == other.expectedVersion &&
        date == other.date &&
        name == other.name &&
        nameMr == other.nameMr &&
        holidayType == other.holidayType;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, expectedVersion.hashCode);
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, nameMr.hashCode);
    _$hash = $jc(_$hash, holidayType.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateHolidayDto')
          ..add('expectedVersion', expectedVersion)
          ..add('date', date)
          ..add('name', name)
          ..add('nameMr', nameMr)
          ..add('holidayType', holidayType))
        .toString();
  }
}

class UpdateHolidayDtoBuilder
    implements Builder<UpdateHolidayDto, UpdateHolidayDtoBuilder> {
  _$UpdateHolidayDto? _$v;

  num? _expectedVersion;
  num? get expectedVersion => _$this._expectedVersion;
  set expectedVersion(num? expectedVersion) =>
      _$this._expectedVersion = expectedVersion;

  String? _date;
  String? get date => _$this._date;
  set date(String? date) => _$this._date = date;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _nameMr;
  String? get nameMr => _$this._nameMr;
  set nameMr(String? nameMr) => _$this._nameMr = nameMr;

  UpdateHolidayDtoHolidayTypeEnum? _holidayType;
  UpdateHolidayDtoHolidayTypeEnum? get holidayType => _$this._holidayType;
  set holidayType(UpdateHolidayDtoHolidayTypeEnum? holidayType) =>
      _$this._holidayType = holidayType;

  UpdateHolidayDtoBuilder() {
    UpdateHolidayDto._defaults(this);
  }

  UpdateHolidayDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _expectedVersion = $v.expectedVersion;
      _date = $v.date;
      _name = $v.name;
      _nameMr = $v.nameMr;
      _holidayType = $v.holidayType;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateHolidayDto other) {
    _$v = other as _$UpdateHolidayDto;
  }

  @override
  void update(void Function(UpdateHolidayDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateHolidayDto build() => _build();

  _$UpdateHolidayDto _build() {
    final _$result = _$v ??
        _$UpdateHolidayDto._(
          expectedVersion: BuiltValueNullFieldError.checkNotNull(
              expectedVersion, r'UpdateHolidayDto', 'expectedVersion'),
          date: date,
          name: name,
          nameMr: nameMr,
          holidayType: holidayType,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
