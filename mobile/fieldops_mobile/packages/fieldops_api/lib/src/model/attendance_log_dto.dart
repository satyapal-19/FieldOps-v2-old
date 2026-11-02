//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fieldops_api/src/model/punch_details_dto.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'attendance_log_dto.g.dart';

/// AttendanceLogDto
///
/// Properties:
/// * [id] 
/// * [staffId] 
/// * [date] - IST date of the shift
/// * [status] 
/// * [wardId] 
/// * [officeId] 
/// * [assignmentId] 
/// * [isLate] 
/// * [lateMinutes] 
/// * [workedMinutes] 
/// * [checkin] 
/// * [checkinDistanceM] - Metres outside the geofence
/// * [checkinFaceScore] 
/// * [checkout] 
/// * [checkoutType] 
/// * [isSuspicious] - Mock location or other warning signs
/// * [version] 
@BuiltValue()
abstract class AttendanceLogDto implements Built<AttendanceLogDto, AttendanceLogDtoBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'staffId')
  String get staffId;

  /// IST date of the shift
  @BuiltValueField(wireName: r'date')
  String get date;

  @BuiltValueField(wireName: r'status')
  AttendanceLogDtoStatusEnum get status;
  // enum statusEnum {  PRESENT,  ABSENT,  LATE,  HALF_DAY,  HOLIDAY_OFF,  ON_LEAVE,  REGULARIZED,  };

  @BuiltValueField(wireName: r'wardId')
  String? get wardId;

  @BuiltValueField(wireName: r'officeId')
  String? get officeId;

  @BuiltValueField(wireName: r'assignmentId')
  String? get assignmentId;

  @BuiltValueField(wireName: r'isLate')
  bool get isLate;

  @BuiltValueField(wireName: r'lateMinutes')
  num get lateMinutes;

  @BuiltValueField(wireName: r'workedMinutes')
  num? get workedMinutes;

  @BuiltValueField(wireName: r'checkin')
  PunchDetailsDto? get checkin;

  /// Metres outside the geofence
  @BuiltValueField(wireName: r'checkinDistanceM')
  num? get checkinDistanceM;

  @BuiltValueField(wireName: r'checkinFaceScore')
  num? get checkinFaceScore;

  @BuiltValueField(wireName: r'checkout')
  PunchDetailsDto? get checkout;

  @BuiltValueField(wireName: r'checkoutType')
  AttendanceLogDtoCheckoutTypeEnum? get checkoutType;
  // enum checkoutTypeEnum {  MANUAL,  AUTO_GPS_LAST_SEEN,  AUTO_OFFICE_SCHEDULED,  SUPERVISOR_OVERRIDE,  };

  /// Mock location or other warning signs
  @BuiltValueField(wireName: r'isSuspicious')
  bool get isSuspicious;

  @BuiltValueField(wireName: r'version')
  num get version;

  AttendanceLogDto._();

  factory AttendanceLogDto([void updates(AttendanceLogDtoBuilder b)]) = _$AttendanceLogDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AttendanceLogDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AttendanceLogDto> get serializer => _$AttendanceLogDtoSerializer();
}

class _$AttendanceLogDtoSerializer implements PrimitiveSerializer<AttendanceLogDto> {
  @override
  final Iterable<Type> types = const [AttendanceLogDto, _$AttendanceLogDto];

  @override
  final String wireName = r'AttendanceLogDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AttendanceLogDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'staffId';
    yield serializers.serialize(
      object.staffId,
      specifiedType: const FullType(String),
    );
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AttendanceLogDtoStatusEnum),
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
    yield r'assignmentId';
    yield object.assignmentId == null ? null : serializers.serialize(
      object.assignmentId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'isLate';
    yield serializers.serialize(
      object.isLate,
      specifiedType: const FullType(bool),
    );
    yield r'lateMinutes';
    yield serializers.serialize(
      object.lateMinutes,
      specifiedType: const FullType(num),
    );
    yield r'workedMinutes';
    yield object.workedMinutes == null ? null : serializers.serialize(
      object.workedMinutes,
      specifiedType: const FullType.nullable(num),
    );
    yield r'checkin';
    yield object.checkin == null ? null : serializers.serialize(
      object.checkin,
      specifiedType: const FullType.nullable(PunchDetailsDto),
    );
    yield r'checkinDistanceM';
    yield object.checkinDistanceM == null ? null : serializers.serialize(
      object.checkinDistanceM,
      specifiedType: const FullType.nullable(num),
    );
    yield r'checkinFaceScore';
    yield object.checkinFaceScore == null ? null : serializers.serialize(
      object.checkinFaceScore,
      specifiedType: const FullType.nullable(num),
    );
    yield r'checkout';
    yield object.checkout == null ? null : serializers.serialize(
      object.checkout,
      specifiedType: const FullType.nullable(PunchDetailsDto),
    );
    yield r'checkoutType';
    yield object.checkoutType == null ? null : serializers.serialize(
      object.checkoutType,
      specifiedType: const FullType.nullable(AttendanceLogDtoCheckoutTypeEnum),
    );
    yield r'isSuspicious';
    yield serializers.serialize(
      object.isSuspicious,
      specifiedType: const FullType(bool),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AttendanceLogDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AttendanceLogDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'staffId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.staffId = valueDes;
          break;
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.date = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AttendanceLogDtoStatusEnum),
          ) as AttendanceLogDtoStatusEnum;
          result.status = valueDes;
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
        case r'assignmentId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.assignmentId = valueDes;
          break;
        case r'isLate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isLate = valueDes;
          break;
        case r'lateMinutes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.lateMinutes = valueDes;
          break;
        case r'workedMinutes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.workedMinutes = valueDes;
          break;
        case r'checkin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(PunchDetailsDto),
          ) as PunchDetailsDto?;
          if (valueDes == null) continue;
          result.checkin.replace(valueDes);
          break;
        case r'checkinDistanceM':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.checkinDistanceM = valueDes;
          break;
        case r'checkinFaceScore':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.checkinFaceScore = valueDes;
          break;
        case r'checkout':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(PunchDetailsDto),
          ) as PunchDetailsDto?;
          if (valueDes == null) continue;
          result.checkout.replace(valueDes);
          break;
        case r'checkoutType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AttendanceLogDtoCheckoutTypeEnum),
          ) as AttendanceLogDtoCheckoutTypeEnum?;
          if (valueDes == null) continue;
          result.checkoutType = valueDes;
          break;
        case r'isSuspicious':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isSuspicious = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.version = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AttendanceLogDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AttendanceLogDtoBuilder();
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

class AttendanceLogDtoStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PRESENT')
  static const AttendanceLogDtoStatusEnum PRESENT = _$attendanceLogDtoStatusEnum_PRESENT;
  @BuiltValueEnumConst(wireName: r'ABSENT')
  static const AttendanceLogDtoStatusEnum ABSENT = _$attendanceLogDtoStatusEnum_ABSENT;
  @BuiltValueEnumConst(wireName: r'LATE')
  static const AttendanceLogDtoStatusEnum LATE = _$attendanceLogDtoStatusEnum_LATE;
  @BuiltValueEnumConst(wireName: r'HALF_DAY')
  static const AttendanceLogDtoStatusEnum HALF_DAY = _$attendanceLogDtoStatusEnum_HALF_DAY;
  @BuiltValueEnumConst(wireName: r'HOLIDAY_OFF')
  static const AttendanceLogDtoStatusEnum HOLIDAY_OFF = _$attendanceLogDtoStatusEnum_HOLIDAY_OFF;
  @BuiltValueEnumConst(wireName: r'ON_LEAVE')
  static const AttendanceLogDtoStatusEnum ON_LEAVE = _$attendanceLogDtoStatusEnum_ON_LEAVE;
  @BuiltValueEnumConst(wireName: r'REGULARIZED')
  static const AttendanceLogDtoStatusEnum REGULARIZED = _$attendanceLogDtoStatusEnum_REGULARIZED;

  static Serializer<AttendanceLogDtoStatusEnum> get serializer => _$attendanceLogDtoStatusEnumSerializer;

  const AttendanceLogDtoStatusEnum._(String name): super(name);

  static BuiltSet<AttendanceLogDtoStatusEnum> get values => _$attendanceLogDtoStatusEnumValues;
  static AttendanceLogDtoStatusEnum valueOf(String name) => _$attendanceLogDtoStatusEnumValueOf(name);
}

class AttendanceLogDtoCheckoutTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'MANUAL')
  static const AttendanceLogDtoCheckoutTypeEnum MANUAL = _$attendanceLogDtoCheckoutTypeEnum_MANUAL;
  @BuiltValueEnumConst(wireName: r'AUTO_GPS_LAST_SEEN')
  static const AttendanceLogDtoCheckoutTypeEnum AUTO_GPS_LAST_SEEN = _$attendanceLogDtoCheckoutTypeEnum_AUTO_GPS_LAST_SEEN;
  @BuiltValueEnumConst(wireName: r'AUTO_OFFICE_SCHEDULED')
  static const AttendanceLogDtoCheckoutTypeEnum AUTO_OFFICE_SCHEDULED = _$attendanceLogDtoCheckoutTypeEnum_AUTO_OFFICE_SCHEDULED;
  @BuiltValueEnumConst(wireName: r'SUPERVISOR_OVERRIDE')
  static const AttendanceLogDtoCheckoutTypeEnum SUPERVISOR_OVERRIDE = _$attendanceLogDtoCheckoutTypeEnum_SUPERVISOR_OVERRIDE;

  static Serializer<AttendanceLogDtoCheckoutTypeEnum> get serializer => _$attendanceLogDtoCheckoutTypeEnumSerializer;

  const AttendanceLogDtoCheckoutTypeEnum._(String name): super(name);

  static BuiltSet<AttendanceLogDtoCheckoutTypeEnum> get values => _$attendanceLogDtoCheckoutTypeEnumValues;
  static AttendanceLogDtoCheckoutTypeEnum valueOf(String name) => _$attendanceLogDtoCheckoutTypeEnumValueOf(name);
}

