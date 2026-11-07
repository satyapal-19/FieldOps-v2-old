//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_ward_day_dto.g.dart';

/// PublicWardDayDto
///
/// Properties:
/// * [date] 
/// * [assignedCount] 
/// * [presentCount] 
/// * [onLeaveCount] 
@BuiltValue()
abstract class PublicWardDayDto implements Built<PublicWardDayDto, PublicWardDayDtoBuilder> {
  @BuiltValueField(wireName: r'date')
  String get date;

  @BuiltValueField(wireName: r'assignedCount')
  num get assignedCount;

  @BuiltValueField(wireName: r'presentCount')
  num get presentCount;

  @BuiltValueField(wireName: r'onLeaveCount')
  num get onLeaveCount;

  PublicWardDayDto._();

  factory PublicWardDayDto([void updates(PublicWardDayDtoBuilder b)]) = _$PublicWardDayDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicWardDayDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicWardDayDto> get serializer => _$PublicWardDayDtoSerializer();
}

class _$PublicWardDayDtoSerializer implements PrimitiveSerializer<PublicWardDayDto> {
  @override
  final Iterable<Type> types = const [PublicWardDayDto, _$PublicWardDayDto];

  @override
  final String wireName = r'PublicWardDayDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicWardDayDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(String),
    );
    yield r'assignedCount';
    yield serializers.serialize(
      object.assignedCount,
      specifiedType: const FullType(num),
    );
    yield r'presentCount';
    yield serializers.serialize(
      object.presentCount,
      specifiedType: const FullType(num),
    );
    yield r'onLeaveCount';
    yield serializers.serialize(
      object.onLeaveCount,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicWardDayDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicWardDayDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.date = valueDes;
          break;
        case r'assignedCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.assignedCount = valueDes;
          break;
        case r'presentCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.presentCount = valueDes;
          break;
        case r'onLeaveCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.onLeaveCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublicWardDayDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicWardDayDtoBuilder();
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

