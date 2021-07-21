import 'package:flutter/material.dart';

class BackgroundContainer extends StatelessWidget {
  final Widget widget;
  BackgroundContainer(this.widget);
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: const Color(0xff0B4B66),
          image: DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.dstATop),
            image: NetworkImage(
                "https://s3.ap-south-1.amazonaws.com/pb-egov-assets/pb.testing/Punjab-bg-QA.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: widget);
  }
}
