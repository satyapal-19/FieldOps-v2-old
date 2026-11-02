//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fieldops_api/src/model/rejected_item_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tamper_batch_result_dto.g.dart';

/// TamperBatchResultDto
///
/// Properties:
/// * [accepted] 
/// * [duplicates] 
/// * [rejected] 
@BuiltValue()
abstract class TamperBatchResultDto implements Built<TamperBatchResultDto, TamperBatchResultDtoBuilder> {
  @BuiltValueField(wireName: r'accepted')
  num get accepted;

  @BuiltValueField(wireName: r'duplicates')
  num get duplicates;

  @BuiltValueField(wireName: r'rejected')
  BuiltList<RejectedItemDto> get rejected;

  TamperBatchResultDto._();

  factory TamperBatchResultDto([void updates(TamperBatchResultDtoBuilder b)]) = _$TamperBatchResultDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TamperBatchResultDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TamperBatchResultDto> get serializer => _$TamperBatchResultDtoSerializer();
}

class _$TamperBatchResultDtoSerializer implements PrimitiveSerializer<TamperBatchResultDto> {
  @override
  final Iterable<Type> types = const [TamperBatchResultDto, _$TamperBatchResultDto];

  @override
  final String wireName = r'TamperBatchResultDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TamperBatchResultDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'accepted';
    yield serializers.serialize(
      object.accepted,
      specifiedType: const FullType(num),
    );
    yield r'duplicates';
    yield serializers.serialize(
      object.duplicates,
      specifiedType: const FullType(num),
    );
    yield r'rejected';
    yield serializers.serialize(
      object.rejected,
      specifiedType: const FullType(BuiltList, [FullType(RejectedItemDto)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TamperBatchResultDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TamperBatchResultDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accepted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.accepted = valueDes;
          break;
        case r'duplicates':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.duplicates = valueDes;
          break;
        case r'rejected':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(RejectedItemDto)]),
          ) as BuiltList<RejectedItemDto>;
          result.rejected.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TamperBatchResultDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TamperBatchResultDtoBuilder();
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

