// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complaint_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ComplaintDtoCategoryEnum _$complaintDtoCategoryEnum_GARBAGE =
    const ComplaintDtoCategoryEnum._('GARBAGE');
const ComplaintDtoCategoryEnum _$complaintDtoCategoryEnum_DRAIN =
    const ComplaintDtoCategoryEnum._('DRAIN');
const ComplaintDtoCategoryEnum _$complaintDtoCategoryEnum_ROAD =
    const ComplaintDtoCategoryEnum._('ROAD');
const ComplaintDtoCategoryEnum _$complaintDtoCategoryEnum_WATER =
    const ComplaintDtoCategoryEnum._('WATER');
const ComplaintDtoCategoryEnum _$complaintDtoCategoryEnum_TREE =
    const ComplaintDtoCategoryEnum._('TREE');
const ComplaintDtoCategoryEnum _$complaintDtoCategoryEnum_STRAY_ANIMAL =
    const ComplaintDtoCategoryEnum._('STRAY_ANIMAL');
const ComplaintDtoCategoryEnum _$complaintDtoCategoryEnum_OTHER =
    const ComplaintDtoCategoryEnum._('OTHER');

ComplaintDtoCategoryEnum _$complaintDtoCategoryEnumValueOf(String name) {
  switch (name) {
    case 'GARBAGE':
      return _$complaintDtoCategoryEnum_GARBAGE;
    case 'DRAIN':
      return _$complaintDtoCategoryEnum_DRAIN;
    case 'ROAD':
      return _$complaintDtoCategoryEnum_ROAD;
    case 'WATER':
      return _$complaintDtoCategoryEnum_WATER;
    case 'TREE':
      return _$complaintDtoCategoryEnum_TREE;
    case 'STRAY_ANIMAL':
      return _$complaintDtoCategoryEnum_STRAY_ANIMAL;
    case 'OTHER':
      return _$complaintDtoCategoryEnum_OTHER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ComplaintDtoCategoryEnum> _$complaintDtoCategoryEnumValues =
    BuiltSet<ComplaintDtoCategoryEnum>(const <ComplaintDtoCategoryEnum>[
  _$complaintDtoCategoryEnum_GARBAGE,
  _$complaintDtoCategoryEnum_DRAIN,
  _$complaintDtoCategoryEnum_ROAD,
  _$complaintDtoCategoryEnum_WATER,
  _$complaintDtoCategoryEnum_TREE,
  _$complaintDtoCategoryEnum_STRAY_ANIMAL,
  _$complaintDtoCategoryEnum_OTHER,
]);

const ComplaintDtoStatusEnum _$complaintDtoStatusEnum_RECEIVED =
    const ComplaintDtoStatusEnum._('RECEIVED');
const ComplaintDtoStatusEnum _$complaintDtoStatusEnum_ASSIGNED =
    const ComplaintDtoStatusEnum._('ASSIGNED');
const ComplaintDtoStatusEnum _$complaintDtoStatusEnum_IN_PROGRESS =
    const ComplaintDtoStatusEnum._('IN_PROGRESS');
const ComplaintDtoStatusEnum _$complaintDtoStatusEnum_RESOLVED =
    const ComplaintDtoStatusEnum._('RESOLVED');
const ComplaintDtoStatusEnum _$complaintDtoStatusEnum_CLOSED =
    const ComplaintDtoStatusEnum._('CLOSED');
const ComplaintDtoStatusEnum _$complaintDtoStatusEnum_REJECTED =
    const ComplaintDtoStatusEnum._('REJECTED');

ComplaintDtoStatusEnum _$complaintDtoStatusEnumValueOf(String name) {
  switch (name) {
    case 'RECEIVED':
      return _$complaintDtoStatusEnum_RECEIVED;
    case 'ASSIGNED':
      return _$complaintDtoStatusEnum_ASSIGNED;
    case 'IN_PROGRESS':
      return _$complaintDtoStatusEnum_IN_PROGRESS;
    case 'RESOLVED':
      return _$complaintDtoStatusEnum_RESOLVED;
    case 'CLOSED':
      return _$complaintDtoStatusEnum_CLOSED;
    case 'REJECTED':
      return _$complaintDtoStatusEnum_REJECTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ComplaintDtoStatusEnum> _$complaintDtoStatusEnumValues =
    BuiltSet<ComplaintDtoStatusEnum>(const <ComplaintDtoStatusEnum>[
  _$complaintDtoStatusEnum_RECEIVED,
  _$complaintDtoStatusEnum_ASSIGNED,
  _$complaintDtoStatusEnum_IN_PROGRESS,
  _$complaintDtoStatusEnum_RESOLVED,
  _$complaintDtoStatusEnum_CLOSED,
  _$complaintDtoStatusEnum_REJECTED,
]);

Serializer<ComplaintDtoCategoryEnum> _$complaintDtoCategoryEnumSerializer =
    _$ComplaintDtoCategoryEnumSerializer();
Serializer<ComplaintDtoStatusEnum> _$complaintDtoStatusEnumSerializer =
    _$ComplaintDtoStatusEnumSerializer();

class _$ComplaintDtoCategoryEnumSerializer
    implements PrimitiveSerializer<ComplaintDtoCategoryEnum> {
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
  final Iterable<Type> types = const <Type>[ComplaintDtoCategoryEnum];
  @override
  final String wireName = 'ComplaintDtoCategoryEnum';

  @override
  Object serialize(Serializers serializers, ComplaintDtoCategoryEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ComplaintDtoCategoryEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ComplaintDtoCategoryEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ComplaintDtoStatusEnumSerializer
    implements PrimitiveSerializer<ComplaintDtoStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'RECEIVED': 'RECEIVED',
    'ASSIGNED': 'ASSIGNED',
    'IN_PROGRESS': 'IN_PROGRESS',
    'RESOLVED': 'RESOLVED',
    'CLOSED': 'CLOSED',
    'REJECTED': 'REJECTED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'RECEIVED': 'RECEIVED',
    'ASSIGNED': 'ASSIGNED',
    'IN_PROGRESS': 'IN_PROGRESS',
    'RESOLVED': 'RESOLVED',
    'CLOSED': 'CLOSED',
    'REJECTED': 'REJECTED',
  };

  @override
  final Iterable<Type> types = const <Type>[ComplaintDtoStatusEnum];
  @override
  final String wireName = 'ComplaintDtoStatusEnum';

  @override
  Object serialize(Serializers serializers, ComplaintDtoStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ComplaintDtoStatusEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ComplaintDtoStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ComplaintDto extends ComplaintDto {
  @override
  final String id;
  @override
  final String trackingId;
  @override
  final ComplaintDtoCategoryEnum category;
  @override
  final String description;
  @override
  final ComplaintDtoStatusEnum status;
  @override
  final String? wardId;
  @override
  final String? citizenName;
  @override
  final String? citizenPhone;
  @override
  final num? lat;
  @override
  final num? lng;
  @override
  final DateTime? resolvedAt;
  @override
  final num version;
  @override
  final DateTime createdAt;
  @override
  final BuiltList<TaskDto>? tasks;

  factory _$ComplaintDto([void Function(ComplaintDtoBuilder)? updates]) =>
      (ComplaintDtoBuilder()..update(updates))._build();

  _$ComplaintDto._(
      {required this.id,
      required this.trackingId,
      required this.category,
      required this.description,
      required this.status,
      this.wardId,
      this.citizenName,
      this.citizenPhone,
      this.lat,
      this.lng,
      this.resolvedAt,
      required this.version,
      required this.createdAt,
      this.tasks})
      : super._();
  @override
  ComplaintDto rebuild(void Function(ComplaintDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ComplaintDtoBuilder toBuilder() => ComplaintDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ComplaintDto &&
        id == other.id &&
        trackingId == other.trackingId &&
        category == other.category &&
        description == other.description &&
        status == other.status &&
        wardId == other.wardId &&
        citizenName == other.citizenName &&
        citizenPhone == other.citizenPhone &&
        lat == other.lat &&
        lng == other.lng &&
        resolvedAt == other.resolvedAt &&
        version == other.version &&
        createdAt == other.createdAt &&
        tasks == other.tasks;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, trackingId.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, wardId.hashCode);
    _$hash = $jc(_$hash, citizenName.hashCode);
    _$hash = $jc(_$hash, citizenPhone.hashCode);
    _$hash = $jc(_$hash, lat.hashCode);
    _$hash = $jc(_$hash, lng.hashCode);
    _$hash = $jc(_$hash, resolvedAt.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, tasks.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ComplaintDto')
          ..add('id', id)
          ..add('trackingId', trackingId)
          ..add('category', category)
          ..add('description', description)
          ..add('status', status)
          ..add('wardId', wardId)
          ..add('citizenName', citizenName)
          ..add('citizenPhone', citizenPhone)
          ..add('lat', lat)
          ..add('lng', lng)
          ..add('resolvedAt', resolvedAt)
          ..add('version', version)
          ..add('createdAt', createdAt)
          ..add('tasks', tasks))
        .toString();
  }
}

class ComplaintDtoBuilder
    implements Builder<ComplaintDto, ComplaintDtoBuilder> {
  _$ComplaintDto? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _trackingId;
  String? get trackingId => _$this._trackingId;
  set trackingId(String? trackingId) => _$this._trackingId = trackingId;

  ComplaintDtoCategoryEnum? _category;
  ComplaintDtoCategoryEnum? get category => _$this._category;
  set category(ComplaintDtoCategoryEnum? category) =>
      _$this._category = category;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  ComplaintDtoStatusEnum? _status;
  ComplaintDtoStatusEnum? get status => _$this._status;
  set status(ComplaintDtoStatusEnum? status) => _$this._status = status;

  String? _wardId;
  String? get wardId => _$this._wardId;
  set wardId(String? wardId) => _$this._wardId = wardId;

  String? _citizenName;
  String? get citizenName => _$this._citizenName;
  set citizenName(String? citizenName) => _$this._citizenName = citizenName;

  String? _citizenPhone;
  String? get citizenPhone => _$this._citizenPhone;
  set citizenPhone(String? citizenPhone) => _$this._citizenPhone = citizenPhone;

  num? _lat;
  num? get lat => _$this._lat;
  set lat(num? lat) => _$this._lat = lat;

  num? _lng;
  num? get lng => _$this._lng;
  set lng(num? lng) => _$this._lng = lng;

  DateTime? _resolvedAt;
  DateTime? get resolvedAt => _$this._resolvedAt;
  set resolvedAt(DateTime? resolvedAt) => _$this._resolvedAt = resolvedAt;

  num? _version;
  num? get version => _$this._version;
  set version(num? version) => _$this._version = version;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ListBuilder<TaskDto>? _tasks;
  ListBuilder<TaskDto> get tasks => _$this._tasks ??= ListBuilder<TaskDto>();
  set tasks(ListBuilder<TaskDto>? tasks) => _$this._tasks = tasks;

  ComplaintDtoBuilder() {
    ComplaintDto._defaults(this);
  }

  ComplaintDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _trackingId = $v.trackingId;
      _category = $v.category;
      _description = $v.description;
      _status = $v.status;
      _wardId = $v.wardId;
      _citizenName = $v.citizenName;
      _citizenPhone = $v.citizenPhone;
      _lat = $v.lat;
      _lng = $v.lng;
      _resolvedAt = $v.resolvedAt;
      _version = $v.version;
      _createdAt = $v.createdAt;
      _tasks = $v.tasks?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ComplaintDto other) {
    _$v = other as _$ComplaintDto;
  }

  @override
  void update(void Function(ComplaintDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ComplaintDto build() => _build();

  _$ComplaintDto _build() {
    _$ComplaintDto _$result;
    try {
      _$result = _$v ??
          _$ComplaintDto._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ComplaintDto', 'id'),
            trackingId: BuiltValueNullFieldError.checkNotNull(
                trackingId, r'ComplaintDto', 'trackingId'),
            category: BuiltValueNullFieldError.checkNotNull(
                category, r'ComplaintDto', 'category'),
            description: BuiltValueNullFieldError.checkNotNull(
                description, r'ComplaintDto', 'description'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'ComplaintDto', 'status'),
            wardId: wardId,
            citizenName: citizenName,
            citizenPhone: citizenPhone,
            lat: lat,
            lng: lng,
            resolvedAt: resolvedAt,
            version: BuiltValueNullFieldError.checkNotNull(
                version, r'ComplaintDto', 'version'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'ComplaintDto', 'createdAt'),
            tasks: _tasks?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tasks';
        _tasks?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ComplaintDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
