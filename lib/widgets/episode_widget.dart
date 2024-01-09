import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webtoon/models/webtoon_episode_model.dart';

class Episode extends StatelessWidget {
  // detail_screen.dart에서 Episode 생성자 파라미터에 저장된 데이터들을 받음
  const Episode({
    super.key,
    required this.episode,
    required this.webtoonId,
  });

  final String webtoonId;
  final WebtoonEpisodeModel episode;

  // launchUrl는 Future를 가져다주는 함수
  onButtonTap() async {
    final url = Uri.parse(
        "https://comic.naver.com/webtoon/detail?titleId=$webtoonId&no=${episode.id}"); // webtoonId는 사용자가 클릭한 webtoon의 아이디 1개라서 중괄호 없음
    await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onButtonTap,
      child: Container(
        // 버튼 사이의 margin 설정
        margin: const EdgeInsets.only(
          bottom: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.green.shade400,
        ),
        // 버튼 안에 텍스트와 아이콘에 대한 padding 설정
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Row(
          // 텍스트와 아이콘에 대한 spacebetween으로 설정
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              episode.title,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            const Icon(
              Icons.chevron_right_outlined,
            ),
          ],
        ),
      ),
    );
  }
}
