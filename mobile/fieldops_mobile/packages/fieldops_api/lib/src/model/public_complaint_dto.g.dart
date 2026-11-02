// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_complaint_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PublicComplaintDtoCategoryEnum _$publicComplaintDtoCategoryEnum_GARBAGE =
    const PublicComplaintDtoCategoryEnum._('GARBAGE');
const PublicComplaintDtoCategoryEnum _$publicComplaintDtoCategoryEnum_DRAIN =
    const PublicComplaintDtoCategoryEnum._('DRAIN');
const PublicComplaintDtoCategoryEnum _$publicComplaintDtoCategoryEnum_ROAD =
    const PublicComplaintDtoCategoryEnum._('ROAD');
const PublicComplaintDtoCategoryEnum _$publicComplaintDtoCategoryEnum_WATER =
    const PublicComplaintDtoCategoryEnum._('WATER');
const PublicComplaintDtoCategoryEnum _$publicComplaintDtoCategoryEnum_TREE =
    const PublicComplaintDtoCategoryEnum._('TREE');
const PublicComplaintDtoCategoryEnum
    _$publicComplaintDtoCategoryEnum_STRAY_ANIMAL =
    const PublicComplaintDtoCategoryEnum._('STRAY_ANIMAL');
const PublicComplaintDtoCategoryEnum _$publicComplaintDtoCategoryEnum_OTHER =
    const PublicComplaintDtoCategoryEnum._('OTHER');

