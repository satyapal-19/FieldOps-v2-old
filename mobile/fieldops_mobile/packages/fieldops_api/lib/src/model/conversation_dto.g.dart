// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ConversationDtoTypeEnum _$conversationDtoTypeEnum_DIRECT =
    const ConversationDtoTypeEnum._('DIRECT');
const ConversationDtoTypeEnum _$conversationDtoTypeEnum_SQUAD_TEAM =
    const ConversationDtoTypeEnum._('SQUAD_TEAM');
const ConversationDtoTypeEnum _$conversationDtoTypeEnum_WARD_BROADCAST =
    const ConversationDtoTypeEnum._('WARD_BROADCAST');
const ConversationDtoTypeEnum _$conversationDtoTypeEnum_CITY_BROADCAST =
    const ConversationDtoTypeEnum._('CITY_BROADCAST');

ConversationDtoTypeEnum _$conversationDtoTypeEnumValueOf(String name) {
  switch (name) {
    case 'DIRECT':
      return _$conversationDtoTypeEnum_DIRECT;
    case 'SQUAD_TEAM':
      return _$conversationDtoTypeEnum_SQUAD_TEAM;
    case 'WARD_BROADCAST':
      return _$conversationDtoTypeEnum_WARD_BROADCAST;
    case 'CITY_BROADCAST':
      return _$conversationDtoTypeEnum_CITY_BROADCAST;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ConversationDtoTypeEnum> _$conversationDtoTypeEnumValues =
    BuiltSet<ConversationDtoTypeEnum>(const <ConversationDtoTypeEnum>[
  _$conversationDtoTypeEnum_DIRECT,
  _$conversationDtoTypeEnum_SQUAD_TEAM,
  _$conversationDtoTypeEnum_WARD_BROADCAST,
  _$conversationDtoTypeEnum_CITY_BROADCAST,
]);

Serializer<ConversationDtoTypeEnum> _$conversationDtoTypeEnumSerializer =
    _$ConversationDtoTypeEnumSerializer();

class _$ConversationDtoTypeEnumSerializer
    implements PrimitiveSerializer<ConversationDtoTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DIRECT': 'DIRECT',
    'SQUAD_TEAM': 'SQUAD_TEAM',
    'WARD_BROADCAST': 'WARD_BROADCAST',
    'CITY_BROADCAST': 'CITY_BROADCAST',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DIRECT': 'DIRECT',
    'SQUAD_TEAM': 'SQUAD_TEAM',
    'WARD_BROADCAST': 'WARD_BROADCAST',
    'CITY_BROADCAST': 'CITY_BROADCAST',
  };

  @override
  final Iterable<Type> types = const <Type>[ConversationDtoTypeEnum];
  @override
  final String wireName = 'ConversationDtoTypeEnum';

  @override
  Object serialize(Serializers serializers, ConversationDtoTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ConversationDtoTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ConversationDtoTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ConversationDto extends ConversationDto {
  @override
  final String id;
  @override
  final ConversationDtoTypeEnum type;
  @override
  final String? title;
  @override
  final String? wardId;
  @override
  final String? inspectorId;
  @override
  final String? date;
  @override
  final bool archived;
  @override
  final bool canPost;
  @override
  final BuiltList<String> memberIds;
  @override
  final DateTime? lastMessageAt;
  @override
  final num unread;

  factory _$ConversationDto([void Function(ConversationDtoBuilder)? updates]) =>
      (ConversationDtoBuilder()..update(updates))._build();

  _$ConversationDto._(
      {required this.id,
      required this.type,
      this.title,
      this.wardId,
      this.inspectorId,
      this.date,
      required this.archived,
      required this.canPost,
      required this.memberIds,
      this.lastMessageAt,
      required this.unread})
      : super._();
  @override
  ConversationDto rebuild(void Function(ConversationDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ConversationDtoBuilder toBuilder() => ConversationDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConversationDto &&
        id == other.id &&
        type == other.type &&
        title == other.title &&
        wardId == other.wardId &&
        inspectorId == other.inspectorId &&
        date == other.date &&
        archived == other.archived &&
        canPost == other.canPost &&
        memberIds == other.memberIds &&
        lastMessageAt == other.lastMessageAt &&
        unread == other.unread;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, wardId.hashCode);
    _$hash = $jc(_$hash, inspectorId.hashCode);
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, archived.hashCode);
    _$hash = $jc(_$hash, canPost.hashCode);
    _$hash = $jc(_$hash, memberIds.hashCode);
    _$hash = $jc(_$hash, lastMessageAt.hashCode);
    _$hash = $jc(_$hash, unread.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ConversationDto')
          ..add('id', id)
          ..add('type', type)
          ..add('title', title)
          ..add('wardId', wardId)
          ..add('inspectorId', inspectorId)
          ..add('date', date)
          ..add('archived', archived)
          ..add('canPost', canPost)
          ..add('memberIds', memberIds)
          ..add('lastMessageAt', lastMessageAt)
          ..add('unread', unread))
        .toString();
  }
}

class ConversationDtoBuilder
    implements Builder<ConversationDto, ConversationDtoBuilder> {
  _$ConversationDto? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  ConversationDtoTypeEnum? _type;
  ConversationDtoTypeEnum? get type => _$this._type;
  set type(ConversationDtoTypeEnum? type) => _$this._type = type;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _wardId;
  String? get wardId => _$this._wardId;
  set wardId(String? wardId) => _$this._wardId = wardId;

  String? _inspectorId;
  String? get inspectorId => _$this._inspectorId;
  set inspectorId(String? inspectorId) => _$this._inspectorId = inspectorId;

  String? _date;
  String? get date => _$this._date;
  set date(String? date) => _$this._date = date;

  bool? _archived;
  bool? get archived => _$this._archived;
  set archived(bool? archived) => _$this._archived = archived;

  bool? _canPost;
  bool? get canPost => _$this._canPost;
  set canPost(bool? canPost) => _$this._canPost = canPost;

  ListBuilder<String>? _memberIds;
  ListBuilder<String> get memberIds =>
      _$this._memberIds ??= ListBuilder<String>();
  set memberIds(ListBuilder<String>? memberIds) =>
      _$this._memberIds = memberIds;

  DateTime? _lastMessageAt;
  DateTime? get lastMessageAt => _$this._lastMessageAt;
  set lastMessageAt(DateTime? lastMessageAt) =>
      _$this._lastMessageAt = lastMessageAt;

  num? _unread;
  num? get unread => _$this._unread;
  set unread(num? unread) => _$this._unread = unread;

  ConversationDtoBuilder() {
    ConversationDto._defaults(this);
  }

  ConversationDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _type = $v.type;
      _title = $v.title;
      _wardId = $v.wardId;
      _inspectorId = $v.inspectorId;
      _date = $v.date;
      _archived = $v.archived;
      _canPost = $v.canPost;
      _memberIds = $v.memberIds.toBuilder();
      _lastMessageAt = $v.lastMessageAt;
      _unread = $v.unread;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ConversationDto other) {
    _$v = other as _$ConversationDto;
  }

  @override
  void update(void Function(ConversationDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ConversationDto build() => _build();

  _$ConversationDto _build() {
    _$ConversationDto _$result;
    try {
      _$result = _$v ??
          _$ConversationDto._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ConversationDto', 'id'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'ConversationDto', 'type'),
            title: title,
            wardId: wardId,
            inspectorId: inspectorId,
            date: date,
            archived: BuiltValueNullFieldError.checkNotNull(
                archived, r'ConversationDto', 'archived'),
            canPost: BuiltValueNullFieldError.checkNotNull(
                canPost, r'ConversationDto', 'canPost'),
            memberIds: memberIds.build(),
            lastMessageAt: lastMessageAt,
            unread: BuiltValueNullFieldError.checkNotNull(
                unread, r'ConversationDto', 'unread'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'memberIds';
        memberIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ConversationDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
