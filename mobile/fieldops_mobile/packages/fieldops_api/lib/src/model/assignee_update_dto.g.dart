// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignee_update_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AssigneeUpdateDtoActionEnum _$assigneeUpdateDtoActionEnum_START =
    const AssigneeUpdateDtoActionEnum._('START');
const AssigneeUpdateDtoActionEnum _$assigneeUpdateDtoActionEnum_SUBMIT =
    const AssigneeUpdateDtoActionEnum._('SUBMIT');

AssigneeUpdateDtoActionEnum _$assigneeUpdateDtoActionEnumValueOf(String name) {
  switch (name) {
    case 'START':
      return _$assigneeUpdateDtoActionEnum_START;
    case 'SUBMIT':
      return _$assigneeUpdateDtoActionEnum_SUBMIT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AssigneeUpdateDtoActionEnum>
    _$assigneeUpdateDtoActionEnumValues =
    BuiltSet<AssigneeUpdateDtoActionEnum>(const <AssigneeUpdateDtoActionEnum>[
  _$assigneeUpdateDtoActionEnum_START,
  _$assigneeUpdateDtoActionEnum_SUBMIT,
]);

Serializer<AssigneeUpdateDtoActionEnum>
    _$assigneeUpdateDtoActionEnumSerializer =
    _$AssigneeUpdateDtoActionEnumSerializer();

class _$AssigneeUpdateDtoActionEnumSerializer
    implements PrimitiveSerializer<AssigneeUpdateDtoActionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'START': 'START',
    'SUBMIT': 'SUBMIT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'START': 'START',
    'SUBMIT': 'SUBMIT',
  };

  @override
  final Iterable<Type> types = const <Type>[AssigneeUpdateDtoActionEnum];
  @override
  final String wireName = 'AssigneeUpdateDtoActionEnum';

  @override
  Object serialize(Serializers serializers, AssigneeUpdateDtoActionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AssigneeUpdateDtoActionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AssigneeUpdateDtoActionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AssigneeUpdateDto extends AssigneeUpdateDto {
  @override
  final String clientUuid;
  @override
  final AssigneeUpdateDtoActionEnum action;
  @override
  final String? note;
  @override
  final String? photoKey;
  @override
  final num? lat;
  @override
  final num? lng;

  factory _$AssigneeUpdateDto(
          [void Function(AssigneeUpdateDtoBuilder)? updates]) =>
      (AssigneeUpdateDtoBuilder()..update(updates))._build();

  _$AssigneeUpdateDto._(
      {required this.clientUuid,
      required this.action,
      this.note,
      this.photoKey,
      this.lat,
      this.lng})
      : super._();
  @override
  AssigneeUpdateDto rebuild(void Function(AssigneeUpdateDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AssigneeUpdateDtoBuilder toBuilder() =>
      AssigneeUpdateDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AssigneeUpdateDto &&
        clientUuid == other.clientUuid &&
        action == other.action &&
        note == other.note &&
        photoKey == other.photoKey &&
        lat == other.lat &&
        lng == other.lng;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, clientUuid.hashCode);
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, photoKey.hashCode);
    _$hash = $jc(_$hash, lat.hashCode);
    _$hash = $jc(_$hash, lng.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AssigneeUpdateDto')
          ..add('clientUuid', clientUuid)
          ..add('action', action)
          ..add('note', note)
          ..add('photoKey', photoKey)
          ..add('lat', lat)
          ..add('lng', lng))
        .toString();
  }
}

class AssigneeUpdateDtoBuilder
    implements Builder<AssigneeUpdateDto, AssigneeUpdateDtoBuilder> {
  _$AssigneeUpdateDto? _$v;

  String? _clientUuid;
  String? get clientUuid => _$this._clientUuid;
  set clientUuid(String? clientUuid) => _$this._clientUuid = clientUuid;

  AssigneeUpdateDtoActionEnum? _action;
  AssigneeUpdateDtoActionEnum? get action => _$this._action;
  set action(AssigneeUpdateDtoActionEnum? action) => _$this._action = action;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  String? _photoKey;
  String? get photoKey => _$this._photoKey;
  set photoKey(String? photoKey) => _$this._photoKey = photoKey;

  num? _lat;
  num? get lat => _$this._lat;
  set lat(num? lat) => _$this._lat = lat;

  num? _lng;
  num? get lng => _$this._lng;
  set lng(num? lng) => _$this._lng = lng;

  AssigneeUpdateDtoBuilder() {
    AssigneeUpdateDto._defaults(this);
  }

  AssigneeUpdateDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _clientUuid = $v.clientUuid;
      _action = $v.action;
      _note = $v.note;
      _photoKey = $v.photoKey;
      _lat = $v.lat;
      _lng = $v.lng;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AssigneeUpdateDto other) {
    _$v = other as _$AssigneeUpdateDto;
  }

  @override
  void update(void Function(AssigneeUpdateDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AssigneeUpdateDto build() => _build();

  _$AssigneeUpdateDto _build() {
    final _$result = _$v ??
        _$AssigneeUpdateDto._(
          clientUuid: BuiltValueNullFieldError.checkNotNull(
              clientUuid, r'AssigneeUpdateDto', 'clientUuid'),
          action: BuiltValueNullFieldError.checkNotNull(
              action, r'AssigneeUpdateDto', 'action'),
          note: note,
          photoKey: photoKey,
          lat: lat,
          lng: lng,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
