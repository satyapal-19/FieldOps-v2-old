//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ping_dto.g.dart';

/// PingDto
///
/// Properties:
/// * [clientUuid] - Idempotency key from the phone outbox
/// * [latitude] 
/// * [longitude] 
/// * [accuracyM] 
/// * [batteryPct] 
/// * [isMocked] 
/// * [fromOffline] - Sent from the offline buffer
/// * [recordedAt] - Phone time of the fix (UTC)
@BuiltValue()
abstract class PingDto implements Built<PingDto, PingDtoBuilder> {
  /// Idempotency key from the phone outbox
  @BuiltValueField(wireName: r'clientUuid')
  String get clientUuid;

  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  @BuiltValueField(wireName: r'accuracyM')
  num? get accuracyM;

  @BuiltValueField(wireName: r'batteryPct')
  num? get batteryPct;

  @BuiltValueField(wireName: r'isMocked')
  bool? get isMocked;

  /// Sent from the offline buffer
  @BuiltValueField(wireName: r'fromOffline')
  bool? get fromOffline;

  /// Phone time of the fix (UTC)
  @BuiltValueField(wireName: r'recordedAt')
  DateTime get recordedAt;

  PingDto._();

  factory PingDto([void updates(PingDtoBuilder b)]) = _$PingDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PingDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PingDto> get serializer => _$PingDtoSerializer();
}

class _$PingDtoSerializer implements PrimitiveSerializer<PingDto> {
  @override
  final Iterable<Type> types = const [PingDto, _$PingDto];

  @override
  final String wireName = r'PingDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PingDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'clientUuid';
    yield serializers.serialize(
      object.clientUuid,
      specifiedType: const FullType(String),
    );
    yield r'latitude';
    yield serializers.serialize(
      object.latitude,
      specifiedType: const FullType(num),
    );
    yield r'longitude';
    yield serializers.serialize(
      object.longitude,
      specifiedType: const FullType(num),
    );
    if (object.accuracyM != null) {
      yield r'accuracyM';
      yield serializers.serialize(
        object.accuracyM,
        specifiedType: const FullType(num),
      );
    }
    if (object.batteryPct != null) {
      yield r'batteryPct';
      yield serializers.serialize(
        object.batteryPct,
        specifiedType: const FullType(num),
      );
    }
    if (object.isMocked != null) {
      yield r'isMocked';
      yield serializers.serialize(
        object.isMocked,
        specifiedType: const FullType(bool),
      );
    }
    if (object.fromOffline != null) {
      yield r'fromOffline';
      yield serializers.serialize(
        object.fromOffline,
        specifiedType: const FullType(bool),
      );
    }
    yield r'recordedAt';
    yield serializers.serialize(
      object.recordedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PingDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PingDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'clientUuid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.clientUuid = valueDes;
          break;
        case r'latitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.longitude = valueDes;
          break;
        case r'accuracyM':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.accuracyM = valueDes;
          break;
        case r'batteryPct':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.batteryPct = valueDes;
          break;
        case r'isMocked':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isMocked = valueDes;
          break;
        case r'fromOffline':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.fromOffline = valueDes;
          break;
        case r'recordedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.recordedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PingDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PingDtoBuilder();
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

