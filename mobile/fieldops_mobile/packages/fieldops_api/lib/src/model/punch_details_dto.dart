//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'punch_details_dto.g.dart';

/// PunchDetailsDto
///
/// Properties:
/// * [at] - Server time (UTC)
/// * [latitude] 
/// * [longitude] 
/// * [accuracyM] 
/// * [inGeofence] 
/// * [mode] 
/// * [markedById] 
@BuiltValue()
abstract class PunchDetailsDto implements Built<PunchDetailsDto, PunchDetailsDtoBuilder> {
  /// Server time (UTC)
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  @BuiltValueField(wireName: r'accuracyM')
  num? get accuracyM;

  @BuiltValueField(wireName: r'inGeofence')
  bool? get inGeofence;

  @BuiltValueField(wireName: r'mode')
  PunchDetailsDtoModeEnum? get mode;
  // enum modeEnum {  SELF,  INSPECTOR_PROXY,  ADMIN_PROXY,  };

  @BuiltValueField(wireName: r'markedById')
  String? get markedById;

  PunchDetailsDto._();

  factory PunchDetailsDto([void updates(PunchDetailsDtoBuilder b)]) = _$PunchDetailsDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PunchDetailsDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PunchDetailsDto> get serializer => _$PunchDetailsDtoSerializer();
}

class _$PunchDetailsDtoSerializer implements PrimitiveSerializer<PunchDetailsDto> {
  @override
  final Iterable<Type> types = const [PunchDetailsDto, _$PunchDetailsDto];

  @override
  final String wireName = r'PunchDetailsDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PunchDetailsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
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
    yield object.accuracyM == null ? null : serializers.serialize(
      object.accuracyM,
      specifiedType: const FullType.nullable(num),
    );
    yield r'inGeofence';
    yield object.inGeofence == null ? null : serializers.serialize(
      object.inGeofence,
      specifiedType: const FullType.nullable(bool),
    );
    yield r'mode';
    yield object.mode == null ? null : serializers.serialize(
      object.mode,
      specifiedType: const FullType.nullable(PunchDetailsDtoModeEnum),
    );
    yield r'markedById';
    yield object.markedById == null ? null : serializers.serialize(
      object.markedById,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PunchDetailsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PunchDetailsDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.at = valueDes;
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
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.accuracyM = valueDes;
          break;
        case r'inGeofence':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.inGeofence = valueDes;
          break;
        case r'mode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(PunchDetailsDtoModeEnum),
          ) as PunchDetailsDtoModeEnum?;
          if (valueDes == null) continue;
          result.mode = valueDes;
          break;
        case r'markedById':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.markedById = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PunchDetailsDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PunchDetailsDtoBuilder();
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

class PunchDetailsDtoModeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SELF')
  static const PunchDetailsDtoModeEnum SELF = _$punchDetailsDtoModeEnum_SELF;
  @BuiltValueEnumConst(wireName: r'INSPECTOR_PROXY')
  static const PunchDetailsDtoModeEnum INSPECTOR_PROXY = _$punchDetailsDtoModeEnum_INSPECTOR_PROXY;
  @BuiltValueEnumConst(wireName: r'ADMIN_PROXY')
  static const PunchDetailsDtoModeEnum ADMIN_PROXY = _$punchDetailsDtoModeEnum_ADMIN_PROXY;

  static Serializer<PunchDetailsDtoModeEnum> get serializer => _$punchDetailsDtoModeEnumSerializer;

  const PunchDetailsDtoModeEnum._(String name): super(name);

  static BuiltSet<PunchDetailsDtoModeEnum> get values => _$punchDetailsDtoModeEnumValues;
  static PunchDetailsDtoModeEnum valueOf(String name) => _$punchDetailsDtoModeEnumValueOf(name);
}

