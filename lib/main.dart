import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'data/api/tour_api.dart'; // 추가

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 네이버 지도 초기화
  await FlutterNaverMap().init(
    clientId: 'pdv7b9bvni',
  );

  // 관광 API 테스트
  final tourApi = TourApi(
    serviceKey: '여기에_네_관광콘텐츠랩_serviceKey',
  );

  await tourApi.fetchBusanPlaces();

  // 앱 실행
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Night Trip',
      home: const MapPage(),
    );
  }
}

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    const busan = NLatLng(35.1796, 129.0756);

    return Scaffold(
      body: NaverMap(
        options: NaverMapViewOptions(
          initialCameraPosition: NCameraPosition(
            target: busan,
            zoom: 12,
          ),
        ),
      ),
    );
  }
}