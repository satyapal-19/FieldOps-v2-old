//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_ward_dto.g.dart';

/// UpdateWardDto
///
/// Properties:
/// * [expectedVersion] - The version you last read; stale versions get 409
/// * [name] 
/// * [nameMr] 
/// * [zone] 
/// * [boundary] 
/// * [isActive] 
@BuiltValue()
abstract class UpdateWardDto implements Built<UpdateWardDto, UpdateWardDtoBuilder> {
  /// The version you last read; stale versions get 409
  @BuiltValueField(wireName: r'expectedVersion')
  num get expectedVersion;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'nameMr')
  String? get nameMr;

  @BuiltValueField(wireName: r'zone')
  UpdateWardDtoZoneEnum? get zone;
  // enum zoneEnum {  SANGLI,  MIRAJ,  KUPWAD,  };

  @BuiltValueField(wireName: r'boundary')
  BuiltMap<String, JsonObject?>? get boundary;

  @BuiltValueField(wireName: r'isActive')
  bool? get isActive;

  UpdateWardDto._();

  factory UpdateWardDto([void updates(UpdateWardDtoBuilder b)]) = _$UpdateWardDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateWardDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateWardDto> get serializer => _$UpdateWardDtoSerializer();
}

class _$UpdateWardDtoSerializer implements PrimitiveSerializer<UpdateWardDto> {
  @override
  final Iterable<Type> types = const [UpdateWardDto, _$UpdateWardDto];

  @override
  final String wireName = r'UpdateWardDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateWardDto object, {
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
        specifiedType: const FullType(UpdateWardDtoZoneEnum),
      );
    }
    if (object.boundary != null) {
      yield r'boundary';
      yield serializers.serialize(
        object.boundary,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
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
    UpdateWardDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateWardDtoBuilder result,
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
            specifiedType: const FullType(UpdateWardDtoZoneEnum),
          ) as UpdateWardDtoZoneEnum;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateWardDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateWardDtoBuilder();
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

class UpdateWardDtoZoneEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SANGLI')
  static const UpdateWardDtoZoneEnum SANGLI = _$updateWardDtoZoneEnum_SANGLI;
  @BuiltValueEnumConst(wireName: r'MIRAJ')
  static const UpdateWardDtoZoneEnum MIRAJ = _$updateWardDtoZoneEnum_MIRAJ;
  @BuiltValueEnumConst(wireName: r'KUPWAD')
  static const UpdateWardDtoZoneEnum KUPWAD = _$updateWardDtoZoneEnum_KUPWAD;

  static Serializer<UpdateWardDtoZoneEnum> get serializer => _$updateWardDtoZoneEnumSerializer;

  const UpdateWardDtoZoneEnum._(String name): super(name);

  static BuiltSet<UpdateWardDtoZoneEnum> get values => _$updateWardDtoZoneEnumValues;
  static UpdateWardDtoZoneEnum valueOf(String name) => _$updateWardDtoZoneEnumValueOf(name);
}

