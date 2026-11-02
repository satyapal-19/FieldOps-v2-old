// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignment_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AssignmentDtoStaffRoleEnum _$assignmentDtoStaffRoleEnum_INSPECTOR =
    const AssignmentDtoStaffRoleEnum._('INSPECTOR');
const AssignmentDtoStaffRoleEnum _$assignmentDtoStaffRoleEnum_WORKER =
    const AssignmentDtoStaffRoleEnum._('WORKER');

AssignmentDtoStaffRoleEnum _$assignmentDtoStaffRoleEnumValueOf(String name) {
  switch (name) {
    case 'INSPECTOR':
      return _$assignmentDtoStaffRoleEnum_INSPECTOR;
    case 'WORKER':
      return _$assignmentDtoStaffRoleEnum_WORKER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AssignmentDtoStaffRoleEnum> _$assignmentDtoStaffRoleEnumValues =
    BuiltSet<AssignmentDtoStaffRoleEnum>(const <AssignmentDtoStaffRoleEnum>[
  _$assignmentDtoStaffRoleEnum_INSPECTOR,
  _$assignmentDtoStaffRoleEnum_WORKER,
]);

const AssignmentDtoAssignmentModeEnum
    _$assignmentDtoAssignmentModeEnum_STANDING_ROSTER =
    const AssignmentDtoAssignmentModeEnum._('STANDING_ROSTER');
const AssignmentDtoAssignmentModeEnum
    _$assignmentDtoAssignmentModeEnum_ADMIN_ASSIGNED =
    const AssignmentDtoAssignmentModeEnum._('ADMIN_ASSIGNED');
const AssignmentDtoAssignmentModeEnum
    _$assignmentDtoAssignmentModeEnum_WARD_INSPECTOR_ASSIGNED =
    const AssignmentDtoAssignmentModeEnum._('WARD_INSPECTOR_ASSIGNED');
const AssignmentDtoAssignmentModeEnum
    _$assignmentDtoAssignmentModeEnum_INSPECTOR_SELF_PICK =
    const AssignmentDtoAssignmentModeEnum._('INSPECTOR_SELF_PICK');
const AssignmentDtoAssignmentModeEnum
    _$assignmentDtoAssignmentModeEnum_WORKER_SELF_JOIN =
    const AssignmentDtoAssignmentModeEnum._('WORKER_SELF_JOIN');

AssignmentDtoAssignmentModeEnum _$assignmentDtoAssignmentModeEnumValueOf(
    String name) {
  switch (name) {
    case 'STANDING_ROSTER':
      return _$assignmentDtoAssignmentModeEnum_STANDING_ROSTER;
    case 'ADMIN_ASSIGNED':
      return _$assignmentDtoAssignmentModeEnum_ADMIN_ASSIGNED;
    case 'WARD_INSPECTOR_ASSIGNED':
      return _$assignmentDtoAssignmentModeEnum_WARD_INSPECTOR_ASSIGNED;
    case 'INSPECTOR_SELF_PICK':
      return _$assignmentDtoAssignmentModeEnum_INSPECTOR_SELF_PICK;
    case 'WORKER_SELF_JOIN':
      return _$assignmentDtoAssignmentModeEnum_WORKER_SELF_JOIN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AssignmentDtoAssignmentModeEnum>
    _$assignmentDtoAssignmentModeEnumValues = BuiltSet<
        AssignmentDtoAssignmentModeEnum>(const <AssignmentDtoAssignmentModeEnum>[
  _$assignmentDtoAssignmentModeEnum_STANDING_ROSTER,
  _$assignmentDtoAssignmentModeEnum_ADMIN_ASSIGNED,
  _$assignmentDtoAssignmentModeEnum_WARD_INSPECTOR_ASSIGNED,
  _$assignmentDtoAssignmentModeEnum_INSPECTOR_SELF_PICK,
  _$assignmentDtoAssignmentModeEnum_WORKER_SELF_JOIN,
]);

Serializer<AssignmentDtoStaffRoleEnum> _$assignmentDtoStaffRoleEnumSerializer =
    _$AssignmentDtoStaffRoleEnumSerializer();
Serializer<AssignmentDtoAssignmentModeEnum>
    _$assignmentDtoAssignmentModeEnumSerializer =
    _$AssignmentDtoAssignmentModeEnumSerializer();

class _$AssignmentDtoStaffRoleEnumSerializer
    implements PrimitiveSerializer<AssignmentDtoStaffRoleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'INSPECTOR': 'INSPECTOR',
    'WORKER': 'WORKER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'INSPECTOR': 'INSPECTOR',
    'WORKER': 'WORKER',
  };

  @override
  final Iterable<Type> types = const <Type>[AssignmentDtoStaffRoleEnum];
  @override
  final String wireName = 'AssignmentDtoStaffRoleEnum';

  @override
  Object serialize(Serializers serializers, AssignmentDtoStaffRoleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AssignmentDtoStaffRoleEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AssignmentDtoStaffRoleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AssignmentDtoAssignmentModeEnumSerializer
    implements PrimitiveSerializer<AssignmentDtoAssignmentModeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'STANDING_ROSTER': 'STANDING_ROSTER',
    'ADMIN_ASSIGNED': 'ADMIN_ASSIGNED',
    'WARD_INSPECTOR_ASSIGNED': 'WARD_INSPECTOR_ASSIGNED',
    'INSPECTOR_SELF_PICK': 'INSPECTOR_SELF_PICK',
    'WORKER_SELF_JOIN': 'WORKER_SELF_JOIN',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'STANDING_ROSTER': 'STANDING_ROSTER',
    'ADMIN_ASSIGNED': 'ADMIN_ASSIGNED',
    'WARD_INSPECTOR_ASSIGNED': 'WARD_INSPECTOR_ASSIGNED',
    'INSPECTOR_SELF_PICK': 'INSPECTOR_SELF_PICK',
    'WORKER_SELF_JOIN': 'WORKER_SELF_JOIN',
  };

  @override
  final Iterable<Type> types = const <Type>[AssignmentDtoAssignmentModeEnum];
  @override
  final String wireName = 'AssignmentDtoAssignmentModeEnum';

  @override
  Object serialize(
          Serializers serializers, AssignmentDtoAssignmentModeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AssignmentDtoAssignmentModeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AssignmentDtoAssignmentModeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AssignmentDto extends AssignmentDto {
  @override
  final String id;
  @override
  final String date;
  @override
  final String staffId;
  @override
  final AssignmentDtoStaffRoleEnum staffRole;
  @override
  final String wardId;
  @override
  final String wardInspectorId;
  @override
  final String inspectorId;
  @override
  final AssignmentDtoAssignmentModeEnum assignmentMode;
  @override
  final bool isApproved;
  @override
  final String? approvedById;
  @override
  final DateTime? approvedAt;
  @override
  final String? assignedById;
  @override
  final num version;
  @override
  final DateTime createdAt;

  factory _$AssignmentDto([void Function(AssignmentDtoBuilder)? updates]) =>
      (AssignmentDtoBuilder()..update(updates))._build();

  _$AssignmentDto._(
      {required this.id,
      required this.date,
      required this.staffId,
      required this.staffRole,
      required this.wardId,
      required this.wardInspectorId,
      required this.inspectorId,
      required this.assignmentMode,
      required this.isApproved,
      this.approvedById,
      this.approvedAt,
      this.assignedById,
      required this.version,
      required this.createdAt})
      : super._();
  @override
  AssignmentDto rebuild(void Function(AssignmentDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AssignmentDtoBuilder toBuilder() => AssignmentDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AssignmentDto &&
        id == other.id &&
        date == other.date &&
        staffId == other.staffId &&
        staffRole == other.staffRole &&
        wardId == other.wardId &&
        wardInspectorId == other.wardInspectorId &&
        inspectorId == other.inspectorId &&
        assignmentMode == other.assignmentMode &&
        isApproved == other.isApproved &&
        approvedById == other.approvedById &&
        approvedAt == other.approvedAt &&
        assignedById == other.assignedById &&
        version == other.version &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, staffId.hashCode);
    _$hash = $jc(_$hash, staffRole.hashCode);
    _$hash = $jc(_$hash, wardId.hashCode);
    _$hash = $jc(_$hash, wardInspectorId.hashCode);
    _$hash = $jc(_$hash, inspectorId.hashCode);
    _$hash = $jc(_$hash, assignmentMode.hashCode);
    _$hash = $jc(_$hash, isApproved.hashCode);
    _$hash = $jc(_$hash, approvedById.hashCode);
    _$hash = $jc(_$hash, approvedAt.hashCode);
    _$hash = $jc(_$hash, assignedById.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AssignmentDto')
          ..add('id', id)
          ..add('date', date)
          ..add('staffId', staffId)
          ..add('staffRole', staffRole)
          ..add('wardId', wardId)
          ..add('wardInspectorId', wardInspectorId)
          ..add('inspectorId', inspectorId)
          ..add('assignmentMode', assignmentMode)
          ..add('isApproved', isApproved)
          ..add('approvedById', approvedById)
          ..add('approvedAt', approvedAt)
          ..add('assignedById', assignedById)
          ..add('version', version)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class AssignmentDtoBuilder
    implements Builder<AssignmentDto, AssignmentDtoBuilder> {
  _$AssignmentDto? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _date;
  String? get date => _$this._date;
  set date(String? date) => _$this._date = date;

  String? _staffId;
  String? get staffId => _$this._staffId;
  set staffId(String? staffId) => _$this._staffId = staffId;

  AssignmentDtoStaffRoleEnum? _staffRole;
  AssignmentDtoStaffRoleEnum? get staffRole => _$this._staffRole;
  set staffRole(AssignmentDtoStaffRoleEnum? staffRole) =>
      _$this._staffRole = staffRole;

  String? _wardId;
  String? get wardId => _$this._wardId;
  set wardId(String? wardId) => _$this._wardId = wardId;

  String? _wardInspectorId;
  String? get wardInspectorId => _$this._wardInspectorId;
  set wardInspectorId(String? wardInspectorId) =>
      _$this._wardInspectorId = wardInspectorId;

  String? _inspectorId;
  String? get inspectorId => _$this._inspectorId;
  set inspectorId(String? inspectorId) => _$this._inspectorId = inspectorId;

  AssignmentDtoAssignmentModeEnum? _assignmentMode;
  AssignmentDtoAssignmentModeEnum? get assignmentMode => _$this._assignmentMode;
  set assignmentMode(AssignmentDtoAssignmentModeEnum? assignmentMode) =>
      _$this._assignmentMode = assignmentMode;

  bool? _isApproved;
  bool? get isApproved => _$this._isApproved;
  set isApproved(bool? isApproved) => _$this._isApproved = isApproved;

  String? _approvedById;
  String? get approvedById => _$this._approvedById;
  set approvedById(String? approvedById) => _$this._approvedById = approvedById;

  DateTime? _approvedAt;
  DateTime? get approvedAt => _$this._approvedAt;
  set approvedAt(DateTime? approvedAt) => _$this._approvedAt = approvedAt;

  String? _assignedById;
  String? get assignedById => _$this._assignedById;
  set assignedById(String? assignedById) => _$this._assignedById = assignedById;

  num? _version;
  num? get version => _$this._version;
  set version(num? version) => _$this._version = version;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  AssignmentDtoBuilder() {
    AssignmentDto._defaults(this);
  }

  AssignmentDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _date = $v.date;
      _staffId = $v.staffId;
      _staffRole = $v.staffRole;
      _wardId = $v.wardId;
      _wardInspectorId = $v.wardInspectorId;
      _inspectorId = $v.inspectorId;
      _assignmentMode = $v.assignmentMode;
      _isApproved = $v.isApproved;
      _approvedById = $v.approvedById;
      _approvedAt = $v.approvedAt;
      _assignedById = $v.assignedById;
      _version = $v.version;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AssignmentDto other) {
    _$v = other as _$AssignmentDto;
  }

  @override
  void update(void Function(AssignmentDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AssignmentDto build() => _build();

  _$AssignmentDto _build() {
    final _$result = _$v ??
        _$AssignmentDto._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'AssignmentDto', 'id'),
          date: BuiltValueNullFieldError.checkNotNull(
              date, r'AssignmentDto', 'date'),
          staffId: BuiltValueNullFieldError.checkNotNull(
              staffId, r'AssignmentDto', 'staffId'),
          staffRole: BuiltValueNullFieldError.checkNotNull(
              staffRole, r'AssignmentDto', 'staffRole'),
          wardId: BuiltValueNullFieldError.checkNotNull(
              wardId, r'AssignmentDto', 'wardId'),
          wardInspectorId: BuiltValueNullFieldError.checkNotNull(
              wardInspectorId, r'AssignmentDto', 'wardInspectorId'),
          inspectorId: BuiltValueNullFieldError.checkNotNull(
              inspectorId, r'AssignmentDto', 'inspectorId'),
          assignmentMode: BuiltValueNullFieldError.checkNotNull(
              assignmentMode, r'AssignmentDto', 'assignmentMode'),
          isApproved: BuiltValueNullFieldError.checkNotNull(
              isApproved, r'AssignmentDto', 'isApproved'),
          approvedById: approvedById,
          approvedAt: approvedAt,
          assignedById: assignedById,
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'AssignmentDto', 'version'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'AssignmentDto', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
