import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webtoon/models/webtoon_detail_model.dart';
import 'package:webtoon/models/webtoon_episode_model.dart';
import 'package:webtoon/services/api_service.dart';
import 'package:webtoon/widgets/episode_widget.dart';

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
  late SharedPreferences prefs;
  bool isLiked = false;

  // 애플리케이션을 처음 실행시켰을 때 likedToons 리스트가 사용자의 저장소에 있는지 없는지 확인하는 함수
  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final likedToons = prefs.getStringList('likedToons');
    // 저장소에 리스트 likedToons가 있다면 웹툰 아이디가 있는지 확인
    if (likedToons != null) {
      // 있으면 isliked를 true로 설정(좋아요)
      if (likedToons.contains(widget.id) == true) {
        setState(() {
          isLiked = true;
        });
      }
    }
    // 없으면 likedToons 리스트 생성
    else {
      await prefs.setStringList('likedToons', []);
    }
  }

  @override
  void initState() {
    super.initState();
    webtoon = ApiService().getToonById(widget.id);
    episode = ApiService().getLatestEpisoidesById(widget.id);
    initPrefs();
  }

  // likedToons 리스트를 확인해 있을 때 좋아요일 경우 웹툰 id 삭제하고 좋아요가 아닐 경우 웹툰 id 추가해서 리스트를 저장소에 저장
  onHeartTap() async {
    final likedToons = prefs.getStringList('likedToons');
    if (likedToons != null) {
      if (isLiked) {
        likedToons.remove(widget.id);
      } else {
        likedToons.add(widget.id);
      }
      await prefs.setStringList('likedToons', likedToons);
      setState(() {
        isLiked = !isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2, // 밑의 그림자 설정
        shadowColor: Colors.black, // 그림자 색깔 설정ㅇ
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: onHeartTap,
            icon: isLiked
                ? const Icon(Icons.favorite_outline_outlined)
                : const Icon(Icons.favorite_rounded),
          )
        ],
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        // 위젯이 overflow 시 사용
        child: Padding(
          // 전체 body 내용 padding 50 설정
          padding: const EdgeInsets.symmetric(
            horizontal: 50,
            vertical: 50,
          ),
          child: Column(
            children: [
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
                            color:
                                Colors.black.withOpacity(0.3), // 그림자 색깔과 투명도 설정
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

              // 웹툰 상세 정보
              FutureBuilder(
                future: webtoon, // WebtoonDetailModel 클래스 타입
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
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
                          height: 20,
                        ),

                        // 웹툰 genre, age 출력
                        Text(
                          '${snapshot.data!.genre} / ${snapshot.data!.age}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    );
                  }
                  return const Text('...');
                },
              ),

              const SizedBox(
                height: 20,
              ),

              // 웹툰 에피소드
              FutureBuilder(
                future: episode,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      // list 개수가 정해져있을 시 Column 사용
                      children: [
                        for (var episode in snapshot.data!)

                          // 에피소드 회차 버튼을 다른 클래스로 분리
                          Episode(
                            // WebtoonEpisodeDetail 클래스에 있는 에피소드 정보들을 부름
                            episode: episode,
                            // DetailScreen의 ID를 뜻하는데 사용자가 클릭한 webtoon들을 부름
                            webtoonId: widget.id,
                          ),
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
