// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_update_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TaskUpdateDtoFromStatusEnum _$taskUpdateDtoFromStatusEnum_OPEN =
    const TaskUpdateDtoFromStatusEnum._('OPEN');
const TaskUpdateDtoFromStatusEnum _$taskUpdateDtoFromStatusEnum_IN_PROGRESS =
    const TaskUpdateDtoFromStatusEnum._('IN_PROGRESS');
const TaskUpdateDtoFromStatusEnum _$taskUpdateDtoFromStatusEnum_SUBMITTED =
    const TaskUpdateDtoFromStatusEnum._('SUBMITTED');
const TaskUpdateDtoFromStatusEnum _$taskUpdateDtoFromStatusEnum_APPROVED =
    const TaskUpdateDtoFromStatusEnum._('APPROVED');
const TaskUpdateDtoFromStatusEnum _$taskUpdateDtoFromStatusEnum_REJECTED =
    const TaskUpdateDtoFromStatusEnum._('REJECTED');
const TaskUpdateDtoFromStatusEnum _$taskUpdateDtoFromStatusEnum_ESCALATED =
    const TaskUpdateDtoFromStatusEnum._('ESCALATED');
const TaskUpdateDtoFromStatusEnum _$taskUpdateDtoFromStatusEnum_CLOSED =
    const TaskUpdateDtoFromStatusEnum._('CLOSED');

