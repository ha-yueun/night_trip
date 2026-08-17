import 'dart:convert';
import 'package:http/http.dart' as http;

class TourApi {
  final String serviceKey;

  TourApi({required this.serviceKey});

  Future<void> fetchBusanPlaces() async {
    final uri = Uri.parse(
      'https://apis.data.go.kr/B551011/KorService2/areaBasedList2'
      '?serviceKey=$serviceKey'
      '&numOfRows=10'
      '&pageNo=1'
      '&MobileOS=ETC'
      '&MobileApp=NightTrip'
      '&_type=json'
      '&arrange=C'
      '&contentTypeId=12'
      '&lDongRegnCd=26',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
    } else {
      throw Exception('관광정보 API 호출 실패: ${response.statusCode}');
    }
  }
}