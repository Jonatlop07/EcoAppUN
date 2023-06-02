import 'package:flutter/material.dart';

import '../constants/app.sizes.dart';
import '../constants/breakpoints.dart';
import 'responsive_center.dart';

/// Scrollable widget that shows a responsive card with a given child widget.
/// Useful for displaying forms and other widgets that need to be scrollable.
class ResponsiveScrollableCard extends StatelessWidget {
  const ResponsiveScrollableCard({Key? key, required this.child}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ResponsiveCenter(
        maxContentWidth: Breakpoint.tablet,
        child: Padding(
          padding: insetsAll4,
          child: Card(
            child: Padding(
              padding: insetsAll4,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
