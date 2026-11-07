// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const NotificationDtoKindEnum _$notificationDtoKindEnum_SPOT_CHECK =
    const NotificationDtoKindEnum._('SPOT_CHECK');
const NotificationDtoKindEnum _$notificationDtoKindEnum_ALERT =
    const NotificationDtoKindEnum._('ALERT');
const NotificationDtoKindEnum _$notificationDtoKindEnum_TASK =
    const NotificationDtoKindEnum._('TASK');
const NotificationDtoKindEnum _$notificationDtoKindEnum_CHAT =
    const NotificationDtoKindEnum._('CHAT');
const NotificationDtoKindEnum _$notificationDtoKindEnum_REQUEST =
    const NotificationDtoKindEnum._('REQUEST');
const NotificationDtoKindEnum _$notificationDtoKindEnum_SYSTEM =
    const NotificationDtoKindEnum._('SYSTEM');

NotificationDtoKindEnum _$notificationDtoKindEnumValueOf(String name) {
  switch (name) {
    case 'SPOT_CHECK':
      return _$notificationDtoKindEnum_SPOT_CHECK;
    case 'ALERT':
      return _$notificationDtoKindEnum_ALERT;
    case 'TASK':
      return _$notificationDtoKindEnum_TASK;
    case 'CHAT':
      return _$notificationDtoKindEnum_CHAT;
    case 'REQUEST':
      return _$notificationDtoKindEnum_REQUEST;
    case 'SYSTEM':
      return _$notificationDtoKindEnum_SYSTEM;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<NotificationDtoKindEnum> _$notificationDtoKindEnumValues =
    BuiltSet<NotificationDtoKindEnum>(const <NotificationDtoKindEnum>[
  _$notificationDtoKindEnum_SPOT_CHECK,
  _$notificationDtoKindEnum_ALERT,
  _$notificationDtoKindEnum_TASK,
  _$notificationDtoKindEnum_CHAT,
  _$notificationDtoKindEnum_REQUEST,
  _$notificationDtoKindEnum_SYSTEM,
]);

const NotificationDtoPriorityEnum _$notificationDtoPriorityEnum_HIGH =
    const NotificationDtoPriorityEnum._('HIGH');
const NotificationDtoPriorityEnum _$notificationDtoPriorityEnum_NORMAL =
    const NotificationDtoPriorityEnum._('NORMAL');

NotificationDtoPriorityEnum _$notificationDtoPriorityEnumValueOf(String name) {
  switch (name) {
    case 'HIGH':
      return _$notificationDtoPriorityEnum_HIGH;
    case 'NORMAL':
      return _$notificationDtoPriorityEnum_NORMAL;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<NotificationDtoPriorityEnum>
    _$notificationDtoPriorityEnumValues =
    BuiltSet<NotificationDtoPriorityEnum>(const <NotificationDtoPriorityEnum>[
  _$notificationDtoPriorityEnum_HIGH,
  _$notificationDtoPriorityEnum_NORMAL,
]);

Serializer<NotificationDtoKindEnum> _$notificationDtoKindEnumSerializer =
    _$NotificationDtoKindEnumSerializer();
Serializer<NotificationDtoPriorityEnum>
    _$notificationDtoPriorityEnumSerializer =
    _$NotificationDtoPriorityEnumSerializer();

class _$NotificationDtoKindEnumSerializer
    implements PrimitiveSerializer<NotificationDtoKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SPOT_CHECK': 'SPOT_CHECK',
    'ALERT': 'ALERT',
    'TASK': 'TASK',
    'CHAT': 'CHAT',
    'REQUEST': 'REQUEST',
    'SYSTEM': 'SYSTEM',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SPOT_CHECK': 'SPOT_CHECK',
    'ALERT': 'ALERT',
    'TASK': 'TASK',
    'CHAT': 'CHAT',
    'REQUEST': 'REQUEST',
    'SYSTEM': 'SYSTEM',
  };

  @override
  final Iterable<Type> types = const <Type>[NotificationDtoKindEnum];
  @override
  final String wireName = 'NotificationDtoKindEnum';

  @override
  Object serialize(Serializers serializers, NotificationDtoKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  NotificationDtoKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      NotificationDtoKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$NotificationDtoPriorityEnumSerializer
    implements PrimitiveSerializer<NotificationDtoPriorityEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'HIGH': 'HIGH',
    'NORMAL': 'NORMAL',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'HIGH': 'HIGH',
    'NORMAL': 'NORMAL',
  };

  @override
  final Iterable<Type> types = const <Type>[NotificationDtoPriorityEnum];
  @override
  final String wireName = 'NotificationDtoPriorityEnum';

  @override
  Object serialize(Serializers serializers, NotificationDtoPriorityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  NotificationDtoPriorityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      NotificationDtoPriorityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$NotificationDto extends NotificationDto {
  @override
  final String id;
  @override
  final NotificationDtoKindEnum kind;
  @override
  final NotificationDtoPriorityEnum priority;
  @override
  final String title;
  @override
  final String? titleMr;
  @override
  final String? body;
  @override
  final String? bodyMr;
  @override
  final String? refType;
  @override
  final String? refId;
  @override
  final DateTime createdAt;
  @override
  final DateTime? readAt;

  factory _$NotificationDto([void Function(NotificationDtoBuilder)? updates]) =>
      (NotificationDtoBuilder()..update(updates))._build();

  _$NotificationDto._(
      {required this.id,
      required this.kind,
      required this.priority,
      required this.title,
      this.titleMr,
      this.body,
      this.bodyMr,
      this.refType,
      this.refId,
      required this.createdAt,
      this.readAt})
      : super._();
  @override
  NotificationDto rebuild(void Function(NotificationDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationDtoBuilder toBuilder() => NotificationDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationDto &&
        id == other.id &&
        kind == other.kind &&
        priority == other.priority &&
        title == other.title &&
        titleMr == other.titleMr &&
        body == other.body &&
        bodyMr == other.bodyMr &&
        refType == other.refType &&
        refId == other.refId &&
        createdAt == other.createdAt &&
        readAt == other.readAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, priority.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, titleMr.hashCode);
    _$hash = $jc(_$hash, body.hashCode);
    _$hash = $jc(_$hash, bodyMr.hashCode);
    _$hash = $jc(_$hash, refType.hashCode);
    _$hash = $jc(_$hash, refId.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, readAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NotificationDto')
          ..add('id', id)
          ..add('kind', kind)
          ..add('priority', priority)
          ..add('title', title)
          ..add('titleMr', titleMr)
          ..add('body', body)
          ..add('bodyMr', bodyMr)
          ..add('refType', refType)
          ..add('refId', refId)
          ..add('createdAt', createdAt)
          ..add('readAt', readAt))
        .toString();
  }
}

class NotificationDtoBuilder
    implements Builder<NotificationDto, NotificationDtoBuilder> {
  _$NotificationDto? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  NotificationDtoKindEnum? _kind;
  NotificationDtoKindEnum? get kind => _$this._kind;
  set kind(NotificationDtoKindEnum? kind) => _$this._kind = kind;

  NotificationDtoPriorityEnum? _priority;
  NotificationDtoPriorityEnum? get priority => _$this._priority;
  set priority(NotificationDtoPriorityEnum? priority) =>
      _$this._priority = priority;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _titleMr;
  String? get titleMr => _$this._titleMr;
  set titleMr(String? titleMr) => _$this._titleMr = titleMr;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  String? _bodyMr;
  String? get bodyMr => _$this._bodyMr;
  set bodyMr(String? bodyMr) => _$this._bodyMr = bodyMr;

  String? _refType;
  String? get refType => _$this._refType;
  set refType(String? refType) => _$this._refType = refType;

  String? _refId;
  String? get refId => _$this._refId;
  set refId(String? refId) => _$this._refId = refId;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _readAt;
  DateTime? get readAt => _$this._readAt;
  set readAt(DateTime? readAt) => _$this._readAt = readAt;

  NotificationDtoBuilder() {
    NotificationDto._defaults(this);
  }

  NotificationDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _kind = $v.kind;
      _priority = $v.priority;
      _title = $v.title;
      _titleMr = $v.titleMr;
      _body = $v.body;
      _bodyMr = $v.bodyMr;
      _refType = $v.refType;
      _refId = $v.refId;
      _createdAt = $v.createdAt;
      _readAt = $v.readAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationDto other) {
    _$v = other as _$NotificationDto;
  }

  @override
  void update(void Function(NotificationDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificationDto build() => _build();

  _$NotificationDto _build() {
    final _$result = _$v ??
        _$NotificationDto._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'NotificationDto', 'id'),
          kind: BuiltValueNullFieldError.checkNotNull(
              kind, r'NotificationDto', 'kind'),
          priority: BuiltValueNullFieldError.checkNotNull(
              priority, r'NotificationDto', 'priority'),
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'NotificationDto', 'title'),
          titleMr: titleMr,
          body: body,
          bodyMr: bodyMr,
          refType: refType,
          refId: refId,
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'NotificationDto', 'createdAt'),
          readAt: readAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
