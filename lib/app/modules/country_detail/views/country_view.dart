import 'dart:ui';

import 'package:chewie/chewie.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_travel_app/app/data/global_widgets/custom_app_bar.dart';
import 'package:flutter_travel_app/app/data/models/country_model.dart';
import 'package:flutter_travel_app/app/data/models/places_models.dart';
import 'package:flutter_travel_app/app/modules/country_detail/controllers/country_detail_controller.dart';
import 'package:flutter_travel_app/app/modules/place_detail/views/place_detail.dart';
import 'package:get/get.dart';

class CountryDetailView extends StatefulWidget {
  final int id;
  final CountryModel countryModel;
  final ChewieController chewieController;
  CountryDetailView({required this.chewieController, required this.id, required this.countryModel});

  @override
  _CountryDetailViewState createState() => _CountryDetailViewState();
}

class _CountryDetailViewState extends State<CountryDetailView> with TickerProviderStateMixin {
  bool isSwipeUp = false;
  late DragStartDetails startVerticalDragDetails;
  late DragUpdateDetails updateVerticalDragDetails;
  late AnimationController animationController;
  late Animation<Offset> slideAnim;
  late AnimationController slideController;

  String get countryName => widget.countryModel.name;
  String? get description => widget.countryModel.description;
  List<PlacesModel> get places => widget.countryModel.placeVisit;
  int get totalPlaceVisit => widget.countryModel.totalPlaceVisit;
  PlacesModel place(int index) => places[index];
  String placeName(int index) => places[index].name;
  String imageAssset(int index) => widget.countryModel.placeVisit[index].photos.first;

  void onSwipeUp() {
    setState(() {
      isSwipeUp = !isSwipeUp;
    });
    Future<void> future = showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      barrierColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      builder: (context) {
        return Scaffold(
          appBar: CustomAppBar(
            childs: [],
            onTapBack: () {
              Get.back();
            },
            homeIcon: Icon(
              EvaIcons.arrowBackOutline,
            ),
          ),
          backgroundColor: Colors.transparent,
          body: Container(
              height: Get.height,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Column(
                children: <Widget>[
                  Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            countryName,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                          ),
                          const SizedBox(height: 10),
                          countryName.isEmpty ? const SizedBox() : Text(description!),
                        ],
                      )),
                  const SizedBox(height: 20),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text("Place to visit", style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: ListView.separated(
                            separatorBuilder: (context, index) => const SizedBox(width: 10),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: totalPlaceVisit,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Get.to(() => PlaceDetail(place: place(index)),
                                      preventDuplicates: false);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: SizedBox(
                                    height: 100,
                                    width: 200,
                                    child: Stack(
                                      children: [
                                        SizedBox.expand(
                                          child: Image.asset(
                                            imageAssset(index),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 10,
                                          left: 10,
                                          child: Text(
                                            placeName(index),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              shadows: [
                                                Shadow(
                                                    offset: Offset(1.0, 2.0),
                                                    blurRadius: 3.0,
                                                    color: Colors.black.withOpacity(0.2)),
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
                          ),
                        ),
                      ),
                    ],
                  ))
                ],
              )),
        );
      },
    );
    future.then((_) => onCloseModal());
  }

  void onSwipeDown() {
    setState(() {
      isSwipeUp = !isSwipeUp;
    });
  }

  void onCloseModal() {
    setState(() {
      isSwipeUp = false;
    });
  }

  void onVerticalDragEnd(DragEndDetails endDetails) {
    double dx =
        updateVerticalDragDetails.globalPosition.dx - startVerticalDragDetails.globalPosition.dx;
    double dy =
        updateVerticalDragDetails.globalPosition.dy - startVerticalDragDetails.globalPosition.dy;
    double? velocity = endDetails.primaryVelocity;

    //Convert values to be positive
    if (dx < 0) dx = -dx;
    if (dy < 0) dy = -dy;

    if (velocity! < 0) {
      onSwipeUp();
    } else {
      //onSwipeDown();
    }
  }

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: 800.milliseconds);
    slideAnim = Tween(begin: Offset.zero, end: Offset(0, -1)).animate(animationController);
    animationController.repeat(reverse: true);

    slideController = AnimationController(vsync: this, duration: 500.milliseconds);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(CountryDetailController());
    widget.chewieController.videoPlayerController.pause();
    return WillPopScope(
      onWillPop: () {
        widget.chewieController.videoPlayerController.play();

        return Future.value(true);
      },
      child: GestureDetector(
        onVerticalDragStart: (dragDetails) {
          startVerticalDragDetails = dragDetails;
        },
        onVerticalDragUpdate: (dragDetails) {
          updateVerticalDragDetails = dragDetails;
        },
        onVerticalDragEnd: onVerticalDragEnd,
        child: Hero(
          tag: widget.id,
          child: Material(
            child: Container(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SizedBox.expand(
                      child: Chewie(
                        controller: widget.chewieController,
                      ),
                    ),
                  ),
                  isSwipeUp
                      ? BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            color: Colors.black.withOpacity(0.2),
                          ),
                        )
                      : const SizedBox(),
                  !isSwipeUp
                      ? Positioned(
                          left: 20,
                          bottom: 100,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.countryModel.name,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                                ),
                                const SizedBox(height: 10),
                                Text("${widget.countryModel.totalPlaceVisit} place to visit")
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                  !isSwipeUp
                      ? Positioned(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: SlideTransition(
                              position: slideAnim,
                              child: FadeTransition(
                                opacity: animationController,
                                child: Icon(
                                  EvaIcons.arrowUpwardOutline,
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
