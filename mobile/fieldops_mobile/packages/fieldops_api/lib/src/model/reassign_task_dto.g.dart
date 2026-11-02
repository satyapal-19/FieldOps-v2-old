// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reassign_task_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReassignTaskDto extends ReassignTaskDto {
  @override
  final num expectedVersion;
  @override
  final String assignedToId;

  factory _$ReassignTaskDto([void Function(ReassignTaskDtoBuilder)? updates]) =>
      (ReassignTaskDtoBuilder()..update(updates))._build();

  _$ReassignTaskDto._(
      {required this.expectedVersion, required this.assignedToId})
      : super._();
  @override
  ReassignTaskDto rebuild(void Function(ReassignTaskDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReassignTaskDtoBuilder toBuilder() => ReassignTaskDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReassignTaskDto &&
        expectedVersion == other.expectedVersion &&
        assignedToId == other.assignedToId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, expectedVersion.hashCode);
    _$hash = $jc(_$hash, assignedToId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReassignTaskDto')
          ..add('expectedVersion', expectedVersion)
          ..add('assignedToId', assignedToId))
        .toString();
  }
}

class ReassignTaskDtoBuilder
    implements Builder<ReassignTaskDto, ReassignTaskDtoBuilder> {
  _$ReassignTaskDto? _$v;

  num? _expectedVersion;
  num? get expectedVersion => _$this._expectedVersion;
  set expectedVersion(num? expectedVersion) =>
      _$this._expectedVersion = expectedVersion;

  String? _assignedToId;
  String? get assignedToId => _$this._assignedToId;
  set assignedToId(String? assignedToId) => _$this._assignedToId = assignedToId;

  ReassignTaskDtoBuilder() {
    ReassignTaskDto._defaults(this);
  }

  ReassignTaskDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _expectedVersion = $v.expectedVersion;
      _assignedToId = $v.assignedToId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReassignTaskDto other) {
    _$v = other as _$ReassignTaskDto;
  }

  @override
  void update(void Function(ReassignTaskDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReassignTaskDto build() => _build();

  _$ReassignTaskDto _build() {
    final _$result = _$v ??
        _$ReassignTaskDto._(
          expectedVersion: BuiltValueNullFieldError.checkNotNull(
              expectedVersion, r'ReassignTaskDto', 'expectedVersion'),
          assignedToId: BuiltValueNullFieldError.checkNotNull(
              assignedToId, r'ReassignTaskDto', 'assignedToId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
