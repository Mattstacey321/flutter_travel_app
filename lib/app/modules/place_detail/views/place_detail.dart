import 'dart:ui';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_travel_app/app/data/models/places_models.dart';
import 'package:flutter_travel_app/app/modules/place_detail/widgets/photo_item.dart';
import 'package:get/get.dart';

class PlaceDetail extends StatefulWidget {
  final PlacesModel place;
  PlaceDetail({required this.place});

  @override
  _PlaceDetailState createState() => _PlaceDetailState();
}

class _PlaceDetailState extends State<PlaceDetail> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  PlacesModel get place => widget.place;

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: 500.milliseconds);
    animationController.forward();
    super.initState();
  }

  Widget _buildItem(Widget child, int index) {
    return FadeTransition(
      opacity: animationController,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(-1, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Interval(
              0.100 + index * 0.05,
              0.150 + index * 0.05,
              curve: Curves.ease,
            ),
          ),
        ),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverPadding(
            padding: EdgeInsets.all(20),
            sliver: SliverFillRemaining(
              child: Column(
                children: <Widget>[
                  _buildItem(_buildDescription(), 0),
                  const SizedBox(height: 30),
                  _buildItem(_buildPhotos(), 1),
                  const SizedBox(height: 30),
                  _buildItem(_buildReview(), 2),
                  const SizedBox(height: 30),
                  _buildItem(_buildFeatureSpot(), 3),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      snap: true,
      floating: true,
      expandedHeight: 160.0,
      actionsIconTheme: IconThemeData(opacity: 0.0),
      flexibleSpace: Stack(
        children: <Widget>[
          Positioned.fill(
              child: Image.asset(
            widget.place.photos.first,
            fit: BoxFit.cover,
          )),
          Positioned(
            bottom: 10,
            left: 30,
            child: Text(
              widget.place.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      widget.place.description!,
      style: TextStyle(fontSize: 16),
    );
  }

  Widget _buildPhotos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Photos",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 10),
        Container(
          height: 100,
          width: Get.width,
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: widget.place.photos.length,
            itemBuilder: (context, index) {
              return PhotoItem(
                imagePath: widget.place.photos[index],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Review",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 25,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),
            Row(
              children: [
                Text("Add a review"),
                Icon(EvaIcons.arrowForwardOutline),
              ],
            )
          ],
        )
      ],
    );
  }

  Widget _buildFeatureSpot() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Feature Spot",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Text("Nothing"),
          ],
        )
      ],
    );
  }
}
