//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'route_shift_dto.g.dart';

/// RouteShiftDto
///
/// Properties:
/// * [attendanceId] 
/// * [wardId] 
/// * [officeId] 
/// * [checkinAt] 
/// * [checkoutAt] 
@BuiltValue()
abstract class RouteShiftDto implements Built<RouteShiftDto, RouteShiftDtoBuilder> {
  @BuiltValueField(wireName: r'attendanceId')
  String get attendanceId;

  @BuiltValueField(wireName: r'wardId')
  String? get wardId;

  @BuiltValueField(wireName: r'officeId')
  String? get officeId;

  @BuiltValueField(wireName: r'checkinAt')
  DateTime? get checkinAt;

  @BuiltValueField(wireName: r'checkoutAt')
  DateTime? get checkoutAt;

  RouteShiftDto._();

  factory RouteShiftDto([void updates(RouteShiftDtoBuilder b)]) = _$RouteShiftDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RouteShiftDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RouteShiftDto> get serializer => _$RouteShiftDtoSerializer();
}

class _$RouteShiftDtoSerializer implements PrimitiveSerializer<RouteShiftDto> {
  @override
  final Iterable<Type> types = const [RouteShiftDto, _$RouteShiftDto];

  @override
  final String wireName = r'RouteShiftDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RouteShiftDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'attendanceId';
    yield serializers.serialize(
      object.attendanceId,
      specifiedType: const FullType(String),
    );
    yield r'wardId';
    yield object.wardId == null ? null : serializers.serialize(
      object.wardId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'officeId';
    yield object.officeId == null ? null : serializers.serialize(
      object.officeId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'checkinAt';
    yield object.checkinAt == null ? null : serializers.serialize(
      object.checkinAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'checkoutAt';
    yield object.checkoutAt == null ? null : serializers.serialize(
      object.checkoutAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RouteShiftDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RouteShiftDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'attendanceId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.attendanceId = valueDes;
          break;
        case r'wardId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.wardId = valueDes;
          break;
        case r'officeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.officeId = valueDes;
          break;
        case r'checkinAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.checkinAt = valueDes;
          break;
        case r'checkoutAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.checkoutAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RouteShiftDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RouteShiftDtoBuilder();
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

