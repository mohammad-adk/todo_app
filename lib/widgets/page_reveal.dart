import 'package:flutter/material.dart';

import './circular_reveal_clipper.dart';

/// This class reveals the next page in the circular form.
class PageReveal extends StatelessWidget {
  final double revealPercent;
  final Widget child;

  //Constructor
  PageReveal({this.revealPercent, this.child});

  @override
  Widget build(BuildContext context) {
    //ClipOval cuts the page to circular shape.
    return ClipOval(
      clipper:  CircularRevealClipper(revealPercent: revealPercent),
      child: child,
    );
  }
}
