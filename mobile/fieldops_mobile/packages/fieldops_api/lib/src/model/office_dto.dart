//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'office_dto.g.dart';

/// OfficeDto
///
/// Properties:
/// * [id] 
/// * [code] 
/// * [name] 
/// * [nameMr] 
/// * [zone] 
/// * [premises] 
/// * [bufferMeters] 
/// * [isActive] 
/// * [version] 
/// * [createdAt] 
/// * [updatedAt] 
@BuiltValue()
abstract class OfficeDto implements Built<OfficeDto, OfficeDtoBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'nameMr')
  String get nameMr;

  @BuiltValueField(wireName: r'zone')
  OfficeDtoZoneEnum get zone;
  // enum zoneEnum {  SANGLI,  MIRAJ,  KUPWAD,  };

  @BuiltValueField(wireName: r'premises')
  BuiltMap<String, JsonObject?> get premises;

  @BuiltValueField(wireName: r'bufferMeters')
  num get bufferMeters;

  @BuiltValueField(wireName: r'isActive')
  bool get isActive;

  @BuiltValueField(wireName: r'version')
  num get version;

  @BuiltValueField(wireName: r'createdAt')
  String get createdAt;

  @BuiltValueField(wireName: r'updatedAt')
  String get updatedAt;

  OfficeDto._();

  factory OfficeDto([void updates(OfficeDtoBuilder b)]) = _$OfficeDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OfficeDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OfficeDto> get serializer => _$OfficeDtoSerializer();
}

class _$OfficeDtoSerializer implements PrimitiveSerializer<OfficeDto> {
  @override
  final Iterable<Type> types = const [OfficeDto, _$OfficeDto];

  @override
  final String wireName = r'OfficeDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OfficeDto object, {
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
      specifiedType: const FullType(OfficeDtoZoneEnum),
    );
    yield r'premises';
    yield serializers.serialize(
      object.premises,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'bufferMeters';
    yield serializers.serialize(
      object.bufferMeters,
      specifiedType: const FullType(num),
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
    OfficeDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OfficeDtoBuilder result,
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
            specifiedType: const FullType(OfficeDtoZoneEnum),
          ) as OfficeDtoZoneEnum;
          result.zone = valueDes;
          break;
        case r'premises':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.premises.replace(valueDes);
          break;
        case r'bufferMeters':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.bufferMeters = valueDes;
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
  OfficeDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OfficeDtoBuilder();
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

class OfficeDtoZoneEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SANGLI')
  static const OfficeDtoZoneEnum SANGLI = _$officeDtoZoneEnum_SANGLI;
  @BuiltValueEnumConst(wireName: r'MIRAJ')
  static const OfficeDtoZoneEnum MIRAJ = _$officeDtoZoneEnum_MIRAJ;
  @BuiltValueEnumConst(wireName: r'KUPWAD')
  static const OfficeDtoZoneEnum KUPWAD = _$officeDtoZoneEnum_KUPWAD;

  static Serializer<OfficeDtoZoneEnum> get serializer => _$officeDtoZoneEnumSerializer;

  const OfficeDtoZoneEnum._(String name): super(name);

  static BuiltSet<OfficeDtoZoneEnum> get values => _$officeDtoZoneEnumValues;
  static OfficeDtoZoneEnum valueOf(String name) => _$officeDtoZoneEnumValueOf(name);
}

