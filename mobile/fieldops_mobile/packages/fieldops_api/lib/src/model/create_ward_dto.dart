//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_ward_dto.g.dart';

/// CreateWardDto
///
/// Properties:
/// * [code] - Unique ward code (A-Z, 0-9, _ or -)
/// * [name] 
/// * [nameMr] 
/// * [zone] 
/// * [boundary] - GeoJSON Polygon or MultiPolygon, coordinates as [longitude, latitude]
@BuiltValue()
abstract class CreateWardDto implements Built<CreateWardDto, CreateWardDtoBuilder> {
  /// Unique ward code (A-Z, 0-9, _ or -)
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'nameMr')
  String get nameMr;

  @BuiltValueField(wireName: r'zone')
  CreateWardDtoZoneEnum get zone;
  // enum zoneEnum {  SANGLI,  MIRAJ,  KUPWAD,  };

  /// GeoJSON Polygon or MultiPolygon, coordinates as [longitude, latitude]
  @BuiltValueField(wireName: r'boundary')
  BuiltMap<String, JsonObject?> get boundary;

  CreateWardDto._();

  factory CreateWardDto([void updates(CreateWardDtoBuilder b)]) = _$CreateWardDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateWardDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateWardDto> get serializer => _$CreateWardDtoSerializer();
}

class _$CreateWardDtoSerializer implements PrimitiveSerializer<CreateWardDto> {
  @override
  final Iterable<Type> types = const [CreateWardDto, _$CreateWardDto];

  @override
  final String wireName = r'CreateWardDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateWardDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
      specifiedType: const FullType(CreateWardDtoZoneEnum),
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
    CreateWardDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateWardDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
            specifiedType: const FullType(CreateWardDtoZoneEnum),
          ) as CreateWardDtoZoneEnum;
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
  CreateWardDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateWardDtoBuilder();
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

class CreateWardDtoZoneEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SANGLI')
  static const CreateWardDtoZoneEnum SANGLI = _$createWardDtoZoneEnum_SANGLI;
  @BuiltValueEnumConst(wireName: r'MIRAJ')
  static const CreateWardDtoZoneEnum MIRAJ = _$createWardDtoZoneEnum_MIRAJ;
  @BuiltValueEnumConst(wireName: r'KUPWAD')
  static const CreateWardDtoZoneEnum KUPWAD = _$createWardDtoZoneEnum_KUPWAD;

  static Serializer<CreateWardDtoZoneEnum> get serializer => _$createWardDtoZoneEnumSerializer;

  const CreateWardDtoZoneEnum._(String name): super(name);

  static BuiltSet<CreateWardDtoZoneEnum> get values => _$createWardDtoZoneEnumValues;
  static CreateWardDtoZoneEnum valueOf(String name) => _$createWardDtoZoneEnumValueOf(name);
}

