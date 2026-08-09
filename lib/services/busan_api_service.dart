import 'dart:convert';
import 'package:http/http.dart' as http;

class BusanApiService {
  static const String baseUrl =
      'https://apis.data.go.kr/B551011/KorService2/locationBasedList2';

  // TODO: 여기에 공공데이터포털에서 발급받은 인증키를 넣으세요.
  static const String serviceKey = 'YOUR_SERVICE_KEY';

  Future<List<Map<String, dynamic>>> getNearbyPlaces({
    required double longitude,
    required double latitude,
    int radius = 5000,
  }) async {
    final uri = Uri.parse(baseUrl).replace(
      queryParameters: {
        'serviceKey': serviceKey,
        'numOfRows': '10',
        'pageNo': '1',
        'MobileOS': 'IOS',
        'MobileApp': 'NightTrip',
        '_type': 'json',
        'arrange': 'E',
        'contentTypeId': '12',
        'mapX': longitude.toString(),
        'mapY': latitude.toString(),
        'radius': radius.toString(),
      },
    );

    print('부산 관광 API 요청: $uri');

    final response = await http.get(uri);

    print('API 응답 코드: ${response.statusCode}');
    print('API 응답: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(
        '부산 관광 API 요청 실패: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body);

    final responseData = data['response'];
    final header = responseData['header'];

    if (header['resultCode'] != '0000') {
      throw Exception(
        '부산 관광 API 오류: ${header['resultMsg']}',
      );
    }

    final items = responseData['body']['items']['item'];

    if (items == null) {
      return [];
    }

    if (items is List) {
      return items
          .map<Map<String, dynamic>>(
            (item) => Map<String, dynamic>.from(item),
          )
          .toList();
    }

    return [
      Map<String, dynamic>.from(items),
    ];
  }
}