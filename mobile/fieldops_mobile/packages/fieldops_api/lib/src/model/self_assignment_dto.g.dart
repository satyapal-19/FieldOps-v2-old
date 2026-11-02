// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'self_assignment_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SelfAssignmentDto extends SelfAssignmentDto {
  @override
  final String clientUuid;
  @override
  final String date;
  @override
  final String? wardId;
  @override
  final String? inspectorId;

  factory _$SelfAssignmentDto(
          [void Function(SelfAssignmentDtoBuilder)? updates]) =>
      (SelfAssignmentDtoBuilder()..update(updates))._build();

  _$SelfAssignmentDto._(
      {required this.clientUuid,
      required this.date,
      this.wardId,
      this.inspectorId})
      : super._();
  @override
  SelfAssignmentDto rebuild(void Function(SelfAssignmentDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SelfAssignmentDtoBuilder toBuilder() =>
      SelfAssignmentDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SelfAssignmentDto &&
        clientUuid == other.clientUuid &&
        date == other.date &&
        wardId == other.wardId &&
        inspectorId == other.inspectorId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, clientUuid.hashCode);
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, wardId.hashCode);
    _$hash = $jc(_$hash, inspectorId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SelfAssignmentDto')
          ..add('clientUuid', clientUuid)
          ..add('date', date)
          ..add('wardId', wardId)
          ..add('inspectorId', inspectorId))
        .toString();
  }
}

class SelfAssignmentDtoBuilder
    implements Builder<SelfAssignmentDto, SelfAssignmentDtoBuilder> {
  _$SelfAssignmentDto? _$v;

  String? _clientUuid;
  String? get clientUuid => _$this._clientUuid;
  set clientUuid(String? clientUuid) => _$this._clientUuid = clientUuid;

  String? _date;
  String? get date => _$this._date;
  set date(String? date) => _$this._date = date;

  String? _wardId;
  String? get wardId => _$this._wardId;
  set wardId(String? wardId) => _$this._wardId = wardId;

  String? _inspectorId;
  String? get inspectorId => _$this._inspectorId;
  set inspectorId(String? inspectorId) => _$this._inspectorId = inspectorId;

  SelfAssignmentDtoBuilder() {
    SelfAssignmentDto._defaults(this);
  }

  SelfAssignmentDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _clientUuid = $v.clientUuid;
      _date = $v.date;
      _wardId = $v.wardId;
      _inspectorId = $v.inspectorId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SelfAssignmentDto other) {
    _$v = other as _$SelfAssignmentDto;
  }

  @override
  void update(void Function(SelfAssignmentDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SelfAssignmentDto build() => _build();

  _$SelfAssignmentDto _build() {
    final _$result = _$v ??
        _$SelfAssignmentDto._(
          clientUuid: BuiltValueNullFieldError.checkNotNull(
              clientUuid, r'SelfAssignmentDto', 'clientUuid'),
          date: BuiltValueNullFieldError.checkNotNull(
              date, r'SelfAssignmentDto', 'date'),
          wardId: wardId,
          inspectorId: inspectorId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
