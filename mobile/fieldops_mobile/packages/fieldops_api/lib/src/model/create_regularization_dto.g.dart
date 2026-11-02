// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_regularization_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreateRegularizationDtoReasonTypeEnum
    _$createRegularizationDtoReasonTypeEnum_BATTERY_DEAD =
    const CreateRegularizationDtoReasonTypeEnum._('BATTERY_DEAD');
const CreateRegularizationDtoReasonTypeEnum
    _$createRegularizationDtoReasonTypeEnum_APP_CRASH =
    const CreateRegularizationDtoReasonTypeEnum._('APP_CRASH');
const CreateRegularizationDtoReasonTypeEnum
    _$createRegularizationDtoReasonTypeEnum_FIELD_RESCUE_DUTY =
    const CreateRegularizationDtoReasonTypeEnum._('FIELD_RESCUE_DUTY');
const CreateRegularizationDtoReasonTypeEnum
    _$createRegularizationDtoReasonTypeEnum_OUT_OF_NETWORK =
    const CreateRegularizationDtoReasonTypeEnum._('OUT_OF_NETWORK');
const CreateRegularizationDtoReasonTypeEnum
    _$createRegularizationDtoReasonTypeEnum_OTHER =
    const CreateRegularizationDtoReasonTypeEnum._('OTHER');

CreateRegularizationDtoReasonTypeEnum
    _$createRegularizationDtoReasonTypeEnumValueOf(String name) {
  switch (name) {
    case 'BATTERY_DEAD':
      return _$createRegularizationDtoReasonTypeEnum_BATTERY_DEAD;
    case 'APP_CRASH':
      return _$createRegularizationDtoReasonTypeEnum_APP_CRASH;
    case 'FIELD_RESCUE_DUTY':
      return _$createRegularizationDtoReasonTypeEnum_FIELD_RESCUE_DUTY;
    case 'OUT_OF_NETWORK':
      return _$createRegularizationDtoReasonTypeEnum_OUT_OF_NETWORK;
    case 'OTHER':
      return _$createRegularizationDtoReasonTypeEnum_OTHER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CreateRegularizationDtoReasonTypeEnum>
    _$createRegularizationDtoReasonTypeEnumValues = BuiltSet<
        CreateRegularizationDtoReasonTypeEnum>(const <CreateRegularizationDtoReasonTypeEnum>[
  _$createRegularizationDtoReasonTypeEnum_BATTERY_DEAD,
  _$createRegularizationDtoReasonTypeEnum_APP_CRASH,
  _$createRegularizationDtoReasonTypeEnum_FIELD_RESCUE_DUTY,
  _$createRegularizationDtoReasonTypeEnum_OUT_OF_NETWORK,
  _$createRegularizationDtoReasonTypeEnum_OTHER,
]);

Serializer<CreateRegularizationDtoReasonTypeEnum>
    _$createRegularizationDtoReasonTypeEnumSerializer =
    _$CreateRegularizationDtoReasonTypeEnumSerializer();

class _$CreateRegularizationDtoReasonTypeEnumSerializer
    implements PrimitiveSerializer<CreateRegularizationDtoReasonTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BATTERY_DEAD': 'BATTERY_DEAD',
    'APP_CRASH': 'APP_CRASH',
    'FIELD_RESCUE_DUTY': 'FIELD_RESCUE_DUTY',
    'OUT_OF_NETWORK': 'OUT_OF_NETWORK',
    'OTHER': 'OTHER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BATTERY_DEAD': 'BATTERY_DEAD',
    'APP_CRASH': 'APP_CRASH',
    'FIELD_RESCUE_DUTY': 'FIELD_RESCUE_DUTY',
    'OUT_OF_NETWORK': 'OUT_OF_NETWORK',
    'OTHER': 'OTHER',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CreateRegularizationDtoReasonTypeEnum
  ];
  @override
  final String wireName = 'CreateRegularizationDtoReasonTypeEnum';

  @override
  Object serialize(
          Serializers serializers, CreateRegularizationDtoReasonTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreateRegularizationDtoReasonTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreateRegularizationDtoReasonTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreateRegularizationDto extends CreateRegularizationDto {
  @override
  final String? clientUuid;
  @override
  final String attendanceDate;
  @override
  final CreateRegularizationDtoReasonTypeEnum reasonType;
  @override
  final String explanation;

  factory _$CreateRegularizationDto(
          [void Function(CreateRegularizationDtoBuilder)? updates]) =>
      (CreateRegularizationDtoBuilder()..update(updates))._build();

  _$CreateRegularizationDto._(
      {this.clientUuid,
      required this.attendanceDate,
      required this.reasonType,
      required this.explanation})
      : super._();
  @override
  CreateRegularizationDto rebuild(
          void Function(CreateRegularizationDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateRegularizationDtoBuilder toBuilder() =>
      CreateRegularizationDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateRegularizationDto &&
        clientUuid == other.clientUuid &&
        attendanceDate == other.attendanceDate &&
        reasonType == other.reasonType &&
        explanation == other.explanation;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, clientUuid.hashCode);
    _$hash = $jc(_$hash, attendanceDate.hashCode);
    _$hash = $jc(_$hash, reasonType.hashCode);
    _$hash = $jc(_$hash, explanation.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateRegularizationDto')
          ..add('clientUuid', clientUuid)
          ..add('attendanceDate', attendanceDate)
          ..add('reasonType', reasonType)
          ..add('explanation', explanation))
        .toString();
  }
}

class CreateRegularizationDtoBuilder
    implements
        Builder<CreateRegularizationDto, CreateRegularizationDtoBuilder> {
  _$CreateRegularizationDto? _$v;

  String? _clientUuid;
  String? get clientUuid => _$this._clientUuid;
  set clientUuid(String? clientUuid) => _$this._clientUuid = clientUuid;

  String? _attendanceDate;
  String? get attendanceDate => _$this._attendanceDate;
  set attendanceDate(String? attendanceDate) =>
      _$this._attendanceDate = attendanceDate;

  CreateRegularizationDtoReasonTypeEnum? _reasonType;
  CreateRegularizationDtoReasonTypeEnum? get reasonType => _$this._reasonType;
  set reasonType(CreateRegularizationDtoReasonTypeEnum? reasonType) =>
      _$this._reasonType = reasonType;

  String? _explanation;
  String? get explanation => _$this._explanation;
  set explanation(String? explanation) => _$this._explanation = explanation;

  CreateRegularizationDtoBuilder() {
    CreateRegularizationDto._defaults(this);
  }

  CreateRegularizationDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _clientUuid = $v.clientUuid;
      _attendanceDate = $v.attendanceDate;
      _reasonType = $v.reasonType;
      _explanation = $v.explanation;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateRegularizationDto other) {
    _$v = other as _$CreateRegularizationDto;
  }

  @override
  void update(void Function(CreateRegularizationDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateRegularizationDto build() => _build();

  _$CreateRegularizationDto _build() {
    final _$result = _$v ??
        _$CreateRegularizationDto._(
          clientUuid: clientUuid,
          attendanceDate: BuiltValueNullFieldError.checkNotNull(
              attendanceDate, r'CreateRegularizationDto', 'attendanceDate'),
          reasonType: BuiltValueNullFieldError.checkNotNull(
              reasonType, r'CreateRegularizationDto', 'reasonType'),
          explanation: BuiltValueNullFieldError.checkNotNull(
              explanation, r'CreateRegularizationDto', 'explanation'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
