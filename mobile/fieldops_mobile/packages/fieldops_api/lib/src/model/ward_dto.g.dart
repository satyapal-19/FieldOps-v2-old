// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ward_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const WardDtoZoneEnum _$wardDtoZoneEnum_SANGLI =
    const WardDtoZoneEnum._('SANGLI');
const WardDtoZoneEnum _$wardDtoZoneEnum_MIRAJ =
    const WardDtoZoneEnum._('MIRAJ');
const WardDtoZoneEnum _$wardDtoZoneEnum_KUPWAD =
    const WardDtoZoneEnum._('KUPWAD');

WardDtoZoneEnum _$wardDtoZoneEnumValueOf(String name) {
  switch (name) {
    case 'SANGLI':
      return _$wardDtoZoneEnum_SANGLI;
    case 'MIRAJ':
      return _$wardDtoZoneEnum_MIRAJ;
    case 'KUPWAD':
      return _$wardDtoZoneEnum_KUPWAD;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WardDtoZoneEnum> _$wardDtoZoneEnumValues =
    BuiltSet<WardDtoZoneEnum>(const <WardDtoZoneEnum>[
  _$wardDtoZoneEnum_SANGLI,
  _$wardDtoZoneEnum_MIRAJ,
  _$wardDtoZoneEnum_KUPWAD,
]);

Serializer<WardDtoZoneEnum> _$wardDtoZoneEnumSerializer =
    _$WardDtoZoneEnumSerializer();

class _$WardDtoZoneEnumSerializer
    implements PrimitiveSerializer<WardDtoZoneEnum> {
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
  final Iterable<Type> types = const <Type>[WardDtoZoneEnum];
  @override
  final String wireName = 'WardDtoZoneEnum';

  @override
  Object serialize(Serializers serializers, WardDtoZoneEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WardDtoZoneEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WardDtoZoneEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WardDto extends WardDto {
  @override
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final String nameMr;
  @override
  final WardDtoZoneEnum zone;
  @override
  final BuiltMap<String, JsonObject?> boundary;
  @override
  final bool isActive;
  @override
  final num version;
  @override
  final String createdAt;
  @override
  final String updatedAt;

  factory _$WardDto([void Function(WardDtoBuilder)? updates]) =>
      (WardDtoBuilder()..update(updates))._build();

  _$WardDto._(
      {required this.id,
      required this.code,
      required this.name,
      required this.nameMr,
      required this.zone,
      required this.boundary,
      required this.isActive,
      required this.version,
      required this.createdAt,
      required this.updatedAt})
      : super._();
  @override
  WardDto rebuild(void Function(WardDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WardDtoBuilder toBuilder() => WardDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WardDto &&
        id == other.id &&
        code == other.code &&
        name == other.name &&
        nameMr == other.nameMr &&
        zone == other.zone &&
        boundary == other.boundary &&
        isActive == other.isActive &&
        version == other.version &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
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
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WardDto')
          ..add('id', id)
          ..add('code', code)
          ..add('name', name)
          ..add('nameMr', nameMr)
          ..add('zone', zone)
          ..add('boundary', boundary)
          ..add('isActive', isActive)
          ..add('version', version)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class WardDtoBuilder implements Builder<WardDto, WardDtoBuilder> {
  _$WardDto? _$v;

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

  WardDtoZoneEnum? _zone;
  WardDtoZoneEnum? get zone => _$this._zone;
  set zone(WardDtoZoneEnum? zone) => _$this._zone = zone;

  MapBuilder<String, JsonObject?>? _boundary;
  MapBuilder<String, JsonObject?> get boundary =>
      _$this._boundary ??= MapBuilder<String, JsonObject?>();
  set boundary(MapBuilder<String, JsonObject?>? boundary) =>
      _$this._boundary = boundary;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  num? _version;
  num? get version => _$this._version;
  set version(num? version) => _$this._version = version;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  String? _updatedAt;
  String? get updatedAt => _$this._updatedAt;
  set updatedAt(String? updatedAt) => _$this._updatedAt = updatedAt;

  WardDtoBuilder() {
    WardDto._defaults(this);
  }

  WardDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _code = $v.code;
      _name = $v.name;
      _nameMr = $v.nameMr;
      _zone = $v.zone;
      _boundary = $v.boundary.toBuilder();
      _isActive = $v.isActive;
      _version = $v.version;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WardDto other) {
    _$v = other as _$WardDto;
  }

  @override
  void update(void Function(WardDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WardDto build() => _build();

  _$WardDto _build() {
    _$WardDto _$result;
    try {
      _$result = _$v ??
          _$WardDto._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'WardDto', 'id'),
            code:
                BuiltValueNullFieldError.checkNotNull(code, r'WardDto', 'code'),
            name:
                BuiltValueNullFieldError.checkNotNull(name, r'WardDto', 'name'),
            nameMr: BuiltValueNullFieldError.checkNotNull(
                nameMr, r'WardDto', 'nameMr'),
            zone:
                BuiltValueNullFieldError.checkNotNull(zone, r'WardDto', 'zone'),
            boundary: boundary.build(),
            isActive: BuiltValueNullFieldError.checkNotNull(
                isActive, r'WardDto', 'isActive'),
            version: BuiltValueNullFieldError.checkNotNull(
                version, r'WardDto', 'version'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'WardDto', 'createdAt'),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
                updatedAt, r'WardDto', 'updatedAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'boundary';
        boundary.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'WardDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
