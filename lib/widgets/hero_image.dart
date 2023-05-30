import 'package:flutter/material.dart';

import '../constants.dart';

class HeroImage extends StatelessWidget {
  const HeroImage({
    Key? key,
    @required this.path,
    @required this.sementicLabel,
  }) : super(key: key);

  final String? path, sementicLabel;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Config.screenHeight! * 0.02),
        child: Image.asset(
          path!,
          semanticLabel: sementicLabel,
        ),
      ),
    );
  }
}
