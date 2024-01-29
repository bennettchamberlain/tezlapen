import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  const ResponsiveWidget({
    required this.largeScreen,
     this.smallScreen,
     this.mediumScreen,
    super.key,
  });
  final Widget largeScreen;
  final Widget? smallScreen;
  final Widget? mediumScreen;
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 650;


  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 650;


  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return largeScreen;
        } else if (constraints.maxWidth <= 1200 &&
            constraints.maxWidth >= 800) {
          return mediumScreen ?? largeScreen;
        } else {
          return smallScreen ?? largeScreen;
        }
      },
    );
  }
}
