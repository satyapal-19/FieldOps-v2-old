// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UploadDtoKindEnum _$uploadDtoKindEnum_TASK_PHOTO =
    const UploadDtoKindEnum._('TASK_PHOTO');
const UploadDtoKindEnum _$uploadDtoKindEnum_VOICE_NOTE =
    const UploadDtoKindEnum._('VOICE_NOTE');

UploadDtoKindEnum _$uploadDtoKindEnumValueOf(String name) {
  switch (name) {
    case 'TASK_PHOTO':
      return _$uploadDtoKindEnum_TASK_PHOTO;
    case 'VOICE_NOTE':
      return _$uploadDtoKindEnum_VOICE_NOTE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<UploadDtoKindEnum> _$uploadDtoKindEnumValues =
    BuiltSet<UploadDtoKindEnum>(const <UploadDtoKindEnum>[
  _$uploadDtoKindEnum_TASK_PHOTO,
  _$uploadDtoKindEnum_VOICE_NOTE,
]);

Serializer<UploadDtoKindEnum> _$uploadDtoKindEnumSerializer =
    _$UploadDtoKindEnumSerializer();

class _$UploadDtoKindEnumSerializer
    implements PrimitiveSerializer<UploadDtoKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'TASK_PHOTO': 'TASK_PHOTO',
    'VOICE_NOTE': 'VOICE_NOTE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'TASK_PHOTO': 'TASK_PHOTO',
    'VOICE_NOTE': 'VOICE_NOTE',
  };

  @override
  final Iterable<Type> types = const <Type>[UploadDtoKindEnum];
  @override
  final String wireName = 'UploadDtoKindEnum';

  @override
  Object serialize(Serializers serializers, UploadDtoKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  UploadDtoKindEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      UploadDtoKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$UploadDto extends UploadDto {
  @override
  final String id;
  @override
  final UploadDtoKindEnum kind;
  @override
  final String contentType;
  @override
  final num sizeBytes;
  @override
  final DateTime createdAt;
  @override
  final bool replayed;

  factory _$UploadDto([void Function(UploadDtoBuilder)? updates]) =>
      (UploadDtoBuilder()..update(updates))._build();

  _$UploadDto._(
      {required this.id,
      required this.kind,
      required this.contentType,
      required this.sizeBytes,
      required this.createdAt,
      required this.replayed})
      : super._();
  @override
  UploadDto rebuild(void Function(UploadDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UploadDtoBuilder toBuilder() => UploadDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UploadDto &&
        id == other.id &&
        kind == other.kind &&
        contentType == other.contentType &&
        sizeBytes == other.sizeBytes &&
        createdAt == other.createdAt &&
        replayed == other.replayed;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, contentType.hashCode);
    _$hash = $jc(_$hash, sizeBytes.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, replayed.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UploadDto')
          ..add('id', id)
          ..add('kind', kind)
          ..add('contentType', contentType)
          ..add('sizeBytes', sizeBytes)
          ..add('createdAt', createdAt)
          ..add('replayed', replayed))
        .toString();
  }
}

class UploadDtoBuilder implements Builder<UploadDto, UploadDtoBuilder> {
  _$UploadDto? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  UploadDtoKindEnum? _kind;
  UploadDtoKindEnum? get kind => _$this._kind;
  set kind(UploadDtoKindEnum? kind) => _$this._kind = kind;

  String? _contentType;
  String? get contentType => _$this._contentType;
  set contentType(String? contentType) => _$this._contentType = contentType;

  num? _sizeBytes;
  num? get sizeBytes => _$this._sizeBytes;
  set sizeBytes(num? sizeBytes) => _$this._sizeBytes = sizeBytes;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  bool? _replayed;
  bool? get replayed => _$this._replayed;
  set replayed(bool? replayed) => _$this._replayed = replayed;

  UploadDtoBuilder() {
    UploadDto._defaults(this);
  }

  UploadDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _kind = $v.kind;
      _contentType = $v.contentType;
      _sizeBytes = $v.sizeBytes;
      _createdAt = $v.createdAt;
      _replayed = $v.replayed;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UploadDto other) {
    _$v = other as _$UploadDto;
  }

  @override
  void update(void Function(UploadDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UploadDto build() => _build();

  _$UploadDto _build() {
    final _$result = _$v ??
        _$UploadDto._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'UploadDto', 'id'),
          kind:
              BuiltValueNullFieldError.checkNotNull(kind, r'UploadDto', 'kind'),
          contentType: BuiltValueNullFieldError.checkNotNull(
              contentType, r'UploadDto', 'contentType'),
          sizeBytes: BuiltValueNullFieldError.checkNotNull(
              sizeBytes, r'UploadDto', 'sizeBytes'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'UploadDto', 'createdAt'),
          replayed: BuiltValueNullFieldError.checkNotNull(
              replayed, r'UploadDto', 'replayed'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
