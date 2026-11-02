// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_standing_roster_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateStandingRosterDto extends CreateStandingRosterDto {
  @override
  final String workerId;
  @override
  final String inspectorId;

  factory _$CreateStandingRosterDto(
          [void Function(CreateStandingRosterDtoBuilder)? updates]) =>
      (CreateStandingRosterDtoBuilder()..update(updates))._build();

  _$CreateStandingRosterDto._(
      {required this.workerId, required this.inspectorId})
      : super._();
  @override
  CreateStandingRosterDto rebuild(
          void Function(CreateStandingRosterDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateStandingRosterDtoBuilder toBuilder() =>
      CreateStandingRosterDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateStandingRosterDto &&
        workerId == other.workerId &&
        inspectorId == other.inspectorId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, workerId.hashCode);
    _$hash = $jc(_$hash, inspectorId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateStandingRosterDto')
          ..add('workerId', workerId)
          ..add('inspectorId', inspectorId))
        .toString();
  }
}

class CreateStandingRosterDtoBuilder
    implements
        Builder<CreateStandingRosterDto, CreateStandingRosterDtoBuilder> {
  _$CreateStandingRosterDto? _$v;

  String? _workerId;
  String? get workerId => _$this._workerId;
  set workerId(String? workerId) => _$this._workerId = workerId;

  String? _inspectorId;
  String? get inspectorId => _$this._inspectorId;
  set inspectorId(String? inspectorId) => _$this._inspectorId = inspectorId;

  CreateStandingRosterDtoBuilder() {
    CreateStandingRosterDto._defaults(this);
  }

  CreateStandingRosterDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _workerId = $v.workerId;
      _inspectorId = $v.inspectorId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateStandingRosterDto other) {
    _$v = other as _$CreateStandingRosterDto;
  }

  @override
  void update(void Function(CreateStandingRosterDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateStandingRosterDto build() => _build();

  _$CreateStandingRosterDto _build() {
    final _$result = _$v ??
        _$CreateStandingRosterDto._(
          workerId: BuiltValueNullFieldError.checkNotNull(
              workerId, r'CreateStandingRosterDto', 'workerId'),
          inspectorId: BuiltValueNullFieldError.checkNotNull(
              inspectorId, r'CreateStandingRosterDto', 'inspectorId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
