// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_ward_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PublicWardDtoZoneEnum _$publicWardDtoZoneEnum_SANGLI =
    const PublicWardDtoZoneEnum._('SANGLI');
const PublicWardDtoZoneEnum _$publicWardDtoZoneEnum_MIRAJ =
    const PublicWardDtoZoneEnum._('MIRAJ');
const PublicWardDtoZoneEnum _$publicWardDtoZoneEnum_KUPWAD =
    const PublicWardDtoZoneEnum._('KUPWAD');

PublicWardDtoZoneEnum _$publicWardDtoZoneEnumValueOf(String name) {
  switch (name) {
    case 'SANGLI':
      return _$publicWardDtoZoneEnum_SANGLI;
    case 'MIRAJ':
      return _$publicWardDtoZoneEnum_MIRAJ;
    case 'KUPWAD':
      return _$publicWardDtoZoneEnum_KUPWAD;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PublicWardDtoZoneEnum> _$publicWardDtoZoneEnumValues =
    BuiltSet<PublicWardDtoZoneEnum>(const <PublicWardDtoZoneEnum>[
  _$publicWardDtoZoneEnum_SANGLI,
  _$publicWardDtoZoneEnum_MIRAJ,
  _$publicWardDtoZoneEnum_KUPWAD,
]);

Serializer<PublicWardDtoZoneEnum> _$publicWardDtoZoneEnumSerializer =
    _$PublicWardDtoZoneEnumSerializer();

class _$PublicWardDtoZoneEnumSerializer
    implements PrimitiveSerializer<PublicWardDtoZoneEnum> {
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
  final Iterable<Type> types = const <Type>[PublicWardDtoZoneEnum];
  @override
  final String wireName = 'PublicWardDtoZoneEnum';

  @override
  Object serialize(Serializers serializers, PublicWardDtoZoneEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PublicWardDtoZoneEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PublicWardDtoZoneEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PublicWardDto extends PublicWardDto {
  @override
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final String nameMr;
  @override
  final PublicWardDtoZoneEnum zone;
  @override
  final BuiltMap<String, JsonObject?> boundary;

  factory _$PublicWardDto([void Function(PublicWardDtoBuilder)? updates]) =>
      (PublicWardDtoBuilder()..update(updates))._build();

  _$PublicWardDto._(
      {required this.id,
      required this.code,
      required this.name,
      required this.nameMr,
      required this.zone,
      required this.boundary})
      : super._();
  @override
  PublicWardDto rebuild(void Function(PublicWardDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicWardDtoBuilder toBuilder() => PublicWardDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicWardDto &&
        id == other.id &&
        code == other.code &&
        name == other.name &&
        nameMr == other.nameMr &&
        zone == other.zone &&
        boundary == other.boundary;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
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
    return (newBuiltValueToStringHelper(r'PublicWardDto')
          ..add('id', id)
          ..add('code', code)
          ..add('name', name)
          ..add('nameMr', nameMr)
          ..add('zone', zone)
          ..add('boundary', boundary))
        .toString();
  }
}

class PublicWardDtoBuilder
    implements Builder<PublicWardDto, PublicWardDtoBuilder> {
  _$PublicWardDto? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _nameMr;
  String? get nameMr => _$this._nameMr;
  set nameMr(String? nameMr) => _$this._nameMr = nameMr;

  PublicWardDtoZoneEnum? _zone;
  PublicWardDtoZoneEnum? get zone => _$this._zone;
  set zone(PublicWardDtoZoneEnum? zone) => _$this._zone = zone;

  MapBuilder<String, JsonObject?>? _boundary;
  MapBuilder<String, JsonObject?> get boundary =>
      _$this._boundary ??= MapBuilder<String, JsonObject?>();
  set boundary(MapBuilder<String, JsonObject?>? boundary) =>
      _$this._boundary = boundary;

  PublicWardDtoBuilder() {
    PublicWardDto._defaults(this);
  }

  PublicWardDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
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
  void replace(PublicWardDto other) {
    _$v = other as _$PublicWardDto;
  }

  @override
  void update(void Function(PublicWardDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicWardDto build() => _build();

  _$PublicWardDto _build() {
    _$PublicWardDto _$result;
    try {
      _$result = _$v ??
          _$PublicWardDto._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'PublicWardDto', 'id'),
            code: BuiltValueNullFieldError.checkNotNull(
                code, r'PublicWardDto', 'code'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'PublicWardDto', 'name'),
            nameMr: BuiltValueNullFieldError.checkNotNull(
                nameMr, r'PublicWardDto', 'nameMr'),
            zone: BuiltValueNullFieldError.checkNotNull(
                zone, r'PublicWardDto', 'zone'),
            boundary: boundary.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'boundary';
        boundary.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PublicWardDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
