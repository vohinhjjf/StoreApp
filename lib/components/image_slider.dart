import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:store_app/Firebase/firebase_realtime_data_service.dart';

class ImageSlider extends StatefulWidget {
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  var customerApiProvider = CustomerApiProvider();
  int _index = 0;
  int _dataLength=1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          if(_dataLength!=0)
            Padding(
              padding: const EdgeInsets.all(15),
              child: StreamBuilder(
                stream: customerApiProvider.banner.snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if(snapshot.hasData){
                      return CarouselSlider(
                        items: snapshot.data!.docs.map((DocumentSnapshot document) {
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                    image: NetworkImage(document['image']),
                                    fit: BoxFit.cover)),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          height: 180.0,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                          viewportFraction: 0.8,
                        ),
                      );
                    }
                    else if(snapshot.hasError){}
                    return const Center(child: CircularProgressIndicator());
                },
              )
            ),
          if(_dataLength!=0)
            DotsIndicator(
              dotsCount: 3,
              position: _index.toDouble(),
              decorator: DotsDecorator(
                  size: const Size.square(5.0),
                  activeSize: const Size(18.0, 5.0),
                  activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  activeColor: Theme.of(context).primaryColor
              ),
            )
        ],
      ),
    );
  }
}