//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fieldops_api/src/model/public_ward_day_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_ward_attendance_dto.g.dart';

/// PublicWardAttendanceDto
///
/// Properties:
/// * [wardId] 
/// * [days] - The last 7 summarised days, newest first
@BuiltValue()
abstract class PublicWardAttendanceDto implements Built<PublicWardAttendanceDto, PublicWardAttendanceDtoBuilder> {
  @BuiltValueField(wireName: r'wardId')
  String get wardId;

  /// The last 7 summarised days, newest first
  @BuiltValueField(wireName: r'days')
  BuiltList<PublicWardDayDto> get days;

  PublicWardAttendanceDto._();

  factory PublicWardAttendanceDto([void updates(PublicWardAttendanceDtoBuilder b)]) = _$PublicWardAttendanceDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicWardAttendanceDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicWardAttendanceDto> get serializer => _$PublicWardAttendanceDtoSerializer();
}

class _$PublicWardAttendanceDtoSerializer implements PrimitiveSerializer<PublicWardAttendanceDto> {
  @override
  final Iterable<Type> types = const [PublicWardAttendanceDto, _$PublicWardAttendanceDto];

  @override
  final String wireName = r'PublicWardAttendanceDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicWardAttendanceDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'wardId';
    yield serializers.serialize(
      object.wardId,
      specifiedType: const FullType(String),
    );
    yield r'days';
    yield serializers.serialize(
      object.days,
      specifiedType: const FullType(BuiltList, [FullType(PublicWardDayDto)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicWardAttendanceDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicWardAttendanceDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'wardId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.wardId = valueDes;
          break;
        case r'days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PublicWardDayDto)]),
          ) as BuiltList<PublicWardDayDto>;
          result.days.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublicWardAttendanceDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicWardAttendanceDtoBuilder();
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

