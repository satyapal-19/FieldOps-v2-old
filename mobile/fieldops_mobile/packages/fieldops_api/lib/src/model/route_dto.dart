//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:fieldops_api/src/model/route_point_dto.dart';
import 'package:built_collection/built_collection.dart';
import 'package:fieldops_api/src/model/route_shift_dto.dart';
import 'package:fieldops_api/src/model/route_tamper_event_dto.dart';
import 'package:fieldops_api/src/model/route_summary_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'route_dto.g.dart';

/// RouteDto
///
/// Properties:
/// * [staffId] 
/// * [date] 
/// * [shift] 
/// * [summary] 
/// * [points] - Oldest first; empty once purged
/// * [pointsPurged] - True when the raw points are past the retention period
/// * [tamperEvents] 
@BuiltValue()
abstract class RouteDto implements Built<RouteDto, RouteDtoBuilder> {
  @BuiltValueField(wireName: r'staffId')
  String get staffId;

  @BuiltValueField(wireName: r'date')
  String get date;

  @BuiltValueField(wireName: r'shift')
  RouteShiftDto? get shift;

  @BuiltValueField(wireName: r'summary')
  RouteSummaryDto get summary;

  /// Oldest first; empty once purged
  @BuiltValueField(wireName: r'points')
  BuiltList<RoutePointDto> get points;

  /// True when the raw points are past the retention period
  @BuiltValueField(wireName: r'pointsPurged')
  bool get pointsPurged;

  @BuiltValueField(wireName: r'tamperEvents')
  BuiltList<RouteTamperEventDto> get tamperEvents;

  RouteDto._();

  factory RouteDto([void updates(RouteDtoBuilder b)]) = _$RouteDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RouteDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RouteDto> get serializer => _$RouteDtoSerializer();
}

class _$RouteDtoSerializer implements PrimitiveSerializer<RouteDto> {
  @override
  final Iterable<Type> types = const [RouteDto, _$RouteDto];

  @override
  final String wireName = r'RouteDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RouteDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'shift';
    yield object.shift == null ? null : serializers.serialize(
      object.shift,
      specifiedType: const FullType.nullable(RouteShiftDto),
    );
    yield r'summary';
    yield serializers.serialize(
      object.summary,
      specifiedType: const FullType(RouteSummaryDto),
    );
    yield r'points';
    yield serializers.serialize(
      object.points,
      specifiedType: const FullType(BuiltList, [FullType(RoutePointDto)]),
    );
    yield r'pointsPurged';
    yield serializers.serialize(
      object.pointsPurged,
      specifiedType: const FullType(bool),
    );
    yield r'tamperEvents';
    yield serializers.serialize(
      object.tamperEvents,
      specifiedType: const FullType(BuiltList, [FullType(RouteTamperEventDto)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RouteDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RouteDtoBuilder result,
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
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.date = valueDes;
          break;
        case r'shift':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(RouteShiftDto),
          ) as RouteShiftDto?;
          if (valueDes == null) continue;
          result.shift.replace(valueDes);
          break;
        case r'summary':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RouteSummaryDto),
          ) as RouteSummaryDto;
          result.summary.replace(valueDes);
          break;
        case r'points':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(RoutePointDto)]),
          ) as BuiltList<RoutePointDto>;
          result.points.replace(valueDes);
          break;
        case r'pointsPurged':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.pointsPurged = valueDes;
          break;
        case r'tamperEvents':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(RouteTamperEventDto)]),
          ) as BuiltList<RouteTamperEventDto>;
          result.tamperEvents.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RouteDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RouteDtoBuilder();
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

