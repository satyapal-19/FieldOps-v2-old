// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_staff_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CreateStaffDtoRoleEnum _$createStaffDtoRoleEnum_ADMIN =
    const CreateStaffDtoRoleEnum._('ADMIN');
const CreateStaffDtoRoleEnum _$createStaffDtoRoleEnum_WARD_INSPECTOR =
    const CreateStaffDtoRoleEnum._('WARD_INSPECTOR');
const CreateStaffDtoRoleEnum _$createStaffDtoRoleEnum_INSPECTOR =
    const CreateStaffDtoRoleEnum._('INSPECTOR');
const CreateStaffDtoRoleEnum _$createStaffDtoRoleEnum_WORKER =
    const CreateStaffDtoRoleEnum._('WORKER');
const CreateStaffDtoRoleEnum _$createStaffDtoRoleEnum_OFFICE_STAFF =
    const CreateStaffDtoRoleEnum._('OFFICE_STAFF');

CreateStaffDtoRoleEnum _$createStaffDtoRoleEnumValueOf(String name) {
  switch (name) {
    case 'ADMIN':
      return _$createStaffDtoRoleEnum_ADMIN;
    case 'WARD_INSPECTOR':
      return _$createStaffDtoRoleEnum_WARD_INSPECTOR;
    case 'INSPECTOR':
      return _$createStaffDtoRoleEnum_INSPECTOR;
    case 'WORKER':
      return _$createStaffDtoRoleEnum_WORKER;
    case 'OFFICE_STAFF':
      return _$createStaffDtoRoleEnum_OFFICE_STAFF;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CreateStaffDtoRoleEnum> _$createStaffDtoRoleEnumValues =
    BuiltSet<CreateStaffDtoRoleEnum>(const <CreateStaffDtoRoleEnum>[
  _$createStaffDtoRoleEnum_ADMIN,
  _$createStaffDtoRoleEnum_WARD_INSPECTOR,
  _$createStaffDtoRoleEnum_INSPECTOR,
  _$createStaffDtoRoleEnum_WORKER,
  _$createStaffDtoRoleEnum_OFFICE_STAFF,
]);

Serializer<CreateStaffDtoRoleEnum> _$createStaffDtoRoleEnumSerializer =
    _$CreateStaffDtoRoleEnumSerializer();

class _$CreateStaffDtoRoleEnumSerializer
    implements PrimitiveSerializer<CreateStaffDtoRoleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ADMIN': 'ADMIN',
    'WARD_INSPECTOR': 'WARD_INSPECTOR',
    'INSPECTOR': 'INSPECTOR',
    'WORKER': 'WORKER',
    'OFFICE_STAFF': 'OFFICE_STAFF',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ADMIN': 'ADMIN',
    'WARD_INSPECTOR': 'WARD_INSPECTOR',
    'INSPECTOR': 'INSPECTOR',
    'WORKER': 'WORKER',
    'OFFICE_STAFF': 'OFFICE_STAFF',
  };

  @override
  final Iterable<Type> types = const <Type>[CreateStaffDtoRoleEnum];
  @override
  final String wireName = 'CreateStaffDtoRoleEnum';

  @override
  Object serialize(Serializers serializers, CreateStaffDtoRoleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CreateStaffDtoRoleEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CreateStaffDtoRoleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CreateStaffDto extends CreateStaffDto {
  @override
  final String employeeCode;
  @override
  final String fullName;
  @override
  final String? fullNameMr;
  @override
  final String phone;
  @override
  final CreateStaffDtoRoleEnum role;
  @override
  final String? homeWardId;
  @override
  final String? officeId;
  @override
  final String? reportsToId;
  @override
  final String? department;
  @override
  final String? shiftStart;
  @override
  final String? shiftEnd;
  @override
  final String? initialPassword;

  factory _$CreateStaffDto([void Function(CreateStaffDtoBuilder)? updates]) =>
      (CreateStaffDtoBuilder()..update(updates))._build();

  _$CreateStaffDto._(
      {required this.employeeCode,
      required this.fullName,
      this.fullNameMr,
      required this.phone,
      required this.role,
      this.homeWardId,
      this.officeId,
      this.reportsToId,
      this.department,
      this.shiftStart,
      this.shiftEnd,
      this.initialPassword})
      : super._();
  @override
  CreateStaffDto rebuild(void Function(CreateStaffDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateStaffDtoBuilder toBuilder() => CreateStaffDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateStaffDto &&
        employeeCode == other.employeeCode &&
        fullName == other.fullName &&
        fullNameMr == other.fullNameMr &&
        phone == other.phone &&
        role == other.role &&
        homeWardId == other.homeWardId &&
        officeId == other.officeId &&
        reportsToId == other.reportsToId &&
        department == other.department &&
        shiftStart == other.shiftStart &&
        shiftEnd == other.shiftEnd &&
        initialPassword == other.initialPassword;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, employeeCode.hashCode);
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, fullNameMr.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, homeWardId.hashCode);
    _$hash = $jc(_$hash, officeId.hashCode);
    _$hash = $jc(_$hash, reportsToId.hashCode);
    _$hash = $jc(_$hash, department.hashCode);
    _$hash = $jc(_$hash, shiftStart.hashCode);
    _$hash = $jc(_$hash, shiftEnd.hashCode);
    _$hash = $jc(_$hash, initialPassword.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateStaffDto')
          ..add('employeeCode', employeeCode)
          ..add('fullName', fullName)
          ..add('fullNameMr', fullNameMr)
          ..add('phone', phone)
          ..add('role', role)
          ..add('homeWardId', homeWardId)
          ..add('officeId', officeId)
          ..add('reportsToId', reportsToId)
          ..add('department', department)
          ..add('shiftStart', shiftStart)
          ..add('shiftEnd', shiftEnd)
          ..add('initialPassword', initialPassword))
        .toString();
  }
}

class CreateStaffDtoBuilder
    implements Builder<CreateStaffDto, CreateStaffDtoBuilder> {
  _$CreateStaffDto? _$v;

  String? _employeeCode;
  String? get employeeCode => _$this._employeeCode;
  set employeeCode(String? employeeCode) => _$this._employeeCode = employeeCode;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _fullNameMr;
  String? get fullNameMr => _$this._fullNameMr;
  set fullNameMr(String? fullNameMr) => _$this._fullNameMr = fullNameMr;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  CreateStaffDtoRoleEnum? _role;
  CreateStaffDtoRoleEnum? get role => _$this._role;
  set role(CreateStaffDtoRoleEnum? role) => _$this._role = role;

  String? _homeWardId;
  String? get homeWardId => _$this._homeWardId;
  set homeWardId(String? homeWardId) => _$this._homeWardId = homeWardId;

  String? _officeId;
  String? get officeId => _$this._officeId;
  set officeId(String? officeId) => _$this._officeId = officeId;

  String? _reportsToId;
  String? get reportsToId => _$this._reportsToId;
  set reportsToId(String? reportsToId) => _$this._reportsToId = reportsToId;

  String? _department;
  String? get department => _$this._department;
  set department(String? department) => _$this._department = department;

  String? _shiftStart;
  String? get shiftStart => _$this._shiftStart;
  set shiftStart(String? shiftStart) => _$this._shiftStart = shiftStart;

  String? _shiftEnd;
  String? get shiftEnd => _$this._shiftEnd;
  set shiftEnd(String? shiftEnd) => _$this._shiftEnd = shiftEnd;

  String? _initialPassword;
  String? get initialPassword => _$this._initialPassword;
  set initialPassword(String? initialPassword) =>
      _$this._initialPassword = initialPassword;

  CreateStaffDtoBuilder() {
    CreateStaffDto._defaults(this);
  }

  CreateStaffDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _employeeCode = $v.employeeCode;
      _fullName = $v.fullName;
      _fullNameMr = $v.fullNameMr;
      _phone = $v.phone;
      _role = $v.role;
      _homeWardId = $v.homeWardId;
      _officeId = $v.officeId;
      _reportsToId = $v.reportsToId;
      _department = $v.department;
      _shiftStart = $v.shiftStart;
      _shiftEnd = $v.shiftEnd;
      _initialPassword = $v.initialPassword;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateStaffDto other) {
    _$v = other as _$CreateStaffDto;
  }

  @override
  void update(void Function(CreateStaffDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateStaffDto build() => _build();

  _$CreateStaffDto _build() {
    final _$result = _$v ??
        _$CreateStaffDto._(
          employeeCode: BuiltValueNullFieldError.checkNotNull(
              employeeCode, r'CreateStaffDto', 'employeeCode'),
          fullName: BuiltValueNullFieldError.checkNotNull(
              fullName, r'CreateStaffDto', 'fullName'),
          fullNameMr: fullNameMr,
          phone: BuiltValueNullFieldError.checkNotNull(
              phone, r'CreateStaffDto', 'phone'),
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'CreateStaffDto', 'role'),
          homeWardId: homeWardId,
          officeId: officeId,
          reportsToId: reportsToId,
          department: department,
          shiftStart: shiftStart,
          shiftEnd: shiftEnd,
          initialPassword: initialPassword,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
