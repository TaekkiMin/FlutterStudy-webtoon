import 'package:flutter/material.dart';
import 'package:webtoon/models/home_model.dart';
import 'package:webtoon/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<WebtoonModel> webtoons = []; // List<WebtoonModel> 타입의 배열을 빈 상태로 선언
  bool isLoading = true; // 데이터를 받고 있기 때문에 로딩 상태 true

  void waitForWebtoons() async {
    //
    webtoons = await ApiService()
        .getTodaysToons(); // 클래스 apiservice의 getTodaysToons를 호출
    isLoading = false; // 데이터를 받으면 로딩 상태 false
    setState(() {}); // StatefulWidget의 UI를 새로고침
  }

  @override
  void initState() {
    super.initState();
    waitForWebtoons();
  }

  @override
  Widget build(BuildContext context) {
    print(webtoons);
    print(isLoading);

    return Scaffold(
      appBar: AppBar(
        elevation: 2, // 밑의 그림자 설정
        shadowColor: Colors.black, // 그림자 색깔 설정
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        title: const Text(
          '오늘의 웹툰',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
