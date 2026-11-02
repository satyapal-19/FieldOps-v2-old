// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_office_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreateOfficeDtoZoneEnum _$createOfficeDtoZoneEnum_SANGLI =
    const CreateOfficeDtoZoneEnum._('SANGLI');
const CreateOfficeDtoZoneEnum _$createOfficeDtoZoneEnum_MIRAJ =
    const CreateOfficeDtoZoneEnum._('MIRAJ');
const CreateOfficeDtoZoneEnum _$createOfficeDtoZoneEnum_KUPWAD =
    const CreateOfficeDtoZoneEnum._('KUPWAD');

CreateOfficeDtoZoneEnum _$createOfficeDtoZoneEnumValueOf(String name) {
  switch (name) {
    case 'SANGLI':
      return _$createOfficeDtoZoneEnum_SANGLI;
    case 'MIRAJ':
      return _$createOfficeDtoZoneEnum_MIRAJ;
    case 'KUPWAD':
      return _$createOfficeDtoZoneEnum_KUPWAD;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CreateOfficeDtoZoneEnum> _$createOfficeDtoZoneEnumValues =
    BuiltSet<CreateOfficeDtoZoneEnum>(const <CreateOfficeDtoZoneEnum>[
  _$createOfficeDtoZoneEnum_SANGLI,
  _$createOfficeDtoZoneEnum_MIRAJ,
  _$createOfficeDtoZoneEnum_KUPWAD,
]);

Serializer<CreateOfficeDtoZoneEnum> _$createOfficeDtoZoneEnumSerializer =
    _$CreateOfficeDtoZoneEnumSerializer();

class _$CreateOfficeDtoZoneEnumSerializer
    implements PrimitiveSerializer<CreateOfficeDtoZoneEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SANGLI': 'SANGLI',
    'MIRAJ': 'MIRAJ',
    'KUPWAD': 'KUPWAD',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SANGLI': 'SANGLI',
    'MIRAJ': 'MIRAJ',
    'KUPWAD': 'KUPWAD',
  };

  @override
  final Iterable<Type> types = const <Type>[CreateOfficeDtoZoneEnum];
  @override
  final String wireName = 'CreateOfficeDtoZoneEnum';

  @override
  Object serialize(Serializers serializers, CreateOfficeDtoZoneEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreateOfficeDtoZoneEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreateOfficeDtoZoneEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreateOfficeDto extends CreateOfficeDto {
  @override
  final String code;
  @override
  final String name;
  @override
  final String nameMr;
  @override
  final CreateOfficeDtoZoneEnum zone;
  @override
  final BuiltMap<String, JsonObject?> premises;
  @override
  final num? bufferMeters;

  factory _$CreateOfficeDto([void Function(CreateOfficeDtoBuilder)? updates]) =>
      (CreateOfficeDtoBuilder()..update(updates))._build();

  _$CreateOfficeDto._(
      {required this.code,
      required this.name,
      required this.nameMr,
      required this.zone,
      required this.premises,
      this.bufferMeters})
      : super._();
  @override
  CreateOfficeDto rebuild(void Function(CreateOfficeDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateOfficeDtoBuilder toBuilder() => CreateOfficeDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateOfficeDto &&
        code == other.code &&
        name == other.name &&
        nameMr == other.nameMr &&
        zone == other.zone &&
        premises == other.premises &&
        bufferMeters == other.bufferMeters;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, nameMr.hashCode);
    _$hash = $jc(_$hash, zone.hashCode);
    _$hash = $jc(_$hash, premises.hashCode);
    _$hash = $jc(_$hash, bufferMeters.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateOfficeDto')
          ..add('code', code)
          ..add('name', name)
          ..add('nameMr', nameMr)
          ..add('zone', zone)
          ..add('premises', premises)
          ..add('bufferMeters', bufferMeters))
        .toString();
  }
}

class CreateOfficeDtoBuilder
    implements Builder<CreateOfficeDto, CreateOfficeDtoBuilder> {
  _$CreateOfficeDto? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _nameMr;
  String? get nameMr => _$this._nameMr;
  set nameMr(String? nameMr) => _$this._nameMr = nameMr;

  CreateOfficeDtoZoneEnum? _zone;
  CreateOfficeDtoZoneEnum? get zone => _$this._zone;
  set zone(CreateOfficeDtoZoneEnum? zone) => _$this._zone = zone;

  MapBuilder<String, JsonObject?>? _premises;
  MapBuilder<String, JsonObject?> get premises =>
      _$this._premises ??= MapBuilder<String, JsonObject?>();
  set premises(MapBuilder<String, JsonObject?>? premises) =>
      _$this._premises = premises;

  num? _bufferMeters;
  num? get bufferMeters => _$this._bufferMeters;
  set bufferMeters(num? bufferMeters) => _$this._bufferMeters = bufferMeters;

  CreateOfficeDtoBuilder() {
    CreateOfficeDto._defaults(this);
  }

  CreateOfficeDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _name = $v.name;
      _nameMr = $v.nameMr;
      _zone = $v.zone;
      _premises = $v.premises.toBuilder();
      _bufferMeters = $v.bufferMeters;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateOfficeDto other) {
    _$v = other as _$CreateOfficeDto;
  }

  @override
  void update(void Function(CreateOfficeDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateOfficeDto build() => _build();

  _$CreateOfficeDto _build() {
    _$CreateOfficeDto _$result;
    try {
      _$result = _$v ??
          _$CreateOfficeDto._(
            code: BuiltValueNullFieldError.checkNotNull(
                code, r'CreateOfficeDto', 'code'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'CreateOfficeDto', 'name'),
            nameMr: BuiltValueNullFieldError.checkNotNull(
                nameMr, r'CreateOfficeDto', 'nameMr'),
            zone: BuiltValueNullFieldError.checkNotNull(
                zone, r'CreateOfficeDto', 'zone'),
            premises: premises.build(),
            bufferMeters: bufferMeters,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'premises';
        premises.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CreateOfficeDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
