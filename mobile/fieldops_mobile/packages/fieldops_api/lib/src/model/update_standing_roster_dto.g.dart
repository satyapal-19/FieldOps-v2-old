// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_standing_roster_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateStandingRosterDto extends UpdateStandingRosterDto {
  @override
  final num expectedVersion;
  @override
  final String? inspectorId;
  @override
  final bool? isActive;

  factory _$UpdateStandingRosterDto(
          [void Function(UpdateStandingRosterDtoBuilder)? updates]) =>
      (UpdateStandingRosterDtoBuilder()..update(updates))._build();

  _$UpdateStandingRosterDto._(
      {required this.expectedVersion, this.inspectorId, this.isActive})
      : super._();
  @override
  UpdateStandingRosterDto rebuild(
          void Function(UpdateStandingRosterDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateStandingRosterDtoBuilder toBuilder() =>
      UpdateStandingRosterDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateStandingRosterDto &&
        expectedVersion == other.expectedVersion &&
        inspectorId == other.inspectorId &&
        isActive == other.isActive;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, expectedVersion.hashCode);
    _$hash = $jc(_$hash, inspectorId.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateStandingRosterDto')
          ..add('expectedVersion', expectedVersion)
          ..add('inspectorId', inspectorId)
          ..add('isActive', isActive))
        .toString();
  }
}

class UpdateStandingRosterDtoBuilder
    implements
        Builder<UpdateStandingRosterDto, UpdateStandingRosterDtoBuilder> {
  _$UpdateStandingRosterDto? _$v;

  num? _expectedVersion;
  num? get expectedVersion => _$this._expectedVersion;
  set expectedVersion(num? expectedVersion) =>
      _$this._expectedVersion = expectedVersion;

  String? _inspectorId;
  String? get inspectorId => _$this._inspectorId;
  set inspectorId(String? inspectorId) => _$this._inspectorId = inspectorId;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  UpdateStandingRosterDtoBuilder() {
    UpdateStandingRosterDto._defaults(this);
  }

  UpdateStandingRosterDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _expectedVersion = $v.expectedVersion;
      _inspectorId = $v.inspectorId;
      _isActive = $v.isActive;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateStandingRosterDto other) {
    _$v = other as _$UpdateStandingRosterDto;
  }

  @override
  void update(void Function(UpdateStandingRosterDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateStandingRosterDto build() => _build();

  _$UpdateStandingRosterDto _build() {
    final _$result = _$v ??
        _$UpdateStandingRosterDto._(
          expectedVersion: BuiltValueNullFieldError.checkNotNull(
              expectedVersion, r'UpdateStandingRosterDto', 'expectedVersion'),
          inspectorId: inspectorId,
          isActive: isActive,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
