//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'spot_check_dto.g.dart';

/// SpotCheckDto
///
/// Properties:
/// * [id] 
/// * [staffId] 
/// * [wardId] 
/// * [date] 
/// * [trigger] 
/// * [initiatedById] 
/// * [reason] 
/// * [status] 
/// * [notifiedAt] 
/// * [dueAt] - Answer by this time
/// * [snoozed] 
/// * [respondedAt] 
/// * [inGeofence] 
/// * [faceScore] 
/// * [escalatedAt] 
/// * [version] 
@BuiltValue()
abstract class SpotCheckDto implements Built<SpotCheckDto, SpotCheckDtoBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'staffId')
  String get staffId;

  @BuiltValueField(wireName: r'wardId')
  String? get wardId;

  @BuiltValueField(wireName: r'date')
  String get date;

  @BuiltValueField(wireName: r'trigger')
  SpotCheckDtoTriggerEnum get trigger;
  // enum triggerEnum {  RANDOM,  SENIOR_MANUAL,  };

  @BuiltValueField(wireName: r'initiatedById')
  String? get initiatedById;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'status')
  SpotCheckDtoStatusEnum get status;
  // enum statusEnum {  SCHEDULED,  NOTIFIED,  SNOOZED,  VERIFIED,  MISSED,  FACE_MISMATCH,  OUT_OF_GEOFENCE,  UNREACHABLE,  CANCELLED,  };

  @BuiltValueField(wireName: r'notifiedAt')
  DateTime? get notifiedAt;

  /// Answer by this time
  @BuiltValueField(wireName: r'dueAt')
  DateTime? get dueAt;

  @BuiltValueField(wireName: r'snoozed')
  bool get snoozed;

  @BuiltValueField(wireName: r'respondedAt')
  DateTime? get respondedAt;

  @BuiltValueField(wireName: r'inGeofence')
  bool? get inGeofence;

  @BuiltValueField(wireName: r'faceScore')
  num? get faceScore;

  @BuiltValueField(wireName: r'escalatedAt')
  DateTime? get escalatedAt;

  @BuiltValueField(wireName: r'version')
  num get version;

  SpotCheckDto._();

  factory SpotCheckDto([void updates(SpotCheckDtoBuilder b)]) = _$SpotCheckDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SpotCheckDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SpotCheckDto> get serializer => _$SpotCheckDtoSerializer();
}

class _$SpotCheckDtoSerializer implements PrimitiveSerializer<SpotCheckDto> {
  @override
  final Iterable<Type> types = const [SpotCheckDto, _$SpotCheckDto];