PublicComplaintDtoCategoryEnum _$publicComplaintDtoCategoryEnumValueOf(
    String name) {
  switch (name) {
    case 'GARBAGE':
      return _$publicComplaintDtoCategoryEnum_GARBAGE;
    case 'DRAIN':
      return _$publicComplaintDtoCategoryEnum_DRAIN;
    case 'ROAD':
      return _$publicComplaintDtoCategoryEnum_ROAD;
    case 'WATER':
      return _$publicComplaintDtoCategoryEnum_WATER;
    case 'TREE':
      return _$publicComplaintDtoCategoryEnum_TREE;
    case 'STRAY_ANIMAL':
      return _$publicComplaintDtoCategoryEnum_STRAY_ANIMAL;
    case 'OTHER':
      return _$publicComplaintDtoCategoryEnum_OTHER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PublicComplaintDtoCategoryEnum>
    _$publicComplaintDtoCategoryEnumValues = BuiltSet<
        PublicComplaintDtoCategoryEnum>(const <PublicComplaintDtoCategoryEnum>[
  _$publicComplaintDtoCategoryEnum_GARBAGE,
  _$publicComplaintDtoCategoryEnum_DRAIN,
  _$publicComplaintDtoCategoryEnum_ROAD,
  _$publicComplaintDtoCategoryEnum_WATER,
  _$publicComplaintDtoCategoryEnum_TREE,
  _$publicComplaintDtoCategoryEnum_STRAY_ANIMAL,
  _$publicComplaintDtoCategoryEnum_OTHER,
]);

const PublicComplaintDtoStatusEnum _$publicComplaintDtoStatusEnum_RECEIVED =
    const PublicComplaintDtoStatusEnum._('RECEIVED');
const PublicComplaintDtoStatusEnum _$publicComplaintDtoStatusEnum_ASSIGNED =
    const PublicComplaintDtoStatusEnum._('ASSIGNED');
const PublicComplaintDtoStatusEnum _$publicComplaintDtoStatusEnum_IN_PROGRESS =
    const PublicComplaintDtoStatusEnum._('IN_PROGRESS');
const PublicComplaintDtoStatusEnum _$publicComplaintDtoStatusEnum_RESOLVED =
    const PublicComplaintDtoStatusEnum._('RESOLVED');
const PublicComplaintDtoStatusEnum _$publicComplaintDtoStatusEnum_CLOSED =
    const PublicComplaintDtoStatusEnum._('CLOSED');
const PublicComplaintDtoStatusEnum _$publicComplaintDtoStatusEnum_REJECTED =
    const PublicComplaintDtoStatusEnum._('REJECTED');

PublicComplaintDtoStatusEnum _$publicComplaintDtoStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'RECEIVED':
      return _$publicComplaintDtoStatusEnum_RECEIVED;
    case 'ASSIGNED':
      return _$publicComplaintDtoStatusEnum_ASSIGNED;
    case 'IN_PROGRESS':
      return _$publicComplaintDtoStatusEnum_IN_PROGRESS;
    case 'RESOLVED':
      return _$publicComplaintDtoStatusEnum_RESOLVED;
    case 'CLOSED':
      return _$publicComplaintDtoStatusEnum_CLOSED;
    case 'REJECTED':
      return _$publicComplaintDtoStatusEnum_REJECTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PublicComplaintDtoStatusEnum>
    _$publicComplaintDtoStatusEnumValues =
    BuiltSet<PublicComplaintDtoStatusEnum>(const <PublicComplaintDtoStatusEnum>[
  _$publicComplaintDtoStatusEnum_RECEIVED,
  _$publicComplaintDtoStatusEnum_ASSIGNED,
  _$publicComplaintDtoStatusEnum_IN_PROGRESS,
  _$publicComplaintDtoStatusEnum_RESOLVED,
  _$publicComplaintDtoStatusEnum_CLOSED,
  _$publicComplaintDtoStatusEnum_REJECTED,
]);

Serializer<PublicComplaintDtoCategoryEnum>
    _$publicComplaintDtoCategoryEnumSerializer =
    _$PublicComplaintDtoCategoryEnumSerializer();
Serializer<PublicComplaintDtoStatusEnum>
    _$publicComplaintDtoStatusEnumSerializer =
    _$PublicComplaintDtoStatusEnumSerializer();

class _$PublicComplaintDtoCategoryEnumSerializer
    implements PrimitiveSerializer<PublicComplaintDtoCategoryEnum> {
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
  final Iterable<Type> types = const <Type>[PublicComplaintDtoCategoryEnum];
  @override
  final String wireName = 'PublicComplaintDtoCategoryEnum';

  @override
  Object serialize(
          Serializers serializers, PublicComplaintDtoCategoryEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PublicComplaintDtoCategoryEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PublicComplaintDtoCategoryEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PublicComplaintDtoStatusEnumSerializer
    implements PrimitiveSerializer<PublicComplaintDtoStatusEnum> {
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
  final Iterable<Type> types = const <Type>[PublicComplaintDtoStatusEnum];
  @override
  final String wireName = 'PublicComplaintDtoStatusEnum';

  @override
  Object serialize(Serializers serializers, PublicComplaintDtoStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PublicComplaintDtoStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PublicComplaintDtoStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PublicComplaintDto extends PublicComplaintDto {
  @override
  final String trackingId;
  @override
  final PublicComplaintDtoCategoryEnum category;
  @override
  final PublicComplaintDtoStatusEnum status;
  @override
  final String? wardCode;
  @override
  final DateTime createdAt;
  @override
  final DateTime? resolvedAt;

  factory _$PublicComplaintDto(
          [void Function(PublicComplaintDtoBuilder)? updates]) =>
      (PublicComplaintDtoBuilder()..update(updates))._build();

  _$PublicComplaintDto._(
      {required this.trackingId,
      required this.category,
      required this.status,
      this.wardCode,
      required this.createdAt,
      this.resolvedAt})
      : super._();
  @override
  PublicComplaintDto rebuild(
          void Function(PublicComplaintDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicComplaintDtoBuilder toBuilder() =>
      PublicComplaintDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicComplaintDto &&
        trackingId == other.trackingId &&
        category == other.category &&
        status == other.status &&
        wardCode == other.wardCode &&
        createdAt == other.createdAt &&
        resolvedAt == other.resolvedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, trackingId.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, wardCode.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, resolvedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PublicComplaintDto')
          ..add('trackingId', trackingId)
          ..add('category', category)
          ..add('status', status)
          ..add('wardCode', wardCode)
          ..add('createdAt', createdAt)
          ..add('resolvedAt', resolvedAt))
        .toString();
  }
}

class PublicComplaintDtoBuilder
    implements Builder<PublicComplaintDto, PublicComplaintDtoBuilder> {
  _$PublicComplaintDto? _$v;

  String? _trackingId;
  String? get trackingId => _$this._trackingId;
  set trackingId(String? trackingId) => _$this._trackingId = trackingId;

  PublicComplaintDtoCategoryEnum? _category;
  PublicComplaintDtoCategoryEnum? get category => _$this._category;
  set category(PublicComplaintDtoCategoryEnum? category) =>
      _$this._category = category;

  PublicComplaintDtoStatusEnum? _status;
  PublicComplaintDtoStatusEnum? get status => _$this._status;
  set status(PublicComplaintDtoStatusEnum? status) => _$this._status = status;

  String? _wardCode;
  String? get wardCode => _$this._wardCode;
  set wardCode(String? wardCode) => _$this._wardCode = wardCode;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _resolvedAt;
  DateTime? get resolvedAt => _$this._resolvedAt;
  set resolvedAt(DateTime? resolvedAt) => _$this._resolvedAt = resolvedAt;

  PublicComplaintDtoBuilder() {
    PublicComplaintDto._defaults(this);
  }

  PublicComplaintDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _trackingId = $v.trackingId;
      _category = $v.category;
      _status = $v.status;
      _wardCode = $v.wardCode;
      _createdAt = $v.createdAt;
      _resolvedAt = $v.resolvedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicComplaintDto other) {
    _$v = other as _$PublicComplaintDto;
  }

  @override
  void update(void Function(PublicComplaintDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicComplaintDto build() => _build();

  _$PublicComplaintDto _build() {
    final _$result = _$v ??
        _$PublicComplaintDto._(
          trackingId: BuiltValueNullFieldError.checkNotNull(
              trackingId, r'PublicComplaintDto', 'trackingId'),
          category: BuiltValueNullFieldError.checkNotNull(
              category, r'PublicComplaintDto', 'category'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'PublicComplaintDto', 'status'),
          wardCode: wardCode,
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'PublicComplaintDto', 'createdAt'),
          resolvedAt: resolvedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
