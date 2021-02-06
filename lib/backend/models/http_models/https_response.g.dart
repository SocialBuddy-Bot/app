// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'https_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HttpsResponse<T> _$HttpsResponseFromJson<T>(Map json) {
  return HttpsResponse<T>(
    success: json['success'] as bool,
    message: json['message'] as String,
    payload: json['payload'],
  );
}

Map<String, dynamic> _$HttpsResponseToJson<T>(HttpsResponse<T> instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'payload': instance.payload,
    };
