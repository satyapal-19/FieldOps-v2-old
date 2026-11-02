// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_staff_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UpdateStaffDtoRoleEnum _$updateStaffDtoRoleEnum_ADMIN =
    const UpdateStaffDtoRoleEnum._('ADMIN');
const UpdateStaffDtoRoleEnum _$updateStaffDtoRoleEnum_WARD_INSPECTOR =
    const UpdateStaffDtoRoleEnum._('WARD_INSPECTOR');
const UpdateStaffDtoRoleEnum _$updateStaffDtoRoleEnum_INSPECTOR =
    const UpdateStaffDtoRoleEnum._('INSPECTOR');
const UpdateStaffDtoRoleEnum _$updateStaffDtoRoleEnum_WORKER =
    const UpdateStaffDtoRoleEnum._('WORKER');
const UpdateStaffDtoRoleEnum _$updateStaffDtoRoleEnum_OFFICE_STAFF =
    const UpdateStaffDtoRoleEnum._('OFFICE_STAFF');

UpdateStaffDtoRoleEnum _$updateStaffDtoRoleEnumValueOf(String name) {
  switch (name) {
    case 'ADMIN':
      return _$updateStaffDtoRoleEnum_ADMIN;
    case 'WARD_INSPECTOR':
      return _$updateStaffDtoRoleEnum_WARD_INSPECTOR;
    case 'INSPECTOR':
      return _$updateStaffDtoRoleEnum_INSPECTOR;
    case 'WORKER':
      return _$updateStaffDtoRoleEnum_WORKER;
    case 'OFFICE_STAFF':
      return _$updateStaffDtoRoleEnum_OFFICE_STAFF;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<UpdateStaffDtoRoleEnum> _$updateStaffDtoRoleEnumValues =
    BuiltSet<UpdateStaffDtoRoleEnum>(const <UpdateStaffDtoRoleEnum>[
  _$updateStaffDtoRoleEnum_ADMIN,
  _$updateStaffDtoRoleEnum_WARD_INSPECTOR,
  _$updateStaffDtoRoleEnum_INSPECTOR,
  _$updateStaffDtoRoleEnum_WORKER,
  _$updateStaffDtoRoleEnum_OFFICE_STAFF,
]);

Serializer<UpdateStaffDtoRoleEnum> _$updateStaffDtoRoleEnumSerializer =
    _$UpdateStaffDtoRoleEnumSerializer();

class _$UpdateStaffDtoRoleEnumSerializer
    implements PrimitiveSerializer<UpdateStaffDtoRoleEnum> {
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
  final Iterable<Type> types = const <Type>[UpdateStaffDtoRoleEnum];
  @override
  final String wireName = 'UpdateStaffDtoRoleEnum';

  @override
  Object serialize(Serializers serializers, UpdateStaffDtoRoleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  UpdateStaffDtoRoleEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      UpdateStaffDtoRoleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$UpdateStaffDto extends UpdateStaffDto {
  @override
  final num expectedVersion;
  @override
  final String? fullName;
  @override
  final String? fullNameMr;
  @override
  final String? phone;
  @override
  final UpdateStaffDtoRoleEnum? role;
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
  final bool? isActive;

  factory _$UpdateStaffDto([void Function(UpdateStaffDtoBuilder)? updates]) =>
      (UpdateStaffDtoBuilder()..update(updates))._build();

  _$UpdateStaffDto._(
      {required this.expectedVersion,
      this.fullName,
      this.fullNameMr,
      this.phone,
      this.role,
      this.homeWardId,
      this.officeId,
      this.reportsToId,
      this.department,
      this.shiftStart,
      this.shiftEnd,
      this.isActive})
      : super._();
  @override
  UpdateStaffDto rebuild(void Function(UpdateStaffDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateStaffDtoBuilder toBuilder() => UpdateStaffDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateStaffDto &&
        expectedVersion == other.expectedVersion &&
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
        isActive == other.isActive;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, expectedVersion.hashCode);
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
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateStaffDto')
          ..add('expectedVersion', expectedVersion)
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
          ..add('isActive', isActive))
        .toString();
  }
}

class UpdateStaffDtoBuilder
    implements Builder<UpdateStaffDto, UpdateStaffDtoBuilder> {
  _$UpdateStaffDto? _$v;

  num? _expectedVersion;
  num? get expectedVersion => _$this._expectedVersion;
  set expectedVersion(num? expectedVersion) =>
      _$this._expectedVersion = expectedVersion;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _fullNameMr;
  String? get fullNameMr => _$this._fullNameMr;
  set fullNameMr(String? fullNameMr) => _$this._fullNameMr = fullNameMr;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  UpdateStaffDtoRoleEnum? _role;
  UpdateStaffDtoRoleEnum? get role => _$this._role;
  set role(UpdateStaffDtoRoleEnum? role) => _$this._role = role;

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

  UpdateStaffDtoBuilder() {
    UpdateStaffDto._defaults(this);
  }

  UpdateStaffDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _expectedVersion = $v.expectedVersion;
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
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateStaffDto other) {
    _$v = other as _$UpdateStaffDto;
  }

  @override
  void update(void Function(UpdateStaffDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateStaffDto build() => _build();

  _$UpdateStaffDto _build() {
    final _$result = _$v ??
        _$UpdateStaffDto._(
          expectedVersion: BuiltValueNullFieldError.checkNotNull(
              expectedVersion, r'UpdateStaffDto', 'expectedVersion'),
          fullName: fullName,
          fullNameMr: fullNameMr,
          phone: phone,
          role: role,
          homeWardId: homeWardId,
          officeId: officeId,
          reportsToId: reportsToId,
          department: department,
          shiftStart: shiftStart,
          shiftEnd: shiftEnd,
          isActive: isActive,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
