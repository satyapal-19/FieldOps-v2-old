// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tile_manifest_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TileManifestDto extends TileManifestDto {
  @override
  final bool available;
  @override
  final num? minZoom;
  @override
  final num? maxZoom;
  @override
  final BuiltList<num>? bounds;
  @override
  final String attribution;
  @override
  final String? builtAt;

  factory _$TileManifestDto([void Function(TileManifestDtoBuilder)? updates]) =>
      (TileManifestDtoBuilder()..update(updates))._build();

  _$TileManifestDto._(
      {required this.available,
      this.minZoom,
      this.maxZoom,
      this.bounds,
      required this.attribution,
      this.builtAt})
      : super._();
  @override
  TileManifestDto rebuild(void Function(TileManifestDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TileManifestDtoBuilder toBuilder() => TileManifestDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TileManifestDto &&
        available == other.available &&
        minZoom == other.minZoom &&
        maxZoom == other.maxZoom &&
        bounds == other.bounds &&
        attribution == other.attribution &&
        builtAt == other.builtAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, available.hashCode);
    _$hash = $jc(_$hash, minZoom.hashCode);
    _$hash = $jc(_$hash, maxZoom.hashCode);
    _$hash = $jc(_$hash, bounds.hashCode);
    _$hash = $jc(_$hash, attribution.hashCode);
    _$hash = $jc(_$hash, builtAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TileManifestDto')
          ..add('available', available)
          ..add('minZoom', minZoom)
          ..add('maxZoom', maxZoom)
          ..add('bounds', bounds)
          ..add('attribution', attribution)
          ..add('builtAt', builtAt))
        .toString();
  }
}

class TileManifestDtoBuilder
    implements Builder<TileManifestDto, TileManifestDtoBuilder> {
  _$TileManifestDto? _$v;

  bool? _available;
  bool? get available => _$this._available;
  set available(bool? available) => _$this._available = available;

  num? _minZoom;
  num? get minZoom => _$this._minZoom;
  set minZoom(num? minZoom) => _$this._minZoom = minZoom;

  num? _maxZoom;
  num? get maxZoom => _$this._maxZoom;
  set maxZoom(num? maxZoom) => _$this._maxZoom = maxZoom;

  ListBuilder<num>? _bounds;
  ListBuilder<num> get bounds => _$this._bounds ??= ListBuilder<num>();
  set bounds(ListBuilder<num>? bounds) => _$this._bounds = bounds;

  String? _attribution;
  String? get attribution => _$this._attribution;
  set attribution(String? attribution) => _$this._attribution = attribution;

  String? _builtAt;
  String? get builtAt => _$this._builtAt;
  set builtAt(String? builtAt) => _$this._builtAt = builtAt;

  TileManifestDtoBuilder() {
    TileManifestDto._defaults(this);
  }

  TileManifestDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _available = $v.available;
      _minZoom = $v.minZoom;
      _maxZoom = $v.maxZoom;
      _bounds = $v.bounds?.toBuilder();
      _attribution = $v.attribution;
      _builtAt = $v.builtAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TileManifestDto other) {
    _$v = other as _$TileManifestDto;
  }

  @override
  void update(void Function(TileManifestDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TileManifestDto build() => _build();

  _$TileManifestDto _build() {
    _$TileManifestDto _$result;
    try {
      _$result = _$v ??
          _$TileManifestDto._(
            available: BuiltValueNullFieldError.checkNotNull(
                available, r'TileManifestDto', 'available'),
            minZoom: minZoom,
            maxZoom: maxZoom,
            bounds: _bounds?.build(),
            attribution: BuiltValueNullFieldError.checkNotNull(
                attribution, r'TileManifestDto', 'attribution'),
            builtAt: builtAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'bounds';
        _bounds?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TileManifestDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
