// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_leave_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreateLeaveDtoLeaveTypeEnum _$createLeaveDtoLeaveTypeEnum_CASUAL =
    const CreateLeaveDtoLeaveTypeEnum._('CASUAL');
const CreateLeaveDtoLeaveTypeEnum _$createLeaveDtoLeaveTypeEnum_SICK =
    const CreateLeaveDtoLeaveTypeEnum._('SICK');
const CreateLeaveDtoLeaveTypeEnum _$createLeaveDtoLeaveTypeEnum_EARNED =
    const CreateLeaveDtoLeaveTypeEnum._('EARNED');
const CreateLeaveDtoLeaveTypeEnum _$createLeaveDtoLeaveTypeEnum_WEEKLY_OFF =
    const CreateLeaveDtoLeaveTypeEnum._('WEEKLY_OFF');

CreateLeaveDtoLeaveTypeEnum _$createLeaveDtoLeaveTypeEnumValueOf(String name) {
  switch (name) {
    case 'CASUAL':
      return _$createLeaveDtoLeaveTypeEnum_CASUAL;
    case 'SICK':
      return _$createLeaveDtoLeaveTypeEnum_SICK;
    case 'EARNED':
      return _$createLeaveDtoLeaveTypeEnum_EARNED;
    case 'WEEKLY_OFF':
      return _$createLeaveDtoLeaveTypeEnum_WEEKLY_OFF;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CreateLeaveDtoLeaveTypeEnum>
    _$createLeaveDtoLeaveTypeEnumValues =
    BuiltSet<CreateLeaveDtoLeaveTypeEnum>(const <CreateLeaveDtoLeaveTypeEnum>[
  _$createLeaveDtoLeaveTypeEnum_CASUAL,
  _$createLeaveDtoLeaveTypeEnum_SICK,
  _$createLeaveDtoLeaveTypeEnum_EARNED,
  _$createLeaveDtoLeaveTypeEnum_WEEKLY_OFF,
]);

Serializer<CreateLeaveDtoLeaveTypeEnum>
    _$createLeaveDtoLeaveTypeEnumSerializer =
    _$CreateLeaveDtoLeaveTypeEnumSerializer();

class _$CreateLeaveDtoLeaveTypeEnumSerializer
    implements PrimitiveSerializer<CreateLeaveDtoLeaveTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'CASUAL': 'CASUAL',
    'SICK': 'SICK',
    'EARNED': 'EARNED',
    'WEEKLY_OFF': 'WEEKLY_OFF',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CASUAL': 'CASUAL',
    'SICK': 'SICK',
    'EARNED': 'EARNED',
    'WEEKLY_OFF': 'WEEKLY_OFF',
  };

  @override
  final Iterable<Type> types = const <Type>[CreateLeaveDtoLeaveTypeEnum];
  @override
  final String wireName = 'CreateLeaveDtoLeaveTypeEnum';

  @override
  Object serialize(Serializers serializers, CreateLeaveDtoLeaveTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreateLeaveDtoLeaveTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreateLeaveDtoLeaveTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreateLeaveDto extends CreateLeaveDto {
  @override
  final String? clientUuid;
  @override
  final CreateLeaveDtoLeaveTypeEnum leaveType;
  @override
  final String fromDate;
  @override
  final String toDate;
  @override
  final String? reason;

  factory _$CreateLeaveDto([void Function(CreateLeaveDtoBuilder)? updates]) =>
      (CreateLeaveDtoBuilder()..update(updates))._build();

  _$CreateLeaveDto._(
      {this.clientUuid,
      required this.leaveType,
      required this.fromDate,
      required this.toDate,
      this.reason})
      : super._();
  @override
  CreateLeaveDto rebuild(void Function(CreateLeaveDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateLeaveDtoBuilder toBuilder() => CreateLeaveDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateLeaveDto &&
        clientUuid == other.clientUuid &&
        leaveType == other.leaveType &&
        fromDate == other.fromDate &&
        toDate == other.toDate &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, clientUuid.hashCode);
    _$hash = $jc(_$hash, leaveType.hashCode);
    _$hash = $jc(_$hash, fromDate.hashCode);
    _$hash = $jc(_$hash, toDate.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateLeaveDto')
          ..add('clientUuid', clientUuid)
          ..add('leaveType', leaveType)
          ..add('fromDate', fromDate)
          ..add('toDate', toDate)
          ..add('reason', reason))
        .toString();
  }
}

class CreateLeaveDtoBuilder
    implements Builder<CreateLeaveDto, CreateLeaveDtoBuilder> {
  _$CreateLeaveDto? _$v;

  String? _clientUuid;
  String? get clientUuid => _$this._clientUuid;
  set clientUuid(String? clientUuid) => _$this._clientUuid = clientUuid;

  CreateLeaveDtoLeaveTypeEnum? _leaveType;
  CreateLeaveDtoLeaveTypeEnum? get leaveType => _$this._leaveType;
  set leaveType(CreateLeaveDtoLeaveTypeEnum? leaveType) =>
      _$this._leaveType = leaveType;

  String? _fromDate;
  String? get fromDate => _$this._fromDate;
  set fromDate(String? fromDate) => _$this._fromDate = fromDate;

  String? _toDate;
  String? get toDate => _$this._toDate;
  set toDate(String? toDate) => _$this._toDate = toDate;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  CreateLeaveDtoBuilder() {
    CreateLeaveDto._defaults(this);
  }

  CreateLeaveDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _clientUuid = $v.clientUuid;
      _leaveType = $v.leaveType;
      _fromDate = $v.fromDate;
      _toDate = $v.toDate;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateLeaveDto other) {
    _$v = other as _$CreateLeaveDto;
  }

  @override
  void update(void Function(CreateLeaveDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateLeaveDto build() => _build();

  _$CreateLeaveDto _build() {
    final _$result = _$v ??
        _$CreateLeaveDto._(
          clientUuid: clientUuid,
          leaveType: BuiltValueNullFieldError.checkNotNull(
              leaveType, r'CreateLeaveDto', 'leaveType'),
          fromDate: BuiltValueNullFieldError.checkNotNull(
              fromDate, r'CreateLeaveDto', 'fromDate'),
          toDate: BuiltValueNullFieldError.checkNotNull(
              toDate, r'CreateLeaveDto', 'toDate'),
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
