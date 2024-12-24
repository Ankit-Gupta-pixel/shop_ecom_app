import 'package:flutter/material.dart';
import 'package:shop_ecom_app/widgets/subtitle_text.dart';
import 'package:shop_ecom_app/widgets/title_text.dart';

class EmptyBagWidget extends StatelessWidget {
  const EmptyBagWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.buttonText, 
    //required String buttonText,
  });
  final String imagePath, title, subtitle, buttonText;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Image.asset(
            imagePath,
            width: double.infinity,
            height: size.height * 0.45,
          ),
          TitlesTextWidget(
            label: title,
            fontSize: 30,
            color: Colors.black87,
          ),
          const SizedBox(
            height: 20,
          ),
          SubtitleTextWidget(
            label: subtitle,
            color: Colors.redAccent,
            fontSize: 25,
          ),
          const SizedBox(
            height: 10,
          ),
          /* Padding(
            padding: const EdgeInsets.all(0.0),
            child: SubtitleTextWidget(
              label: subtitle,
              color: Colors.redAccent,
              fontSize: 25,
            ),
          ), */
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.orange,
            ),
            onPressed: () {},
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}
