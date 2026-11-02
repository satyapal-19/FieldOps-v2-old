// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generate_assignments_result_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GenerateAssignmentsResultDto extends GenerateAssignmentsResultDto {
  @override
  final String date;
  @override
  final num created;

  factory _$GenerateAssignmentsResultDto(
          [void Function(GenerateAssignmentsResultDtoBuilder)? updates]) =>
      (GenerateAssignmentsResultDtoBuilder()..update(updates))._build();

  _$GenerateAssignmentsResultDto._({required this.date, required this.created})
      : super._();
  @override
  GenerateAssignmentsResultDto rebuild(
          void Function(GenerateAssignmentsResultDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GenerateAssignmentsResultDtoBuilder toBuilder() =>
      GenerateAssignmentsResultDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GenerateAssignmentsResultDto &&
        date == other.date &&
        created == other.created;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, created.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GenerateAssignmentsResultDto')
          ..add('date', date)
          ..add('created', created))
        .toString();
  }
}

class GenerateAssignmentsResultDtoBuilder
    implements
        Builder<GenerateAssignmentsResultDto,
            GenerateAssignmentsResultDtoBuilder> {
  _$GenerateAssignmentsResultDto? _$v;

  String? _date;
  String? get date => _$this._date;
  set date(String? date) => _$this._date = date;

  num? _created;
  num? get created => _$this._created;
  set created(num? created) => _$this._created = created;

  GenerateAssignmentsResultDtoBuilder() {
    GenerateAssignmentsResultDto._defaults(this);
  }

  GenerateAssignmentsResultDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date = $v.date;
      _created = $v.created;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GenerateAssignmentsResultDto other) {
    _$v = other as _$GenerateAssignmentsResultDto;
  }

  @override
  void update(void Function(GenerateAssignmentsResultDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GenerateAssignmentsResultDto build() => _build();

  _$GenerateAssignmentsResultDto _build() {
    final _$result = _$v ??
        _$GenerateAssignmentsResultDto._(
          date: BuiltValueNullFieldError.checkNotNull(
              date, r'GenerateAssignmentsResultDto', 'date'),
          created: BuiltValueNullFieldError.checkNotNull(
              created, r'GenerateAssignmentsResultDto', 'created'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
