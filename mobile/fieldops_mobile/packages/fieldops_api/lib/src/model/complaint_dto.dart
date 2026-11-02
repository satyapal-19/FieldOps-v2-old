//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:fieldops_api/src/model/task_dto.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'complaint_dto.g.dart';

/// ComplaintDto
///
/// Properties:
/// * [id] 
/// * [trackingId] 
/// * [category] 
/// * [description] 
/// * [status] 
/// * [wardId] 
/// * [citizenName] 
/// * [citizenPhone] - Masked unless you may call back
/// * [lat] 
/// * [lng] 
/// * [resolvedAt] 
/// * [version] 
/// * [createdAt] 
/// * [tasks] - Linked tasks (single-complaint view only)
@BuiltValue()
abstract class ComplaintDto implements Built<ComplaintDto, ComplaintDtoBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'trackingId')
  String get trackingId;

  @BuiltValueField(wireName: r'category')
  ComplaintDtoCategoryEnum get category;
  // enum categoryEnum {  GARBAGE,  DRAIN,  ROAD,  WATER,  TREE,  STRAY_ANIMAL,  OTHER,  };

  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'status')
  ComplaintDtoStatusEnum get status;
  // enum statusEnum {  RECEIVED,  ASSIGNED,  IN_PROGRESS,  RESOLVED,  CLOSED,  REJECTED,  };

  @BuiltValueField(wireName: r'wardId')
  String? get wardId;

  @BuiltValueField(wireName: r'citizenName')
  String? get citizenName;

  /// Masked unless you may call back
  @BuiltValueField(wireName: r'citizenPhone')
  String? get citizenPhone;

  @BuiltValueField(wireName: r'lat')
  num? get lat;

  @BuiltValueField(wireName: r'lng')
  num? get lng;

  @BuiltValueField(wireName: r'resolvedAt')
  DateTime? get resolvedAt;

  @BuiltValueField(wireName: r'version')
  num get version;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  /// Linked tasks (single-complaint view only)
  @BuiltValueField(wireName: r'tasks')
  BuiltList<TaskDto>? get tasks;

  ComplaintDto._();

  factory ComplaintDto([void updates(ComplaintDtoBuilder b)]) = _$ComplaintDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ComplaintDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ComplaintDto> get serializer => _$ComplaintDtoSerializer();
}

class _$ComplaintDtoSerializer implements PrimitiveSerializer<ComplaintDto> {
  @override
  final Iterable<Type> types = const [ComplaintDto, _$ComplaintDto];

  @override
  final String wireName = r'ComplaintDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ComplaintDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'trackingId';
    yield serializers.serialize(
      object.trackingId,
      specifiedType: const FullType(String),
    );
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(ComplaintDtoCategoryEnum),
    );
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ComplaintDtoStatusEnum),
    );
    yield r'wardId';
    yield object.wardId == null ? null : serializers.serialize(
      object.wardId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'citizenName';
    yield object.citizenName == null ? null : serializers.serialize(
      object.citizenName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'citizenPhone';
    yield object.citizenPhone == null ? null : serializers.serialize(
      object.citizenPhone,
      specifiedType: const FullType.nullable(String),
    );
    yield r'lat';
    yield object.lat == null ? null : serializers.serialize(
      object.lat,
      specifiedType: const FullType.nullable(num),
    );
    yield r'lng';
    yield object.lng == null ? null : serializers.serialize(
      object.lng,
      specifiedType: const FullType.nullable(num),
    );
    yield r'resolvedAt';
    yield object.resolvedAt == null ? null : serializers.serialize(
      object.resolvedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(num),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.tasks != null) {
      yield r'tasks';
      yield serializers.serialize(
        object.tasks,
        specifiedType: const FullType(BuiltList, [FullType(TaskDto)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ComplaintDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ComplaintDtoBuilder result,
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
            specifiedType: const FullType(ComplaintDtoCategoryEnum),
          ) as ComplaintDtoCategoryEnum;
          result.category = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ComplaintDtoStatusEnum),
          ) as ComplaintDtoStatusEnum;
          result.status = valueDes;
          break;
        case r'wardId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.wardId = valueDes;
          break;
        case r'citizenName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.citizenName = valueDes;
          break;
        case r'citizenPhone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.citizenPhone = valueDes;
          break;
        case r'lat':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.lat = valueDes;
          break;
        case r'lng':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.lng = valueDes;
          break;
        case r'resolvedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.resolvedAt = valueDes;
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
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'tasks':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TaskDto)]),
          ) as BuiltList<TaskDto>;
          result.tasks.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ComplaintDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ComplaintDtoBuilder();
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

class ComplaintDtoCategoryEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'GARBAGE')
  static const ComplaintDtoCategoryEnum GARBAGE = _$complaintDtoCategoryEnum_GARBAGE;
  @BuiltValueEnumConst(wireName: r'DRAIN')
  static const ComplaintDtoCategoryEnum DRAIN = _$complaintDtoCategoryEnum_DRAIN;
  @BuiltValueEnumConst(wireName: r'ROAD')
  static const ComplaintDtoCategoryEnum ROAD = _$complaintDtoCategoryEnum_ROAD;
  @BuiltValueEnumConst(wireName: r'WATER')
  static const ComplaintDtoCategoryEnum WATER = _$complaintDtoCategoryEnum_WATER;
  @BuiltValueEnumConst(wireName: r'TREE')
  static const ComplaintDtoCategoryEnum TREE = _$complaintDtoCategoryEnum_TREE;
  @BuiltValueEnumConst(wireName: r'STRAY_ANIMAL')
  static const ComplaintDtoCategoryEnum STRAY_ANIMAL = _$complaintDtoCategoryEnum_STRAY_ANIMAL;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const ComplaintDtoCategoryEnum OTHER = _$complaintDtoCategoryEnum_OTHER;

  static Serializer<ComplaintDtoCategoryEnum> get serializer => _$complaintDtoCategoryEnumSerializer;

  const ComplaintDtoCategoryEnum._(String name): super(name);

  static BuiltSet<ComplaintDtoCategoryEnum> get values => _$complaintDtoCategoryEnumValues;
  static ComplaintDtoCategoryEnum valueOf(String name) => _$complaintDtoCategoryEnumValueOf(name);
}

class ComplaintDtoStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'RECEIVED')
  static const ComplaintDtoStatusEnum RECEIVED = _$complaintDtoStatusEnum_RECEIVED;
  @BuiltValueEnumConst(wireName: r'ASSIGNED')
  static const ComplaintDtoStatusEnum ASSIGNED = _$complaintDtoStatusEnum_ASSIGNED;
  @BuiltValueEnumConst(wireName: r'IN_PROGRESS')
  static const ComplaintDtoStatusEnum IN_PROGRESS = _$complaintDtoStatusEnum_IN_PROGRESS;
  @BuiltValueEnumConst(wireName: r'RESOLVED')
  static const ComplaintDtoStatusEnum RESOLVED = _$complaintDtoStatusEnum_RESOLVED;
  @BuiltValueEnumConst(wireName: r'CLOSED')
  static const ComplaintDtoStatusEnum CLOSED = _$complaintDtoStatusEnum_CLOSED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const ComplaintDtoStatusEnum REJECTED = _$complaintDtoStatusEnum_REJECTED;

  static Serializer<ComplaintDtoStatusEnum> get serializer => _$complaintDtoStatusEnumSerializer;

  const ComplaintDtoStatusEnum._(String name): super(name);

  static BuiltSet<ComplaintDtoStatusEnum> get values => _$complaintDtoStatusEnumValues;
  static ComplaintDtoStatusEnum valueOf(String name) => _$complaintDtoStatusEnumValueOf(name);
}

