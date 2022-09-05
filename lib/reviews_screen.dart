// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mechanic/widgets/AppText/AppText.dart';
import 'package:mechanic/widgets/const.dart';

class ReviewsScreen extends StatefulWidget {
  ScrollController scrollcontroller = ScrollController();
  ReviewsScreen({Key? key, required this.scrollcontroller}) : super(key: key);

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: widget.scrollcontroller,
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Center(
                child: Txt(
                  text: 'Ratings & Reviews',
                  bold: true,
                  size: 24,
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                decoration: BoxDecoration(
                  color: pagesBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 0),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    RatingBar(
                      ignoreGestures: true,
                      glow: false,
                      initialRating: 3.5,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      ratingWidget: RatingWidget(
                        full: Icon(Icons.star_rounded),
                        half: Icon(Icons.star_half_rounded),
                        empty: Icon(Icons.star_outline_rounded),
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                    Txt(
                      text: '3.5',
                      size: 24,
                      bold: true,
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: pagesBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 0),
                    ),
                  ],
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Txt(
                        text: 'Reviews History',
                        size: 14,
                        bold: true,
                      ),
                    ),
                    Divider(
                      height: 0,
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 10,
                      itemBuilder: (context, i) {
                        return ListTile(
                          title: Txt(text: 'Customer Name'),
                          subtitle: Txt(text: 'Comment or Review'),
                          trailing: RatingBar(
                            itemSize: 14,
                            ignoreGestures: true,
                            glow: false,
                            initialRating: 3.5,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            ratingWidget: RatingWidget(
                              full: Icon(Icons.star_rounded),
                              half: Icon(Icons.star_half_rounded),
                              empty: Icon(Icons.star_outline_rounded),
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                          leading: CircleAvatar(),
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
