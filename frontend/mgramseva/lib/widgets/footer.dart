import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25),
      child: Image(
          width: 140,
          image: NetworkImage(
            "https://s3.ap-south-1.amazonaws.com/egov-qa-assets/digit-footer.png",
          )),
    );
  }
}
