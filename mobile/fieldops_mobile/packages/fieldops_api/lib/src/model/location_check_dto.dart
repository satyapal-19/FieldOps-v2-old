//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'location_check_dto.g.dart';

/// LocationCheckDto
///
/// Properties:
/// * [latitude] 
/// * [longitude] 
@BuiltValue()
abstract class LocationCheckDto implements Built<LocationCheckDto, LocationCheckDtoBuilder> {
  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  LocationCheckDto._();

  factory LocationCheckDto([void updates(LocationCheckDtoBuilder b)]) = _$LocationCheckDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LocationCheckDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LocationCheckDto> get serializer => _$LocationCheckDtoSerializer();
}

class _$LocationCheckDtoSerializer implements PrimitiveSerializer<LocationCheckDto> {
  @override
  final Iterable<Type> types = const [LocationCheckDto, _$LocationCheckDto];

  @override
  final String wireName = r'LocationCheckDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LocationCheckDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    LocationCheckDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LocationCheckDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LocationCheckDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LocationCheckDtoBuilder();
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

