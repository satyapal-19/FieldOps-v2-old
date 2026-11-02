//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'staff_profile_dto.g.dart';

/// StaffProfileDto
///
/// Properties:
/// * [id] 
/// * [employeeCode] 
/// * [fullName] 
/// * [fullNameMr] 
/// * [phone] - Masked except for admins
/// * [role] 
/// * [homeWardId] 
/// * [officeId] 
/// * [reportsToId] 
/// * [department] 
/// * [shiftStart] 
/// * [shiftEnd] 
/// * [isActive] 
/// * [hasPassword] 
/// * [version] 
/// * [createdAt] 
/// * [updatedAt] 
@BuiltValue()
abstract class StaffProfileDto implements Built<StaffProfileDto, StaffProfileDtoBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'employeeCode')
  String get employeeCode;

  @BuiltValueField(wireName: r'fullName')
  String get fullName;

  @BuiltValueField(wireName: r'fullNameMr')
  String? get fullNameMr;

  /// Masked except for admins
  @BuiltValueField(wireName: r'phone')
  String get phone;

  @BuiltValueField(wireName: r'role')
  StaffProfileDtoRoleEnum get role;
  // enum roleEnum {  ADMIN,  WARD_INSPECTOR,  INSPECTOR,  WORKER,  OFFICE_STAFF,  };

  @BuiltValueField(wireName: r'homeWardId')
  String? get homeWardId;

  @BuiltValueField(wireName: r'officeId')
  String? get officeId;

  @BuiltValueField(wireName: r'reportsToId')
  String? get reportsToId;

  @BuiltValueField(wireName: r'department')
  String? get department;

  @BuiltValueField(wireName: r'shiftStart')
  String get shiftStart;

  @BuiltValueField(wireName: r'shiftEnd')
  String get shiftEnd;

  @BuiltValueField(wireName: r'isActive')
  bool get isActive;

  @BuiltValueField(wireName: r'hasPassword')
  bool get hasPassword;

  @BuiltValueField(wireName: r'version')
  num get version;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  StaffProfileDto._();

  factory StaffProfileDto([void updates(StaffProfileDtoBuilder b)]) = _$StaffProfileDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(StaffProfileDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<StaffProfileDto> get serializer => _$StaffProfileDtoSerializer();
}

class _$StaffProfileDtoSerializer implements PrimitiveSerializer<StaffProfileDto> {
  @override
  final Iterable<Type> types = const [StaffProfileDto, _$StaffProfileDto];

  @override
  final String wireName = r'StaffProfileDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    StaffProfileDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'employeeCode';
    yield serializers.serialize(
      object.employeeCode,
      specifiedType: const FullType(String),
    );
    yield r'fullName';
    yield serializers.serialize(
      object.fullName,
      specifiedType: const FullType(String),
    );
    yield r'fullNameMr';
    yield object.fullNameMr == null ? null : serializers.serialize(
      object.fullNameMr,
      specifiedType: const FullType.nullable(String),
    );
    yield r'phone';
    yield serializers.serialize(
      object.phone,
      specifiedType: const FullType(String),
    );
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(StaffProfileDtoRoleEnum),
    );
    yield r'homeWardId';
    yield object.homeWardId == null ? null : serializers.serialize(
      object.homeWardId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'officeId';
    yield object.officeId == null ? null : serializers.serialize(
      object.officeId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'reportsToId';
    yield object.reportsToId == null ? null : serializers.serialize(
      object.reportsToId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'department';
    yield object.department == null ? null : serializers.serialize(
      object.department,
      specifiedType: const FullType.nullable(String),
    );
    yield r'shiftStart';
    yield serializers.serialize(
      object.shiftStart,
      specifiedType: const FullType(String),
    );
    yield r'shiftEnd';
    yield serializers.serialize(
      object.shiftEnd,
      specifiedType: const FullType(String),
    );
    yield r'isActive';
    yield serializers.serialize(
      object.isActive,
      specifiedType: const FullType(bool),
    );
    yield r'hasPassword';
    yield serializers.serialize(
      object.hasPassword,
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
      specifiedType: const FullType(DateTime),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    StaffProfileDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required StaffProfileDtoBuilder result,
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
        case r'employeeCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.employeeCode = valueDes;
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
            specifiedType: const FullType(StaffProfileDtoRoleEnum),
          ) as StaffProfileDtoRoleEnum;
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
        case r'hasPassword':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hasPassword = valueDes;
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
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
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
  StaffProfileDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StaffProfileDtoBuilder();
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

class StaffProfileDtoRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ADMIN')
  static const StaffProfileDtoRoleEnum ADMIN = _$staffProfileDtoRoleEnum_ADMIN;
  @BuiltValueEnumConst(wireName: r'WARD_INSPECTOR')
  static const StaffProfileDtoRoleEnum WARD_INSPECTOR = _$staffProfileDtoRoleEnum_WARD_INSPECTOR;
  @BuiltValueEnumConst(wireName: r'INSPECTOR')
  static const StaffProfileDtoRoleEnum INSPECTOR = _$staffProfileDtoRoleEnum_INSPECTOR;
  @BuiltValueEnumConst(wireName: r'WORKER')
  static const StaffProfileDtoRoleEnum WORKER = _$staffProfileDtoRoleEnum_WORKER;
  @BuiltValueEnumConst(wireName: r'OFFICE_STAFF')
  static const StaffProfileDtoRoleEnum OFFICE_STAFF = _$staffProfileDtoRoleEnum_OFFICE_STAFF;

  static Serializer<StaffProfileDtoRoleEnum> get serializer => _$staffProfileDtoRoleEnumSerializer;

  const StaffProfileDtoRoleEnum._(String name): super(name);

  static BuiltSet<StaffProfileDtoRoleEnum> get values => _$staffProfileDtoRoleEnumValues;
  static StaffProfileDtoRoleEnum valueOf(String name) => _$staffProfileDtoRoleEnumValueOf(name);
}

