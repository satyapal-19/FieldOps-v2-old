//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'live_position_dto.g.dart';

/// LivePositionDto
///
/// Properties:
/// * [staffId] 
/// * [attendanceId] 
/// * [wardId] 
/// * [date] 
/// * [checkinAt] 
/// * [state] 
/// * [lastSeenAt] 
/// * [latitude] - Last ping, else the check-in point
/// * [longitude] 
/// * [accuracyM] 
/// * [inWard] 
/// * [isMocked] 
@BuiltValue()
abstract class LivePositionDto implements Built<LivePositionDto, LivePositionDtoBuilder> {
  @BuiltValueField(wireName: r'staffId')
  String get staffId;

  @BuiltValueField(wireName: r'attendanceId')
  String get attendanceId;

  @BuiltValueField(wireName: r'wardId')
  String get wardId;

  @BuiltValueField(wireName: r'date')
  String get date;

  @BuiltValueField(wireName: r'checkinAt')
  DateTime get checkinAt;

  @BuiltValueField(wireName: r'state')
  LivePositionDtoStateEnum get state;
  // enum stateEnum {  ACTIVE,  STALE,  SILENT,  NO_SIGNAL,  };

  @BuiltValueField(wireName: r'lastSeenAt')
  DateTime? get lastSeenAt;

  /// Last ping, else the check-in point
  @BuiltValueField(wireName: r'latitude')
  num? get latitude;

  @BuiltValueField(wireName: r'longitude')
  num? get longitude;

  @BuiltValueField(wireName: r'accuracyM')
  num? get accuracyM;

  @BuiltValueField(wireName: r'inWard')
  bool? get inWard;

  @BuiltValueField(wireName: r'isMocked')
  bool get isMocked;

  LivePositionDto._();

  factory LivePositionDto([void updates(LivePositionDtoBuilder b)]) = _$LivePositionDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LivePositionDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LivePositionDto> get serializer => _$LivePositionDtoSerializer();
}

class _$LivePositionDtoSerializer implements PrimitiveSerializer<LivePositionDto> {
  @override
  final Iterable<Type> types = const [LivePositionDto, _$LivePositionDto];

  @override
  final String wireName = r'LivePositionDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LivePositionDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'staffId';
    yield serializers.serialize(
      object.staffId,
      specifiedType: const FullType(String),
    );
    yield r'attendanceId';
    yield serializers.serialize(
      object.attendanceId,
      specifiedType: const FullType(String),
    );
    yield r'wardId';
    yield serializers.serialize(
      object.wardId,
      specifiedType: const FullType(String),
    );
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(String),
    );
    yield r'checkinAt';
    yield serializers.serialize(
      object.checkinAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(LivePositionDtoStateEnum),
    );
    yield r'lastSeenAt';
    yield object.lastSeenAt == null ? null : serializers.serialize(
      object.lastSeenAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'latitude';
    yield object.latitude == null ? null : serializers.serialize(
      object.latitude,
      specifiedType: const FullType.nullable(num),
    );
    yield r'longitude';
    yield object.longitude == null ? null : serializers.serialize(
      object.longitude,
      specifiedType: const FullType.nullable(num),
    );
    yield r'accuracyM';
    yield object.accuracyM == null ? null : serializers.serialize(
      object.accuracyM,
      specifiedType: const FullType.nullable(num),
    );
    yield r'inWard';
    yield object.inWard == null ? null : serializers.serialize(
      object.inWard,
      specifiedType: const FullType.nullable(bool),
    );
    yield r'isMocked';
    yield serializers.serialize(
      object.isMocked,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    LivePositionDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LivePositionDtoBuilder result,
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
            specifiedType: const FullType(String),
          ) as String;
          result.wardId = valueDes;
          break;
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.date = valueDes;
          break;
        case r'checkinAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.checkinAt = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(LivePositionDtoStateEnum),
          ) as LivePositionDtoStateEnum;
          result.state = valueDes;
          break;
        case r'lastSeenAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.lastSeenAt = valueDes;
          break;
        case r'latitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.longitude = valueDes;
          break;
        case r'accuracyM':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.accuracyM = valueDes;
          break;
        case r'inWard':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.inWard = valueDes;
          break;
        case r'isMocked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isMocked = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  LivePositionDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LivePositionDtoBuilder();
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

class LivePositionDtoStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const LivePositionDtoStateEnum ACTIVE = _$livePositionDtoStateEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'STALE')
  static const LivePositionDtoStateEnum STALE = _$livePositionDtoStateEnum_STALE;
  @BuiltValueEnumConst(wireName: r'SILENT')
  static const LivePositionDtoStateEnum SILENT = _$livePositionDtoStateEnum_SILENT;
  @BuiltValueEnumConst(wireName: r'NO_SIGNAL')
  static const LivePositionDtoStateEnum NO_SIGNAL = _$livePositionDtoStateEnum_NO_SIGNAL;

  static Serializer<LivePositionDtoStateEnum> get serializer => _$livePositionDtoStateEnumSerializer;

  const LivePositionDtoStateEnum._(String name): super(name);

  static BuiltSet<LivePositionDtoStateEnum> get values => _$livePositionDtoStateEnumValues;
  static LivePositionDtoStateEnum valueOf(String name) => _$livePositionDtoStateEnumValueOf(name);
}

