//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_punch_dto.g.dart';

/// CreatePunchDto
///
/// Properties:
/// * [clientUuid] - Idempotency key from the phone outbox; a retry returns the same result
/// * [type] 
/// * [staffId] - Omit for yourself; set for a proxy punch
/// * [challengeId] - From POST /attendance/challenges
/// * [latitude] 
/// * [longitude] 
/// * [accuracyM] - GPS accuracy in metres (field ≤ 25, office ≤ 100)
/// * [presenceCode] - Proxy punch: the worker's rolling code scanned from their phone (co-presence)
/// * [isMocked] - The phone reported a mock location (recorded, flagged)
/// * [faceImageBase64] - Local face provider: base64 JPEG face crop (≤ 96000 chars); never stored
/// * [aadhaarPidXml] - Aadhaar face provider: PidData XML from FaceRD
/// * [aadhaarTxn] - Aadhaar face provider: the txn from capture-options
@BuiltValue()
abstract class CreatePunchDto implements Built<CreatePunchDto, CreatePunchDtoBuilder> {
  /// Idempotency key from the phone outbox; a retry returns the same result
  @BuiltValueField(wireName: r'clientUuid')
  String get clientUuid;

  @BuiltValueField(wireName: r'type')
  CreatePunchDtoTypeEnum get type;
  // enum typeEnum {  CHECK_IN,  CHECK_OUT,  };

  /// Omit for yourself; set for a proxy punch
  @BuiltValueField(wireName: r'staffId')
  String? get staffId;

  /// From POST /attendance/challenges
  @BuiltValueField(wireName: r'challengeId')
  String get challengeId;

  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  /// GPS accuracy in metres (field ≤ 25, office ≤ 100)
  @BuiltValueField(wireName: r'accuracyM')
  num get accuracyM;

  /// Proxy punch: the worker's rolling code scanned from their phone (co-presence)
  @BuiltValueField(wireName: r'presenceCode')
  String? get presenceCode;

  /// The phone reported a mock location (recorded, flagged)
  @BuiltValueField(wireName: r'isMocked')
  bool? get isMocked;

  /// Local face provider: base64 JPEG face crop (≤ 96000 chars); never stored
  @BuiltValueField(wireName: r'faceImageBase64')
  String? get faceImageBase64;

  /// Aadhaar face provider: PidData XML from FaceRD
  @BuiltValueField(wireName: r'aadhaarPidXml')
  String? get aadhaarPidXml;

  /// Aadhaar face provider: the txn from capture-options
  @BuiltValueField(wireName: r'aadhaarTxn')
  String? get aadhaarTxn;

  CreatePunchDto._();

  factory CreatePunchDto([void updates(CreatePunchDtoBuilder b)]) = _$CreatePunchDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreatePunchDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreatePunchDto> get serializer => _$CreatePunchDtoSerializer();
}

class _$CreatePunchDtoSerializer implements PrimitiveSerializer<CreatePunchDto> {
  @override
  final Iterable<Type> types = const [CreatePunchDto, _$CreatePunchDto];

  @override
  final String wireName = r'CreatePunchDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreatePunchDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'clientUuid';
    yield serializers.serialize(
      object.clientUuid,
      specifiedType: const FullType(String),
    );
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(CreatePunchDtoTypeEnum),
    );
    if (object.staffId != null) {
      yield r'staffId';
      yield serializers.serialize(
        object.staffId,
        specifiedType: const FullType(String),
      );
    }
    yield r'challengeId';
    yield serializers.serialize(
      object.challengeId,
      specifiedType: const FullType(String),
    );
    yield r'latitude';
    yield serializers.serialize(
      object.latitude,
      specifiedType: const FullType(num),
    );
    yield r'longitude';
    yield serializers.serialize(
      object.longitude,
      specifiedType: const FullType(num),
    );
    yield r'accuracyM';
    yield serializers.serialize(
      object.accuracyM,
      specifiedType: const FullType(num),
    );
    if (object.presenceCode != null) {
      yield r'presenceCode';
      yield serializers.serialize(
        object.presenceCode,
        specifiedType: const FullType(String),
      );
    }
    if (object.isMocked != null) {
      yield r'isMocked';
      yield serializers.serialize(
        object.isMocked,
        specifiedType: const FullType(bool),
      );
    }
    if (object.faceImageBase64 != null) {
      yield r'faceImageBase64';
      yield serializers.serialize(
        object.faceImageBase64,
        specifiedType: const FullType(String),
      );
    }
    if (object.aadhaarPidXml != null) {
      yield r'aadhaarPidXml';
      yield serializers.serialize(
        object.aadhaarPidXml,
        specifiedType: const FullType(String),
      );
    }
    if (object.aadhaarTxn != null) {
      yield r'aadhaarTxn';
      yield serializers.serialize(
        object.aadhaarTxn,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreatePunchDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreatePunchDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'clientUuid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.clientUuid = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CreatePunchDtoTypeEnum),
          ) as CreatePunchDtoTypeEnum;
          result.type = valueDes;
          break;
        case r'staffId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.staffId = valueDes;
          break;
        case r'challengeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.challengeId = valueDes;
          break;
        case r'latitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.longitude = valueDes;
          break;
        case r'accuracyM':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.accuracyM = valueDes;
          break;
        case r'presenceCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.presenceCode = valueDes;
          break;
        case r'isMocked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isMocked = valueDes;
          break;
        case r'faceImageBase64':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.faceImageBase64 = valueDes;
          break;
        case r'aadhaarPidXml':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.aadhaarPidXml = valueDes;
          break;
        case r'aadhaarTxn':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.aadhaarTxn = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreatePunchDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreatePunchDtoBuilder();
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

class CreatePunchDtoTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'CHECK_IN')
  static const CreatePunchDtoTypeEnum IN = _$createPunchDtoTypeEnum_IN;
  @BuiltValueEnumConst(wireName: r'CHECK_OUT')
  static const CreatePunchDtoTypeEnum OUT = _$createPunchDtoTypeEnum_OUT;

  static Serializer<CreatePunchDtoTypeEnum> get serializer => _$createPunchDtoTypeEnumSerializer;

  const CreatePunchDtoTypeEnum._(String name): super(name);

  static BuiltSet<CreatePunchDtoTypeEnum> get values => _$createPunchDtoTypeEnumValues;
  static CreatePunchDtoTypeEnum valueOf(String name) => _$createPunchDtoTypeEnumValueOf(name);
}

