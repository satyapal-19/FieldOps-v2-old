// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_profile_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const StaffProfileDtoRoleEnum _$staffProfileDtoRoleEnum_ADMIN =
    const StaffProfileDtoRoleEnum._('ADMIN');
const StaffProfileDtoRoleEnum _$staffProfileDtoRoleEnum_WARD_INSPECTOR =
    const StaffProfileDtoRoleEnum._('WARD_INSPECTOR');
const StaffProfileDtoRoleEnum _$staffProfileDtoRoleEnum_INSPECTOR =
    const StaffProfileDtoRoleEnum._('INSPECTOR');
const StaffProfileDtoRoleEnum _$staffProfileDtoRoleEnum_WORKER =
    const StaffProfileDtoRoleEnum._('WORKER');
const StaffProfileDtoRoleEnum _$staffProfileDtoRoleEnum_OFFICE_STAFF =
    const StaffProfileDtoRoleEnum._('OFFICE_STAFF');

StaffProfileDtoRoleEnum _$staffProfileDtoRoleEnumValueOf(String name) {
  switch (name) {
    case 'ADMIN':
      return _$staffProfileDtoRoleEnum_ADMIN;
    case 'WARD_INSPECTOR':
      return _$staffProfileDtoRoleEnum_WARD_INSPECTOR;
    case 'INSPECTOR':
      return _$staffProfileDtoRoleEnum_INSPECTOR;
    case 'WORKER':
      return _$staffProfileDtoRoleEnum_WORKER;
    case 'OFFICE_STAFF':
      return _$staffProfileDtoRoleEnum_OFFICE_STAFF;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<StaffProfileDtoRoleEnum> _$staffProfileDtoRoleEnumValues =
    BuiltSet<StaffProfileDtoRoleEnum>(const <StaffProfileDtoRoleEnum>[
  _$staffProfileDtoRoleEnum_ADMIN,
  _$staffProfileDtoRoleEnum_WARD_INSPECTOR,
  _$staffProfileDtoRoleEnum_INSPECTOR,
  _$staffProfileDtoRoleEnum_WORKER,
  _$staffProfileDtoRoleEnum_OFFICE_STAFF,
]);

Serializer<StaffProfileDtoRoleEnum> _$staffProfileDtoRoleEnumSerializer =
    _$StaffProfileDtoRoleEnumSerializer();

class _$StaffProfileDtoRoleEnumSerializer
    implements PrimitiveSerializer<StaffProfileDtoRoleEnum> {
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
  final Iterable<Type> types = const <Type>[StaffProfileDtoRoleEnum];
  @override
  final String wireName = 'StaffProfileDtoRoleEnum';

  @override
  Object serialize(Serializers serializers, StaffProfileDtoRoleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  StaffProfileDtoRoleEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      StaffProfileDtoRoleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$StaffProfileDto extends StaffProfileDto {
  @override
  final String id;
  @override
  final String employeeCode;
  @override
  final String fullName;
  @override
  final String? fullNameMr;
  @override
  final String phone;
  @override
  final StaffProfileDtoRoleEnum role;
  @override
  final String? homeWardId;
  @override
  final String? officeId;
  @override
  final String? reportsToId;
  @override
  final String? department;
  @override
  final String shiftStart;
  @override
  final String shiftEnd;
  @override
  final bool isActive;
  @override
  final bool hasPassword;
  @override
  final num version;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  factory _$StaffProfileDto([void Function(StaffProfileDtoBuilder)? updates]) =>
      (StaffProfileDtoBuilder()..update(updates))._build();

  _$StaffProfileDto._(
      {required this.id,
      required this.employeeCode,
      required this.fullName,
      this.fullNameMr,
      required this.phone,
      required this.role,
      this.homeWardId,
      this.officeId,
      this.reportsToId,
      this.department,
      required this.shiftStart,
      required this.shiftEnd,
      required this.isActive,
      required this.hasPassword,
      required this.version,
      required this.createdAt,
      required this.updatedAt})
      : super._();
  @override
  StaffProfileDto rebuild(void Function(StaffProfileDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StaffProfileDtoBuilder toBuilder() => StaffProfileDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StaffProfileDto &&
        id == other.id &&
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
        isActive == other.isActive &&
        hasPassword == other.hasPassword &&
        version == other.version &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
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
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jc(_$hash, hasPassword.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StaffProfileDto')
          ..add('id', id)
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
          ..add('isActive', isActive)
          ..add('hasPassword', hasPassword)
          ..add('version', version)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class StaffProfileDtoBuilder
    implements Builder<StaffProfileDto, StaffProfileDtoBuilder> {
  _$StaffProfileDto? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

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

  StaffProfileDtoRoleEnum? _role;
  StaffProfileDtoRoleEnum? get role => _$this._role;
  set role(StaffProfileDtoRoleEnum? role) => _$this._role = role;

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

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  bool? _hasPassword;
  bool? get hasPassword => _$this._hasPassword;
  set hasPassword(bool? hasPassword) => _$this._hasPassword = hasPassword;

  num? _version;
  num? get version => _$this._version;
  set version(num? version) => _$this._version = version;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  StaffProfileDtoBuilder() {
    StaffProfileDto._defaults(this);
  }

  StaffProfileDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
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
      _isActive = $v.isActive;
      _hasPassword = $v.hasPassword;
      _version = $v.version;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StaffProfileDto other) {
    _$v = other as _$StaffProfileDto;
  }

  @override
  void update(void Function(StaffProfileDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StaffProfileDto build() => _build();

  _$StaffProfileDto _build() {
    final _$result = _$v ??
        _$StaffProfileDto._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'StaffProfileDto', 'id'),
          employeeCode: BuiltValueNullFieldError.checkNotNull(
              employeeCode, r'StaffProfileDto', 'employeeCode'),
          fullName: BuiltValueNullFieldError.checkNotNull(
              fullName, r'StaffProfileDto', 'fullName'),
          fullNameMr: fullNameMr,
          phone: BuiltValueNullFieldError.checkNotNull(
              phone, r'StaffProfileDto', 'phone'),
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'StaffProfileDto', 'role'),
          homeWardId: homeWardId,
          officeId: officeId,
          reportsToId: reportsToId,
          department: department,
          shiftStart: BuiltValueNullFieldError.checkNotNull(
              shiftStart, r'StaffProfileDto', 'shiftStart'),
          shiftEnd: BuiltValueNullFieldError.checkNotNull(
              shiftEnd, r'StaffProfileDto', 'shiftEnd'),
          isActive: BuiltValueNullFieldError.checkNotNull(
              isActive, r'StaffProfileDto', 'isActive'),
          hasPassword: BuiltValueNullFieldError.checkNotNull(
              hasPassword, r'StaffProfileDto', 'hasPassword'),
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'StaffProfileDto', 'version'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'StaffProfileDto', 'createdAt'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'StaffProfileDto', 'updatedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
