//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_complaint_dto.g.dart';

/// PublicComplaintDto
///
/// Properties:
/// * [trackingId] 
/// * [category] 
/// * [status] 
/// * [wardCode] 
/// * [createdAt] 
/// * [resolvedAt] 
@BuiltValue()
abstract class PublicComplaintDto implements Built<PublicComplaintDto, PublicComplaintDtoBuilder> {
  @BuiltValueField(wireName: r'trackingId')
  String get trackingId;

  @BuiltValueField(wireName: r'category')
  PublicComplaintDtoCategoryEnum get category;
  // enum categoryEnum {  GARBAGE,  DRAIN,  ROAD,  WATER,  TREE,  STRAY_ANIMAL,  OTHER,  };

  @BuiltValueField(wireName: r'status')
  PublicComplaintDtoStatusEnum get status;
  // enum statusEnum {  RECEIVED,  ASSIGNED,  IN_PROGRESS,  RESOLVED,  CLOSED,  REJECTED,  };

  @BuiltValueField(wireName: r'wardCode')
  String? get wardCode;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'resolvedAt')
  DateTime? get resolvedAt;

  PublicComplaintDto._();

  factory PublicComplaintDto([void updates(PublicComplaintDtoBuilder b)]) = _$PublicComplaintDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicComplaintDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicComplaintDto> get serializer => _$PublicComplaintDtoSerializer();
}

class _$PublicComplaintDtoSerializer implements PrimitiveSerializer<PublicComplaintDto> {
  @override
  final Iterable<Type> types = const [PublicComplaintDto, _$PublicComplaintDto];

  @override
  final String wireName = r'PublicComplaintDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicComplaintDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'trackingId';
    yield serializers.serialize(
      object.trackingId,
      specifiedType: const FullType(String),
    );
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(PublicComplaintDtoCategoryEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(PublicComplaintDtoStatusEnum),
    );
    yield r'wardCode';
    yield object.wardCode == null ? null : serializers.serialize(
      object.wardCode,
      specifiedType: const FullType.nullable(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'resolvedAt';
    yield object.resolvedAt == null ? null : serializers.serialize(
      object.resolvedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicComplaintDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicComplaintDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'trackingId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.trackingId = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicComplaintDtoCategoryEnum),
          ) as PublicComplaintDtoCategoryEnum;
          result.category = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicComplaintDtoStatusEnum),
          ) as PublicComplaintDtoStatusEnum;
          result.status = valueDes;
          break;
        case r'wardCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.wardCode = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'resolvedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.resolvedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublicComplaintDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicComplaintDtoBuilder();
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

class PublicComplaintDtoCategoryEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'GARBAGE')
  static const PublicComplaintDtoCategoryEnum GARBAGE = _$publicComplaintDtoCategoryEnum_GARBAGE;
  @BuiltValueEnumConst(wireName: r'DRAIN')
  static const PublicComplaintDtoCategoryEnum DRAIN = _$publicComplaintDtoCategoryEnum_DRAIN;
  @BuiltValueEnumConst(wireName: r'ROAD')
  static const PublicComplaintDtoCategoryEnum ROAD = _$publicComplaintDtoCategoryEnum_ROAD;
  @BuiltValueEnumConst(wireName: r'WATER')
  static const PublicComplaintDtoCategoryEnum WATER = _$publicComplaintDtoCategoryEnum_WATER;
  @BuiltValueEnumConst(wireName: r'TREE')
  static const PublicComplaintDtoCategoryEnum TREE = _$publicComplaintDtoCategoryEnum_TREE;
  @BuiltValueEnumConst(wireName: r'STRAY_ANIMAL')
  static const PublicComplaintDtoCategoryEnum STRAY_ANIMAL = _$publicComplaintDtoCategoryEnum_STRAY_ANIMAL;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const PublicComplaintDtoCategoryEnum OTHER = _$publicComplaintDtoCategoryEnum_OTHER;

  static Serializer<PublicComplaintDtoCategoryEnum> get serializer => _$publicComplaintDtoCategoryEnumSerializer;

  const PublicComplaintDtoCategoryEnum._(String name): super(name);

  static BuiltSet<PublicComplaintDtoCategoryEnum> get values => _$publicComplaintDtoCategoryEnumValues;
  static PublicComplaintDtoCategoryEnum valueOf(String name) => _$publicComplaintDtoCategoryEnumValueOf(name);
}

class PublicComplaintDtoStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'RECEIVED')
  static const PublicComplaintDtoStatusEnum RECEIVED = _$publicComplaintDtoStatusEnum_RECEIVED;
  @BuiltValueEnumConst(wireName: r'ASSIGNED')
  static const PublicComplaintDtoStatusEnum ASSIGNED = _$publicComplaintDtoStatusEnum_ASSIGNED;
  @BuiltValueEnumConst(wireName: r'IN_PROGRESS')
  static const PublicComplaintDtoStatusEnum IN_PROGRESS = _$publicComplaintDtoStatusEnum_IN_PROGRESS;
  @BuiltValueEnumConst(wireName: r'RESOLVED')
  static const PublicComplaintDtoStatusEnum RESOLVED = _$publicComplaintDtoStatusEnum_RESOLVED;
  @BuiltValueEnumConst(wireName: r'CLOSED')
  static const PublicComplaintDtoStatusEnum CLOSED = _$publicComplaintDtoStatusEnum_CLOSED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const PublicComplaintDtoStatusEnum REJECTED = _$publicComplaintDtoStatusEnum_REJECTED;

  static Serializer<PublicComplaintDtoStatusEnum> get serializer => _$publicComplaintDtoStatusEnumSerializer;

  const PublicComplaintDtoStatusEnum._(String name): super(name);

  static BuiltSet<PublicComplaintDtoStatusEnum> get values => _$publicComplaintDtoStatusEnumValues;
  static PublicComplaintDtoStatusEnum valueOf(String name) => _$publicComplaintDtoStatusEnumValueOf(name);
}

