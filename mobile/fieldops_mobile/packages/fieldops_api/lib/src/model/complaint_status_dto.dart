//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'complaint_status_dto.g.dart';

/// ComplaintStatusDto
///
/// Properties:
/// * [expectedVersion] 
/// * [action] 
@BuiltValue()
abstract class ComplaintStatusDto implements Built<ComplaintStatusDto, ComplaintStatusDtoBuilder> {
  @BuiltValueField(wireName: r'expectedVersion')
  num get expectedVersion;

  @BuiltValueField(wireName: r'action')
  ComplaintStatusDtoActionEnum get action;
  // enum actionEnum {  RESOLVE,  REJECT,  CLOSE,  };

  ComplaintStatusDto._();

  factory ComplaintStatusDto([void updates(ComplaintStatusDtoBuilder b)]) = _$ComplaintStatusDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ComplaintStatusDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ComplaintStatusDto> get serializer => _$ComplaintStatusDtoSerializer();
}

class _$ComplaintStatusDtoSerializer implements PrimitiveSerializer<ComplaintStatusDto> {
  @override
  final Iterable<Type> types = const [ComplaintStatusDto, _$ComplaintStatusDto];

  @override
  final String wireName = r'ComplaintStatusDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ComplaintStatusDto object, {
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
      specifiedType: const FullType(ComplaintStatusDtoActionEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ComplaintStatusDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ComplaintStatusDtoBuilder result,
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
            specifiedType: const FullType(ComplaintStatusDtoActionEnum),
          ) as ComplaintStatusDtoActionEnum;
          result.action = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ComplaintStatusDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ComplaintStatusDtoBuilder();
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

class ComplaintStatusDtoActionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'RESOLVE')
  static const ComplaintStatusDtoActionEnum RESOLVE = _$complaintStatusDtoActionEnum_RESOLVE;
  @BuiltValueEnumConst(wireName: r'REJECT')
  static const ComplaintStatusDtoActionEnum REJECT = _$complaintStatusDtoActionEnum_REJECT;
  @BuiltValueEnumConst(wireName: r'CLOSE')
  static const ComplaintStatusDtoActionEnum CLOSE = _$complaintStatusDtoActionEnum_CLOSE;

  static Serializer<ComplaintStatusDtoActionEnum> get serializer => _$complaintStatusDtoActionEnumSerializer;

  const ComplaintStatusDtoActionEnum._(String name): super(name);

  static BuiltSet<ComplaintStatusDtoActionEnum> get values => _$complaintStatusDtoActionEnumValues;
  static ComplaintStatusDtoActionEnum valueOf(String name) => _$complaintStatusDtoActionEnumValueOf(name);
}

