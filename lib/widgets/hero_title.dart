import 'package:flutter/material.dart';

import '../constants.dart';

class HeroTitle extends StatelessWidget {
  const HeroTitle({
    Key? key,
    @required this.title,
    @required this.subtitle,
  }) : super(key: key);

  final String? title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title!,
            style: TextStyle(
              fontSize: Config.screenWidth! * 0.065,
              // fontWeight: FontWeight.bold,
              color: Constants.Kprimary,
            ),
          ),
          SizedBox(height: Config.screenHeight! * 0.002),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: Config.screenWidth! * 0.045,
            ),
          ),
          SizedBox(height: Config.screenHeight! * 0.005),
        ],
      ),
    );
  }
}