TaskUpdateDtoFromStatusEnum _$taskUpdateDtoFromStatusEnumValueOf(String name) {
  switch (name) {
    case 'OPEN':
      return _$taskUpdateDtoFromStatusEnum_OPEN;
    case 'IN_PROGRESS':
      return _$taskUpdateDtoFromStatusEnum_IN_PROGRESS;
    case 'SUBMITTED':
      return _$taskUpdateDtoFromStatusEnum_SUBMITTED;
    case 'APPROVED':
      return _$taskUpdateDtoFromStatusEnum_APPROVED;
    case 'REJECTED':
      return _$taskUpdateDtoFromStatusEnum_REJECTED;
    case 'ESCALATED':
      return _$taskUpdateDtoFromStatusEnum_ESCALATED;
    case 'CLOSED':
      return _$taskUpdateDtoFromStatusEnum_CLOSED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TaskUpdateDtoFromStatusEnum>
    _$taskUpdateDtoFromStatusEnumValues =
    BuiltSet<TaskUpdateDtoFromStatusEnum>(const <TaskUpdateDtoFromStatusEnum>[
  _$taskUpdateDtoFromStatusEnum_OPEN,
  _$taskUpdateDtoFromStatusEnum_IN_PROGRESS,
  _$taskUpdateDtoFromStatusEnum_SUBMITTED,
  _$taskUpdateDtoFromStatusEnum_APPROVED,
  _$taskUpdateDtoFromStatusEnum_REJECTED,
  _$taskUpdateDtoFromStatusEnum_ESCALATED,
  _$taskUpdateDtoFromStatusEnum_CLOSED,
]);

const TaskUpdateDtoToStatusEnum _$taskUpdateDtoToStatusEnum_OPEN =
    const TaskUpdateDtoToStatusEnum._('OPEN');
const TaskUpdateDtoToStatusEnum _$taskUpdateDtoToStatusEnum_IN_PROGRESS =
    const TaskUpdateDtoToStatusEnum._('IN_PROGRESS');
const TaskUpdateDtoToStatusEnum _$taskUpdateDtoToStatusEnum_SUBMITTED =
    const TaskUpdateDtoToStatusEnum._('SUBMITTED');
const TaskUpdateDtoToStatusEnum _$taskUpdateDtoToStatusEnum_APPROVED =
    const TaskUpdateDtoToStatusEnum._('APPROVED');
const TaskUpdateDtoToStatusEnum _$taskUpdateDtoToStatusEnum_REJECTED =
    const TaskUpdateDtoToStatusEnum._('REJECTED');
const TaskUpdateDtoToStatusEnum _$taskUpdateDtoToStatusEnum_ESCALATED =
    const TaskUpdateDtoToStatusEnum._('ESCALATED');
const TaskUpdateDtoToStatusEnum _$taskUpdateDtoToStatusEnum_CLOSED =
    const TaskUpdateDtoToStatusEnum._('CLOSED');

TaskUpdateDtoToStatusEnum _$taskUpdateDtoToStatusEnumValueOf(String name) {
  switch (name) {
    case 'OPEN':
      return _$taskUpdateDtoToStatusEnum_OPEN;
    case 'IN_PROGRESS':
      return _$taskUpdateDtoToStatusEnum_IN_PROGRESS;
    case 'SUBMITTED':
      return _$taskUpdateDtoToStatusEnum_SUBMITTED;
    case 'APPROVED':
      return _$taskUpdateDtoToStatusEnum_APPROVED;
    case 'REJECTED':
      return _$taskUpdateDtoToStatusEnum_REJECTED;
    case 'ESCALATED':
      return _$taskUpdateDtoToStatusEnum_ESCALATED;
    case 'CLOSED':
      return _$taskUpdateDtoToStatusEnum_CLOSED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TaskUpdateDtoToStatusEnum> _$taskUpdateDtoToStatusEnumValues =
    BuiltSet<TaskUpdateDtoToStatusEnum>(const <TaskUpdateDtoToStatusEnum>[
  _$taskUpdateDtoToStatusEnum_OPEN,
  _$taskUpdateDtoToStatusEnum_IN_PROGRESS,
  _$taskUpdateDtoToStatusEnum_SUBMITTED,
  _$taskUpdateDtoToStatusEnum_APPROVED,
  _$taskUpdateDtoToStatusEnum_REJECTED,
  _$taskUpdateDtoToStatusEnum_ESCALATED,
  _$taskUpdateDtoToStatusEnum_CLOSED,
]);

Serializer<TaskUpdateDtoFromStatusEnum>
    _$taskUpdateDtoFromStatusEnumSerializer =
    _$TaskUpdateDtoFromStatusEnumSerializer();
Serializer<TaskUpdateDtoToStatusEnum> _$taskUpdateDtoToStatusEnumSerializer =
    _$TaskUpdateDtoToStatusEnumSerializer();

class _$TaskUpdateDtoFromStatusEnumSerializer
    implements PrimitiveSerializer<TaskUpdateDtoFromStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OPEN': 'OPEN',
    'IN_PROGRESS': 'IN_PROGRESS',
    'SUBMITTED': 'SUBMITTED',
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
    'ESCALATED': 'ESCALATED',
    'CLOSED': 'CLOSED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OPEN': 'OPEN',
    'IN_PROGRESS': 'IN_PROGRESS',
    'SUBMITTED': 'SUBMITTED',
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
    'ESCALATED': 'ESCALATED',
    'CLOSED': 'CLOSED',
  };

  @override
  final Iterable<Type> types = const <Type>[TaskUpdateDtoFromStatusEnum];
  @override
  final String wireName = 'TaskUpdateDtoFromStatusEnum';

  @override
  Object serialize(Serializers serializers, TaskUpdateDtoFromStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TaskUpdateDtoFromStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TaskUpdateDtoFromStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TaskUpdateDtoToStatusEnumSerializer
    implements PrimitiveSerializer<TaskUpdateDtoToStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OPEN': 'OPEN',
    'IN_PROGRESS': 'IN_PROGRESS',
    'SUBMITTED': 'SUBMITTED',
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
    'ESCALATED': 'ESCALATED',
    'CLOSED': 'CLOSED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OPEN': 'OPEN',
    'IN_PROGRESS': 'IN_PROGRESS',
    'SUBMITTED': 'SUBMITTED',
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
    'ESCALATED': 'ESCALATED',
    'CLOSED': 'CLOSED',
  };

  @override
  final Iterable<Type> types = const <Type>[TaskUpdateDtoToStatusEnum];
  @override
  final String wireName = 'TaskUpdateDtoToStatusEnum';

  @override
  Object serialize(Serializers serializers, TaskUpdateDtoToStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TaskUpdateDtoToStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TaskUpdateDtoToStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TaskUpdateDto extends TaskUpdateDto {
  @override
  final String id;
  @override
  final String staffId;
  @override
  final TaskUpdateDtoFromStatusEnum fromStatus;
  @override
  final TaskUpdateDtoToStatusEnum toStatus;
  @override
  final String? note;
  @override
  final String? photoKey;
  @override
  final DateTime createdAt;

  factory _$TaskUpdateDto([void Function(TaskUpdateDtoBuilder)? updates]) =>
      (TaskUpdateDtoBuilder()..update(updates))._build();

  _$TaskUpdateDto._(
      {required this.id,
      required this.staffId,
      required this.fromStatus,
      required this.toStatus,
      this.note,
      this.photoKey,
      required this.createdAt})
      : super._();
  @override
  TaskUpdateDto rebuild(void Function(TaskUpdateDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TaskUpdateDtoBuilder toBuilder() => TaskUpdateDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TaskUpdateDto &&
        id == other.id &&
        staffId == other.staffId &&
        fromStatus == other.fromStatus &&
        toStatus == other.toStatus &&
        note == other.note &&
        photoKey == other.photoKey &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, staffId.hashCode);
    _$hash = $jc(_$hash, fromStatus.hashCode);
    _$hash = $jc(_$hash, toStatus.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, photoKey.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TaskUpdateDto')
          ..add('id', id)
          ..add('staffId', staffId)
          ..add('fromStatus', fromStatus)
          ..add('toStatus', toStatus)
          ..add('note', note)
          ..add('photoKey', photoKey)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class TaskUpdateDtoBuilder
    implements Builder<TaskUpdateDto, TaskUpdateDtoBuilder> {
  _$TaskUpdateDto? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _staffId;
  String? get staffId => _$this._staffId;
  set staffId(String? staffId) => _$this._staffId = staffId;

  TaskUpdateDtoFromStatusEnum? _fromStatus;
  TaskUpdateDtoFromStatusEnum? get fromStatus => _$this._fromStatus;
  set fromStatus(TaskUpdateDtoFromStatusEnum? fromStatus) =>
      _$this._fromStatus = fromStatus;

  TaskUpdateDtoToStatusEnum? _toStatus;
  TaskUpdateDtoToStatusEnum? get toStatus => _$this._toStatus;
  set toStatus(TaskUpdateDtoToStatusEnum? toStatus) =>
      _$this._toStatus = toStatus;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  String? _photoKey;
  String? get photoKey => _$this._photoKey;
  set photoKey(String? photoKey) => _$this._photoKey = photoKey;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  TaskUpdateDtoBuilder() {
    TaskUpdateDto._defaults(this);
  }

  TaskUpdateDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _staffId = $v.staffId;
      _fromStatus = $v.fromStatus;
      _toStatus = $v.toStatus;
      _note = $v.note;
      _photoKey = $v.photoKey;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TaskUpdateDto other) {
    _$v = other as _$TaskUpdateDto;
  }

  @override
  void update(void Function(TaskUpdateDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TaskUpdateDto build() => _build();

  _$TaskUpdateDto _build() {
    final _$result = _$v ??
        _$TaskUpdateDto._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'TaskUpdateDto', 'id'),
          staffId: BuiltValueNullFieldError.checkNotNull(
              staffId, r'TaskUpdateDto', 'staffId'),
          fromStatus: BuiltValueNullFieldError.checkNotNull(
              fromStatus, r'TaskUpdateDto', 'fromStatus'),
          toStatus: BuiltValueNullFieldError.checkNotNull(
              toStatus, r'TaskUpdateDto', 'toStatus'),
          note: note,
          photoKey: photoKey,
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'TaskUpdateDto', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
