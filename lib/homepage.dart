import 'package:flutter/material.dart';
import 'package:healthmate/diseaseprediction.dart';
import 'package:healthmate/expirytracker.dart';
import 'package:healthmate/firstaidguide.dart';
import 'package:healthmate/intakereminder.dart';
import 'package:healthmate/medicinerecommendation.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // // Glowing Mic Button
              // Center(
              //   child: Container(
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       gradient: const RadialGradient(
              //         colors: [
              //           Color(0xFF00A57E),
              //           Color(0xFF056443),
              //           Colors.black,
              //         ],
              //         radius: 0.8,
              //       ),
              //       boxShadow: const [
              //         BoxShadow(
              //           color: Color(0xA000A57E),
              //           blurRadius: 25,
              //           spreadRadius: 5,
              //         ),
              //       ],
              //     ),
              //     padding: const EdgeInsets.all(20),
              //     child: const Icon(Icons.mic, size: 40, color: Colors.white),
              //   ),
              // ),
              // const SizedBox(height: 24),

              // Title Text
              const Center(
                child: Text(
                  "\n\n\nWelcome to HealthMate",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF01D6A4),
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Project Feature Tiles (3 + 2 layout)
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
       featureTile("Disease Prediction","\nAI-powered symptom analysis", Icons.coronavirus, () {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => const DiseasePredictionPage(),
      ));
    }),
featureTile("Medicine Recommendation","\nPersonalized medicine", Icons.medical_services, () {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => const Medicinerecommendation(),
      ));
    }),     ],
    ),
    const SizedBox(height: 16),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
featureTile("Medicine Expiry Tracker","\nMonitor medication expiry date with smart notifications", Icons.date_range, () {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => const Expirytracker(),
      ));
    }),
featureTile("Medicine Intake Reminder","\nSet timely reminders so you never miss", Icons.alarm, () {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => const Intakereminder(),
      ));
    }),      ],
    ),
    const SizedBox(height: 16),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
featureTile("First Aid Guide","\nEssential procedures and tips", Icons.health_and_safety, () {
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => const Firstaidguide(),
      ));
    }),      ],
    ),
  ],
)

                ],
              ),
              const SizedBox(height: 30),

              // // Start Button
              // emeraldButton("Start with HealthMate", onTap: () {
              //   // Navigate or perform action
              // }),
              const SizedBox(height: 20),

              // Sign In / Sign Up Buttons
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     emeraldButton("Sign Up", width: 140),
              //     emeraldButton("Sign In", width: 140),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

 Widget featureTile(String title,String tiletext, IconData icon, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 170,
      height: 190,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF056443), Color(0xFF013924)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFF00A57E), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x6600A57E),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align to left
        children: [
          Icon(icon, size: 34, color: const Color(0xFF01D6A4)),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF01D6A4),
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(children: [
            Expanded(child: Text(
            tiletext,
            style: const TextStyle(
              color: Color.fromARGB(255, 38, 143, 118),
              fontSize: 14,
              // fontWeight: FontWeight.w600,
            ),
          ),),

          Icon(Icons.arrow_forward,color: Color.fromARGB(255, 38, 143, 118),)
          ],)
          
        ],
      ),
    ),
  );
}


  // Widget emeraldButton(String text, {VoidCallback? onTap, double? width}) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Container(
  //       width: width ?? double.infinity,
  //       padding: const EdgeInsets.symmetric(vertical: 14),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(30),
  //         gradient: const LinearGradient(
  //           begin: Alignment.topLeft,
  //           end: Alignment.bottomRight,
  //           colors: [
  //             Color(0xFF00A57E),
  //             Color(0xFF056443),
  //             Color(0xFF013924),
  //           ],
  //         ),
  //         boxShadow: const [
  //           BoxShadow(
  //             color: Color(0x9900A57E),
  //             blurRadius: 15,
  //             spreadRadius: 2,
  //             offset: Offset(0, 4),
  //           ),
  //         ],
  //       ),
  //       child: Center(
  //         child: Text(
  //           text,
  //           style: const TextStyle(
  //             color: Colors.white,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
