// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const TaskDtoPriorityEnum _$taskDtoPriorityEnum_URGENT =
    const TaskDtoPriorityEnum._('URGENT');
const TaskDtoPriorityEnum _$taskDtoPriorityEnum_NORMAL =
    const TaskDtoPriorityEnum._('NORMAL');
const TaskDtoPriorityEnum _$taskDtoPriorityEnum_LOW =
    const TaskDtoPriorityEnum._('LOW');

TaskDtoPriorityEnum _$taskDtoPriorityEnumValueOf(String name) {
  switch (name) {
    case 'URGENT':
      return _$taskDtoPriorityEnum_URGENT;
    case 'NORMAL':
      return _$taskDtoPriorityEnum_NORMAL;
    case 'LOW':
      return _$taskDtoPriorityEnum_LOW;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TaskDtoPriorityEnum> _$taskDtoPriorityEnumValues =
    BuiltSet<TaskDtoPriorityEnum>(const <TaskDtoPriorityEnum>[
  _$taskDtoPriorityEnum_URGENT,
  _$taskDtoPriorityEnum_NORMAL,
  _$taskDtoPriorityEnum_LOW,
]);

const TaskDtoStatusEnum _$taskDtoStatusEnum_OPEN =
    const TaskDtoStatusEnum._('OPEN');
const TaskDtoStatusEnum _$taskDtoStatusEnum_IN_PROGRESS =
    const TaskDtoStatusEnum._('IN_PROGRESS');
const TaskDtoStatusEnum _$taskDtoStatusEnum_SUBMITTED =
    const TaskDtoStatusEnum._('SUBMITTED');
const TaskDtoStatusEnum _$taskDtoStatusEnum_APPROVED =
    const TaskDtoStatusEnum._('APPROVED');
const TaskDtoStatusEnum _$taskDtoStatusEnum_REJECTED =
    const TaskDtoStatusEnum._('REJECTED');
const TaskDtoStatusEnum _$taskDtoStatusEnum_ESCALATED =
    const TaskDtoStatusEnum._('ESCALATED');
const TaskDtoStatusEnum _$taskDtoStatusEnum_CLOSED =
    const TaskDtoStatusEnum._('CLOSED');

TaskDtoStatusEnum _$taskDtoStatusEnumValueOf(String name) {
  switch (name) {
    case 'OPEN':
      return _$taskDtoStatusEnum_OPEN;
    case 'IN_PROGRESS':
      return _$taskDtoStatusEnum_IN_PROGRESS;
    case 'SUBMITTED':
      return _$taskDtoStatusEnum_SUBMITTED;
    case 'APPROVED':
      return _$taskDtoStatusEnum_APPROVED;
    case 'REJECTED':
      return _$taskDtoStatusEnum_REJECTED;
    case 'ESCALATED':
      return _$taskDtoStatusEnum_ESCALATED;
    case 'CLOSED':
      return _$taskDtoStatusEnum_CLOSED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<TaskDtoStatusEnum> _$taskDtoStatusEnumValues =
    BuiltSet<TaskDtoStatusEnum>(const <TaskDtoStatusEnum>[
  _$taskDtoStatusEnum_OPEN,
  _$taskDtoStatusEnum_IN_PROGRESS,
  _$taskDtoStatusEnum_SUBMITTED,
  _$taskDtoStatusEnum_APPROVED,
  _$taskDtoStatusEnum_REJECTED,
  _$taskDtoStatusEnum_ESCALATED,
  _$taskDtoStatusEnum_CLOSED,
]);

Serializer<TaskDtoPriorityEnum> _$taskDtoPriorityEnumSerializer =
    _$TaskDtoPriorityEnumSerializer();
Serializer<TaskDtoStatusEnum> _$taskDtoStatusEnumSerializer =
    _$TaskDtoStatusEnumSerializer();

class _$TaskDtoPriorityEnumSerializer
    implements PrimitiveSerializer<TaskDtoPriorityEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'URGENT': 'URGENT',
    'NORMAL': 'NORMAL',
    'LOW': 'LOW',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'URGENT': 'URGENT',
    'NORMAL': 'NORMAL',
    'LOW': 'LOW',
  };

  @override
  final Iterable<Type> types = const <Type>[TaskDtoPriorityEnum];
  @override
  final String wireName = 'TaskDtoPriorityEnum';

  @override
  Object serialize(Serializers serializers, TaskDtoPriorityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TaskDtoPriorityEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TaskDtoPriorityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TaskDtoStatusEnumSerializer
    implements PrimitiveSerializer<TaskDtoStatusEnum> {
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
  final Iterable<Type> types = const <Type>[TaskDtoStatusEnum];
  @override
  final String wireName = 'TaskDtoStatusEnum';

  @override
  Object serialize(Serializers serializers, TaskDtoStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  TaskDtoStatusEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TaskDtoStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$TaskDto extends TaskDto {
  @override
  final String id;
  @override
  final String title;
  @override
  final String? titleMr;
  @override
  final String? description;
  @override
  final TaskDtoPriorityEnum priority;
  @override
  final TaskDtoStatusEnum status;
  @override
  final String? wardId;
  @override
  final String? assignedToId;
  @override
  final String createdById;
  @override
  final String? complaintId;
  @override
  final num? locationLat;
  @override
  final num? locationLng;
  @override
  final String? locationLabel;
  @override
  final DateTime? dueAt;
  @override
  final DateTime? startedAt;
  @override
  final DateTime? submittedAt;
  @override
  final DateTime? closedAt;
  @override
  final String? completionNote;
  @override
  final String? rejectionReason;
  @override
  final num rejectionCount;
  @override
  final num version;
  @override
  final DateTime createdAt;

  factory _$TaskDto([void Function(TaskDtoBuilder)? updates]) =>
      (TaskDtoBuilder()..update(updates))._build();

  _$TaskDto._(
      {required this.id,
      required this.title,
      this.titleMr,
      this.description,
      required this.priority,
      required this.status,
      this.wardId,
      this.assignedToId,
      required this.createdById,
      this.complaintId,
      this.locationLat,
      this.locationLng,
      this.locationLabel,
      this.dueAt,
      this.startedAt,
      this.submittedAt,
      this.closedAt,
      this.completionNote,
      this.rejectionReason,
      required this.rejectionCount,
      required this.version,
      required this.createdAt})
      : super._();
  @override
  TaskDto rebuild(void Function(TaskDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TaskDtoBuilder toBuilder() => TaskDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TaskDto &&
        id == other.id &&
        title == other.title &&
        titleMr == other.titleMr &&
        description == other.description &&
        priority == other.priority &&
        status == other.status &&
        wardId == other.wardId &&
        assignedToId == other.assignedToId &&
        createdById == other.createdById &&
        complaintId == other.complaintId &&
        locationLat == other.locationLat &&
        locationLng == other.locationLng &&
        locationLabel == other.locationLabel &&
        dueAt == other.dueAt &&
        startedAt == other.startedAt &&
        submittedAt == other.submittedAt &&
        closedAt == other.closedAt &&
        completionNote == other.completionNote &&
        rejectionReason == other.rejectionReason &&
        rejectionCount == other.rejectionCount &&
        version == other.version &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, titleMr.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, priority.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, wardId.hashCode);
    _$hash = $jc(_$hash, assignedToId.hashCode);
    _$hash = $jc(_$hash, createdById.hashCode);
    _$hash = $jc(_$hash, complaintId.hashCode);
    _$hash = $jc(_$hash, locationLat.hashCode);
    _$hash = $jc(_$hash, locationLng.hashCode);
    _$hash = $jc(_$hash, locationLabel.hashCode);
    _$hash = $jc(_$hash, dueAt.hashCode);
    _$hash = $jc(_$hash, startedAt.hashCode);
    _$hash = $jc(_$hash, submittedAt.hashCode);
    _$hash = $jc(_$hash, closedAt.hashCode);
    _$hash = $jc(_$hash, completionNote.hashCode);
    _$hash = $jc(_$hash, rejectionReason.hashCode);
    _$hash = $jc(_$hash, rejectionCount.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TaskDto')
          ..add('id', id)
          ..add('title', title)
          ..add('titleMr', titleMr)
          ..add('description', description)
          ..add('priority', priority)
          ..add('status', status)
          ..add('wardId', wardId)
          ..add('assignedToId', assignedToId)
          ..add('createdById', createdById)
          ..add('complaintId', complaintId)
          ..add('locationLat', locationLat)
          ..add('locationLng', locationLng)
          ..add('locationLabel', locationLabel)
          ..add('dueAt', dueAt)
          ..add('startedAt', startedAt)
          ..add('submittedAt', submittedAt)
          ..add('closedAt', closedAt)
          ..add('completionNote', completionNote)
          ..add('rejectionReason', rejectionReason)
          ..add('rejectionCount', rejectionCount)
          ..add('version', version)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class TaskDtoBuilder implements Builder<TaskDto, TaskDtoBuilder> {
  _$TaskDto? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _titleMr;
  String? get titleMr => _$this._titleMr;
  set titleMr(String? titleMr) => _$this._titleMr = titleMr;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  TaskDtoPriorityEnum? _priority;
  TaskDtoPriorityEnum? get priority => _$this._priority;
  set priority(TaskDtoPriorityEnum? priority) => _$this._priority = priority;

  TaskDtoStatusEnum? _status;
  TaskDtoStatusEnum? get status => _$this._status;
  set status(TaskDtoStatusEnum? status) => _$this._status = status;

  String? _wardId;
  String? get wardId => _$this._wardId;
  set wardId(String? wardId) => _$this._wardId = wardId;

  String? _assignedToId;
  String? get assignedToId => _$this._assignedToId;
  set assignedToId(String? assignedToId) => _$this._assignedToId = assignedToId;

  String? _createdById;
  String? get createdById => _$this._createdById;
  set createdById(String? createdById) => _$this._createdById = createdById;

  String? _complaintId;
  String? get complaintId => _$this._complaintId;
  set complaintId(String? complaintId) => _$this._complaintId = complaintId;

  num? _locationLat;
  num? get locationLat => _$this._locationLat;
  set locationLat(num? locationLat) => _$this._locationLat = locationLat;

  num? _locationLng;
  num? get locationLng => _$this._locationLng;
  set locationLng(num? locationLng) => _$this._locationLng = locationLng;

  String? _locationLabel;
  String? get locationLabel => _$this._locationLabel;
  set locationLabel(String? locationLabel) =>
      _$this._locationLabel = locationLabel;

  DateTime? _dueAt;
  DateTime? get dueAt => _$this._dueAt;
  set dueAt(DateTime? dueAt) => _$this._dueAt = dueAt;

  DateTime? _startedAt;
  DateTime? get startedAt => _$this._startedAt;
  set startedAt(DateTime? startedAt) => _$this._startedAt = startedAt;

  DateTime? _submittedAt;
  DateTime? get submittedAt => _$this._submittedAt;
  set submittedAt(DateTime? submittedAt) => _$this._submittedAt = submittedAt;

  DateTime? _closedAt;
  DateTime? get closedAt => _$this._closedAt;
  set closedAt(DateTime? closedAt) => _$this._closedAt = closedAt;

  String? _completionNote;
  String? get completionNote => _$this._completionNote;
  set completionNote(String? completionNote) =>
      _$this._completionNote = completionNote;

  String? _rejectionReason;
  String? get rejectionReason => _$this._rejectionReason;
  set rejectionReason(String? rejectionReason) =>
      _$this._rejectionReason = rejectionReason;

  num? _rejectionCount;
  num? get rejectionCount => _$this._rejectionCount;
  set rejectionCount(num? rejectionCount) =>
      _$this._rejectionCount = rejectionCount;

  num? _version;
  num? get version => _$this._version;
  set version(num? version) => _$this._version = version;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  TaskDtoBuilder() {
    TaskDto._defaults(this);
  }

  TaskDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _titleMr = $v.titleMr;
      _description = $v.description;
      _priority = $v.priority;
      _status = $v.status;
      _wardId = $v.wardId;
      _assignedToId = $v.assignedToId;
      _createdById = $v.createdById;
      _complaintId = $v.complaintId;
      _locationLat = $v.locationLat;
      _locationLng = $v.locationLng;
      _locationLabel = $v.locationLabel;
      _dueAt = $v.dueAt;
      _startedAt = $v.startedAt;
      _submittedAt = $v.submittedAt;
      _closedAt = $v.closedAt;
      _completionNote = $v.completionNote;
      _rejectionReason = $v.rejectionReason;
      _rejectionCount = $v.rejectionCount;
      _version = $v.version;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TaskDto other) {
    _$v = other as _$TaskDto;
  }

  @override
  void update(void Function(TaskDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TaskDto build() => _build();

  _$TaskDto _build() {
    final _$result = _$v ??
        _$TaskDto._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'TaskDto', 'id'),
          title:
              BuiltValueNullFieldError.checkNotNull(title, r'TaskDto', 'title'),
          titleMr: titleMr,
          description: description,
          priority: BuiltValueNullFieldError.checkNotNull(
              priority, r'TaskDto', 'priority'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'TaskDto', 'status'),
          wardId: wardId,
          assignedToId: assignedToId,
          createdById: BuiltValueNullFieldError.checkNotNull(
              createdById, r'TaskDto', 'createdById'),
          complaintId: complaintId,
          locationLat: locationLat,
          locationLng: locationLng,
          locationLabel: locationLabel,
          dueAt: dueAt,
          startedAt: startedAt,
          submittedAt: submittedAt,
          closedAt: closedAt,
          completionNote: completionNote,
          rejectionReason: rejectionReason,
          rejectionCount: BuiltValueNullFieldError.checkNotNull(
              rejectionCount, r'TaskDto', 'rejectionCount'),
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'TaskDto', 'version'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'TaskDto', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
