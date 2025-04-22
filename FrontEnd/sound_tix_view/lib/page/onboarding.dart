import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sound_tix_view/components/app_localizations.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _IntroductionState();
}

class _IntroductionState extends State<Onboarding> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() => isLastPage = index == 2);
          },
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    Image.asset(
                      "images/soundtix_logo.png",
                      height: 350,
                      width: 350,
                    ),
                    Text(
                      AppLocalizations.of(context).translate("SoundTix - Touch the Music"),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color.fromARGB(255, 95, 95, 95)),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context).translate("Book tickets easily and quickly for the hottest concerts."),
                      style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 120, 120, 120)),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    Image.asset(
                      "images/secure_payment.png",
                      height: 350,
                      width: 350,
                    ),
                    Text(
                      AppLocalizations.of(context).translate("Safe and secure payment"),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color.fromARGB(255, 95, 95, 95)),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context).translate(
                          "Provide a safe and secure payment system, protecting customer personal information throughout the booking process."),
                      style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 120, 120, 120)),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    Image.asset(
                      "images/e-ticket.jpg",
                      height: 350,
                      width: 350,
                    ),
                    Text(
                      AppLocalizations.of(context).translate("E-Tickets - Carry the Concert in Your Pocket"),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color.fromARGB(255, 95, 95, 95)),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context).translate(
                          "No more worrying about forgetting or losing paper tickets, now everything is digitized and secure at your fingertips."),
                      style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 120, 120, 120)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                backgroundColor: const Color(0xFF2DC275),
                minimumSize: const Size.fromHeight(70),
              ),
              onPressed: () async {
                context.go('/login');
              },
              child: Text(
                AppLocalizations.of(context).translate("Get Started"),
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
              ),
            )
          : Container(
              padding: const EdgeInsets.all(20),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => controller.jumpToPage(2),
                    child: Text(
                      AppLocalizations.of(context).translate("Skip"),
                      style: const TextStyle(color: Color(0xFF2DC275)),
                    ),
                  ),
                  Center(
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: 3,
                      effect: const WormEffect(spacing: 16, dotColor: Colors.black26, activeDotColor: Color(0xFF2DC275)),
                      onDotClicked: (index) => controller.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.easeIn),
                    ),
                  ),
                  TextButton(
                    onPressed: () => controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeOut),
                    child: Text(
                      AppLocalizations.of(context).translate("Next"),
                      style: const TextStyle(color: Color(0xFF2DC275)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
