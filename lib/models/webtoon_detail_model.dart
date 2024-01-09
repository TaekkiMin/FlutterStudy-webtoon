// 웹툰 상세 모델 클래스 객체
class WebtoonDeatailModel {
  final String title, about, genre, age;

  WebtoonDeatailModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        about = json['about'],
        genre = json['genre'],
        age = json['age'];
}
