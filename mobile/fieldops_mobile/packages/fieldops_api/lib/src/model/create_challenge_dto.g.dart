// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_challenge_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateChallengeDto extends CreateChallengeDto {
  @override
  final String? staffId;

  factory _$CreateChallengeDto(
          [void Function(CreateChallengeDtoBuilder)? updates]) =>
      (CreateChallengeDtoBuilder()..update(updates))._build();

  _$CreateChallengeDto._({this.staffId}) : super._();
  @override
  CreateChallengeDto rebuild(
          void Function(CreateChallengeDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateChallengeDtoBuilder toBuilder() =>
      CreateChallengeDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateChallengeDto && staffId == other.staffId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, staffId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateChallengeDto')
          ..add('staffId', staffId))
        .toString();
  }
}

class CreateChallengeDtoBuilder
    implements Builder<CreateChallengeDto, CreateChallengeDtoBuilder> {
  _$CreateChallengeDto? _$v;

  String? _staffId;
  String? get staffId => _$this._staffId;
  set staffId(String? staffId) => _$this._staffId = staffId;

  CreateChallengeDtoBuilder() {
    CreateChallengeDto._defaults(this);
  }

  CreateChallengeDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _staffId = $v.staffId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateChallengeDto other) {
    _$v = other as _$CreateChallengeDto;
  }

  @override
  void update(void Function(CreateChallengeDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateChallengeDto build() => _build();

  _$CreateChallengeDto _build() {
    final _$result = _$v ??
        _$CreateChallengeDto._(
          staffId: staffId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
