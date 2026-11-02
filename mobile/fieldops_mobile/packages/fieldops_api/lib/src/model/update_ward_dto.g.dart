// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_ward_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UpdateWardDtoZoneEnum _$updateWardDtoZoneEnum_SANGLI =
    const UpdateWardDtoZoneEnum._('SANGLI');
const UpdateWardDtoZoneEnum _$updateWardDtoZoneEnum_MIRAJ =
    const UpdateWardDtoZoneEnum._('MIRAJ');
const UpdateWardDtoZoneEnum _$updateWardDtoZoneEnum_KUPWAD =
    const UpdateWardDtoZoneEnum._('KUPWAD');

UpdateWardDtoZoneEnum _$updateWardDtoZoneEnumValueOf(String name) {
  switch (name) {
    case 'SANGLI':
      return _$updateWardDtoZoneEnum_SANGLI;
    case 'MIRAJ':
      return _$updateWardDtoZoneEnum_MIRAJ;
    case 'KUPWAD':
      return _$updateWardDtoZoneEnum_KUPWAD;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<UpdateWardDtoZoneEnum> _$updateWardDtoZoneEnumValues =
    BuiltSet<UpdateWardDtoZoneEnum>(const <UpdateWardDtoZoneEnum>[
  _$updateWardDtoZoneEnum_SANGLI,
  _$updateWardDtoZoneEnum_MIRAJ,
  _$updateWardDtoZoneEnum_KUPWAD,
]);

Serializer<UpdateWardDtoZoneEnum> _$updateWardDtoZoneEnumSerializer =
    _$UpdateWardDtoZoneEnumSerializer();

class _$UpdateWardDtoZoneEnumSerializer
    implements PrimitiveSerializer<UpdateWardDtoZoneEnum> {
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
  final Iterable<Type> types = const <Type>[UpdateWardDtoZoneEnum];
  @override
  final String wireName = 'UpdateWardDtoZoneEnum';

  @override
  Object serialize(Serializers serializers, UpdateWardDtoZoneEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  UpdateWardDtoZoneEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      UpdateWardDtoZoneEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$UpdateWardDto extends UpdateWardDto {
  @override
  final num expectedVersion;
  @override
  final String? name;
  @override
  final String? nameMr;
  @override
  final UpdateWardDtoZoneEnum? zone;
  @override
  final BuiltMap<String, JsonObject?>? boundary;
  @override
  final bool? isActive;

  factory _$UpdateWardDto([void Function(UpdateWardDtoBuilder)? updates]) =>
      (UpdateWardDtoBuilder()..update(updates))._build();

  _$UpdateWardDto._(
      {required this.expectedVersion,
      this.name,
      this.nameMr,
      this.zone,
      this.boundary,
      this.isActive})
      : super._();
  @override
  UpdateWardDto rebuild(void Function(UpdateWardDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateWardDtoBuilder toBuilder() => UpdateWardDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateWardDto &&
        expectedVersion == other.expectedVersion &&
        name == other.name &&
        nameMr == other.nameMr &&
        zone == other.zone &&
        boundary == other.boundary &&
        isActive == other.isActive;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, expectedVersion.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, nameMr.hashCode);
    _$hash = $jc(_$hash, zone.hashCode);
    _$hash = $jc(_$hash, boundary.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateWardDto')
          ..add('expectedVersion', expectedVersion)
          ..add('name', name)
          ..add('nameMr', nameMr)
          ..add('zone', zone)
          ..add('boundary', boundary)
          ..add('isActive', isActive))
        .toString();
  }
}

class UpdateWardDtoBuilder
    implements Builder<UpdateWardDto, UpdateWardDtoBuilder> {
  _$UpdateWardDto? _$v;

  num? _expectedVersion;
  num? get expectedVersion => _$this._expectedVersion;
  set expectedVersion(num? expectedVersion) =>
      _$this._expectedVersion = expectedVersion;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _nameMr;
  String? get nameMr => _$this._nameMr;
  set nameMr(String? nameMr) => _$this._nameMr = nameMr;

  UpdateWardDtoZoneEnum? _zone;
  UpdateWardDtoZoneEnum? get zone => _$this._zone;
  set zone(UpdateWardDtoZoneEnum? zone) => _$this._zone = zone;

  MapBuilder<String, JsonObject?>? _boundary;
  MapBuilder<String, JsonObject?> get boundary =>
      _$this._boundary ??= MapBuilder<String, JsonObject?>();
  set boundary(MapBuilder<String, JsonObject?>? boundary) =>
      _$this._boundary = boundary;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  UpdateWardDtoBuilder() {
    UpdateWardDto._defaults(this);
  }

  UpdateWardDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _expectedVersion = $v.expectedVersion;
      _name = $v.name;
      _nameMr = $v.nameMr;
      _zone = $v.zone;
      _boundary = $v.boundary?.toBuilder();
      _isActive = $v.isActive;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateWardDto other) {
    _$v = other as _$UpdateWardDto;
  }

  @override
  void update(void Function(UpdateWardDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateWardDto build() => _build();

  _$UpdateWardDto _build() {
    _$UpdateWardDto _$result;
    try {
      _$result = _$v ??
          _$UpdateWardDto._(
            expectedVersion: BuiltValueNullFieldError.checkNotNull(
                expectedVersion, r'UpdateWardDto', 'expectedVersion'),
            name: name,
            nameMr: nameMr,
            zone: zone,
            boundary: _boundary?.build(),
            isActive: isActive,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'boundary';
        _boundary?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UpdateWardDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
