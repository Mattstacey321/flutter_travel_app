import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_travel_app/app/modules/country_detail/views/country_view.dart';
import 'package:flutter_travel_app/app/modules/home/controllers/home_controller.dart';
import 'package:flutter_travel_app/app/modules/home/widgets/bottom_navigation_bar..dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var controller = Get.put(HomeController());
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(),
      body: Container(
        height: size.height,
        width: size.width,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Explorer",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                Text(
                  "new amazing countries",
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
            //build slider

            Expanded(
              child: controller.obx(
                (country) => ObxValue<RxList<Map<String, dynamic>>>(
                  (videoController) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: CarouselSlider.builder(
                        carouselController: controller.carouseController,
                        itemCount: videoController.length,
                        itemBuilder: (context, index, realIndex) {
                          final _videoController =
                              videoController[index]["controller"] as ChewieController;
                          return videoController.length == 0
                              ? Text("Loading")
                              : Material(
                                child: Hero(
                                  tag: index,
                                  child: GestureDetector(
                                      onTap: () {
                                        Get.to(
                                          () => CountryDetailView(
                                            id: index,
                                            countryModel: country![index],
                                            chewieController: _videoController,
                                          ),
                                        );
                                      },
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                            child: Chewie(controller: _videoController),
                                          ),
                                          Positioned(
                                            bottom: 80,
                                            child: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    country![index].name,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold, fontSize: 20),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                      "${country[index].totalPlaceVisit} place to visit")
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                ),
                              );
                        },
                        options: CarouselOptions(
                          enlargeCenterPage: true,
                          height: Get.height,
                          viewportFraction: 0.85,
                          onPageChanged: (index, reason) {
                            controller.changePage(index);
                          },
                        ),
                      ),
                    );
                  },
                  controller.videoControllers,
                ),
                onLoading: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            //indicator
            ObxValue<RxInt>(
              (index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedSmoothIndicator(
                      activeIndex: index.value,
                      count: controller.places.length,
                      duration: 200.milliseconds,
                      effect: SlideEffect(
                        spacing: 15.0,
                        radius: 4.0,
                        dotWidth: 20.0,
                        dotHeight: 3,
                        paintStyle: PaintingStyle.fill,
                        strokeWidth: 0,
                        dotColor: Colors.grey.withOpacity(0.5),
                        activeDotColor: Colors.white,
                      ),
                    ),
                  ],
                );
              },
              controller.newIndex,
            )
          ],
        ),
      ),
    );
  }
}
