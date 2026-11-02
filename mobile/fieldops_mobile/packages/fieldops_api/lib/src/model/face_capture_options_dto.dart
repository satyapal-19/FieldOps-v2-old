//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'face_capture_options_dto.g.dart';

/// FaceCaptureOptionsDto
///
/// Properties:
/// * [provider] 
/// * [instructions] 
/// * [txn] - Aadhaar only: transaction ID to echo back
/// * [pidOptionsXml] - Aadhaar only: PidOptions XML for the FaceRD intent extra \"request\"
/// * [intentAction] 
@BuiltValue()
abstract class FaceCaptureOptionsDto implements Built<FaceCaptureOptionsDto, FaceCaptureOptionsDtoBuilder> {
  @BuiltValueField(wireName: r'provider')
  FaceCaptureOptionsDtoProviderEnum get provider;
  // enum providerEnum {  local,  aadhaar,  };

  @BuiltValueField(wireName: r'instructions')
  FaceCaptureOptionsDtoInstructionsEnum get instructions;
  // enum instructionsEnum {  ML_KIT_LIVENESS_THEN_UPLOAD_CROP,  LAUNCH_FACERD,  };

  /// Aadhaar only: transaction ID to echo back
  @BuiltValueField(wireName: r'txn')
  String? get txn;

  /// Aadhaar only: PidOptions XML for the FaceRD intent extra \"request\"
  @BuiltValueField(wireName: r'pidOptionsXml')
  String? get pidOptionsXml;

  @BuiltValueField(wireName: r'intentAction')
  String? get intentAction;

  FaceCaptureOptionsDto._();

  factory FaceCaptureOptionsDto([void updates(FaceCaptureOptionsDtoBuilder b)]) = _$FaceCaptureOptionsDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FaceCaptureOptionsDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FaceCaptureOptionsDto> get serializer => _$FaceCaptureOptionsDtoSerializer();
}

class _$FaceCaptureOptionsDtoSerializer implements PrimitiveSerializer<FaceCaptureOptionsDto> {
  @override
  final Iterable<Type> types = const [FaceCaptureOptionsDto, _$FaceCaptureOptionsDto];

  @override
  final String wireName = r'FaceCaptureOptionsDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FaceCaptureOptionsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'provider';
    yield serializers.serialize(
      object.provider,
      specifiedType: const FullType(FaceCaptureOptionsDtoProviderEnum),
    );
    yield r'instructions';
    yield serializers.serialize(
      object.instructions,
      specifiedType: const FullType(FaceCaptureOptionsDtoInstructionsEnum),
    );
    if (object.txn != null) {
      yield r'txn';
      yield serializers.serialize(
        object.txn,
        specifiedType: const FullType(String),
      );
    }
    if (object.pidOptionsXml != null) {
      yield r'pidOptionsXml';
      yield serializers.serialize(
        object.pidOptionsXml,
        specifiedType: const FullType(String),
      );
    }
    if (object.intentAction != null) {
      yield r'intentAction';
      yield serializers.serialize(
        object.intentAction,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    FaceCaptureOptionsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FaceCaptureOptionsDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FaceCaptureOptionsDtoProviderEnum),
          ) as FaceCaptureOptionsDtoProviderEnum;
          result.provider = valueDes;
          break;
        case r'instructions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FaceCaptureOptionsDtoInstructionsEnum),
          ) as FaceCaptureOptionsDtoInstructionsEnum;
          result.instructions = valueDes;
          break;
        case r'txn':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.txn = valueDes;
          break;
        case r'pidOptionsXml':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.pidOptionsXml = valueDes;
          break;
        case r'intentAction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.intentAction = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FaceCaptureOptionsDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FaceCaptureOptionsDtoBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

class FaceCaptureOptionsDtoProviderEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'local')
  static const FaceCaptureOptionsDtoProviderEnum local = _$faceCaptureOptionsDtoProviderEnum_local;
  @BuiltValueEnumConst(wireName: r'aadhaar')
  static const FaceCaptureOptionsDtoProviderEnum aadhaar = _$faceCaptureOptionsDtoProviderEnum_aadhaar;

  static Serializer<FaceCaptureOptionsDtoProviderEnum> get serializer => _$faceCaptureOptionsDtoProviderEnumSerializer;

  const FaceCaptureOptionsDtoProviderEnum._(String name): super(name);

  static BuiltSet<FaceCaptureOptionsDtoProviderEnum> get values => _$faceCaptureOptionsDtoProviderEnumValues;
  static FaceCaptureOptionsDtoProviderEnum valueOf(String name) => _$faceCaptureOptionsDtoProviderEnumValueOf(name);
}

class FaceCaptureOptionsDtoInstructionsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ML_KIT_LIVENESS_THEN_UPLOAD_CROP')
  static const FaceCaptureOptionsDtoInstructionsEnum ML_KIT_LIVENESS_THEN_UPLOAD_CROP = _$faceCaptureOptionsDtoInstructionsEnum_ML_KIT_LIVENESS_THEN_UPLOAD_CROP;
  @BuiltValueEnumConst(wireName: r'LAUNCH_FACERD')
  static const FaceCaptureOptionsDtoInstructionsEnum LAUNCH_FACERD = _$faceCaptureOptionsDtoInstructionsEnum_LAUNCH_FACERD;

  static Serializer<FaceCaptureOptionsDtoInstructionsEnum> get serializer => _$faceCaptureOptionsDtoInstructionsEnumSerializer;

  const FaceCaptureOptionsDtoInstructionsEnum._(String name): super(name);

  static BuiltSet<FaceCaptureOptionsDtoInstructionsEnum> get values => _$faceCaptureOptionsDtoInstructionsEnumValues;
  static FaceCaptureOptionsDtoInstructionsEnum valueOf(String name) => _$faceCaptureOptionsDtoInstructionsEnumValueOf(name);
}

