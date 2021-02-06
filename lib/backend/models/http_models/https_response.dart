import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'https_response.g.dart';

@JsonSerializable()
class HttpsResponse<T> {
  const HttpsResponse({
    @required this.success,
    this.message,
    this.payload,
  });

  final bool success;
  final String message;
  final dynamic payload;

  static HttpsResponse<T> fromJson<T>(Map<String, dynamic> json) =>
      _$HttpsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HttpsResponseToJson(this);
}
