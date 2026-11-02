//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'standing_roster_dto.g.dart';

/// StandingRosterDto
///
/// Properties:
/// * [id] 
/// * [wardId] 
/// * [wardInspectorId] 
/// * [inspectorId] 
/// * [workerId] 
/// * [isActive] 
/// * [version] 
/// * [createdAt] 
/// * [updatedAt] 
@BuiltValue()
abstract class StandingRosterDto implements Built<StandingRosterDto, StandingRosterDtoBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'wardId')
  String get wardId;

  @BuiltValueField(wireName: r'wardInspectorId')
  String get wardInspectorId;

  @BuiltValueField(wireName: r'inspectorId')
  String get inspectorId;

  @BuiltValueField(wireName: r'workerId')
  String get workerId;

  @BuiltValueField(wireName: r'isActive')
  bool get isActive;

  @BuiltValueField(wireName: r'version')
  num get version;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  StandingRosterDto._();

  factory StandingRosterDto([void updates(StandingRosterDtoBuilder b)]) = _$StandingRosterDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StandingRosterDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StandingRosterDto> get serializer => _$StandingRosterDtoSerializer();
}

class _$StandingRosterDtoSerializer implements PrimitiveSerializer<StandingRosterDto> {
  @override
  final Iterable<Type> types = const [StandingRosterDto, _$StandingRosterDto];

  @override
  final String wireName = r'StandingRosterDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StandingRosterDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'wardId';
    yield serializers.serialize(
      object.wardId,
      specifiedType: const FullType(String),
    );
    yield r'wardInspectorId';
    yield serializers.serialize(
      object.wardInspectorId,
      specifiedType: const FullType(String),
    );
    yield r'inspectorId';
    yield serializers.serialize(
      object.inspectorId,
      specifiedType: const FullType(String),
    );
    yield r'workerId';
    yield serializers.serialize(
      object.workerId,
      specifiedType: const FullType(String),
    );
    yield r'isActive';
    yield serializers.serialize(
      object.isActive,
      specifiedType: const FullType(bool),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(num),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    StandingRosterDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required StandingRosterDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'wardId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.wardId = valueDes;
          break;
        case r'wardInspectorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.wardInspectorId = valueDes;
          break;
        case r'inspectorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.inspectorId = valueDes;
          break;
        case r'workerId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.workerId = valueDes;
          break;
        case r'isActive':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isActive = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.version = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  StandingRosterDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StandingRosterDtoBuilder();
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

