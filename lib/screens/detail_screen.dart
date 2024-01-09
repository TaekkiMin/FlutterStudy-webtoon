import 'package:flutter/material.dart';
import 'package:webtoon/models/webtoon_detail_model.dart';
import 'package:webtoon/models/webtoon_episode_model.dart';
import 'package:webtoon/services/api_service.dart';

class DetailScreen extends StatefulWidget {
  final String title, thumb, id;

  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDeatailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> episode;

  @override
  void initState() {
    super.initState();
    webtoon = ApiService().getToonById(widget.id);
    episode = ApiService().getLatestEpisoidesById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2, // 밑의 그림자 설정
        shadowColor: Colors.black, // 그림자 색깔 설정ㅇ
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: widget.id, // 여기서 id는 webtoon의 id
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
                    widget.thumb,
                    headers: const {
                      "User-Agent":
                          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          FutureBuilder(
            future: webtoon, // WebtoonDetailModel 클래스 타입
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 웹툰 about 출력
                      Text(
                        snapshot.data!.about,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      // 웹툰 genre, age 출력
                      Text(
                        '${snapshot.data!.genre} / ${snapshot.data!.age}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const Text('...');
            },
          ),
        ],
      ),
    );
  }
}
