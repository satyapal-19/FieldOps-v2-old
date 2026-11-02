// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'standing_roster_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StandingRosterDto extends StandingRosterDto {
  @override
  final String id;
  @override
  final String wardId;
  @override
  final String wardInspectorId;
  @override
  final String inspectorId;
  @override
  final String workerId;
  @override
  final bool isActive;
  @override
  final num version;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  factory _$StandingRosterDto(
          [void Function(StandingRosterDtoBuilder)? updates]) =>
      (StandingRosterDtoBuilder()..update(updates))._build();

  _$StandingRosterDto._(
      {required this.id,
      required this.wardId,
      required this.wardInspectorId,
      required this.inspectorId,
      required this.workerId,
      required this.isActive,
      required this.version,
      required this.createdAt,
      required this.updatedAt})
      : super._();
  @override
  StandingRosterDto rebuild(void Function(StandingRosterDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StandingRosterDtoBuilder toBuilder() =>
      StandingRosterDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StandingRosterDto &&
        id == other.id &&
        wardId == other.wardId &&
        wardInspectorId == other.wardInspectorId &&
        inspectorId == other.inspectorId &&
        workerId == other.workerId &&
        isActive == other.isActive &&
        version == other.version &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, wardId.hashCode);
    _$hash = $jc(_$hash, wardInspectorId.hashCode);
    _$hash = $jc(_$hash, inspectorId.hashCode);
    _$hash = $jc(_$hash, workerId.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StandingRosterDto')
          ..add('id', id)
          ..add('wardId', wardId)
          ..add('wardInspectorId', wardInspectorId)
          ..add('inspectorId', inspectorId)
          ..add('workerId', workerId)
          ..add('isActive', isActive)
          ..add('version', version)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class StandingRosterDtoBuilder
    implements Builder<StandingRosterDto, StandingRosterDtoBuilder> {
  _$StandingRosterDto? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

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

  String? _workerId;
  String? get workerId => _$this._workerId;
  set workerId(String? workerId) => _$this._workerId = workerId;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  num? _version;
  num? get version => _$this._version;
  set version(num? version) => _$this._version = version;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  StandingRosterDtoBuilder() {
    StandingRosterDto._defaults(this);
  }

  StandingRosterDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _wardId = $v.wardId;
      _wardInspectorId = $v.wardInspectorId;
      _inspectorId = $v.inspectorId;
      _workerId = $v.workerId;
      _isActive = $v.isActive;
      _version = $v.version;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StandingRosterDto other) {
    _$v = other as _$StandingRosterDto;
  }

  @override
  void update(void Function(StandingRosterDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StandingRosterDto build() => _build();

  _$StandingRosterDto _build() {
    final _$result = _$v ??
        _$StandingRosterDto._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'StandingRosterDto', 'id'),
          wardId: BuiltValueNullFieldError.checkNotNull(
              wardId, r'StandingRosterDto', 'wardId'),
          wardInspectorId: BuiltValueNullFieldError.checkNotNull(
              wardInspectorId, r'StandingRosterDto', 'wardInspectorId'),
          inspectorId: BuiltValueNullFieldError.checkNotNull(
              inspectorId, r'StandingRosterDto', 'inspectorId'),
          workerId: BuiltValueNullFieldError.checkNotNull(
              workerId, r'StandingRosterDto', 'workerId'),
          isActive: BuiltValueNullFieldError.checkNotNull(
              isActive, r'StandingRosterDto', 'isActive'),
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'StandingRosterDto', 'version'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'StandingRosterDto', 'createdAt'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'StandingRosterDto', 'updatedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
