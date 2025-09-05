import 'package:flutter/material.dart';

class FirstAidGuide extends StatelessWidget {
  const FirstAidGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // ✅ Match Homepage
      appBar: AppBar(
        backgroundColor: const Color(0xFF056443), // ✅ Dark green like Homepage
        title: const Text(
          'First Aid Guide',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: const Color(0xFF013924),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Comprehensive First Aid Guide',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Step-by-step instructions for common emergencies, empowering you to act confidently when it matters most.',
                      style: TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Main Topics
            const Text(
              'First Aid Topics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.85,
              children: [
                firstAidCard("Burns", "Cool burn under running water, cover with clean cloth.", Icons.local_fire_department),
                firstAidCard("Fractures", "Immobilize injured area, seek medical help.", Icons.personal_injury),
                firstAidCard("Choking", "Perform Heimlich maneuver if needed.", Icons.restaurant),
                firstAidCard("CPR", "30 chest compressions & 2 breaths.", Icons.favorite),
                firstAidCard("Cuts & Wounds", "Clean, disinfect & cover with sterile dressing.", Icons.content_cut),
              ],
            ),

            const SizedBox(height: 20),

            // Child Topics
            const Text(
              'Child Care Topics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),

            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.95, // ✅ Taller cards
              children: [
                firstAidCard("Heat Stroke", "Move to shade, hydrate, cool body quickly.", Icons.wb_sunny, isChild: true),
                firstAidCard("Frostbite", "Warm area gradually, avoid rubbing skin.", Icons.ac_unit, isChild: true),
                firstAidCard("Allergic Reaction", "Use epinephrine if severe, call help.", Icons.sick, isChild: true),
              ],
            ),

            const SizedBox(height: 20),

            // Emergency Contacts
            const Text(
              'Emergency Contacts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),

            const Card(
              color: Color(0xFF013924),
              child: ListTile(
                leading: Icon(Icons.phone, color: Colors.white),
                title: Text(
                  'National Emergency',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'Dial 112 in case of emergency',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Reusable card widget
  static Widget firstAidCard(String title, String subtitle, IconData icon, {bool isChild = false}) {
    return Card(
      color: const Color(0xFF013924),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, size: isChild ? 28 : 40, color: const Color(0xFF01D6A4)),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isChild ? 13 : 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Flexible(
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isChild ? 10 : 13,
                  color: Colors.white70,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}