  @override
  final String wireName = r'SpotCheckDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SpotCheckDto object, {
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
    yield r'wardId';
    yield object.wardId == null ? null : serializers.serialize(
      object.wardId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(String),
    );
    yield r'trigger';
    yield serializers.serialize(
      object.trigger,
      specifiedType: const FullType(SpotCheckDtoTriggerEnum),
    );
    yield r'initiatedById';
    yield object.initiatedById == null ? null : serializers.serialize(
      object.initiatedById,
      specifiedType: const FullType.nullable(String),
    );
    yield r'reason';
    yield object.reason == null ? null : serializers.serialize(
      object.reason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(SpotCheckDtoStatusEnum),
    );
    yield r'notifiedAt';
    yield object.notifiedAt == null ? null : serializers.serialize(
      object.notifiedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'dueAt';
    yield object.dueAt == null ? null : serializers.serialize(
      object.dueAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'snoozed';
    yield serializers.serialize(
      object.snoozed,
      specifiedType: const FullType(bool),
    );
    yield r'respondedAt';
    yield object.respondedAt == null ? null : serializers.serialize(
      object.respondedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'inGeofence';
    yield object.inGeofence == null ? null : serializers.serialize(
      object.inGeofence,
      specifiedType: const FullType.nullable(bool),
    );
    yield r'faceScore';
    yield object.faceScore == null ? null : serializers.serialize(
      object.faceScore,
      specifiedType: const FullType.nullable(num),
    );
    yield r'escalatedAt';
    yield object.escalatedAt == null ? null : serializers.serialize(
      object.escalatedAt,
      specifiedType: const FullType.nullable(DateTime),
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
    SpotCheckDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SpotCheckDtoBuilder result,
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
        case r'wardId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.wardId = valueDes;
          break;
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.date = valueDes;
          break;
        case r'trigger':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SpotCheckDtoTriggerEnum),
          ) as SpotCheckDtoTriggerEnum;
          result.trigger = valueDes;
          break;
        case r'initiatedById':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.initiatedById = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SpotCheckDtoStatusEnum),
          ) as SpotCheckDtoStatusEnum;
          result.status = valueDes;
          break;
        case r'notifiedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.notifiedAt = valueDes;
          break;
        case r'dueAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.dueAt = valueDes;
          break;
        case r'snoozed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.snoozed = valueDes;
          break;
        case r'respondedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.respondedAt = valueDes;
          break;
        case r'inGeofence':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.inGeofence = valueDes;
          break;
        case r'faceScore':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.faceScore = valueDes;
          break;
        case r'escalatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.escalatedAt = valueDes;
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
  SpotCheckDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SpotCheckDtoBuilder();
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

class SpotCheckDtoTriggerEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'RANDOM')
  static const SpotCheckDtoTriggerEnum RANDOM = _$spotCheckDtoTriggerEnum_RANDOM;
  @BuiltValueEnumConst(wireName: r'SENIOR_MANUAL')
  static const SpotCheckDtoTriggerEnum SENIOR_MANUAL = _$spotCheckDtoTriggerEnum_SENIOR_MANUAL;

  static Serializer<SpotCheckDtoTriggerEnum> get serializer => _$spotCheckDtoTriggerEnumSerializer;

  const SpotCheckDtoTriggerEnum._(String name): super(name);

  static BuiltSet<SpotCheckDtoTriggerEnum> get values => _$spotCheckDtoTriggerEnumValues;
  static SpotCheckDtoTriggerEnum valueOf(String name) => _$spotCheckDtoTriggerEnumValueOf(name);
}

class SpotCheckDtoStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SCHEDULED')
  static const SpotCheckDtoStatusEnum SCHEDULED = _$spotCheckDtoStatusEnum_SCHEDULED;
  @BuiltValueEnumConst(wireName: r'NOTIFIED')
  static const SpotCheckDtoStatusEnum NOTIFIED = _$spotCheckDtoStatusEnum_NOTIFIED;
  @BuiltValueEnumConst(wireName: r'SNOOZED')
  static const SpotCheckDtoStatusEnum SNOOZED = _$spotCheckDtoStatusEnum_SNOOZED;
  @BuiltValueEnumConst(wireName: r'VERIFIED')
  static const SpotCheckDtoStatusEnum VERIFIED = _$spotCheckDtoStatusEnum_VERIFIED;
  @BuiltValueEnumConst(wireName: r'MISSED')
  static const SpotCheckDtoStatusEnum MISSED = _$spotCheckDtoStatusEnum_MISSED;
  @BuiltValueEnumConst(wireName: r'FACE_MISMATCH')
  static const SpotCheckDtoStatusEnum FACE_MISMATCH = _$spotCheckDtoStatusEnum_FACE_MISMATCH;
  @BuiltValueEnumConst(wireName: r'OUT_OF_GEOFENCE')
  static const SpotCheckDtoStatusEnum OUT_OF_GEOFENCE = _$spotCheckDtoStatusEnum_OUT_OF_GEOFENCE;
  @BuiltValueEnumConst(wireName: r'UNREACHABLE')
  static const SpotCheckDtoStatusEnum UNREACHABLE = _$spotCheckDtoStatusEnum_UNREACHABLE;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const SpotCheckDtoStatusEnum CANCELLED = _$spotCheckDtoStatusEnum_CANCELLED;

  static Serializer<SpotCheckDtoStatusEnum> get serializer => _$spotCheckDtoStatusEnumSerializer;

  const SpotCheckDtoStatusEnum._(String name): super(name);

  static BuiltSet<SpotCheckDtoStatusEnum> get values => _$spotCheckDtoStatusEnumValues;
  static SpotCheckDtoStatusEnum valueOf(String name) => _$spotCheckDtoStatusEnumValueOf(name);
}

