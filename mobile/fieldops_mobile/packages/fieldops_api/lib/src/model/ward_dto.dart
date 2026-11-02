//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ward_dto.g.dart';

/// WardDto
///
/// Properties:
/// * [id] 
/// * [code] 
/// * [name] 
/// * [nameMr] 
/// * [zone] 
/// * [boundary] 
/// * [isActive] 
/// * [version] 
/// * [createdAt] 
/// * [updatedAt] 
@BuiltValue()
abstract class WardDto implements Built<WardDto, WardDtoBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'nameMr')
  String get nameMr;

  @BuiltValueField(wireName: r'zone')
  WardDtoZoneEnum get zone;
  // enum zoneEnum {  SANGLI,  MIRAJ,  KUPWAD,  };

  @BuiltValueField(wireName: r'boundary')
  BuiltMap<String, JsonObject?> get boundary;

  @BuiltValueField(wireName: r'isActive')
  bool get isActive;

  @BuiltValueField(wireName: r'version')
  num get version;

  @BuiltValueField(wireName: r'createdAt')
  String get createdAt;

  @BuiltValueField(wireName: r'updatedAt')
  String get updatedAt;

  WardDto._();

  factory WardDto([void updates(WardDtoBuilder b)]) = _$WardDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WardDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WardDto> get serializer => _$WardDtoSerializer();
}

class _$WardDtoSerializer implements PrimitiveSerializer<WardDto> {
  @override
  final Iterable<Type> types = const [WardDto, _$WardDto];

  @override
  final String wireName = r'WardDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WardDto object, {
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
      specifiedType: const FullType(WardDtoZoneEnum),
    );
    yield r'boundary';
    yield serializers.serialize(
      object.boundary,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'isActive';
    yield serializers.serialize(
      object.isActive,
      specifiedType: const FullType(bool),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(num),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(String),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    WardDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WardDtoBuilder result,
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
            specifiedType: const FullType(WardDtoZoneEnum),
          ) as WardDtoZoneEnum;
          result.zone = valueDes;
          break;
        case r'boundary':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.boundary.replace(valueDes);
          break;
        case r'isActive':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isActive = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.version = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.createdAt = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WardDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WardDtoBuilder();
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

class WardDtoZoneEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SANGLI')
  static const WardDtoZoneEnum SANGLI = _$wardDtoZoneEnum_SANGLI;
  @BuiltValueEnumConst(wireName: r'MIRAJ')
  static const WardDtoZoneEnum MIRAJ = _$wardDtoZoneEnum_MIRAJ;
  @BuiltValueEnumConst(wireName: r'KUPWAD')
  static const WardDtoZoneEnum KUPWAD = _$wardDtoZoneEnum_KUPWAD;

  static Serializer<WardDtoZoneEnum> get serializer => _$wardDtoZoneEnumSerializer;

  const WardDtoZoneEnum._(String name): super(name);

  static BuiltSet<WardDtoZoneEnum> get values => _$wardDtoZoneEnumValues;
  static WardDtoZoneEnum valueOf(String name) => _$wardDtoZoneEnumValueOf(name);
}

