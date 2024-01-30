import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:ohm_pad/utils/constants/color_constants.dart';

class RoundedGradientButton extends StatelessWidget {
  final String buttonText;
  final double width;
  final Function onpressed;
  final double radius;
  final double height;
  final bool isAcc;

  RoundedGradientButton({
    required this.buttonText,
    required this.width,
    required this.onpressed,
    this.radius = 10,
    this.height = 60,
    this.isAcc = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 1.0],
            colors: [
              ColorConstants.SECONDARY_COLOR,
              ColorConstants.THEME_PINK_COLOR,
            ],
          ),
          //color: Colors.deepPurple.shade300,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
            ),
            minimumSize: MaterialStateProperty.all(Size(width, height)),
            backgroundColor:
            MaterialStateProperty.all(Colors.transparent),
            // elevation: MaterialStateProperty.all(3),
            shadowColor:
            MaterialStateProperty.all(Colors.transparent),
          ),
          onPressed: () {
            onpressed();
          },
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            child: Text(
              buttonText,
              style: Get.theme!.textTheme.headline6!.copyWith(fontSize: isAcc ? 28 : 18 ,fontWeight: FontWeight.bold,color: Colors.white)
            ),
          ),
        ),
      ),
    );
  }
}