// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_complaint_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SubmitComplaintDtoCategoryEnum _$submitComplaintDtoCategoryEnum_GARBAGE =
    const SubmitComplaintDtoCategoryEnum._('GARBAGE');
const SubmitComplaintDtoCategoryEnum _$submitComplaintDtoCategoryEnum_DRAIN =
    const SubmitComplaintDtoCategoryEnum._('DRAIN');
const SubmitComplaintDtoCategoryEnum _$submitComplaintDtoCategoryEnum_ROAD =
    const SubmitComplaintDtoCategoryEnum._('ROAD');
const SubmitComplaintDtoCategoryEnum _$submitComplaintDtoCategoryEnum_WATER =
    const SubmitComplaintDtoCategoryEnum._('WATER');
const SubmitComplaintDtoCategoryEnum _$submitComplaintDtoCategoryEnum_TREE =
    const SubmitComplaintDtoCategoryEnum._('TREE');
const SubmitComplaintDtoCategoryEnum
    _$submitComplaintDtoCategoryEnum_STRAY_ANIMAL =
    const SubmitComplaintDtoCategoryEnum._('STRAY_ANIMAL');
const SubmitComplaintDtoCategoryEnum _$submitComplaintDtoCategoryEnum_OTHER =
    const SubmitComplaintDtoCategoryEnum._('OTHER');

