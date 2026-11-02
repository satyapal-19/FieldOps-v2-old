//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'health_dto.g.dart';

/// HealthDto
///
/// Properties:
/// * [status] 
/// * [environment] 
/// * [version] 
/// * [uptimeSeconds] 
/// * [time] 
@BuiltValue()
abstract class HealthDto implements Built<HealthDto, HealthDtoBuilder> {
  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'environment')
  String get environment;

  @BuiltValueField(wireName: r'version')
  String get version;

  @BuiltValueField(wireName: r'uptimeSeconds')
  num get uptimeSeconds;

  @BuiltValueField(wireName: r'time')
  String get time;

  HealthDto._();

  factory HealthDto([void updates(HealthDtoBuilder b)]) = _$HealthDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(HealthDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<HealthDto> get serializer => _$HealthDtoSerializer();
}

class _$HealthDtoSerializer implements PrimitiveSerializer<HealthDto> {
  @override
  final Iterable<Type> types = const [HealthDto, _$HealthDto];

  @override
  final String wireName = r'HealthDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    HealthDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    yield r'environment';
    yield serializers.serialize(
      object.environment,
      specifiedType: const FullType(String),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(String),
    );
    yield r'uptimeSeconds';
    yield serializers.serialize(
      object.uptimeSeconds,
      specifiedType: const FullType(num),
    );
    yield r'time';
    yield serializers.serialize(
      object.time,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    HealthDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required HealthDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'environment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.environment = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.version = valueDes;
          break;
        case r'uptimeSeconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.uptimeSeconds = valueDes;
          break;
        case r'time':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.time = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  HealthDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = HealthDtoBuilder();
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

