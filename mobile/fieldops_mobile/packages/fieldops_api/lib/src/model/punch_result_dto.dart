//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fieldops_api/src/model/attendance_log_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'punch_result_dto.g.dart';

/// PunchResultDto
///
/// Properties:
/// * [replayed] - True when this clientUuid was already accepted (a retry)
/// * [attendance] 
@BuiltValue()
abstract class PunchResultDto implements Built<PunchResultDto, PunchResultDtoBuilder> {
  /// True when this clientUuid was already accepted (a retry)
  @BuiltValueField(wireName: r'replayed')
  bool get replayed;

  @BuiltValueField(wireName: r'attendance')
  AttendanceLogDto get attendance;

  PunchResultDto._();

  factory PunchResultDto([void updates(PunchResultDtoBuilder b)]) = _$PunchResultDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PunchResultDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PunchResultDto> get serializer => _$PunchResultDtoSerializer();
}

class _$PunchResultDtoSerializer implements PrimitiveSerializer<PunchResultDto> {
  @override
  final Iterable<Type> types = const [PunchResultDto, _$PunchResultDto];

  @override
  final String wireName = r'PunchResultDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PunchResultDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'replayed';
    yield serializers.serialize(
      object.replayed,
      specifiedType: const FullType(bool),
    );
    yield r'attendance';
    yield serializers.serialize(
      object.attendance,
      specifiedType: const FullType(AttendanceLogDto),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PunchResultDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PunchResultDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'replayed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.replayed = valueDes;
          break;
        case r'attendance':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AttendanceLogDto),
          ) as AttendanceLogDto;
          result.attendance.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PunchResultDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PunchResultDtoBuilder();
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

