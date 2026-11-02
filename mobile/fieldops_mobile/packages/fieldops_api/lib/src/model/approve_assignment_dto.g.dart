// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approve_assignment_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApproveAssignmentDto extends ApproveAssignmentDto {
  @override
  final num expectedVersion;

  factory _$ApproveAssignmentDto(
          [void Function(ApproveAssignmentDtoBuilder)? updates]) =>
      (ApproveAssignmentDtoBuilder()..update(updates))._build();

  _$ApproveAssignmentDto._({required this.expectedVersion}) : super._();
  @override
  ApproveAssignmentDto rebuild(
          void Function(ApproveAssignmentDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApproveAssignmentDtoBuilder toBuilder() =>
      ApproveAssignmentDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApproveAssignmentDto &&
        expectedVersion == other.expectedVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, expectedVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApproveAssignmentDto')
          ..add('expectedVersion', expectedVersion))
        .toString();
  }
}

class ApproveAssignmentDtoBuilder
    implements Builder<ApproveAssignmentDto, ApproveAssignmentDtoBuilder> {
  _$ApproveAssignmentDto? _$v;

  num? _expectedVersion;
  num? get expectedVersion => _$this._expectedVersion;
  set expectedVersion(num? expectedVersion) =>
      _$this._expectedVersion = expectedVersion;

  ApproveAssignmentDtoBuilder() {
    ApproveAssignmentDto._defaults(this);
  }

  ApproveAssignmentDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _expectedVersion = $v.expectedVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApproveAssignmentDto other) {
    _$v = other as _$ApproveAssignmentDto;
  }

  @override
  void update(void Function(ApproveAssignmentDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApproveAssignmentDto build() => _build();

  _$ApproveAssignmentDto _build() {
    final _$result = _$v ??
        _$ApproveAssignmentDto._(
          expectedVersion: BuiltValueNullFieldError.checkNotNull(
              expectedVersion, r'ApproveAssignmentDto', 'expectedVersion'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
