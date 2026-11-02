//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fieldops_api/src/model/rejected_item_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ping_batch_result_dto.g.dart';

/// PingBatchResultDto
///
/// Properties:
/// * [accepted] - New pings stored
/// * [duplicates] - Already stored earlier (safe retries)
/// * [rejected] - Dropped; do not resend these
@BuiltValue()
abstract class PingBatchResultDto implements Built<PingBatchResultDto, PingBatchResultDtoBuilder> {
  /// New pings stored
  @BuiltValueField(wireName: r'accepted')
  num get accepted;

  /// Already stored earlier (safe retries)
  @BuiltValueField(wireName: r'duplicates')
  num get duplicates;

  /// Dropped; do not resend these
  @BuiltValueField(wireName: r'rejected')
  BuiltList<RejectedItemDto> get rejected;

  PingBatchResultDto._();

  factory PingBatchResultDto([void updates(PingBatchResultDtoBuilder b)]) = _$PingBatchResultDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PingBatchResultDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PingBatchResultDto> get serializer => _$PingBatchResultDtoSerializer();
}

class _$PingBatchResultDtoSerializer implements PrimitiveSerializer<PingBatchResultDto> {
  @override
  final Iterable<Type> types = const [PingBatchResultDto, _$PingBatchResultDto];

  @override
  final String wireName = r'PingBatchResultDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PingBatchResultDto object, {
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
    PingBatchResultDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PingBatchResultDtoBuilder result,
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
  PingBatchResultDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PingBatchResultDtoBuilder();
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

