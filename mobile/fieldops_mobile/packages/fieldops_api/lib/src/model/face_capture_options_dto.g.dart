// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'face_capture_options_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FaceCaptureOptionsDtoProviderEnum
    _$faceCaptureOptionsDtoProviderEnum_local =
    const FaceCaptureOptionsDtoProviderEnum._('local');
const FaceCaptureOptionsDtoProviderEnum
    _$faceCaptureOptionsDtoProviderEnum_aadhaar =
    const FaceCaptureOptionsDtoProviderEnum._('aadhaar');

FaceCaptureOptionsDtoProviderEnum _$faceCaptureOptionsDtoProviderEnumValueOf(
    String name) {
  switch (name) {
    case 'local':
      return _$faceCaptureOptionsDtoProviderEnum_local;
    case 'aadhaar':
      return _$faceCaptureOptionsDtoProviderEnum_aadhaar;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FaceCaptureOptionsDtoProviderEnum>
    _$faceCaptureOptionsDtoProviderEnumValues = BuiltSet<
        FaceCaptureOptionsDtoProviderEnum>(const <FaceCaptureOptionsDtoProviderEnum>[
  _$faceCaptureOptionsDtoProviderEnum_local,
  _$faceCaptureOptionsDtoProviderEnum_aadhaar,
]);

const FaceCaptureOptionsDtoInstructionsEnum
    _$faceCaptureOptionsDtoInstructionsEnum_ML_KIT_LIVENESS_THEN_UPLOAD_CROP =
    const FaceCaptureOptionsDtoInstructionsEnum._(
        'ML_KIT_LIVENESS_THEN_UPLOAD_CROP');
const FaceCaptureOptionsDtoInstructionsEnum
    _$faceCaptureOptionsDtoInstructionsEnum_LAUNCH_FACERD =
    const FaceCaptureOptionsDtoInstructionsEnum._('LAUNCH_FACERD');

FaceCaptureOptionsDtoInstructionsEnum
    _$faceCaptureOptionsDtoInstructionsEnumValueOf(String name) {
  switch (name) {
    case 'ML_KIT_LIVENESS_THEN_UPLOAD_CROP':
      return _$faceCaptureOptionsDtoInstructionsEnum_ML_KIT_LIVENESS_THEN_UPLOAD_CROP;
    case 'LAUNCH_FACERD':
      return _$faceCaptureOptionsDtoInstructionsEnum_LAUNCH_FACERD;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FaceCaptureOptionsDtoInstructionsEnum>
    _$faceCaptureOptionsDtoInstructionsEnumValues = BuiltSet<
        FaceCaptureOptionsDtoInstructionsEnum>(const <FaceCaptureOptionsDtoInstructionsEnum>[
  _$faceCaptureOptionsDtoInstructionsEnum_ML_KIT_LIVENESS_THEN_UPLOAD_CROP,
  _$faceCaptureOptionsDtoInstructionsEnum_LAUNCH_FACERD,
]);

Serializer<FaceCaptureOptionsDtoProviderEnum>
    _$faceCaptureOptionsDtoProviderEnumSerializer =
    _$FaceCaptureOptionsDtoProviderEnumSerializer();
Serializer<FaceCaptureOptionsDtoInstructionsEnum>
    _$faceCaptureOptionsDtoInstructionsEnumSerializer =
    _$FaceCaptureOptionsDtoInstructionsEnumSerializer();

class _$FaceCaptureOptionsDtoProviderEnumSerializer
    implements PrimitiveSerializer<FaceCaptureOptionsDtoProviderEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'local': 'local',
    'aadhaar': 'aadhaar',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'local': 'local',
    'aadhaar': 'aadhaar',
  };

  @override
  final Iterable<Type> types = const <Type>[FaceCaptureOptionsDtoProviderEnum];
  @override
  final String wireName = 'FaceCaptureOptionsDtoProviderEnum';

  @override
  Object serialize(
          Serializers serializers, FaceCaptureOptionsDtoProviderEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FaceCaptureOptionsDtoProviderEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FaceCaptureOptionsDtoProviderEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FaceCaptureOptionsDtoInstructionsEnumSerializer
    implements PrimitiveSerializer<FaceCaptureOptionsDtoInstructionsEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ML_KIT_LIVENESS_THEN_UPLOAD_CROP': 'ML_KIT_LIVENESS_THEN_UPLOAD_CROP',
    'LAUNCH_FACERD': 'LAUNCH_FACERD',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ML_KIT_LIVENESS_THEN_UPLOAD_CROP': 'ML_KIT_LIVENESS_THEN_UPLOAD_CROP',
    'LAUNCH_FACERD': 'LAUNCH_FACERD',
  };

  @override
  final Iterable<Type> types = const <Type>[
    FaceCaptureOptionsDtoInstructionsEnum
  ];
  @override
  final String wireName = 'FaceCaptureOptionsDtoInstructionsEnum';

  @override
  Object serialize(
          Serializers serializers, FaceCaptureOptionsDtoInstructionsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FaceCaptureOptionsDtoInstructionsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FaceCaptureOptionsDtoInstructionsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FaceCaptureOptionsDto extends FaceCaptureOptionsDto {
  @override
  final FaceCaptureOptionsDtoProviderEnum provider;
  @override
  final FaceCaptureOptionsDtoInstructionsEnum instructions;
  @override
  final String? txn;
  @override
  final String? pidOptionsXml;
  @override
  final String? intentAction;

  factory _$FaceCaptureOptionsDto(
          [void Function(FaceCaptureOptionsDtoBuilder)? updates]) =>
      (FaceCaptureOptionsDtoBuilder()..update(updates))._build();

  _$FaceCaptureOptionsDto._(
      {required this.provider,
      required this.instructions,
      this.txn,
      this.pidOptionsXml,
      this.intentAction})
      : super._();
  @override
  FaceCaptureOptionsDto rebuild(
          void Function(FaceCaptureOptionsDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FaceCaptureOptionsDtoBuilder toBuilder() =>
      FaceCaptureOptionsDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FaceCaptureOptionsDto &&
        provider == other.provider &&
        instructions == other.instructions &&
        txn == other.txn &&
        pidOptionsXml == other.pidOptionsXml &&
        intentAction == other.intentAction;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, provider.hashCode);
    _$hash = $jc(_$hash, instructions.hashCode);
    _$hash = $jc(_$hash, txn.hashCode);
    _$hash = $jc(_$hash, pidOptionsXml.hashCode);
    _$hash = $jc(_$hash, intentAction.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FaceCaptureOptionsDto')
          ..add('provider', provider)
          ..add('instructions', instructions)
          ..add('txn', txn)
          ..add('pidOptionsXml', pidOptionsXml)
          ..add('intentAction', intentAction))
        .toString();
  }
}

class FaceCaptureOptionsDtoBuilder
    implements Builder<FaceCaptureOptionsDto, FaceCaptureOptionsDtoBuilder> {
  _$FaceCaptureOptionsDto? _$v;

  FaceCaptureOptionsDtoProviderEnum? _provider;
  FaceCaptureOptionsDtoProviderEnum? get provider => _$this._provider;
  set provider(FaceCaptureOptionsDtoProviderEnum? provider) =>
      _$this._provider = provider;

  FaceCaptureOptionsDtoInstructionsEnum? _instructions;
  FaceCaptureOptionsDtoInstructionsEnum? get instructions =>
      _$this._instructions;
  set instructions(FaceCaptureOptionsDtoInstructionsEnum? instructions) =>
      _$this._instructions = instructions;

  String? _txn;
  String? get txn => _$this._txn;
  set txn(String? txn) => _$this._txn = txn;

  String? _pidOptionsXml;
  String? get pidOptionsXml => _$this._pidOptionsXml;
  set pidOptionsXml(String? pidOptionsXml) =>
      _$this._pidOptionsXml = pidOptionsXml;

  String? _intentAction;
  String? get intentAction => _$this._intentAction;
  set intentAction(String? intentAction) => _$this._intentAction = intentAction;

  FaceCaptureOptionsDtoBuilder() {
    FaceCaptureOptionsDto._defaults(this);
  }

  FaceCaptureOptionsDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _provider = $v.provider;
      _instructions = $v.instructions;
      _txn = $v.txn;
      _pidOptionsXml = $v.pidOptionsXml;
      _intentAction = $v.intentAction;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FaceCaptureOptionsDto other) {
    _$v = other as _$FaceCaptureOptionsDto;
  }

  @override
  void update(void Function(FaceCaptureOptionsDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FaceCaptureOptionsDto build() => _build();

  _$FaceCaptureOptionsDto _build() {
    final _$result = _$v ??
        _$FaceCaptureOptionsDto._(
          provider: BuiltValueNullFieldError.checkNotNull(
              provider, r'FaceCaptureOptionsDto', 'provider'),
          instructions: BuiltValueNullFieldError.checkNotNull(
              instructions, r'FaceCaptureOptionsDto', 'instructions'),
          txn: txn,
          pidOptionsXml: pidOptionsXml,
          intentAction: intentAction,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
