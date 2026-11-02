// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_office_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UpdateOfficeDtoZoneEnum _$updateOfficeDtoZoneEnum_SANGLI =
    const UpdateOfficeDtoZoneEnum._('SANGLI');
const UpdateOfficeDtoZoneEnum _$updateOfficeDtoZoneEnum_MIRAJ =
    const UpdateOfficeDtoZoneEnum._('MIRAJ');
const UpdateOfficeDtoZoneEnum _$updateOfficeDtoZoneEnum_KUPWAD =
    const UpdateOfficeDtoZoneEnum._('KUPWAD');

UpdateOfficeDtoZoneEnum _$updateOfficeDtoZoneEnumValueOf(String name) {
  switch (name) {
    case 'SANGLI':
      return _$updateOfficeDtoZoneEnum_SANGLI;
    case 'MIRAJ':
      return _$updateOfficeDtoZoneEnum_MIRAJ;
    case 'KUPWAD':
      return _$updateOfficeDtoZoneEnum_KUPWAD;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<UpdateOfficeDtoZoneEnum> _$updateOfficeDtoZoneEnumValues =
    BuiltSet<UpdateOfficeDtoZoneEnum>(const <UpdateOfficeDtoZoneEnum>[
  _$updateOfficeDtoZoneEnum_SANGLI,
  _$updateOfficeDtoZoneEnum_MIRAJ,
  _$updateOfficeDtoZoneEnum_KUPWAD,
]);

Serializer<UpdateOfficeDtoZoneEnum> _$updateOfficeDtoZoneEnumSerializer =
    _$UpdateOfficeDtoZoneEnumSerializer();

class _$UpdateOfficeDtoZoneEnumSerializer
    implements PrimitiveSerializer<UpdateOfficeDtoZoneEnum> {
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
  final Iterable<Type> types = const <Type>[UpdateOfficeDtoZoneEnum];
  @override
  final String wireName = 'UpdateOfficeDtoZoneEnum';

  @override
  Object serialize(Serializers serializers, UpdateOfficeDtoZoneEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  UpdateOfficeDtoZoneEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      UpdateOfficeDtoZoneEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$UpdateOfficeDto extends UpdateOfficeDto {
  @override
  final num expectedVersion;
  @override
  final String? name;
  @override
  final String? nameMr;
  @override
  final UpdateOfficeDtoZoneEnum? zone;
  @override
  final BuiltMap<String, JsonObject?>? premises;
  @override
  final num? bufferMeters;
  @override
  final bool? isActive;

  factory _$UpdateOfficeDto([void Function(UpdateOfficeDtoBuilder)? updates]) =>
      (UpdateOfficeDtoBuilder()..update(updates))._build();

  _$UpdateOfficeDto._(
      {required this.expectedVersion,
      this.name,
      this.nameMr,
      this.zone,
      this.premises,
      this.bufferMeters,
      this.isActive})
      : super._();
  @override
  UpdateOfficeDto rebuild(void Function(UpdateOfficeDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateOfficeDtoBuilder toBuilder() => UpdateOfficeDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateOfficeDto &&
        expectedVersion == other.expectedVersion &&
        name == other.name &&
        nameMr == other.nameMr &&
        zone == other.zone &&
        premises == other.premises &&
        bufferMeters == other.bufferMeters &&
        isActive == other.isActive;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, expectedVersion.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, nameMr.hashCode);
    _$hash = $jc(_$hash, zone.hashCode);
    _$hash = $jc(_$hash, premises.hashCode);
    _$hash = $jc(_$hash, bufferMeters.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateOfficeDto')
          ..add('expectedVersion', expectedVersion)
          ..add('name', name)
          ..add('nameMr', nameMr)
          ..add('zone', zone)
          ..add('premises', premises)
          ..add('bufferMeters', bufferMeters)
          ..add('isActive', isActive))
        .toString();
  }
}

class UpdateOfficeDtoBuilder
    implements Builder<UpdateOfficeDto, UpdateOfficeDtoBuilder> {
  _$UpdateOfficeDto? _$v;

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

  UpdateOfficeDtoZoneEnum? _zone;
  UpdateOfficeDtoZoneEnum? get zone => _$this._zone;
  set zone(UpdateOfficeDtoZoneEnum? zone) => _$this._zone = zone;

  MapBuilder<String, JsonObject?>? _premises;
  MapBuilder<String, JsonObject?> get premises =>
      _$this._premises ??= MapBuilder<String, JsonObject?>();
  set premises(MapBuilder<String, JsonObject?>? premises) =>
      _$this._premises = premises;

  num? _bufferMeters;
  num? get bufferMeters => _$this._bufferMeters;
  set bufferMeters(num? bufferMeters) => _$this._bufferMeters = bufferMeters;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  UpdateOfficeDtoBuilder() {
    UpdateOfficeDto._defaults(this);
  }

  UpdateOfficeDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _expectedVersion = $v.expectedVersion;
      _name = $v.name;
      _nameMr = $v.nameMr;
      _zone = $v.zone;
      _premises = $v.premises?.toBuilder();
      _bufferMeters = $v.bufferMeters;
      _isActive = $v.isActive;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateOfficeDto other) {
    _$v = other as _$UpdateOfficeDto;
  }

  @override
  void update(void Function(UpdateOfficeDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateOfficeDto build() => _build();

  _$UpdateOfficeDto _build() {
    _$UpdateOfficeDto _$result;
    try {
      _$result = _$v ??
          _$UpdateOfficeDto._(
            expectedVersion: BuiltValueNullFieldError.checkNotNull(
                expectedVersion, r'UpdateOfficeDto', 'expectedVersion'),
            name: name,
            nameMr: nameMr,
            zone: zone,
            premises: _premises?.build(),
            bufferMeters: bufferMeters,
            isActive: isActive,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'premises';
        _premises?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UpdateOfficeDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
