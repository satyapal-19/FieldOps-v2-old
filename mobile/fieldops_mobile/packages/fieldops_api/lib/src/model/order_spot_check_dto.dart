//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_spot_check_dto.g.dart';

/// OrderSpotCheckDto
///
/// Properties:
/// * [staffId] - Someone on duty in your scope
/// * [reason] 
@BuiltValue()
abstract class OrderSpotCheckDto implements Built<OrderSpotCheckDto, OrderSpotCheckDtoBuilder> {
  /// Someone on duty in your scope
  @BuiltValueField(wireName: r'staffId')
  String get staffId;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  OrderSpotCheckDto._();

  factory OrderSpotCheckDto([void updates(OrderSpotCheckDtoBuilder b)]) = _$OrderSpotCheckDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderSpotCheckDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderSpotCheckDto> get serializer => _$OrderSpotCheckDtoSerializer();
}

class _$OrderSpotCheckDtoSerializer implements PrimitiveSerializer<OrderSpotCheckDto> {
  @override
  final Iterable<Type> types = const [OrderSpotCheckDto, _$OrderSpotCheckDto];

  @override
  final String wireName = r'OrderSpotCheckDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderSpotCheckDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'staffId';
    yield serializers.serialize(
      object.staffId,
      specifiedType: const FullType(String),
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
    OrderSpotCheckDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OrderSpotCheckDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'staffId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.staffId = valueDes;
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
  OrderSpotCheckDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderSpotCheckDtoBuilder();
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

