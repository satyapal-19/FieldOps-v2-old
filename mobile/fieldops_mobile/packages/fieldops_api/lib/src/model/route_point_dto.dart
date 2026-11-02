//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'route_point_dto.g.dart';

/// RoutePointDto
///
/// Properties:
/// * [latitude] 
/// * [longitude] 
/// * [accuracyM] 
/// * [recordedAt] 
/// * [inWard] - Null before check-in
/// * [isStationary] 
/// * [isMocked] 
/// * [fromOffline] - Buffered on the phone and uploaded later
@BuiltValue()
abstract class RoutePointDto implements Built<RoutePointDto, RoutePointDtoBuilder> {
  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  @BuiltValueField(wireName: r'accuracyM')
  num? get accuracyM;

  @BuiltValueField(wireName: r'recordedAt')
  DateTime get recordedAt;

  /// Null before check-in
  @BuiltValueField(wireName: r'inWard')
  bool? get inWard;

  @BuiltValueField(wireName: r'isStationary')
  bool get isStationary;

  @BuiltValueField(wireName: r'isMocked')
  bool get isMocked;

  /// Buffered on the phone and uploaded later
  @BuiltValueField(wireName: r'fromOffline')
  bool get fromOffline;

  RoutePointDto._();

  factory RoutePointDto([void updates(RoutePointDtoBuilder b)]) = _$RoutePointDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RoutePointDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RoutePointDto> get serializer => _$RoutePointDtoSerializer();
}

class _$RoutePointDtoSerializer implements PrimitiveSerializer<RoutePointDto> {
  @override
  final Iterable<Type> types = const [RoutePointDto, _$RoutePointDto];

  @override
  final String wireName = r'RoutePointDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RoutePointDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'accuracyM';
    yield object.accuracyM == null ? null : serializers.serialize(
      object.accuracyM,
      specifiedType: const FullType.nullable(num),
    );
    yield r'recordedAt';
    yield serializers.serialize(
      object.recordedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'inWard';
    yield object.inWard == null ? null : serializers.serialize(
      object.inWard,
      specifiedType: const FullType.nullable(bool),
    );
    yield r'isStationary';
    yield serializers.serialize(
      object.isStationary,
      specifiedType: const FullType(bool),
    );
    yield r'isMocked';
    yield serializers.serialize(
      object.isMocked,
      specifiedType: const FullType(bool),
    );
    yield r'fromOffline';
    yield serializers.serialize(
      object.fromOffline,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RoutePointDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RoutePointDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.accuracyM = valueDes;
          break;
        case r'recordedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.recordedAt = valueDes;
          break;
        case r'inWard':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.inWard = valueDes;
          break;
        case r'isStationary':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isStationary = valueDes;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RoutePointDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RoutePointDtoBuilder();
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

