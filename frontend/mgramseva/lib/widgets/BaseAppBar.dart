import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {

  final Text title;
  final AppBar appBar;
  final List<Widget> widgets;

  /// you can add more fields that meet your needs

  const BaseAppBar( this.title, this.appBar, this.widgets);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        centerTitle: false,
             titleSpacing: 0.0,
          title:  title,
      backgroundColor:  Color(0xff0B4B66),
      actions: widgets,
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}