import 'package:flutter/material.dart';
import '../../services/busan_api_service.dart';

void main() {
  runApp(const NightTripApp());
}

class NightTripApp extends StatelessWidget {
  const NightTripApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Night Trip',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BusanApiService apiService = BusanApiService();

  List<Map<String, dynamic>> places = [];
  bool isLoading = false;
  String message = '';

  Future<void> loadPlaces() async {
    setState(() {
      isLoading = true;
      message = '';
    });

    try {
      final result = await apiService.getNearbyPlaces(
        longitude: 129.0756,
        latitude: 35.1796,
      );

      setState(() {
        places = result;
        message = '${result.length}개의 관광지를 찾았습니다.';
      });
    } catch (e) {
      setState(() {
        message = '오류가 발생했습니다: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🌙 Night Trip'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              '부산 주변 관광지',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: isLoading ? null : loadPlaces,
              child: Text(
                isLoading ? '불러오는 중...' : '관광지 불러오기',
              ),
            ),

            const SizedBox(height: 20),

            Text(message),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: places.length,
                itemBuilder: (context, index) {
                  final place = places[index];

                  return Card(
                    child: ListTile(
                      title: Text(
                        place['title'] ?? '이름 없음',
                      ),
                      subtitle: Text(
                        '${place['addr1'] ?? ''}\n'
                        '거리: ${place['dist'] ?? '-'}m',
                      ),
                      leading: place['firstimage'] != null &&
                              place['firstimage'].toString().isNotEmpty
                          ? Image.network(
                              place['firstimage'],
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.place),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}