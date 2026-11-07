//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_ward_dto.g.dart';

/// PublicWardDto
///
/// Properties:
/// * [id] 
/// * [code] 
/// * [name] 
/// * [nameMr] 
/// * [zone] 
/// * [boundary] - GeoJSON Polygon
@BuiltValue()
abstract class PublicWardDto implements Built<PublicWardDto, PublicWardDtoBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'nameMr')
  String get nameMr;

  @BuiltValueField(wireName: r'zone')
  PublicWardDtoZoneEnum get zone;
  // enum zoneEnum {  SANGLI,  MIRAJ,  KUPWAD,  };

  /// GeoJSON Polygon
  @BuiltValueField(wireName: r'boundary')
  BuiltMap<String, JsonObject?> get boundary;

  PublicWardDto._();

  factory PublicWardDto([void updates(PublicWardDtoBuilder b)]) = _$PublicWardDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicWardDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicWardDto> get serializer => _$PublicWardDtoSerializer();
}

class _$PublicWardDtoSerializer implements PrimitiveSerializer<PublicWardDto> {
  @override
  final Iterable<Type> types = const [PublicWardDto, _$PublicWardDto];

  @override
  final String wireName = r'PublicWardDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicWardDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'nameMr';
    yield serializers.serialize(
      object.nameMr,
      specifiedType: const FullType(String),
    );
    yield r'zone';
    yield serializers.serialize(
      object.zone,
      specifiedType: const FullType(PublicWardDtoZoneEnum),
    );
    yield r'boundary';
    yield serializers.serialize(
      object.boundary,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicWardDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicWardDtoBuilder result,
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
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'nameMr':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.nameMr = valueDes;
          break;
        case r'zone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicWardDtoZoneEnum),
          ) as PublicWardDtoZoneEnum;
          result.zone = valueDes;
          break;
        case r'boundary':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.boundary.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublicWardDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicWardDtoBuilder();
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

class PublicWardDtoZoneEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SANGLI')
  static const PublicWardDtoZoneEnum SANGLI = _$publicWardDtoZoneEnum_SANGLI;
  @BuiltValueEnumConst(wireName: r'MIRAJ')
  static const PublicWardDtoZoneEnum MIRAJ = _$publicWardDtoZoneEnum_MIRAJ;
  @BuiltValueEnumConst(wireName: r'KUPWAD')
  static const PublicWardDtoZoneEnum KUPWAD = _$publicWardDtoZoneEnum_KUPWAD;

  static Serializer<PublicWardDtoZoneEnum> get serializer => _$publicWardDtoZoneEnumSerializer;

  const PublicWardDtoZoneEnum._(String name): super(name);

  static BuiltSet<PublicWardDtoZoneEnum> get values => _$publicWardDtoZoneEnumValues;
  static PublicWardDtoZoneEnum valueOf(String name) => _$publicWardDtoZoneEnumValueOf(name);
}

