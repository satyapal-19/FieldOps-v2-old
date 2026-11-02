// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complaint_status_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ComplaintStatusDtoActionEnum _$complaintStatusDtoActionEnum_RESOLVE =
    const ComplaintStatusDtoActionEnum._('RESOLVE');
const ComplaintStatusDtoActionEnum _$complaintStatusDtoActionEnum_REJECT =
    const ComplaintStatusDtoActionEnum._('REJECT');
const ComplaintStatusDtoActionEnum _$complaintStatusDtoActionEnum_CLOSE =
    const ComplaintStatusDtoActionEnum._('CLOSE');

ComplaintStatusDtoActionEnum _$complaintStatusDtoActionEnumValueOf(
    String name) {
  switch (name) {
    case 'RESOLVE':
      return _$complaintStatusDtoActionEnum_RESOLVE;
    case 'REJECT':
      return _$complaintStatusDtoActionEnum_REJECT;
    case 'CLOSE':
      return _$complaintStatusDtoActionEnum_CLOSE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ComplaintStatusDtoActionEnum>
    _$complaintStatusDtoActionEnumValues =
    BuiltSet<ComplaintStatusDtoActionEnum>(const <ComplaintStatusDtoActionEnum>[
  _$complaintStatusDtoActionEnum_RESOLVE,
  _$complaintStatusDtoActionEnum_REJECT,
  _$complaintStatusDtoActionEnum_CLOSE,
]);

Serializer<ComplaintStatusDtoActionEnum>
    _$complaintStatusDtoActionEnumSerializer =
    _$ComplaintStatusDtoActionEnumSerializer();

class _$ComplaintStatusDtoActionEnumSerializer
    implements PrimitiveSerializer<ComplaintStatusDtoActionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'RESOLVE': 'RESOLVE',
    'REJECT': 'REJECT',
    'CLOSE': 'CLOSE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'RESOLVE': 'RESOLVE',
    'REJECT': 'REJECT',
    'CLOSE': 'CLOSE',
  };

  @override
  final Iterable<Type> types = const <Type>[ComplaintStatusDtoActionEnum];
  @override
  final String wireName = 'ComplaintStatusDtoActionEnum';

  @override
  Object serialize(Serializers serializers, ComplaintStatusDtoActionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ComplaintStatusDtoActionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ComplaintStatusDtoActionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ComplaintStatusDto extends ComplaintStatusDto {
  @override
  final num expectedVersion;
  @override
  final ComplaintStatusDtoActionEnum action;

  factory _$ComplaintStatusDto(
          [void Function(ComplaintStatusDtoBuilder)? updates]) =>
      (ComplaintStatusDtoBuilder()..update(updates))._build();

  _$ComplaintStatusDto._({required this.expectedVersion, required this.action})
      : super._();
  @override
  ComplaintStatusDto rebuild(
          void Function(ComplaintStatusDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ComplaintStatusDtoBuilder toBuilder() =>
      ComplaintStatusDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ComplaintStatusDto &&
        expectedVersion == other.expectedVersion &&
        action == other.action;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, expectedVersion.hashCode);
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ComplaintStatusDto')
          ..add('expectedVersion', expectedVersion)
          ..add('action', action))
        .toString();
  }
}

class ComplaintStatusDtoBuilder
    implements Builder<ComplaintStatusDto, ComplaintStatusDtoBuilder> {
  _$ComplaintStatusDto? _$v;

  num? _expectedVersion;
  num? get expectedVersion => _$this._expectedVersion;
  set expectedVersion(num? expectedVersion) =>
      _$this._expectedVersion = expectedVersion;

  ComplaintStatusDtoActionEnum? _action;
  ComplaintStatusDtoActionEnum? get action => _$this._action;
  set action(ComplaintStatusDtoActionEnum? action) => _$this._action = action;

  ComplaintStatusDtoBuilder() {
    ComplaintStatusDto._defaults(this);
  }

  ComplaintStatusDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _expectedVersion = $v.expectedVersion;
      _action = $v.action;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ComplaintStatusDto other) {
    _$v = other as _$ComplaintStatusDto;
  }

  @override
  void update(void Function(ComplaintStatusDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ComplaintStatusDto build() => _build();

  _$ComplaintStatusDto _build() {
    final _$result = _$v ??
        _$ComplaintStatusDto._(
          expectedVersion: BuiltValueNullFieldError.checkNotNull(
              expectedVersion, r'ComplaintStatusDto', 'expectedVersion'),
          action: BuiltValueNullFieldError.checkNotNull(
              action, r'ComplaintStatusDto', 'action'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
