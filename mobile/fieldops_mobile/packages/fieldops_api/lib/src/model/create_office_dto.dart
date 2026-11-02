//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_office_dto.g.dart';

/// CreateOfficeDto
///
/// Properties:
/// * [code] 
/// * [name] 
/// * [nameMr] 
/// * [zone] 
/// * [premises] 
/// * [bufferMeters] 
@BuiltValue()
abstract class CreateOfficeDto implements Built<CreateOfficeDto, CreateOfficeDtoBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'nameMr')
  String get nameMr;

  @BuiltValueField(wireName: r'zone')
  CreateOfficeDtoZoneEnum get zone;
  // enum zoneEnum {  SANGLI,  MIRAJ,  KUPWAD,  };

  @BuiltValueField(wireName: r'premises')
  BuiltMap<String, JsonObject?> get premises;

  @BuiltValueField(wireName: r'bufferMeters')
  num? get bufferMeters;

  CreateOfficeDto._();

  factory CreateOfficeDto([void updates(CreateOfficeDtoBuilder b)]) = _$CreateOfficeDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateOfficeDtoBuilder b) => b
      ..bufferMeters = 100;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateOfficeDto> get serializer => _$CreateOfficeDtoSerializer();
}

class _$CreateOfficeDtoSerializer implements PrimitiveSerializer<CreateOfficeDto> {
  @override
  final Iterable<Type> types = const [CreateOfficeDto, _$CreateOfficeDto];

  @override
  final String wireName = r'CreateOfficeDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateOfficeDto object, {
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
      specifiedType: const FullType(CreateOfficeDtoZoneEnum),
    );
    yield r'premises';
    yield serializers.serialize(
      object.premises,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    if (object.bufferMeters != null) {
      yield r'bufferMeters';
      yield serializers.serialize(
        object.bufferMeters,
        specifiedType: const FullType(num),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateOfficeDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateOfficeDtoBuilder result,
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
            specifiedType: const FullType(CreateOfficeDtoZoneEnum),
          ) as CreateOfficeDtoZoneEnum;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateOfficeDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateOfficeDtoBuilder();
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

class CreateOfficeDtoZoneEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SANGLI')
  static const CreateOfficeDtoZoneEnum SANGLI = _$createOfficeDtoZoneEnum_SANGLI;
  @BuiltValueEnumConst(wireName: r'MIRAJ')
  static const CreateOfficeDtoZoneEnum MIRAJ = _$createOfficeDtoZoneEnum_MIRAJ;
  @BuiltValueEnumConst(wireName: r'KUPWAD')
  static const CreateOfficeDtoZoneEnum KUPWAD = _$createOfficeDtoZoneEnum_KUPWAD;

  static Serializer<CreateOfficeDtoZoneEnum> get serializer => _$createOfficeDtoZoneEnumSerializer;

  const CreateOfficeDtoZoneEnum._(String name): super(name);

  static BuiltSet<CreateOfficeDtoZoneEnum> get values => _$createOfficeDtoZoneEnumValues;
  static CreateOfficeDtoZoneEnum valueOf(String name) => _$createOfficeDtoZoneEnumValueOf(name);
}

