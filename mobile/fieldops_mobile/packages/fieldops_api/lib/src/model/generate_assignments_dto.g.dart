// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generate_assignments_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GenerateAssignmentsDto extends GenerateAssignmentsDto {
  @override
  final String date;

  factory _$GenerateAssignmentsDto(
          [void Function(GenerateAssignmentsDtoBuilder)? updates]) =>
      (GenerateAssignmentsDtoBuilder()..update(updates))._build();

  _$GenerateAssignmentsDto._({required this.date}) : super._();
  @override
  GenerateAssignmentsDto rebuild(
          void Function(GenerateAssignmentsDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GenerateAssignmentsDtoBuilder toBuilder() =>
      GenerateAssignmentsDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GenerateAssignmentsDto && date == other.date;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GenerateAssignmentsDto')
          ..add('date', date))
        .toString();
  }
}

class GenerateAssignmentsDtoBuilder
    implements Builder<GenerateAssignmentsDto, GenerateAssignmentsDtoBuilder> {
  _$GenerateAssignmentsDto? _$v;

  String? _date;
  String? get date => _$this._date;
  set date(String? date) => _$this._date = date;

  GenerateAssignmentsDtoBuilder() {
    GenerateAssignmentsDto._defaults(this);
  }

  GenerateAssignmentsDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GenerateAssignmentsDto other) {
    _$v = other as _$GenerateAssignmentsDto;
  }

  @override
  void update(void Function(GenerateAssignmentsDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GenerateAssignmentsDto build() => _build();

  _$GenerateAssignmentsDto _build() {
    final _$result = _$v ??
        _$GenerateAssignmentsDto._(
          date: BuiltValueNullFieldError.checkNotNull(
              date, r'GenerateAssignmentsDto', 'date'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
