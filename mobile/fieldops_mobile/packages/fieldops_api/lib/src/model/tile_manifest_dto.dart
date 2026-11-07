//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tile_manifest_dto.g.dart';

/// TileManifestDto
///
/// Properties:
/// * [available] - False when no offline pack is installed (use the public OSM server)
/// * [minZoom] 
/// * [maxZoom] 
/// * [bounds] - [west, south, east, north] of the pack
/// * [attribution] 
/// * [builtAt] - When the pack was built
@BuiltValue()
abstract class TileManifestDto implements Built<TileManifestDto, TileManifestDtoBuilder> {
  /// False when no offline pack is installed (use the public OSM server)
  @BuiltValueField(wireName: r'available')
  bool get available;

  @BuiltValueField(wireName: r'minZoom')
  num? get minZoom;

  @BuiltValueField(wireName: r'maxZoom')
  num? get maxZoom;

  /// [west, south, east, north] of the pack
  @BuiltValueField(wireName: r'bounds')
  BuiltList<num>? get bounds;

  @BuiltValueField(wireName: r'attribution')
  String get attribution;

  /// When the pack was built
  @BuiltValueField(wireName: r'builtAt')
  String? get builtAt;

  TileManifestDto._();

  factory TileManifestDto([void updates(TileManifestDtoBuilder b)]) = _$TileManifestDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TileManifestDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TileManifestDto> get serializer => _$TileManifestDtoSerializer();
}

class _$TileManifestDtoSerializer implements PrimitiveSerializer<TileManifestDto> {
  @override
  final Iterable<Type> types = const [TileManifestDto, _$TileManifestDto];

  @override
  final String wireName = r'TileManifestDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TileManifestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'available';
    yield serializers.serialize(
      object.available,
      specifiedType: const FullType(bool),
    );
    yield r'minZoom';
    yield object.minZoom == null ? null : serializers.serialize(
      object.minZoom,
      specifiedType: const FullType.nullable(num),
    );
    yield r'maxZoom';
    yield object.maxZoom == null ? null : serializers.serialize(
      object.maxZoom,
      specifiedType: const FullType.nullable(num),
    );
    yield r'bounds';
    yield object.bounds == null ? null : serializers.serialize(
      object.bounds,
      specifiedType: const FullType.nullable(BuiltList, [FullType(num)]),
    );
    yield r'attribution';
    yield serializers.serialize(
      object.attribution,
      specifiedType: const FullType(String),
    );
    yield r'builtAt';
    yield object.builtAt == null ? null : serializers.serialize(
      object.builtAt,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TileManifestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TileManifestDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.available = valueDes;
          break;
        case r'minZoom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.minZoom = valueDes;
          break;
        case r'maxZoom':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.maxZoom = valueDes;
          break;
        case r'bounds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(num)]),
          ) as BuiltList<num>?;
          if (valueDes == null) continue;
          result.bounds.replace(valueDes);
          break;
        case r'attribution':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.attribution = valueDes;
          break;
        case r'builtAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.builtAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TileManifestDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TileManifestDtoBuilder();
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

