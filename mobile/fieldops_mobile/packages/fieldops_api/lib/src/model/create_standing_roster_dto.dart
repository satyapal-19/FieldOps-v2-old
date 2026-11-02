//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_standing_roster_dto.g.dart';

/// CreateStandingRosterDto
///
/// Properties:
/// * [workerId] - An active WORKER
/// * [inspectorId] - An active INSPECTOR of the same home ward
@BuiltValue()
abstract class CreateStandingRosterDto implements Built<CreateStandingRosterDto, CreateStandingRosterDtoBuilder> {
  /// An active WORKER
  @BuiltValueField(wireName: r'workerId')
  String get workerId;

  /// An active INSPECTOR of the same home ward
  @BuiltValueField(wireName: r'inspectorId')
  String get inspectorId;

  CreateStandingRosterDto._();

  factory CreateStandingRosterDto([void updates(CreateStandingRosterDtoBuilder b)]) = _$CreateStandingRosterDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateStandingRosterDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateStandingRosterDto> get serializer => _$CreateStandingRosterDtoSerializer();
}

class _$CreateStandingRosterDtoSerializer implements PrimitiveSerializer<CreateStandingRosterDto> {
  @override
  final Iterable<Type> types = const [CreateStandingRosterDto, _$CreateStandingRosterDto];

  @override
  final String wireName = r'CreateStandingRosterDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateStandingRosterDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'workerId';
    yield serializers.serialize(
      object.workerId,
      specifiedType: const FullType(String),
    );
    yield r'inspectorId';
    yield serializers.serialize(
      object.inspectorId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateStandingRosterDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateStandingRosterDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'workerId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.workerId = valueDes;
          break;
        case r'inspectorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.inspectorId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateStandingRosterDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateStandingRosterDtoBuilder();
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

