//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'review_request_dto.g.dart';

/// ReviewRequestDto
///
/// Properties:
/// * [expectedVersion] 
/// * [decision] 
/// * [note] 
@BuiltValue()
abstract class ReviewRequestDto implements Built<ReviewRequestDto, ReviewRequestDtoBuilder> {
  @BuiltValueField(wireName: r'expectedVersion')
  num get expectedVersion;

  @BuiltValueField(wireName: r'decision')
  ReviewRequestDtoDecisionEnum get decision;
  // enum decisionEnum {  APPROVED,  REJECTED,  };

  @BuiltValueField(wireName: r'note')
  String? get note;

  ReviewRequestDto._();

  factory ReviewRequestDto([void updates(ReviewRequestDtoBuilder b)]) = _$ReviewRequestDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ReviewRequestDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ReviewRequestDto> get serializer => _$ReviewRequestDtoSerializer();
}

class _$ReviewRequestDtoSerializer implements PrimitiveSerializer<ReviewRequestDto> {
  @override
  final Iterable<Type> types = const [ReviewRequestDto, _$ReviewRequestDto];

  @override
  final String wireName = r'ReviewRequestDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ReviewRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'expectedVersion';
    yield serializers.serialize(
      object.expectedVersion,
      specifiedType: const FullType(num),
    );
    yield r'decision';
    yield serializers.serialize(
      object.decision,
      specifiedType: const FullType(ReviewRequestDtoDecisionEnum),
    );
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ReviewRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ReviewRequestDtoBuilder result,
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
        case r'decision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ReviewRequestDtoDecisionEnum),
          ) as ReviewRequestDtoDecisionEnum;
          result.decision = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ReviewRequestDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReviewRequestDtoBuilder();
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

class ReviewRequestDtoDecisionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const ReviewRequestDtoDecisionEnum APPROVED = _$reviewRequestDtoDecisionEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const ReviewRequestDtoDecisionEnum REJECTED = _$reviewRequestDtoDecisionEnum_REJECTED;

  static Serializer<ReviewRequestDtoDecisionEnum> get serializer => _$reviewRequestDtoDecisionEnumSerializer;

  const ReviewRequestDtoDecisionEnum._(String name): super(name);

  static BuiltSet<ReviewRequestDtoDecisionEnum> get values => _$reviewRequestDtoDecisionEnumValues;
  static ReviewRequestDtoDecisionEnum valueOf(String name) => _$reviewRequestDtoDecisionEnumValueOf(name);
}

