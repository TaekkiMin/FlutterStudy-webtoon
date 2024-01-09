// API 데이터를 받고 JSON 데이터 형식으로 변환하는 코드
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:webtoon/models/home_model.dart';
import 'package:webtoon/models/webtoon_detail_model.dart';
import 'package:webtoon/models/webtoon_episode_model.dart';

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

  // static으로 선언하면 baseUrl을 가져올 수 없음
  // 에피소드 api는 객체만 있기 때문에 위에 처럼 배열 선언해서 할 필요 없음
  Future<WebtoonDeatailModel> getToonById(String id) async {
    final url = Uri.parse('$baseUrl/$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final webtoon = jsonDecode(response.body);
      return WebtoonDeatailModel.fromJson(webtoon);
    }
    throw Error();
  }

  Future<List<WebtoonEpisodeModel>> getLatestEpisoidesById(String id) async {
    List<WebtoonEpisodeModel> episodeInstance = [];
    final url = Uri.parse('$baseUrl/$id/episodes');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final episodes =
          jsonDecode(response.body); // 여러 개의 웹툰 정보 객체를 담은 배열을 episode에 저장
      for (var episode in episodes) {
        episodeInstance.add(
          WebtoonEpisodeModel.fromJson(episode),
        ); // 여기서 episode는 하나의 웹툰 정보(하나의 객체)
      }
      return episodeInstance;
    }
    throw Error();
  }
}
