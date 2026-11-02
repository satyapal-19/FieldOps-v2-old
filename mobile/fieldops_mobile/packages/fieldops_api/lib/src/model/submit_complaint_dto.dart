//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'submit_complaint_dto.g.dart';

/// SubmitComplaintDto
///
/// Properties:
/// * [clientUuid] - Makes a double-submitted form a duplicate
/// * [category] 
/// * [description] 
/// * [citizenName] 
/// * [citizenPhone] - For a call-back; never shown publicly
/// * [wardId] - If known; otherwise found from the location
/// * [lat] 
/// * [lng] 
@BuiltValue()
abstract class SubmitComplaintDto implements Built<SubmitComplaintDto, SubmitComplaintDtoBuilder> {
  /// Makes a double-submitted form a duplicate
  @BuiltValueField(wireName: r'clientUuid')
  String? get clientUuid;

  @BuiltValueField(wireName: r'category')
  SubmitComplaintDtoCategoryEnum get category;
  // enum categoryEnum {  GARBAGE,  DRAIN,  ROAD,  WATER,  TREE,  STRAY_ANIMAL,  OTHER,  };

  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'citizenName')
  String? get citizenName;

  /// For a call-back; never shown publicly
  @BuiltValueField(wireName: r'citizenPhone')
  String? get citizenPhone;

  /// If known; otherwise found from the location
  @BuiltValueField(wireName: r'wardId')
  String? get wardId;

  @BuiltValueField(wireName: r'lat')
  num? get lat;

  @BuiltValueField(wireName: r'lng')
  num? get lng;

  SubmitComplaintDto._();

  factory SubmitComplaintDto([void updates(SubmitComplaintDtoBuilder b)]) = _$SubmitComplaintDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SubmitComplaintDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SubmitComplaintDto> get serializer => _$SubmitComplaintDtoSerializer();
}

class _$SubmitComplaintDtoSerializer implements PrimitiveSerializer<SubmitComplaintDto> {
  @override
  final Iterable<Type> types = const [SubmitComplaintDto, _$SubmitComplaintDto];

  @override
  final String wireName = r'SubmitComplaintDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SubmitComplaintDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.clientUuid != null) {
      yield r'clientUuid';
      yield serializers.serialize(
        object.clientUuid,
        specifiedType: const FullType(String),
      );
    }
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(SubmitComplaintDtoCategoryEnum),
    );
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    if (object.citizenName != null) {
      yield r'citizenName';
      yield serializers.serialize(
        object.citizenName,
        specifiedType: const FullType(String),
      );
    }
    if (object.citizenPhone != null) {
      yield r'citizenPhone';
      yield serializers.serialize(
        object.citizenPhone,
        specifiedType: const FullType(String),
      );
    }
    if (object.wardId != null) {
      yield r'wardId';
      yield serializers.serialize(
        object.wardId,
        specifiedType: const FullType(String),
      );
    }
    if (object.lat != null) {
      yield r'lat';
      yield serializers.serialize(
        object.lat,
        specifiedType: const FullType(num),
      );
    }
    if (object.lng != null) {
      yield r'lng';
      yield serializers.serialize(
        object.lng,
        specifiedType: const FullType(num),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SubmitComplaintDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SubmitComplaintDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'clientUuid':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.clientUuid = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SubmitComplaintDtoCategoryEnum),
          ) as SubmitComplaintDtoCategoryEnum;
          result.category = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'citizenName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.citizenName = valueDes;
          break;
        case r'citizenPhone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.citizenPhone = valueDes;
          break;
        case r'wardId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.wardId = valueDes;
          break;
        case r'lat':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.lat = valueDes;
          break;
        case r'lng':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.lng = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SubmitComplaintDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SubmitComplaintDtoBuilder();
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

class SubmitComplaintDtoCategoryEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'GARBAGE')
  static const SubmitComplaintDtoCategoryEnum GARBAGE = _$submitComplaintDtoCategoryEnum_GARBAGE;
  @BuiltValueEnumConst(wireName: r'DRAIN')
  static const SubmitComplaintDtoCategoryEnum DRAIN = _$submitComplaintDtoCategoryEnum_DRAIN;
  @BuiltValueEnumConst(wireName: r'ROAD')
  static const SubmitComplaintDtoCategoryEnum ROAD = _$submitComplaintDtoCategoryEnum_ROAD;
  @BuiltValueEnumConst(wireName: r'WATER')
  static const SubmitComplaintDtoCategoryEnum WATER = _$submitComplaintDtoCategoryEnum_WATER;
  @BuiltValueEnumConst(wireName: r'TREE')
  static const SubmitComplaintDtoCategoryEnum TREE = _$submitComplaintDtoCategoryEnum_TREE;
  @BuiltValueEnumConst(wireName: r'STRAY_ANIMAL')
  static const SubmitComplaintDtoCategoryEnum STRAY_ANIMAL = _$submitComplaintDtoCategoryEnum_STRAY_ANIMAL;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const SubmitComplaintDtoCategoryEnum OTHER = _$submitComplaintDtoCategoryEnum_OTHER;

  static Serializer<SubmitComplaintDtoCategoryEnum> get serializer => _$submitComplaintDtoCategoryEnumSerializer;

  const SubmitComplaintDtoCategoryEnum._(String name): super(name);

  static BuiltSet<SubmitComplaintDtoCategoryEnum> get values => _$submitComplaintDtoCategoryEnumValues;
  static SubmitComplaintDtoCategoryEnum valueOf(String name) => _$submitComplaintDtoCategoryEnumValueOf(name);
}

