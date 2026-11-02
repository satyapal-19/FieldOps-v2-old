// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supervisor_action_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SupervisorActionDtoActionEnum _$supervisorActionDtoActionEnum_APPROVE =
    const SupervisorActionDtoActionEnum._('APPROVE');
const SupervisorActionDtoActionEnum _$supervisorActionDtoActionEnum_REJECT =
    const SupervisorActionDtoActionEnum._('REJECT');
const SupervisorActionDtoActionEnum _$supervisorActionDtoActionEnum_ESCALATE =
    const SupervisorActionDtoActionEnum._('ESCALATE');
const SupervisorActionDtoActionEnum _$supervisorActionDtoActionEnum_CLOSE =
    const SupervisorActionDtoActionEnum._('CLOSE');

SupervisorActionDtoActionEnum _$supervisorActionDtoActionEnumValueOf(
    String name) {
  switch (name) {
    case 'APPROVE':
      return _$supervisorActionDtoActionEnum_APPROVE;
    case 'REJECT':
      return _$supervisorActionDtoActionEnum_REJECT;
    case 'ESCALATE':
      return _$supervisorActionDtoActionEnum_ESCALATE;
    case 'CLOSE':
      return _$supervisorActionDtoActionEnum_CLOSE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SupervisorActionDtoActionEnum>
    _$supervisorActionDtoActionEnumValues = BuiltSet<
        SupervisorActionDtoActionEnum>(const <SupervisorActionDtoActionEnum>[
  _$supervisorActionDtoActionEnum_APPROVE,
  _$supervisorActionDtoActionEnum_REJECT,
  _$supervisorActionDtoActionEnum_ESCALATE,
  _$supervisorActionDtoActionEnum_CLOSE,
]);

Serializer<SupervisorActionDtoActionEnum>
    _$supervisorActionDtoActionEnumSerializer =
    _$SupervisorActionDtoActionEnumSerializer();

class _$SupervisorActionDtoActionEnumSerializer
    implements PrimitiveSerializer<SupervisorActionDtoActionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'APPROVE': 'APPROVE',
    'REJECT': 'REJECT',
    'ESCALATE': 'ESCALATE',
    'CLOSE': 'CLOSE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'APPROVE': 'APPROVE',
    'REJECT': 'REJECT',
    'ESCALATE': 'ESCALATE',
    'CLOSE': 'CLOSE',
  };

  @override
  final Iterable<Type> types = const <Type>[SupervisorActionDtoActionEnum];
  @override
  final String wireName = 'SupervisorActionDtoActionEnum';

  @override
  Object serialize(
          Serializers serializers, SupervisorActionDtoActionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SupervisorActionDtoActionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SupervisorActionDtoActionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SupervisorActionDto extends SupervisorActionDto {
  @override
  final num expectedVersion;
  @override
  final SupervisorActionDtoActionEnum action;
  @override
  final String? reason;

  factory _$SupervisorActionDto(
          [void Function(SupervisorActionDtoBuilder)? updates]) =>
      (SupervisorActionDtoBuilder()..update(updates))._build();

  _$SupervisorActionDto._(
      {required this.expectedVersion, required this.action, this.reason})
      : super._();
  @override
  SupervisorActionDto rebuild(
          void Function(SupervisorActionDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SupervisorActionDtoBuilder toBuilder() =>
      SupervisorActionDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SupervisorActionDto &&
        expectedVersion == other.expectedVersion &&
        action == other.action &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, expectedVersion.hashCode);
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SupervisorActionDto')
          ..add('expectedVersion', expectedVersion)
          ..add('action', action)
          ..add('reason', reason))
        .toString();
  }
}

class SupervisorActionDtoBuilder
    implements Builder<SupervisorActionDto, SupervisorActionDtoBuilder> {
  _$SupervisorActionDto? _$v;

  num? _expectedVersion;
  num? get expectedVersion => _$this._expectedVersion;
  set expectedVersion(num? expectedVersion) =>
      _$this._expectedVersion = expectedVersion;

  SupervisorActionDtoActionEnum? _action;
  SupervisorActionDtoActionEnum? get action => _$this._action;
  set action(SupervisorActionDtoActionEnum? action) => _$this._action = action;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  SupervisorActionDtoBuilder() {
    SupervisorActionDto._defaults(this);
  }

  SupervisorActionDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _expectedVersion = $v.expectedVersion;
      _action = $v.action;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SupervisorActionDto other) {
    _$v = other as _$SupervisorActionDto;
  }

  @override
  void update(void Function(SupervisorActionDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SupervisorActionDto build() => _build();

  _$SupervisorActionDto _build() {
    final _$result = _$v ??
        _$SupervisorActionDto._(
          expectedVersion: BuiltValueNullFieldError.checkNotNull(
              expectedVersion, r'SupervisorActionDto', 'expectedVersion'),
          action: BuiltValueNullFieldError.checkNotNull(
              action, r'SupervisorActionDto', 'action'),
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
