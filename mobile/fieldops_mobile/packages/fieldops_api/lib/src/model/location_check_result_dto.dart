//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'location_check_result_dto.g.dart';

/// LocationCheckResultDto
///
/// Properties:
/// * [wardId] 
/// * [inside] - Strictly inside the boundary
/// * [withinTolerance] - Inside, or within the 25 m edge allowance
/// * [distanceToEdgeMeters] 
@BuiltValue()
abstract class LocationCheckResultDto implements Built<LocationCheckResultDto, LocationCheckResultDtoBuilder> {
  @BuiltValueField(wireName: r'wardId')
  String get wardId;

  /// Strictly inside the boundary
  @BuiltValueField(wireName: r'inside')
  bool get inside;

  /// Inside, or within the 25 m edge allowance
  @BuiltValueField(wireName: r'withinTolerance')
  bool get withinTolerance;

  @BuiltValueField(wireName: r'distanceToEdgeMeters')
  num get distanceToEdgeMeters;

  LocationCheckResultDto._();

  factory LocationCheckResultDto([void updates(LocationCheckResultDtoBuilder b)]) = _$LocationCheckResultDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LocationCheckResultDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LocationCheckResultDto> get serializer => _$LocationCheckResultDtoSerializer();
}

class _$LocationCheckResultDtoSerializer implements PrimitiveSerializer<LocationCheckResultDto> {
  @override
  final Iterable<Type> types = const [LocationCheckResultDto, _$LocationCheckResultDto];

  @override
  final String wireName = r'LocationCheckResultDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LocationCheckResultDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'wardId';
    yield serializers.serialize(
      object.wardId,
      specifiedType: const FullType(String),
    );
    yield r'inside';
    yield serializers.serialize(
      object.inside,
      specifiedType: const FullType(bool),
    );
    yield r'withinTolerance';
    yield serializers.serialize(
      object.withinTolerance,
      specifiedType: const FullType(bool),
    );
    yield r'distanceToEdgeMeters';
    yield serializers.serialize(
      object.distanceToEdgeMeters,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LocationCheckResultDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LocationCheckResultDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'wardId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.wardId = valueDes;
          break;
        case r'inside':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.inside = valueDes;
          break;
        case r'withinTolerance':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.withinTolerance = valueDes;
          break;
        case r'distanceToEdgeMeters':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.distanceToEdgeMeters = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LocationCheckResultDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LocationCheckResultDtoBuilder();
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

