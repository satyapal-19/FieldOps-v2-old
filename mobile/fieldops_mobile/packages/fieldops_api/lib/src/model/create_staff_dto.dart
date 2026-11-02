//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_staff_dto.g.dart';

/// CreateStaffDto
///
/// Properties:
/// * [employeeCode] - 2-20 letters, digits or hyphens; stored upper-case
/// * [fullName] 
/// * [fullNameMr] 
/// * [phone] - Indian mobile; +91 / 0 prefixes accepted
/// * [role] 
/// * [homeWardId] - Required for WARD_INSPECTOR, INSPECTOR, WORKER
/// * [officeId] - Required for OFFICE_STAFF
/// * [reportsToId] - Line manager: exactly the next rank up
/// * [department] 
/// * [shiftStart] - IST, 24-hour HH:MM
/// * [shiftEnd] 
/// * [initialPassword] - Only for ADMIN, WARD_INSPECTOR and OFFICE_STAFF (web sign-in). 10-72 characters.
@BuiltValue()
abstract class CreateStaffDto implements Built<CreateStaffDto, CreateStaffDtoBuilder> {
  /// 2-20 letters, digits or hyphens; stored upper-case
  @BuiltValueField(wireName: r'employeeCode')
  String get employeeCode;

  @BuiltValueField(wireName: r'fullName')
  String get fullName;

  @BuiltValueField(wireName: r'fullNameMr')
  String? get fullNameMr;

  /// Indian mobile; +91 / 0 prefixes accepted
  @BuiltValueField(wireName: r'phone')
  String get phone;

  @BuiltValueField(wireName: r'role')
  CreateStaffDtoRoleEnum get role;
  // enum roleEnum {  ADMIN,  WARD_INSPECTOR,  INSPECTOR,  WORKER,  OFFICE_STAFF,  };

  /// Required for WARD_INSPECTOR, INSPECTOR, WORKER
  @BuiltValueField(wireName: r'homeWardId')
  String? get homeWardId;

  /// Required for OFFICE_STAFF
  @BuiltValueField(wireName: r'officeId')
  String? get officeId;

  /// Line manager: exactly the next rank up
  @BuiltValueField(wireName: r'reportsToId')
  String? get reportsToId;

  @BuiltValueField(wireName: r'department')
  String? get department;

  /// IST, 24-hour HH:MM
  @BuiltValueField(wireName: r'shiftStart')
  String? get shiftStart;

  @BuiltValueField(wireName: r'shiftEnd')
  String? get shiftEnd;

  /// Only for ADMIN, WARD_INSPECTOR and OFFICE_STAFF (web sign-in). 10-72 characters.
  @BuiltValueField(wireName: r'initialPassword')
  String? get initialPassword;

  CreateStaffDto._();

  factory CreateStaffDto([void updates(CreateStaffDtoBuilder b)]) = _$CreateStaffDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateStaffDtoBuilder b) => b
      ..shiftStart = '06:00'
      ..shiftEnd = '14:00';

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateStaffDto> get serializer => _$CreateStaffDtoSerializer();
}

class _$CreateStaffDtoSerializer implements PrimitiveSerializer<CreateStaffDto> {
  @override
  final Iterable<Type> types = const [CreateStaffDto, _$CreateStaffDto];

  @override
  final String wireName = r'CreateStaffDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateStaffDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    if (object.fullNameMr != null) {
      yield r'fullNameMr';
      yield serializers.serialize(
        object.fullNameMr,
        specifiedType: const FullType(String),
      );
    }
    yield r'phone';
    yield serializers.serialize(
      object.phone,
      specifiedType: const FullType(String),
    );
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(CreateStaffDtoRoleEnum),
    );
    if (object.homeWardId != null) {
      yield r'homeWardId';
      yield serializers.serialize(
        object.homeWardId,
        specifiedType: const FullType(String),
      );
    }
    if (object.officeId != null) {
      yield r'officeId';
      yield serializers.serialize(
        object.officeId,
        specifiedType: const FullType(String),
      );
    }
    if (object.reportsToId != null) {
      yield r'reportsToId';
      yield serializers.serialize(
        object.reportsToId,
        specifiedType: const FullType(String),
      );
    }
    if (object.department != null) {
      yield r'department';
      yield serializers.serialize(
        object.department,
        specifiedType: const FullType(String),
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
    if (object.initialPassword != null) {
      yield r'initialPassword';
      yield serializers.serialize(
        object.initialPassword,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateStaffDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateStaffDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
            specifiedType: const FullType(String),
          ) as String;
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
            specifiedType: const FullType(CreateStaffDtoRoleEnum),
          ) as CreateStaffDtoRoleEnum;
          result.role = valueDes;
          break;
        case r'homeWardId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.homeWardId = valueDes;
          break;
        case r'officeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.officeId = valueDes;
          break;
        case r'reportsToId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reportsToId = valueDes;
          break;
        case r'department':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
        case r'initialPassword':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.initialPassword = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateStaffDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateStaffDtoBuilder();
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

class CreateStaffDtoRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ADMIN')
  static const CreateStaffDtoRoleEnum ADMIN = _$createStaffDtoRoleEnum_ADMIN;
  @BuiltValueEnumConst(wireName: r'WARD_INSPECTOR')
  static const CreateStaffDtoRoleEnum WARD_INSPECTOR = _$createStaffDtoRoleEnum_WARD_INSPECTOR;
  @BuiltValueEnumConst(wireName: r'INSPECTOR')
  static const CreateStaffDtoRoleEnum INSPECTOR = _$createStaffDtoRoleEnum_INSPECTOR;
  @BuiltValueEnumConst(wireName: r'WORKER')
  static const CreateStaffDtoRoleEnum WORKER = _$createStaffDtoRoleEnum_WORKER;
  @BuiltValueEnumConst(wireName: r'OFFICE_STAFF')
  static const CreateStaffDtoRoleEnum OFFICE_STAFF = _$createStaffDtoRoleEnum_OFFICE_STAFF;

  static Serializer<CreateStaffDtoRoleEnum> get serializer => _$createStaffDtoRoleEnumSerializer;

  const CreateStaffDtoRoleEnum._(String name): super(name);

  static BuiltSet<CreateStaffDtoRoleEnum> get values => _$createStaffDtoRoleEnumValues;
  static CreateStaffDtoRoleEnum valueOf(String name) => _$createStaffDtoRoleEnumValueOf(name);
}

