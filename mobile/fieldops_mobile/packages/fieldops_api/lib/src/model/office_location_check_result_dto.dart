//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'office_location_check_result_dto.g.dart';

/// OfficeLocationCheckResultDto
///
/// Properties:
/// * [officeId] 
/// * [inside] 
/// * [withinTolerance] - Inside, or within the office buffer
/// * [distanceToEdgeMeters] 
/// * [bufferMeters] 
@BuiltValue()
abstract class OfficeLocationCheckResultDto implements Built<OfficeLocationCheckResultDto, OfficeLocationCheckResultDtoBuilder> {
  @BuiltValueField(wireName: r'officeId')
  String get officeId;

  @BuiltValueField(wireName: r'inside')
  bool get inside;

  /// Inside, or within the office buffer
  @BuiltValueField(wireName: r'withinTolerance')
  bool get withinTolerance;

  @BuiltValueField(wireName: r'distanceToEdgeMeters')
  num get distanceToEdgeMeters;

  @BuiltValueField(wireName: r'bufferMeters')
  num get bufferMeters;

  OfficeLocationCheckResultDto._();

  factory OfficeLocationCheckResultDto([void updates(OfficeLocationCheckResultDtoBuilder b)]) = _$OfficeLocationCheckResultDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OfficeLocationCheckResultDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OfficeLocationCheckResultDto> get serializer => _$OfficeLocationCheckResultDtoSerializer();
}

class _$OfficeLocationCheckResultDtoSerializer implements PrimitiveSerializer<OfficeLocationCheckResultDto> {
  @override
  final Iterable<Type> types = const [OfficeLocationCheckResultDto, _$OfficeLocationCheckResultDto];

  @override
  final String wireName = r'OfficeLocationCheckResultDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OfficeLocationCheckResultDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'officeId';
    yield serializers.serialize(
      object.officeId,
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
    yield r'bufferMeters';
    yield serializers.serialize(
      object.bufferMeters,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OfficeLocationCheckResultDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OfficeLocationCheckResultDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'officeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.officeId = valueDes;
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
        case r'bufferMeters':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.bufferMeters = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OfficeLocationCheckResultDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OfficeLocationCheckResultDtoBuilder();
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

