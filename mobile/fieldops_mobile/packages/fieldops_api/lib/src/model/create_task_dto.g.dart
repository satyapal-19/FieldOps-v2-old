// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_task_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreateTaskDtoPriorityEnum _$createTaskDtoPriorityEnum_URGENT =
    const CreateTaskDtoPriorityEnum._('URGENT');
const CreateTaskDtoPriorityEnum _$createTaskDtoPriorityEnum_NORMAL =
    const CreateTaskDtoPriorityEnum._('NORMAL');
const CreateTaskDtoPriorityEnum _$createTaskDtoPriorityEnum_LOW =
    const CreateTaskDtoPriorityEnum._('LOW');

CreateTaskDtoPriorityEnum _$createTaskDtoPriorityEnumValueOf(String name) {
  switch (name) {
    case 'URGENT':
      return _$createTaskDtoPriorityEnum_URGENT;
    case 'NORMAL':
      return _$createTaskDtoPriorityEnum_NORMAL;
    case 'LOW':
      return _$createTaskDtoPriorityEnum_LOW;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CreateTaskDtoPriorityEnum> _$createTaskDtoPriorityEnumValues =
    BuiltSet<CreateTaskDtoPriorityEnum>(const <CreateTaskDtoPriorityEnum>[
  _$createTaskDtoPriorityEnum_URGENT,
  _$createTaskDtoPriorityEnum_NORMAL,
  _$createTaskDtoPriorityEnum_LOW,
]);

Serializer<CreateTaskDtoPriorityEnum> _$createTaskDtoPriorityEnumSerializer =
    _$CreateTaskDtoPriorityEnumSerializer();

class _$CreateTaskDtoPriorityEnumSerializer
    implements PrimitiveSerializer<CreateTaskDtoPriorityEnum> {
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
  final Iterable<Type> types = const <Type>[CreateTaskDtoPriorityEnum];
  @override
  final String wireName = 'CreateTaskDtoPriorityEnum';

  @override
  Object serialize(Serializers serializers, CreateTaskDtoPriorityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreateTaskDtoPriorityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreateTaskDtoPriorityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreateTaskDto extends CreateTaskDto {
  @override
  final String title;
  @override
  final String? titleMr;
  @override
  final String? description;
  @override
  final CreateTaskDtoPriorityEnum? priority;
  @override
  final String assignedToId;
  @override
  final DateTime? dueAt;
  @override
  final num? locationLat;
  @override
  final num? locationLng;
  @override
  final String? locationLabel;

  factory _$CreateTaskDto([void Function(CreateTaskDtoBuilder)? updates]) =>
      (CreateTaskDtoBuilder()..update(updates))._build();

  _$CreateTaskDto._(
      {required this.title,
      this.titleMr,
      this.description,
      this.priority,
      required this.assignedToId,
      this.dueAt,
      this.locationLat,
      this.locationLng,
      this.locationLabel})
      : super._();
  @override
  CreateTaskDto rebuild(void Function(CreateTaskDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateTaskDtoBuilder toBuilder() => CreateTaskDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateTaskDto &&
        title == other.title &&
        titleMr == other.titleMr &&
        description == other.description &&
        priority == other.priority &&
        assignedToId == other.assignedToId &&
        dueAt == other.dueAt &&
        locationLat == other.locationLat &&
        locationLng == other.locationLng &&
        locationLabel == other.locationLabel;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, titleMr.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, priority.hashCode);
    _$hash = $jc(_$hash, assignedToId.hashCode);
    _$hash = $jc(_$hash, dueAt.hashCode);
    _$hash = $jc(_$hash, locationLat.hashCode);
    _$hash = $jc(_$hash, locationLng.hashCode);
    _$hash = $jc(_$hash, locationLabel.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateTaskDto')
          ..add('title', title)
          ..add('titleMr', titleMr)
          ..add('description', description)
          ..add('priority', priority)
          ..add('assignedToId', assignedToId)
          ..add('dueAt', dueAt)
          ..add('locationLat', locationLat)
          ..add('locationLng', locationLng)
          ..add('locationLabel', locationLabel))
        .toString();
  }
}

class CreateTaskDtoBuilder
    implements Builder<CreateTaskDto, CreateTaskDtoBuilder> {
  _$CreateTaskDto? _$v;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _titleMr;
  String? get titleMr => _$this._titleMr;
  set titleMr(String? titleMr) => _$this._titleMr = titleMr;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  CreateTaskDtoPriorityEnum? _priority;
  CreateTaskDtoPriorityEnum? get priority => _$this._priority;
  set priority(CreateTaskDtoPriorityEnum? priority) =>
      _$this._priority = priority;

  String? _assignedToId;
  String? get assignedToId => _$this._assignedToId;
  set assignedToId(String? assignedToId) => _$this._assignedToId = assignedToId;

  DateTime? _dueAt;
  DateTime? get dueAt => _$this._dueAt;
  set dueAt(DateTime? dueAt) => _$this._dueAt = dueAt;

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

  CreateTaskDtoBuilder() {
    CreateTaskDto._defaults(this);
  }

  CreateTaskDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _title = $v.title;
      _titleMr = $v.titleMr;
      _description = $v.description;
      _priority = $v.priority;
      _assignedToId = $v.assignedToId;
      _dueAt = $v.dueAt;
      _locationLat = $v.locationLat;
      _locationLng = $v.locationLng;
      _locationLabel = $v.locationLabel;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateTaskDto other) {
    _$v = other as _$CreateTaskDto;
  }

  @override
  void update(void Function(CreateTaskDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateTaskDto build() => _build();

  _$CreateTaskDto _build() {
    final _$result = _$v ??
        _$CreateTaskDto._(
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'CreateTaskDto', 'title'),
          titleMr: titleMr,
          description: description,
          priority: priority,
          assignedToId: BuiltValueNullFieldError.checkNotNull(
              assignedToId, r'CreateTaskDto', 'assignedToId'),
          dueAt: dueAt,
          locationLat: locationLat,
          locationLng: locationLng,
          locationLabel: locationLabel,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
