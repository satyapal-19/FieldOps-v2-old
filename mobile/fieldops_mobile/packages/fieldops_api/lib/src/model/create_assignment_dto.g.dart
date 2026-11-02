// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_assignment_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateAssignmentDto extends CreateAssignmentDto {
  @override
  final String date;
  @override
  final String staffId;
  @override
  final String? wardId;
  @override
  final String? inspectorId;

  factory _$CreateAssignmentDto(
          [void Function(CreateAssignmentDtoBuilder)? updates]) =>
      (CreateAssignmentDtoBuilder()..update(updates))._build();

  _$CreateAssignmentDto._(
      {required this.date,
      required this.staffId,
      this.wardId,
      this.inspectorId})
      : super._();
  @override
  CreateAssignmentDto rebuild(
          void Function(CreateAssignmentDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateAssignmentDtoBuilder toBuilder() =>
      CreateAssignmentDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateAssignmentDto &&
        date == other.date &&
        staffId == other.staffId &&
        wardId == other.wardId &&
        inspectorId == other.inspectorId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, staffId.hashCode);
    _$hash = $jc(_$hash, wardId.hashCode);
    _$hash = $jc(_$hash, inspectorId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateAssignmentDto')
          ..add('date', date)
          ..add('staffId', staffId)
          ..add('wardId', wardId)
          ..add('inspectorId', inspectorId))
        .toString();
  }
}

class CreateAssignmentDtoBuilder
    implements Builder<CreateAssignmentDto, CreateAssignmentDtoBuilder> {
  _$CreateAssignmentDto? _$v;

  String? _date;
  String? get date => _$this._date;
  set date(String? date) => _$this._date = date;

  String? _staffId;
  String? get staffId => _$this._staffId;
  set staffId(String? staffId) => _$this._staffId = staffId;

  String? _wardId;
  String? get wardId => _$this._wardId;
  set wardId(String? wardId) => _$this._wardId = wardId;

  String? _inspectorId;
  String? get inspectorId => _$this._inspectorId;
  set inspectorId(String? inspectorId) => _$this._inspectorId = inspectorId;

  CreateAssignmentDtoBuilder() {
    CreateAssignmentDto._defaults(this);
  }

  CreateAssignmentDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _staffId = $v.staffId;
      _wardId = $v.wardId;
      _inspectorId = $v.inspectorId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateAssignmentDto other) {
    _$v = other as _$CreateAssignmentDto;
  }

  @override
  void update(void Function(CreateAssignmentDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateAssignmentDto build() => _build();

  _$CreateAssignmentDto _build() {
    final _$result = _$v ??
        _$CreateAssignmentDto._(
          date: BuiltValueNullFieldError.checkNotNull(
              date, r'CreateAssignmentDto', 'date'),
          staffId: BuiltValueNullFieldError.checkNotNull(
              staffId, r'CreateAssignmentDto', 'staffId'),
          wardId: wardId,
          inspectorId: inspectorId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
