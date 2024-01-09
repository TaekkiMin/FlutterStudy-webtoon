import 'package:flutter/material.dart';
import 'package:webtoon/screens/detail_screen.dart';

class Webtoon extends StatelessWidget {
  final String title, thumb, id;

  const Webtoon({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context, // 해당 화면이 생성될 때의 컨텍스트
          MaterialPageRoute(
            // builder: 새로운 화면을 생성하고 반환하는 역할
            // 여기서 context는 현재 페이지 혹은 화면의 컨텍스트
            // 해당 함수가 호출된 페이지의 컨텍스트를 나타내며, 새로운 화면의 내용을 생성하고 렌더링하는 데 사용
            builder: (context) =>
                DetailScreen(title: title, thumb: thumb, id: id),
            fullscreenDialog: true, // 위에서 스크린이 나오게 설정
          ),
        );
      },
      child: Column(
        children: [
          Hero(
            tag: id,
            child: Container(
              width: 250,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 15, // 그림자 지름(크기) 설정
                    offset: const Offset(10, 10), // 그림자 위치 설정
                    color: Colors.black.withOpacity(0.3), // 그림자 색깔과 투명도 설정
                  ),
                ],
              ),
              child: Image.network(
                // image의 src를 통해 이미지 썸네일 출력
                thumb,
                headers: const {
                  "User-Agent":
                      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                },
              ),
            ),
          ),
          // 웹툰 thumb과 title 사이의 간격 조정
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}
