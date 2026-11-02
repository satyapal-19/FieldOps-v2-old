//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_staff_dto.g.dart';

/// UpdateStaffDto
///
/// Properties:
/// * [expectedVersion] - The version you last read; stale versions get 409
/// * [fullName] 
/// * [fullNameMr] 
/// * [phone] 
/// * [role] 
/// * [homeWardId] - null clears it
/// * [officeId] 
/// * [reportsToId] 
/// * [department] 
/// * [shiftStart] 
/// * [shiftEnd] 
/// * [isActive] - false deactivates and signs the person out everywhere
@BuiltValue()
abstract class UpdateStaffDto implements Built<UpdateStaffDto, UpdateStaffDtoBuilder> {
  /// The version you last read; stale versions get 409
  @BuiltValueField(wireName: r'expectedVersion')
  num get expectedVersion;

  @BuiltValueField(wireName: r'fullName')
  String? get fullName;

  @BuiltValueField(wireName: r'fullNameMr')
  String? get fullNameMr;

  @BuiltValueField(wireName: r'phone')
  String? get phone;

  @BuiltValueField(wireName: r'role')
  UpdateStaffDtoRoleEnum? get role;
  // enum roleEnum {  ADMIN,  WARD_INSPECTOR,  INSPECTOR,  WORKER,  OFFICE_STAFF,  };

  /// null clears it
  @BuiltValueField(wireName: r'homeWardId')
  String? get homeWardId;

  @BuiltValueField(wireName: r'officeId')
  String? get officeId;

  @BuiltValueField(wireName: r'reportsToId')
  String? get reportsToId;

  @BuiltValueField(wireName: r'department')
  String? get department;

  @BuiltValueField(wireName: r'shiftStart')
  String? get shiftStart;

  @BuiltValueField(wireName: r'shiftEnd')
  String? get shiftEnd;

  /// false deactivates and signs the person out everywhere
  @BuiltValueField(wireName: r'isActive')
  bool? get isActive;

  UpdateStaffDto._();

  factory UpdateStaffDto([void updates(UpdateStaffDtoBuilder b)]) = _$UpdateStaffDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateStaffDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateStaffDto> get serializer => _$UpdateStaffDtoSerializer();
}

class _$UpdateStaffDtoSerializer implements PrimitiveSerializer<UpdateStaffDto> {
  @override
  final Iterable<Type> types = const [UpdateStaffDto, _$UpdateStaffDto];

  @override
  final String wireName = r'UpdateStaffDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateStaffDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'expectedVersion';
    yield serializers.serialize(
      object.expectedVersion,
      specifiedType: const FullType(num),
    );
    if (object.fullName != null) {
      yield r'fullName';
      yield serializers.serialize(
        object.fullName,
        specifiedType: const FullType(String),
      );
    }
    if (object.fullNameMr != null) {
      yield r'fullNameMr';
      yield serializers.serialize(
        object.fullNameMr,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.phone != null) {
      yield r'phone';
      yield serializers.serialize(
        object.phone,
        specifiedType: const FullType(String),
      );
    }
    if (object.role != null) {
      yield r'role';
      yield serializers.serialize(
        object.role,
        specifiedType: const FullType(UpdateStaffDtoRoleEnum),
      );
    }
    if (object.homeWardId != null) {
      yield r'homeWardId';
      yield serializers.serialize(
        object.homeWardId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.officeId != null) {
      yield r'officeId';
      yield serializers.serialize(
        object.officeId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.reportsToId != null) {
      yield r'reportsToId';
      yield serializers.serialize(
        object.reportsToId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.department != null) {
      yield r'department';
      yield serializers.serialize(
        object.department,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.shiftStart != null) {
      yield r'shiftStart';
      yield serializers.serialize(
        object.shiftStart,
        specifiedType: const FullType(String),
      );
    }
    if (object.shiftEnd != null) {
      yield r'shiftEnd';
      yield serializers.serialize(
        object.shiftEnd,
        specifiedType: const FullType(String),
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
    UpdateStaffDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateStaffDtoBuilder result,
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
        case r'fullName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fullName = valueDes;
          break;
        case r'fullNameMr':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.fullNameMr = valueDes;
          break;
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.phone = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UpdateStaffDtoRoleEnum),
          ) as UpdateStaffDtoRoleEnum;
          result.role = valueDes;
          break;
        case r'homeWardId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.homeWardId = valueDes;
          break;
        case r'officeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.officeId = valueDes;
          break;
        case r'reportsToId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reportsToId = valueDes;
          break;
        case r'department':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.department = valueDes;
          break;
        case r'shiftStart':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.shiftStart = valueDes;
          break;
        case r'shiftEnd':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.shiftEnd = valueDes;
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
  UpdateStaffDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateStaffDtoBuilder();
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

class UpdateStaffDtoRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ADMIN')
  static const UpdateStaffDtoRoleEnum ADMIN = _$updateStaffDtoRoleEnum_ADMIN;
  @BuiltValueEnumConst(wireName: r'WARD_INSPECTOR')
  static const UpdateStaffDtoRoleEnum WARD_INSPECTOR = _$updateStaffDtoRoleEnum_WARD_INSPECTOR;
  @BuiltValueEnumConst(wireName: r'INSPECTOR')
  static const UpdateStaffDtoRoleEnum INSPECTOR = _$updateStaffDtoRoleEnum_INSPECTOR;
  @BuiltValueEnumConst(wireName: r'WORKER')
  static const UpdateStaffDtoRoleEnum WORKER = _$updateStaffDtoRoleEnum_WORKER;
  @BuiltValueEnumConst(wireName: r'OFFICE_STAFF')
  static const UpdateStaffDtoRoleEnum OFFICE_STAFF = _$updateStaffDtoRoleEnum_OFFICE_STAFF;

  static Serializer<UpdateStaffDtoRoleEnum> get serializer => _$updateStaffDtoRoleEnumSerializer;

  const UpdateStaffDtoRoleEnum._(String name): super(name);

  static BuiltSet<UpdateStaffDtoRoleEnum> get values => _$updateStaffDtoRoleEnumValues;
  static UpdateStaffDtoRoleEnum valueOf(String name) => _$updateStaffDtoRoleEnumValueOf(name);
}

