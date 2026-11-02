// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ChallengeDtoActionsEnum _$challengeDtoActionsEnum_BLINK =
    const ChallengeDtoActionsEnum._('BLINK');
const ChallengeDtoActionsEnum _$challengeDtoActionsEnum_SMILE =
    const ChallengeDtoActionsEnum._('SMILE');
const ChallengeDtoActionsEnum _$challengeDtoActionsEnum_TURN_LEFT =
    const ChallengeDtoActionsEnum._('TURN_LEFT');
const ChallengeDtoActionsEnum _$challengeDtoActionsEnum_TURN_RIGHT =
    const ChallengeDtoActionsEnum._('TURN_RIGHT');

ChallengeDtoActionsEnum _$challengeDtoActionsEnumValueOf(String name) {
  switch (name) {
    case 'BLINK':
      return _$challengeDtoActionsEnum_BLINK;
    case 'SMILE':
      return _$challengeDtoActionsEnum_SMILE;
    case 'TURN_LEFT':
      return _$challengeDtoActionsEnum_TURN_LEFT;
    case 'TURN_RIGHT':
      return _$challengeDtoActionsEnum_TURN_RIGHT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ChallengeDtoActionsEnum> _$challengeDtoActionsEnumValues =
    BuiltSet<ChallengeDtoActionsEnum>(const <ChallengeDtoActionsEnum>[
  _$challengeDtoActionsEnum_BLINK,
  _$challengeDtoActionsEnum_SMILE,
  _$challengeDtoActionsEnum_TURN_LEFT,
  _$challengeDtoActionsEnum_TURN_RIGHT,
]);

Serializer<ChallengeDtoActionsEnum> _$challengeDtoActionsEnumSerializer =
    _$ChallengeDtoActionsEnumSerializer();

class _$ChallengeDtoActionsEnumSerializer
    implements PrimitiveSerializer<ChallengeDtoActionsEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BLINK': 'BLINK',
    'SMILE': 'SMILE',
    'TURN_LEFT': 'TURN_LEFT',
    'TURN_RIGHT': 'TURN_RIGHT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BLINK': 'BLINK',
    'SMILE': 'SMILE',
    'TURN_LEFT': 'TURN_LEFT',
    'TURN_RIGHT': 'TURN_RIGHT',
  };

  @override
  final Iterable<Type> types = const <Type>[ChallengeDtoActionsEnum];
  @override
  final String wireName = 'ChallengeDtoActionsEnum';

  @override
  Object serialize(Serializers serializers, ChallengeDtoActionsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ChallengeDtoActionsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ChallengeDtoActionsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ChallengeDto extends ChallengeDto {
  @override
  final String challengeId;
  @override
  final String staffId;
  @override
  final BuiltList<ChallengeDtoActionsEnum> actions;
  @override
  final DateTime expiresAt;

  factory _$ChallengeDto([void Function(ChallengeDtoBuilder)? updates]) =>
      (ChallengeDtoBuilder()..update(updates))._build();

  _$ChallengeDto._(
      {required this.challengeId,
      required this.staffId,
      required this.actions,
      required this.expiresAt})
      : super._();
  @override
  ChallengeDto rebuild(void Function(ChallengeDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChallengeDtoBuilder toBuilder() => ChallengeDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChallengeDto &&
        challengeId == other.challengeId &&
        staffId == other.staffId &&
        actions == other.actions &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, challengeId.hashCode);
    _$hash = $jc(_$hash, staffId.hashCode);
    _$hash = $jc(_$hash, actions.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChallengeDto')
          ..add('challengeId', challengeId)
          ..add('staffId', staffId)
          ..add('actions', actions)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class ChallengeDtoBuilder
    implements Builder<ChallengeDto, ChallengeDtoBuilder> {
  _$ChallengeDto? _$v;

  String? _challengeId;
  String? get challengeId => _$this._challengeId;
  set challengeId(String? challengeId) => _$this._challengeId = challengeId;

  String? _staffId;
  String? get staffId => _$this._staffId;
  set staffId(String? staffId) => _$this._staffId = staffId;

  ListBuilder<ChallengeDtoActionsEnum>? _actions;
  ListBuilder<ChallengeDtoActionsEnum> get actions =>
      _$this._actions ??= ListBuilder<ChallengeDtoActionsEnum>();
  set actions(ListBuilder<ChallengeDtoActionsEnum>? actions) =>
      _$this._actions = actions;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  ChallengeDtoBuilder() {
    ChallengeDto._defaults(this);
  }

  ChallengeDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _challengeId = $v.challengeId;
      _staffId = $v.staffId;
      _actions = $v.actions.toBuilder();
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChallengeDto other) {
    _$v = other as _$ChallengeDto;
  }

  @override
  void update(void Function(ChallengeDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChallengeDto build() => _build();

  _$ChallengeDto _build() {
    _$ChallengeDto _$result;
    try {
      _$result = _$v ??
          _$ChallengeDto._(
            challengeId: BuiltValueNullFieldError.checkNotNull(
                challengeId, r'ChallengeDto', 'challengeId'),
            staffId: BuiltValueNullFieldError.checkNotNull(
                staffId, r'ChallengeDto', 'staffId'),
            actions: actions.build(),
            expiresAt: BuiltValueNullFieldError.checkNotNull(
                expiresAt, r'ChallengeDto', 'expiresAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'actions';
        actions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ChallengeDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
