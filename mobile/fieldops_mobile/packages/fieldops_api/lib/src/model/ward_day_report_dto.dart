//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ward_day_report_dto.g.dart';

/// WardDayReportDto
///
/// Properties:
/// * [date] 
/// * [wardId] 
/// * [assignedCount] 
/// * [presentCount] 
/// * [lateCount] 
/// * [halfDayCount] 
/// * [absentCount] 
/// * [onLeaveCount] 
/// * [proxyCount] 
/// * [autoCheckoutCount] 
/// * [suspiciousCount] 
/// * [distanceM] - Trusted distance walked by the ward team, metres
@BuiltValue()
abstract class WardDayReportDto implements Built<WardDayReportDto, WardDayReportDtoBuilder> {
  @BuiltValueField(wireName: r'date')
  String get date;

  @BuiltValueField(wireName: r'wardId')
  String get wardId;

  @BuiltValueField(wireName: r'assignedCount')
  num get assignedCount;

  @BuiltValueField(wireName: r'presentCount')
  num get presentCount;

  @BuiltValueField(wireName: r'lateCount')
  num get lateCount;

  @BuiltValueField(wireName: r'halfDayCount')
  num get halfDayCount;

  @BuiltValueField(wireName: r'absentCount')
  num get absentCount;

  @BuiltValueField(wireName: r'onLeaveCount')
  num get onLeaveCount;

  @BuiltValueField(wireName: r'proxyCount')
  num get proxyCount;

  @BuiltValueField(wireName: r'autoCheckoutCount')
  num get autoCheckoutCount;

  @BuiltValueField(wireName: r'suspiciousCount')
  num get suspiciousCount;

  /// Trusted distance walked by the ward team, metres
  @BuiltValueField(wireName: r'distanceM')
  num get distanceM;

  WardDayReportDto._();

  factory WardDayReportDto([void updates(WardDayReportDtoBuilder b)]) = _$WardDayReportDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WardDayReportDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WardDayReportDto> get serializer => _$WardDayReportDtoSerializer();
}

class _$WardDayReportDtoSerializer implements PrimitiveSerializer<WardDayReportDto> {
  @override
  final Iterable<Type> types = const [WardDayReportDto, _$WardDayReportDto];

  @override
  final String wireName = r'WardDayReportDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WardDayReportDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(String),
    );
    yield r'wardId';
    yield serializers.serialize(
      object.wardId,
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
    yield r'lateCount';
    yield serializers.serialize(
      object.lateCount,
      specifiedType: const FullType(num),
    );
    yield r'halfDayCount';
    yield serializers.serialize(
      object.halfDayCount,
      specifiedType: const FullType(num),
    );
    yield r'absentCount';
    yield serializers.serialize(
      object.absentCount,
      specifiedType: const FullType(num),
    );
    yield r'onLeaveCount';
    yield serializers.serialize(
      object.onLeaveCount,
      specifiedType: const FullType(num),
    );
    yield r'proxyCount';
    yield serializers.serialize(
      object.proxyCount,
      specifiedType: const FullType(num),
    );
    yield r'autoCheckoutCount';
    yield serializers.serialize(
      object.autoCheckoutCount,
      specifiedType: const FullType(num),
    );
    yield r'suspiciousCount';
    yield serializers.serialize(
      object.suspiciousCount,
      specifiedType: const FullType(num),
    );
    yield r'distanceM';
    yield serializers.serialize(
      object.distanceM,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    WardDayReportDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WardDayReportDtoBuilder result,
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
        case r'wardId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.wardId = valueDes;
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
        case r'lateCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.lateCount = valueDes;
          break;
        case r'halfDayCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.halfDayCount = valueDes;
          break;
        case r'absentCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.absentCount = valueDes;
          break;
        case r'onLeaveCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.onLeaveCount = valueDes;
          break;
        case r'proxyCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.proxyCount = valueDes;
          break;
        case r'autoCheckoutCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.autoCheckoutCount = valueDes;
          break;
        case r'suspiciousCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.suspiciousCount = valueDes;
          break;
        case r'distanceM':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.distanceM = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WardDayReportDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WardDayReportDtoBuilder();
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

