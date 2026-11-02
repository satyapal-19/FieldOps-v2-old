// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ready_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReadyDto extends ReadyDto {
  @override
  final String status;
  @override
  final String database;
  @override
  final bool pendingMigrations;

  factory _$ReadyDto([void Function(ReadyDtoBuilder)? updates]) =>
      (ReadyDtoBuilder()..update(updates))._build();

  _$ReadyDto._(
      {required this.status,
      required this.database,
      required this.pendingMigrations})
      : super._();
  @override
  ReadyDto rebuild(void Function(ReadyDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReadyDtoBuilder toBuilder() => ReadyDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReadyDto &&
        status == other.status &&
        database == other.database &&
        pendingMigrations == other.pendingMigrations;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, database.hashCode);
    _$hash = $jc(_$hash, pendingMigrations.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReadyDto')
          ..add('status', status)
          ..add('database', database)
          ..add('pendingMigrations', pendingMigrations))
        .toString();
  }
}

class ReadyDtoBuilder implements Builder<ReadyDto, ReadyDtoBuilder> {
  _$ReadyDto? _$v;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _database;
  String? get database => _$this._database;
  set database(String? database) => _$this._database = database;

  bool? _pendingMigrations;
  bool? get pendingMigrations => _$this._pendingMigrations;
  set pendingMigrations(bool? pendingMigrations) =>
      _$this._pendingMigrations = pendingMigrations;

  ReadyDtoBuilder() {
    ReadyDto._defaults(this);
  }

  ReadyDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _database = $v.database;
      _pendingMigrations = $v.pendingMigrations;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReadyDto other) {
    _$v = other as _$ReadyDto;
  }

  @override
  void update(void Function(ReadyDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReadyDto build() => _build();

  _$ReadyDto _build() {
    final _$result = _$v ??
        _$ReadyDto._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'ReadyDto', 'status'),
          database: BuiltValueNullFieldError.checkNotNull(
              database, r'ReadyDto', 'database'),
          pendingMigrations: BuiltValueNullFieldError.checkNotNull(
              pendingMigrations, r'ReadyDto', 'pendingMigrations'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
