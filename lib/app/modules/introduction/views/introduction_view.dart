import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

import '../controllers/introduction_controller.dart';

class IntroductionView extends GetView<IntroductionController> {
  const IntroductionView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      bodyTextStyle: TextStyle(
        fontSize: 18,
      ),
      bodyPadding: EdgeInsets.all(16),
    );
    return Scaffold(
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            title: "Kepulangan PMI",
            body:
                "Mudahnya dalam mengelola data PMI Bermasalah, CPMI, Jenazah, dll.",
            image: Lottie.asset(
              'assets/lotties/introduction-1.json',
              width: 250,
              height: 250,
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Bebas Atur Penanganan & Pemulangan PMI",
            body: "Anda dapat mengatur penanganan & pemulangan untuk para PMI",
            image: Lottie.asset(
              'assets/lotties/introduction-2.json',
              width: 250,
              height: 250,
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Pengelolaan Berkas",
            body: "Memudahkan Anda dalam pelaporan data",
            image: Lottie.asset(
              'assets/lotties/introduction-3.json',
              width: 250,
              height: 250,
            ),
            decoration: pageDecoration,
          ),
        ],
        onDone: () async {
          await controller.doneIntoduction();
        },
        showSkipButton: true,
        showNextButton: true,
        showDoneButton: true,
        showBackButton: false,
        dotsFlex: 3,
        nextFlex: 1,
        skipOrBackFlex: 1,
        back: const Icon(Icons.arrow_back),
        next: const Icon(Icons.arrow_forward),
        skip: const Text(
          'Lewati',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        done: const Text(
          'Selesai',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        dotsDecorator: const DotsDecorator(
          size: Size(10, 10),
          activeSize: Size(22, 10),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
        ),
      ),
    );
  }
}
