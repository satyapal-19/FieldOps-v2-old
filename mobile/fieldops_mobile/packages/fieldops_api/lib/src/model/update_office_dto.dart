//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_office_dto.g.dart';

/// UpdateOfficeDto
///
/// Properties:
/// * [expectedVersion] 
/// * [name] 
/// * [nameMr] 
/// * [zone] 
/// * [premises] 
/// * [bufferMeters] 
/// * [isActive] 
@BuiltValue()
abstract class UpdateOfficeDto implements Built<UpdateOfficeDto, UpdateOfficeDtoBuilder> {
  @BuiltValueField(wireName: r'expectedVersion')
  num get expectedVersion;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'nameMr')
  String? get nameMr;

  @BuiltValueField(wireName: r'zone')
  UpdateOfficeDtoZoneEnum? get zone;
  // enum zoneEnum {  SANGLI,  MIRAJ,  KUPWAD,  };

  @BuiltValueField(wireName: r'premises')
  BuiltMap<String, JsonObject?>? get premises;

  @BuiltValueField(wireName: r'bufferMeters')
  num? get bufferMeters;

  @BuiltValueField(wireName: r'isActive')
  bool? get isActive;

  UpdateOfficeDto._();

  factory UpdateOfficeDto([void updates(UpdateOfficeDtoBuilder b)]) = _$UpdateOfficeDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateOfficeDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateOfficeDto> get serializer => _$UpdateOfficeDtoSerializer();
}

class _$UpdateOfficeDtoSerializer implements PrimitiveSerializer<UpdateOfficeDto> {
  @override
  final Iterable<Type> types = const [UpdateOfficeDto, _$UpdateOfficeDto];

  @override
  final String wireName = r'UpdateOfficeDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateOfficeDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'expectedVersion';
    yield serializers.serialize(
      object.expectedVersion,
      specifiedType: const FullType(num),
    );
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    if (object.nameMr != null) {
      yield r'nameMr';
      yield serializers.serialize(
        object.nameMr,
        specifiedType: const FullType(String),
      );
    }
    if (object.zone != null) {
      yield r'zone';
      yield serializers.serialize(
        object.zone,
        specifiedType: const FullType(UpdateOfficeDtoZoneEnum),
      );
    }
    if (object.premises != null) {
      yield r'premises';
      yield serializers.serialize(
        object.premises,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    if (object.bufferMeters != null) {
      yield r'bufferMeters';
      yield serializers.serialize(
        object.bufferMeters,
        specifiedType: const FullType(num),
      );
    }
    if (object.isActive != null) {
      yield r'isActive';
      yield serializers.serialize(
        object.isActive,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateOfficeDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateOfficeDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'expectedVersion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.expectedVersion = valueDes;
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
            specifiedType: const FullType(UpdateOfficeDtoZoneEnum),
          ) as UpdateOfficeDtoZoneEnum;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateOfficeDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateOfficeDtoBuilder();
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

class UpdateOfficeDtoZoneEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SANGLI')
  static const UpdateOfficeDtoZoneEnum SANGLI = _$updateOfficeDtoZoneEnum_SANGLI;
  @BuiltValueEnumConst(wireName: r'MIRAJ')
  static const UpdateOfficeDtoZoneEnum MIRAJ = _$updateOfficeDtoZoneEnum_MIRAJ;
  @BuiltValueEnumConst(wireName: r'KUPWAD')
  static const UpdateOfficeDtoZoneEnum KUPWAD = _$updateOfficeDtoZoneEnum_KUPWAD;

  static Serializer<UpdateOfficeDtoZoneEnum> get serializer => _$updateOfficeDtoZoneEnumSerializer;

  const UpdateOfficeDtoZoneEnum._(String name): super(name);

  static BuiltSet<UpdateOfficeDtoZoneEnum> get values => _$updateOfficeDtoZoneEnumValues;
  static UpdateOfficeDtoZoneEnum valueOf(String name) => _$updateOfficeDtoZoneEnumValueOf(name);
}

