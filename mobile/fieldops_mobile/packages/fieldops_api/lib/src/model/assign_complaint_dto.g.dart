// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assign_complaint_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AssignComplaintDtoPriorityEnum _$assignComplaintDtoPriorityEnum_URGENT =
    const AssignComplaintDtoPriorityEnum._('URGENT');
const AssignComplaintDtoPriorityEnum _$assignComplaintDtoPriorityEnum_NORMAL =
    const AssignComplaintDtoPriorityEnum._('NORMAL');
const AssignComplaintDtoPriorityEnum _$assignComplaintDtoPriorityEnum_LOW =
    const AssignComplaintDtoPriorityEnum._('LOW');

AssignComplaintDtoPriorityEnum _$assignComplaintDtoPriorityEnumValueOf(
    String name) {
  switch (name) {
    case 'URGENT':
      return _$assignComplaintDtoPriorityEnum_URGENT;
    case 'NORMAL':
      return _$assignComplaintDtoPriorityEnum_NORMAL;
    case 'LOW':
      return _$assignComplaintDtoPriorityEnum_LOW;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AssignComplaintDtoPriorityEnum>
    _$assignComplaintDtoPriorityEnumValues = BuiltSet<
        AssignComplaintDtoPriorityEnum>(const <AssignComplaintDtoPriorityEnum>[
  _$assignComplaintDtoPriorityEnum_URGENT,
  _$assignComplaintDtoPriorityEnum_NORMAL,
  _$assignComplaintDtoPriorityEnum_LOW,
]);

Serializer<AssignComplaintDtoPriorityEnum>
    _$assignComplaintDtoPriorityEnumSerializer =
    _$AssignComplaintDtoPriorityEnumSerializer();

class _$AssignComplaintDtoPriorityEnumSerializer
    implements PrimitiveSerializer<AssignComplaintDtoPriorityEnum> {
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
  final Iterable<Type> types = const <Type>[AssignComplaintDtoPriorityEnum];
  @override
  final String wireName = 'AssignComplaintDtoPriorityEnum';

  @override
  Object serialize(
          Serializers serializers, AssignComplaintDtoPriorityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AssignComplaintDtoPriorityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AssignComplaintDtoPriorityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AssignComplaintDto extends AssignComplaintDto {
  @override
  final num expectedVersion;
  @override
  final String assignedToId;
  @override
  final AssignComplaintDtoPriorityEnum? priority;
  @override
  final DateTime? dueAt;

  factory _$AssignComplaintDto(
          [void Function(AssignComplaintDtoBuilder)? updates]) =>
      (AssignComplaintDtoBuilder()..update(updates))._build();

  _$AssignComplaintDto._(
      {required this.expectedVersion,
      required this.assignedToId,
      this.priority,
      this.dueAt})
      : super._();
  @override
  AssignComplaintDto rebuild(
          void Function(AssignComplaintDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AssignComplaintDtoBuilder toBuilder() =>
      AssignComplaintDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AssignComplaintDto &&
        expectedVersion == other.expectedVersion &&
        assignedToId == other.assignedToId &&
        priority == other.priority &&
        dueAt == other.dueAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, expectedVersion.hashCode);
    _$hash = $jc(_$hash, assignedToId.hashCode);
    _$hash = $jc(_$hash, priority.hashCode);
    _$hash = $jc(_$hash, dueAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AssignComplaintDto')
          ..add('expectedVersion', expectedVersion)
          ..add('assignedToId', assignedToId)
          ..add('priority', priority)
          ..add('dueAt', dueAt))
        .toString();
  }
}

class AssignComplaintDtoBuilder
    implements Builder<AssignComplaintDto, AssignComplaintDtoBuilder> {
  _$AssignComplaintDto? _$v;

  num? _expectedVersion;
  num? get expectedVersion => _$this._expectedVersion;
  set expectedVersion(num? expectedVersion) =>
      _$this._expectedVersion = expectedVersion;

  String? _assignedToId;
  String? get assignedToId => _$this._assignedToId;
  set assignedToId(String? assignedToId) => _$this._assignedToId = assignedToId;

  AssignComplaintDtoPriorityEnum? _priority;
  AssignComplaintDtoPriorityEnum? get priority => _$this._priority;
  set priority(AssignComplaintDtoPriorityEnum? priority) =>
      _$this._priority = priority;

  DateTime? _dueAt;
  DateTime? get dueAt => _$this._dueAt;
  set dueAt(DateTime? dueAt) => _$this._dueAt = dueAt;

  AssignComplaintDtoBuilder() {
    AssignComplaintDto._defaults(this);
  }

  AssignComplaintDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _expectedVersion = $v.expectedVersion;
      _assignedToId = $v.assignedToId;
      _priority = $v.priority;
      _dueAt = $v.dueAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AssignComplaintDto other) {
    _$v = other as _$AssignComplaintDto;
  }

  @override
  void update(void Function(AssignComplaintDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AssignComplaintDto build() => _build();

  _$AssignComplaintDto _build() {
    final _$result = _$v ??
        _$AssignComplaintDto._(
          expectedVersion: BuiltValueNullFieldError.checkNotNull(
              expectedVersion, r'AssignComplaintDto', 'expectedVersion'),
          assignedToId: BuiltValueNullFieldError.checkNotNull(
              assignedToId, r'AssignComplaintDto', 'assignedToId'),
          priority: priority,
          dueAt: dueAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