SubmitComplaintDtoCategoryEnum _$submitComplaintDtoCategoryEnumValueOf(
    String name) {
  switch (name) {
    case 'GARBAGE':
      return _$submitComplaintDtoCategoryEnum_GARBAGE;
    case 'DRAIN':
      return _$submitComplaintDtoCategoryEnum_DRAIN;
    case 'ROAD':
      return _$submitComplaintDtoCategoryEnum_ROAD;
    case 'WATER':
      return _$submitComplaintDtoCategoryEnum_WATER;
    case 'TREE':
      return _$submitComplaintDtoCategoryEnum_TREE;
    case 'STRAY_ANIMAL':
      return _$submitComplaintDtoCategoryEnum_STRAY_ANIMAL;
    case 'OTHER':
      return _$submitComplaintDtoCategoryEnum_OTHER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SubmitComplaintDtoCategoryEnum>
    _$submitComplaintDtoCategoryEnumValues = BuiltSet<
        SubmitComplaintDtoCategoryEnum>(const <SubmitComplaintDtoCategoryEnum>[
  _$submitComplaintDtoCategoryEnum_GARBAGE,
  _$submitComplaintDtoCategoryEnum_DRAIN,
  _$submitComplaintDtoCategoryEnum_ROAD,
  _$submitComplaintDtoCategoryEnum_WATER,
  _$submitComplaintDtoCategoryEnum_TREE,
  _$submitComplaintDtoCategoryEnum_STRAY_ANIMAL,
  _$submitComplaintDtoCategoryEnum_OTHER,
]);

Serializer<SubmitComplaintDtoCategoryEnum>
    _$submitComplaintDtoCategoryEnumSerializer =
    _$SubmitComplaintDtoCategoryEnumSerializer();

class _$SubmitComplaintDtoCategoryEnumSerializer
    implements PrimitiveSerializer<SubmitComplaintDtoCategoryEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'GARBAGE': 'GARBAGE',
    'DRAIN': 'DRAIN',
    'ROAD': 'ROAD',
    'WATER': 'WATER',
    'TREE': 'TREE',
    'STRAY_ANIMAL': 'STRAY_ANIMAL',
    'OTHER': 'OTHER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'GARBAGE': 'GARBAGE',
    'DRAIN': 'DRAIN',
    'ROAD': 'ROAD',
    'WATER': 'WATER',
    'TREE': 'TREE',
    'STRAY_ANIMAL': 'STRAY_ANIMAL',
    'OTHER': 'OTHER',
  };

  @override
  final Iterable<Type> types = const <Type>[SubmitComplaintDtoCategoryEnum];
  @override
  final String wireName = 'SubmitComplaintDtoCategoryEnum';

  @override
  Object serialize(
          Serializers serializers, SubmitComplaintDtoCategoryEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SubmitComplaintDtoCategoryEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SubmitComplaintDtoCategoryEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SubmitComplaintDto extends SubmitComplaintDto {
  @override
  final String? clientUuid;
  @override
  final SubmitComplaintDtoCategoryEnum category;
  @override
  final String description;
  @override
  final String? citizenName;
  @override
  final String? citizenPhone;
  @override
  final String? wardId;
  @override
  final num? lat;
  @override
  final num? lng;

  factory _$SubmitComplaintDto(
          [void Function(SubmitComplaintDtoBuilder)? updates]) =>
      (SubmitComplaintDtoBuilder()..update(updates))._build();

  _$SubmitComplaintDto._(
      {this.clientUuid,
      required this.category,
      required this.description,
      this.citizenName,
      this.citizenPhone,
      this.wardId,
      this.lat,
      this.lng})
      : super._();
  @override
  SubmitComplaintDto rebuild(
          void Function(SubmitComplaintDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SubmitComplaintDtoBuilder toBuilder() =>
      SubmitComplaintDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubmitComplaintDto &&
        clientUuid == other.clientUuid &&
        category == other.category &&
        description == other.description &&
        citizenName == other.citizenName &&
        citizenPhone == other.citizenPhone &&
        wardId == other.wardId &&
        lat == other.lat &&
        lng == other.lng;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, clientUuid.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, citizenName.hashCode);
    _$hash = $jc(_$hash, citizenPhone.hashCode);
    _$hash = $jc(_$hash, wardId.hashCode);
    _$hash = $jc(_$hash, lat.hashCode);
    _$hash = $jc(_$hash, lng.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SubmitComplaintDto')
          ..add('clientUuid', clientUuid)
          ..add('category', category)
          ..add('description', description)
          ..add('citizenName', citizenName)
          ..add('citizenPhone', citizenPhone)
          ..add('wardId', wardId)
          ..add('lat', lat)
          ..add('lng', lng))
        .toString();
  }
}

class SubmitComplaintDtoBuilder
    implements Builder<SubmitComplaintDto, SubmitComplaintDtoBuilder> {
  _$SubmitComplaintDto? _$v;

  String? _clientUuid;
  String? get clientUuid => _$this._clientUuid;
  set clientUuid(String? clientUuid) => _$this._clientUuid = clientUuid;

  SubmitComplaintDtoCategoryEnum? _category;
  SubmitComplaintDtoCategoryEnum? get category => _$this._category;
  set category(SubmitComplaintDtoCategoryEnum? category) =>
      _$this._category = category;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _citizenName;
  String? get citizenName => _$this._citizenName;
  set citizenName(String? citizenName) => _$this._citizenName = citizenName;

  String? _citizenPhone;
  String? get citizenPhone => _$this._citizenPhone;
  set citizenPhone(String? citizenPhone) => _$this._citizenPhone = citizenPhone;

  String? _wardId;
  String? get wardId => _$this._wardId;
  set wardId(String? wardId) => _$this._wardId = wardId;

  num? _lat;
  num? get lat => _$this._lat;
  set lat(num? lat) => _$this._lat = lat;

  num? _lng;
  num? get lng => _$this._lng;
  set lng(num? lng) => _$this._lng = lng;

  SubmitComplaintDtoBuilder() {
    SubmitComplaintDto._defaults(this);
  }

  SubmitComplaintDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _clientUuid = $v.clientUuid;
      _category = $v.category;
      _description = $v.description;
      _citizenName = $v.citizenName;
      _citizenPhone = $v.citizenPhone;
      _wardId = $v.wardId;
      _lat = $v.lat;
      _lng = $v.lng;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SubmitComplaintDto other) {
    _$v = other as _$SubmitComplaintDto;
  }

  @override
  void update(void Function(SubmitComplaintDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SubmitComplaintDto build() => _build();

  _$SubmitComplaintDto _build() {
    final _$result = _$v ??
        _$SubmitComplaintDto._(
          clientUuid: clientUuid,
          category: BuiltValueNullFieldError.checkNotNull(
              category, r'SubmitComplaintDto', 'category'),
          description: BuiltValueNullFieldError.checkNotNull(
              description, r'SubmitComplaintDto', 'description'),
          citizenName: citizenName,
          citizenPhone: citizenPhone,
          wardId: wardId,
          lat: lat,
          lng: lng,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
