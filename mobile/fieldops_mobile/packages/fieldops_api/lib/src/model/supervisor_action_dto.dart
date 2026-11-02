//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'supervisor_action_dto.g.dart';

/// SupervisorActionDto
///
/// Properties:
/// * [expectedVersion] 
/// * [action] 
/// * [reason] - Required to REJECT
@BuiltValue()
abstract class SupervisorActionDto implements Built<SupervisorActionDto, SupervisorActionDtoBuilder> {
  @BuiltValueField(wireName: r'expectedVersion')
  num get expectedVersion;

  @BuiltValueField(wireName: r'action')
  SupervisorActionDtoActionEnum get action;
  // enum actionEnum {  APPROVE,  REJECT,  ESCALATE,  CLOSE,  };

  /// Required to REJECT
  @BuiltValueField(wireName: r'reason')
  String? get reason;

  SupervisorActionDto._();

  factory SupervisorActionDto([void updates(SupervisorActionDtoBuilder b)]) = _$SupervisorActionDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SupervisorActionDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SupervisorActionDto> get serializer => _$SupervisorActionDtoSerializer();
}

class _$SupervisorActionDtoSerializer implements PrimitiveSerializer<SupervisorActionDto> {
  @override
  final Iterable<Type> types = const [SupervisorActionDto, _$SupervisorActionDto];

  @override
  final String wireName = r'SupervisorActionDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SupervisorActionDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'expectedVersion';
    yield serializers.serialize(
      object.expectedVersion,
      specifiedType: const FullType(num),
    );
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(SupervisorActionDtoActionEnum),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SupervisorActionDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SupervisorActionDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'expectedVersion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.expectedVersion = valueDes;
          break;
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SupervisorActionDtoActionEnum),
          ) as SupervisorActionDtoActionEnum;
          result.action = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SupervisorActionDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SupervisorActionDtoBuilder();
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

class SupervisorActionDtoActionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'APPROVE')
  static const SupervisorActionDtoActionEnum APPROVE = _$supervisorActionDtoActionEnum_APPROVE;
  @BuiltValueEnumConst(wireName: r'REJECT')
  static const SupervisorActionDtoActionEnum REJECT = _$supervisorActionDtoActionEnum_REJECT;
  @BuiltValueEnumConst(wireName: r'ESCALATE')
  static const SupervisorActionDtoActionEnum ESCALATE = _$supervisorActionDtoActionEnum_ESCALATE;
  @BuiltValueEnumConst(wireName: r'CLOSE')
  static const SupervisorActionDtoActionEnum CLOSE = _$supervisorActionDtoActionEnum_CLOSE;

  static Serializer<SupervisorActionDtoActionEnum> get serializer => _$supervisorActionDtoActionEnumSerializer;

  const SupervisorActionDtoActionEnum._(String name): super(name);

  static BuiltSet<SupervisorActionDtoActionEnum> get values => _$supervisorActionDtoActionEnumValues;
  static SupervisorActionDtoActionEnum valueOf(String name) => _$supervisorActionDtoActionEnumValueOf(name);
}

