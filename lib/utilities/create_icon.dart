import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
// ignore: must_be_immutable
class CreateIcon extends StatefulWidget {
  String iconPath;
  CreateIcon({
     this.iconPath
  });
  @override
  _CreateIconState createState() => _CreateIconState();
}

class _CreateIconState extends State<CreateIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 3.75.h,
        width: 6.66.w,
        child: Image.asset(widget.iconPath,
          fit: BoxFit.cover,)
    );
  }
}
