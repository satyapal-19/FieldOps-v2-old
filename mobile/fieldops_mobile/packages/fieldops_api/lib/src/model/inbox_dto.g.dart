// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbox_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InboxDto extends InboxDto {
  @override
  final BuiltList<NotificationDto> items;
  @override
  final num unreadCount;

  factory _$InboxDto([void Function(InboxDtoBuilder)? updates]) =>
      (InboxDtoBuilder()..update(updates))._build();

  _$InboxDto._({required this.items, required this.unreadCount}) : super._();
  @override
  InboxDto rebuild(void Function(InboxDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InboxDtoBuilder toBuilder() => InboxDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InboxDto &&
        items == other.items &&
        unreadCount == other.unreadCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, unreadCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InboxDto')
          ..add('items', items)
          ..add('unreadCount', unreadCount))
        .toString();
  }
}

class InboxDtoBuilder implements Builder<InboxDto, InboxDtoBuilder> {
  _$InboxDto? _$v;

  ListBuilder<NotificationDto>? _items;
  ListBuilder<NotificationDto> get items =>
      _$this._items ??= ListBuilder<NotificationDto>();
  set items(ListBuilder<NotificationDto>? items) => _$this._items = items;

  num? _unreadCount;
  num? get unreadCount => _$this._unreadCount;
  set unreadCount(num? unreadCount) => _$this._unreadCount = unreadCount;

  InboxDtoBuilder() {
    InboxDto._defaults(this);
  }

  InboxDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _unreadCount = $v.unreadCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InboxDto other) {
    _$v = other as _$InboxDto;
  }

  @override
  void update(void Function(InboxDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InboxDto build() => _build();

  _$InboxDto _build() {
    _$InboxDto _$result;
    try {
      _$result = _$v ??
          _$InboxDto._(
            items: items.build(),
            unreadCount: BuiltValueNullFieldError.checkNotNull(
                unreadCount, r'InboxDto', 'unreadCount'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'InboxDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
