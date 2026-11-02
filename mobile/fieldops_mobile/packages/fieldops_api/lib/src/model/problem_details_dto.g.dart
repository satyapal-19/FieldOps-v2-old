// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'problem_details_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProblemDetailsDto extends ProblemDetailsDto {
  @override
  final String type;
  @override
  final ErrorCode code;
  @override
  final String title;
  @override
  final num status;
  @override
  final String requestId;
  @override
  final BuiltMap<String, JsonObject?>? details;

  factory _$ProblemDetailsDto(
          [void Function(ProblemDetailsDtoBuilder)? updates]) =>
      (ProblemDetailsDtoBuilder()..update(updates))._build();

  _$ProblemDetailsDto._(
      {required this.type,
      required this.code,
      required this.title,
      required this.status,
      required this.requestId,
      this.details})
      : super._();
  @override
  ProblemDetailsDto rebuild(void Function(ProblemDetailsDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProblemDetailsDtoBuilder toBuilder() =>
      ProblemDetailsDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProblemDetailsDto &&
        type == other.type &&
        code == other.code &&
        title == other.title &&
        status == other.status &&
        requestId == other.requestId &&
        details == other.details;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, requestId.hashCode);
    _$hash = $jc(_$hash, details.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProblemDetailsDto')
          ..add('type', type)
          ..add('code', code)
          ..add('title', title)
          ..add('status', status)
          ..add('requestId', requestId)
          ..add('details', details))
        .toString();
  }
}

class ProblemDetailsDtoBuilder
    implements Builder<ProblemDetailsDto, ProblemDetailsDtoBuilder> {
  _$ProblemDetailsDto? _$v;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  ErrorCode? _code;
  ErrorCode? get code => _$this._code;
  set code(ErrorCode? code) => _$this._code = code;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  num? _status;
  num? get status => _$this._status;
  set status(num? status) => _$this._status = status;

  String? _requestId;
  String? get requestId => _$this._requestId;
  set requestId(String? requestId) => _$this._requestId = requestId;

  MapBuilder<String, JsonObject?>? _details;
  MapBuilder<String, JsonObject?> get details =>
      _$this._details ??= MapBuilder<String, JsonObject?>();
  set details(MapBuilder<String, JsonObject?>? details) =>
      _$this._details = details;

  ProblemDetailsDtoBuilder() {
    ProblemDetailsDto._defaults(this);
  }

  ProblemDetailsDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _code = $v.code;
      _title = $v.title;
      _status = $v.status;
      _requestId = $v.requestId;
      _details = $v.details?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProblemDetailsDto other) {
    _$v = other as _$ProblemDetailsDto;
  }

  @override
  void update(void Function(ProblemDetailsDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProblemDetailsDto build() => _build();

  _$ProblemDetailsDto _build() {
    _$ProblemDetailsDto _$result;
    try {
      _$result = _$v ??
          _$ProblemDetailsDto._(
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'ProblemDetailsDto', 'type'),
            code: BuiltValueNullFieldError.checkNotNull(
                code, r'ProblemDetailsDto', 'code'),
            title: BuiltValueNullFieldError.checkNotNull(
                title, r'ProblemDetailsDto', 'title'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'ProblemDetailsDto', 'status'),
            requestId: BuiltValueNullFieldError.checkNotNull(
                requestId, r'ProblemDetailsDto', 'requestId'),
            details: _details?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'details';
        _details?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProblemDetailsDto', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
