import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shop_ecom_app/widgets/title_text.dart';

class AppNameTextWidget extends StatelessWidget {
  const AppNameTextWidget({
    super.key,
    this.fontSize = 30,
  });

  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        period: const Duration(seconds: 12),
        baseColor: Colors.purple,
        highlightColor: Colors.yellow,
        child: TitlesTextWidget(
          label: "Shop Local",
          fontSize: fontSize,
        ));
  }
}
