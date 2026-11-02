// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_ward_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreateWardDtoZoneEnum _$createWardDtoZoneEnum_SANGLI =
    const CreateWardDtoZoneEnum._('SANGLI');
const CreateWardDtoZoneEnum _$createWardDtoZoneEnum_MIRAJ =
    const CreateWardDtoZoneEnum._('MIRAJ');
const CreateWardDtoZoneEnum _$createWardDtoZoneEnum_KUPWAD =
    const CreateWardDtoZoneEnum._('KUPWAD');

CreateWardDtoZoneEnum _$createWardDtoZoneEnumValueOf(String name) {
  switch (name) {
    case 'SANGLI':
      return _$createWardDtoZoneEnum_SANGLI;
    case 'MIRAJ':
      return _$createWardDtoZoneEnum_MIRAJ;
    case 'KUPWAD':
      return _$createWardDtoZoneEnum_KUPWAD;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CreateWardDtoZoneEnum> _$createWardDtoZoneEnumValues =
    BuiltSet<CreateWardDtoZoneEnum>(const <CreateWardDtoZoneEnum>[
  _$createWardDtoZoneEnum_SANGLI,
  _$createWardDtoZoneEnum_MIRAJ,
  _$createWardDtoZoneEnum_KUPWAD,
]);

Serializer<CreateWardDtoZoneEnum> _$createWardDtoZoneEnumSerializer =
    _$CreateWardDtoZoneEnumSerializer();

class _$CreateWardDtoZoneEnumSerializer
    implements PrimitiveSerializer<CreateWardDtoZoneEnum> {
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
  final Iterable<Type> types = const <Type>[CreateWardDtoZoneEnum];
  @override
  final String wireName = 'CreateWardDtoZoneEnum';

  @override
  Object serialize(Serializers serializers, CreateWardDtoZoneEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreateWardDtoZoneEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreateWardDtoZoneEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreateWardDto extends CreateWardDto {
  @override
  final String code;
  @override
  final String name;
  @override
  final String nameMr;
  @override
  final CreateWardDtoZoneEnum zone;
  @override
  final BuiltMap<String, JsonObject?> boundary;

  factory _$CreateWardDto([void Function(CreateWardDtoBuilder)? updates]) =>
      (CreateWardDtoBuilder()..update(updates))._build();

  _$CreateWardDto._(
      {required this.code,
      required this.name,
      required this.nameMr,
      required this.zone,
      required this.boundary})
      : super._();
  @override
  CreateWardDto rebuild(void Function(CreateWardDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateWardDtoBuilder toBuilder() => CreateWardDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateWardDto &&
        code == other.code &&
        name == other.name &&
        nameMr == other.nameMr &&
        zone == other.zone &&
        boundary == other.boundary;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, nameMr.hashCode);
    _$hash = $jc(_$hash, zone.hashCode);
    _$hash = $jc(_$hash, boundary.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateWardDto')
          ..add('code', code)
          ..add('name', name)
          ..add('nameMr', nameMr)
          ..add('zone', zone)
          ..add('boundary', boundary))
        .toString();
  }
}

class CreateWardDtoBuilder
    implements Builder<CreateWardDto, CreateWardDtoBuilder> {
  _$CreateWardDto? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _nameMr;
  String? get nameMr => _$this._nameMr;
  set nameMr(String? nameMr) => _$this._nameMr = nameMr;

  CreateWardDtoZoneEnum? _zone;
  CreateWardDtoZoneEnum? get zone => _$this._zone;
  set zone(CreateWardDtoZoneEnum? zone) => _$this._zone = zone;

  MapBuilder<String, JsonObject?>? _boundary;
  MapBuilder<String, JsonObject?> get boundary =>
      _$this._boundary ??= MapBuilder<String, JsonObject?>();
  set boundary(MapBuilder<String, JsonObject?>? boundary) =>
      _$this._boundary = boundary;

  CreateWardDtoBuilder() {
    CreateWardDto._defaults(this);
  }

  CreateWardDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _name = $v.name;
      _nameMr = $v.nameMr;
      _zone = $v.zone;
      _boundary = $v.boundary.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateWardDto other) {
    _$v = other as _$CreateWardDto;
  }

  @override
  void update(void Function(CreateWardDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateWardDto build() => _build();

  _$CreateWardDto _build() {
    _$CreateWardDto _$result;
    try {
      _$result = _$v ??
          _$CreateWardDto._(
            code: BuiltValueNullFieldError.checkNotNull(
                code, r'CreateWardDto', 'code'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'CreateWardDto', 'name'),
            nameMr: BuiltValueNullFieldError.checkNotNull(
                nameMr, r'CreateWardDto', 'nameMr'),
            zone: BuiltValueNullFieldError.checkNotNull(
                zone, r'CreateWardDto', 'zone'),
            boundary: boundary.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'boundary';
        boundary.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CreateWardDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
