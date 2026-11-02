//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'route_summary_dto.g.dart';

/// RouteSummaryDto
///
/// Properties:
/// * [source_] - LIVE = computed now from the raw points; NIGHTLY = the stored roll-up
/// * [pingCount] 
/// * [distanceM] - Trusted distance (no mocked or > 50 m fixes), metres
/// * [firstPingAt] 
/// * [lastPingAt] 
/// * [inWardPings] 
/// * [outWardPings] 
/// * [stationaryPings] 
/// * [mockedPings] 
/// * [offlinePings] 
/// * [maxGapMinutes] 
/// * [tamperEvents] 
@BuiltValue()
abstract class RouteSummaryDto implements Built<RouteSummaryDto, RouteSummaryDtoBuilder> {
  /// LIVE = computed now from the raw points; NIGHTLY = the stored roll-up
  @BuiltValueField(wireName: r'source')
  RouteSummaryDtoSource_Enum get source_;
  // enum source_Enum {  LIVE,  NIGHTLY,  };

  @BuiltValueField(wireName: r'pingCount')
  num get pingCount;

  /// Trusted distance (no mocked or > 50 m fixes), metres
  @BuiltValueField(wireName: r'distanceM')
  num get distanceM;

  @BuiltValueField(wireName: r'firstPingAt')
  DateTime? get firstPingAt;

  @BuiltValueField(wireName: r'lastPingAt')
  DateTime? get lastPingAt;

  @BuiltValueField(wireName: r'inWardPings')
  num get inWardPings;

  @BuiltValueField(wireName: r'outWardPings')
  num get outWardPings;

  @BuiltValueField(wireName: r'stationaryPings')
  num get stationaryPings;

  @BuiltValueField(wireName: r'mockedPings')
  num get mockedPings;

  @BuiltValueField(wireName: r'offlinePings')
  num get offlinePings;

  @BuiltValueField(wireName: r'maxGapMinutes')
  num? get maxGapMinutes;

  @BuiltValueField(wireName: r'tamperEvents')
  num get tamperEvents;

  RouteSummaryDto._();

  factory RouteSummaryDto([void updates(RouteSummaryDtoBuilder b)]) = _$RouteSummaryDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RouteSummaryDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RouteSummaryDto> get serializer => _$RouteSummaryDtoSerializer();
}

class _$RouteSummaryDtoSerializer implements PrimitiveSerializer<RouteSummaryDto> {
  @override
  final Iterable<Type> types = const [RouteSummaryDto, _$RouteSummaryDto];

  @override
  final String wireName = r'RouteSummaryDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RouteSummaryDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'source';
    yield serializers.serialize(
      object.source_,
      specifiedType: const FullType(RouteSummaryDtoSource_Enum),
    );
    yield r'pingCount';
    yield serializers.serialize(
      object.pingCount,
      specifiedType: const FullType(num),
    );
    yield r'distanceM';
    yield serializers.serialize(
      object.distanceM,
      specifiedType: const FullType(num),
    );
    yield r'firstPingAt';
    yield object.firstPingAt == null ? null : serializers.serialize(
      object.firstPingAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'lastPingAt';
    yield object.lastPingAt == null ? null : serializers.serialize(
      object.lastPingAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'inWardPings';
    yield serializers.serialize(
      object.inWardPings,
      specifiedType: const FullType(num),
    );
    yield r'outWardPings';
    yield serializers.serialize(
      object.outWardPings,
      specifiedType: const FullType(num),
    );
    yield r'stationaryPings';
    yield serializers.serialize(
      object.stationaryPings,
      specifiedType: const FullType(num),
    );
    yield r'mockedPings';
    yield serializers.serialize(
      object.mockedPings,
      specifiedType: const FullType(num),
    );
    yield r'offlinePings';
    yield serializers.serialize(
      object.offlinePings,
      specifiedType: const FullType(num),
    );
    yield r'maxGapMinutes';
    yield object.maxGapMinutes == null ? null : serializers.serialize(
      object.maxGapMinutes,
      specifiedType: const FullType.nullable(num),
    );
    yield r'tamperEvents';
    yield serializers.serialize(
      object.tamperEvents,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RouteSummaryDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RouteSummaryDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RouteSummaryDtoSource_Enum),
          ) as RouteSummaryDtoSource_Enum;
          result.source_ = valueDes;
          break;
        case r'pingCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.pingCount = valueDes;
          break;
        case r'distanceM':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.distanceM = valueDes;
          break;
        case r'firstPingAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.firstPingAt = valueDes;
          break;
        case r'lastPingAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.lastPingAt = valueDes;
          break;
        case r'inWardPings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.inWardPings = valueDes;
          break;
        case r'outWardPings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.outWardPings = valueDes;
          break;
        case r'stationaryPings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.stationaryPings = valueDes;
          break;
        case r'mockedPings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.mockedPings = valueDes;
          break;
        case r'offlinePings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.offlinePings = valueDes;
          break;
        case r'maxGapMinutes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.maxGapMinutes = valueDes;
          break;
        case r'tamperEvents':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.tamperEvents = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RouteSummaryDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RouteSummaryDtoBuilder();
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

class RouteSummaryDtoSource_Enum extends EnumClass {

  /// LIVE = computed now from the raw points; NIGHTLY = the stored roll-up
  @BuiltValueEnumConst(wireName: r'LIVE')
  static const RouteSummaryDtoSource_Enum LIVE = _$routeSummaryDtoSourceEnum_LIVE;
  /// LIVE = computed now from the raw points; NIGHTLY = the stored roll-up
  @BuiltValueEnumConst(wireName: r'NIGHTLY')
  static const RouteSummaryDtoSource_Enum NIGHTLY = _$routeSummaryDtoSourceEnum_NIGHTLY;

  static Serializer<RouteSummaryDtoSource_Enum> get serializer => _$routeSummaryDtoSourceEnumSerializer;

  const RouteSummaryDtoSource_Enum._(String name): super(name);

  static BuiltSet<RouteSummaryDtoSource_Enum> get values => _$routeSummaryDtoSourceEnumValues;
  static RouteSummaryDtoSource_Enum valueOf(String name) => _$routeSummaryDtoSourceEnumValueOf(name);
}

