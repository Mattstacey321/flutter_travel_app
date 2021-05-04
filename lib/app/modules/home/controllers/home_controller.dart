import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_travel_app/app/data/api/api_provider.dart';
import 'package:flutter_travel_app/app/data/models/country_model.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:video_player/video_player.dart';

class HomeController extends GetxController with StateMixin<List<CountryModel>> {
  ApiProvider _apiProvider = ApiProvider();
  var carouseController = CarouselController();
  var places = RxList<CountryModel>();
  var videoControllers = RxList<Map<String, dynamic>>();
  var oldIndex = 0.obs;
  var newIndex = 0.obs;

  void loadData() async {
    final json = await _apiProvider.loadJson();
    final result = CountryModel.fromList(json);
    places.addAll(result);
    change(result, status: RxStatus.success());
    loadVideo();
  }

  void loadVideo() async {
    final videos = places.map((item) {
      return {"id": item.id, "video": item.video};
    }).toList();
    for (var item in videos) {
      final videoController = VideoPlayerController.asset("${item["video"]}");
      await videoController.initialize();
      final chewieController = ChewieController(
        videoPlayerController: videoController,
        autoInitialize: true,
        showControls: false,
        looping: true,
        playbackSpeeds: [0.25]
        
      );
      videoControllers.add({"id": item["id"], "controller": chewieController});
    }
    (videoControllers[0]["controller"] as ChewieController).play();
  }

  void changePage(int index) {
    newIndex(index);
    if (oldIndex == newIndex) {
      (videoControllers[oldIndex.value]["controller"] as ChewieController).pause();
    } else {
      (videoControllers[newIndex.value]["controller"] as ChewieController).play();
    }
  }

  @override
  void onInit() {
    loadData();
    //loadVideo();
    super.onInit();
  }
}
