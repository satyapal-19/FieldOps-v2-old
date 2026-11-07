//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'respond_spot_check_dto.g.dart';

/// RespondSpotCheckDto
///
/// Properties:
/// * [clientUuid] - Retry-safe: the same one answers once
/// * [challengeId] - From POST /attendance/challenges
/// * [latitude] 
/// * [longitude] 
/// * [accuracyM] - GPS accuracy, metres
/// * [faceImageBase64] - JPEG face crop (FACE_PROVIDER=local)
/// * [aadhaarPidXml] - Aadhaar FaceRD PID block (FACE_PROVIDER=aadhaar)
/// * [aadhaarTxn] 
@BuiltValue()
abstract class RespondSpotCheckDto implements Built<RespondSpotCheckDto, RespondSpotCheckDtoBuilder> {
  /// Retry-safe: the same one answers once
  @BuiltValueField(wireName: r'clientUuid')
  String get clientUuid;

  /// From POST /attendance/challenges
  @BuiltValueField(wireName: r'challengeId')
  String get challengeId;

  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  /// GPS accuracy, metres
  @BuiltValueField(wireName: r'accuracyM')
  num get accuracyM;

  /// JPEG face crop (FACE_PROVIDER=local)
  @BuiltValueField(wireName: r'faceImageBase64')
  String? get faceImageBase64;

  /// Aadhaar FaceRD PID block (FACE_PROVIDER=aadhaar)
  @BuiltValueField(wireName: r'aadhaarPidXml')
  String? get aadhaarPidXml;

  @BuiltValueField(wireName: r'aadhaarTxn')
  String? get aadhaarTxn;

  RespondSpotCheckDto._();

  factory RespondSpotCheckDto([void updates(RespondSpotCheckDtoBuilder b)]) = _$RespondSpotCheckDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RespondSpotCheckDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RespondSpotCheckDto> get serializer => _$RespondSpotCheckDtoSerializer();
}

class _$RespondSpotCheckDtoSerializer implements PrimitiveSerializer<RespondSpotCheckDto> {
  @override
  final Iterable<Type> types = const [RespondSpotCheckDto, _$RespondSpotCheckDto];

  @override
  final String wireName = r'RespondSpotCheckDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RespondSpotCheckDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'clientUuid';
    yield serializers.serialize(
      object.clientUuid,
      specifiedType: const FullType(String),
    );
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
    RespondSpotCheckDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RespondSpotCheckDtoBuilder result,
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
  RespondSpotCheckDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RespondSpotCheckDtoBuilder();
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

