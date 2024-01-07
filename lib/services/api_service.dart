// API 데이터를 받고 JSON 데이터 형식으로 변환하는 코드
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:webtoon/models/home_model.dart';

class ApiService {
  final String baseUrl =
      'https://webtoon-crawler.nomadcoders.workers.dev'; // 이 링크에 오늘의 웹툰, id, 에피소드 데이터들이 들어있다.
  final String today = 'today'; // 오늘의 웹툰을 불러온다.

  // 비동기 함수이기 때문에 Future 작성
  Future<List<WebtoonModel>> getTodaysToons() async {
    List<WebtoonModel> webtoonInstance = []; // WebtoonModel로 구성된 배열을 빈 배열로 초기화
    final url = Uri.parse('$baseUrl/$today'); // 두 개의 변수를 사용해서 URL을 생성한다.
    final response = await http.get(url);
    if (response.statusCode == 200) {
      // 200 : 요청 성공

      // webtoons: 여러 객체(웹툰의 아이디, 제목, 썸네일이 들어있는 정보)가 들어있는 배열
      final List<dynamic> webtoons =
          jsonDecode(response.body); // jsonDecode가 dynamic 리턴타입, 여러 객체가 들어있는 배열

      // webtoon: 배열에 들어있는 객체
      for (var webtoon in webtoons) {
        webtoonInstance.add(WebtoonModel.fromJson(
            webtoon)); // WebtoonModel.fromJson() 생성자 함수를 통해 webtoon을 보내 title, thumb, id를 초기화
      }
      return webtoonInstance;
    }
    throw Error();
  }
}
