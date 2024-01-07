// JSON 데이터로 webtoonmodel를 생성하는 코드
class WebtoonModel {
  final title, thumb, id;

  WebtoonModel.fromJson(Map<String, dynamic> json) // 웹툰 정보가 들어있는 object(객체)
      : title = json['title'], // title를 객체 json의 key(title)인 값(value)를 초기화
        thumb = json['thumb'],
        id = json['id'];
}
