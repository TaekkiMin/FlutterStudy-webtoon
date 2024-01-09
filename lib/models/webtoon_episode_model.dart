// 웹툰의 에피소드 모델 클래스 객제
class WebtoonEpisodeModel {
  String id, title, rating, date;

  WebtoonEpisodeModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        rating = json['rating'],
        date = json['date'];
}
