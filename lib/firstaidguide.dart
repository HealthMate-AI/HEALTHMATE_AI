import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MaterialApp(
    home: const FirstAidGuide(),
    theme: ThemeData.dark(),
  ));
}

class FirstAidGuide extends StatelessWidget {
  const FirstAidGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF056443),
        title: const Text('First Aid Guide', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF013924), Color(0xFF01D6A4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Comprehensive First Aid Guide',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Step-by-step instructions for common emergencies, empowering you to act confidently when it matters most.',
                      style: TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('First Aid Topics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: (MediaQuery.of(context).size.width / 120).floor(),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 0.6,
              children: [
                firstAidCard(
                  context,
                  "Burns",
                  Icons.local_fire_department,
                  imageUrl: "assets/burn1.jpg",
                  steps: [
                    {"title": "Cool under running water", "image": "assets/burn1.jpg"},
                    {"title": "Remove hot/wet clothing", "image": "assets/burn2.jpg"},
                    {"title": "Remove watch,jewellery,rings or tight clothing", "image": "assets/burn3.jpg"},
                    {"title": "If the victim is pale & feeling unwell", "image": "assets/burn4.jpg"},
                    {"title": "For large burn", "image": "assets/burn5.jpg"},
                    {"title": "Apply dressing and light bandage", "image": "assets/burn6.jpg"},
                    {"title": "Do not apply cream,ice or oinments ", "image": "assets/burn7.jpg"},
                  ],
                ),
                firstAidCard(
                  context,
                  "Fractures",
                  Icons.personal_injury,
                  imageUrl: "assets/fracture1.jpg",
                  steps: [
                    {"title": "Check for wounds", "image": "assets/fracture1.jpg"},
                    {"title": "Immobilise & support the injured limb", "image": "assets/fracture2.jpg"},
                    {"title": "Make the victim comfortable", "image": "assets/fracture3.jpg"},
                    {"title": "Treat to reduce shock", "image": "assets/fracture4.jpg"},
                    {"title": "Monitor vital signs", "image": "assets/fracture5.jpg"},
                    {"title": "Seek medical attention", "image": "assets/medicine.jpg"},
                  ],
                ),
                firstAidCard(
                  context,
                  "Choking",
                  Icons.restaurant,
                  imageUrl: "assets/choking_step1.jpg",
                  steps: [
                    {"title": "Reassure victim.Encourage victim to cough & breathe", "image": "assets/choking1.jpg"},
                    {"title": "Monitor vital signs regularly", "image": "assets/choking2.jpg"},
                    {"title": "If unconscious ,begin cpr", "image": "assets/choking3.jpg"},
                    {"title": "No back blows if breathing", "image": "assets/choking4.jpg"},
                    {"title": "Seek medical attention", "image": "assets/medicine.jpg"},
                  ],
                ),
                firstAidCard(
                  context,
                  "CPR",
                  Icons.favorite,
                  imageUrl: "assets/cpr_step1.jpg",
                  steps: [
                    {"title": "Check for danger", "image": "assets/cpr_step1.jpg"},
                    {"title": "Check response", "image": "assets/cpr_step2.jpg"},
                    {"title": "Open airway", "image": "assets/cpr_step3.jpg"},
                    {"title": "Begin CPR", "image": "assets/cpr_step4.jpg"},
                    {"title": "Child(1-8 yrs) and babies", "image": "assets/cpr_step5.jpg"},
                    {"title": "Chest compressions", "image": "assets/cpr_step6.jpg"},
                    {"title": "Rescue breaths", "image": "assets/cpr_step7.jpg"},
                    {"title": "Apply AED", "image": "assets/cpr_step8.jpg"},
                    {"title": "Continue CPR", "image": "assets/cpr_step9.jpg"},
                    {"title": "Normal breathing", "image": "assets/cpr_step10.jpg"},
                  ],
                ),
                firstAidCard(
                  context,
                  "Poisoning",
                  Icons.local_dining,
                  imageUrl: "assets/poisoning_step1.jpg",
                  steps: [
                    {"title": "Check danger", "image": "assets/poisoning1.jpg"},
                    {"title": "Clean up poison", "image": "assets/poisoning2.jpg"},
                    {"title": "Avoid contaminating yourself", "image": "assets/poisoning3.jpg"},
                    {"title": "Record poison details", "image": "assets/poisoning4.jpg"},
                    {"title": "Seek medical attention", "image": "assets/medicine.jpg"},
                  ],
                ),
                firstAidCard(
                  context,
                  "Cuts & Wounds",
                  Icons.content_cut,
                  imageUrl: "assets/wound_step1.jpg",
                  steps: [
                    {"title": "Stop bleeding", "image": "assets/wound1.jpg"},
                    {"title": "Wash hand & use gloves", "image": "assets/wound2.jpg"},
                    {"title": "Clean wound with saline or clean water", "image": "assets/wound3.jpg"},
                    {"title": "Apply & secure sterline dressing", "image": "assets/wound4.jpg"},
                    {"title": "Seek medical help", "image": "assets/wound5.jpg"},
                  ],
                ),
                firstAidCard(
                  context,
                  "Head Injury",
                  Icons.headset,
                  imageUrl: "assets/head_injury_step1.jpg",
                  steps: [
                    {"title": "Check for a response", "image": "assets/head1.jpg"},
                    {"title": "If unresponsive but breathing or partially responsive", "image": "assets/head2.jpg"},
                    {"title": "If responsive,lie the victim down", "image": "assets/head3.jpg"},
                    {"title": "Stop any bleeding", "image": "assets/head4.jpg"},
                    {"title": "Protect from hypothermia", "image": "assets/head5.jpg"},
                    {"title": "Seek medical assistance", "image": "assets/medicine.jpg"},
                  ],
                ),
                firstAidCard(
                  context,
                  "Allergic Reactions",
                  Icons.healing,
                  imageUrl: "assets/allergic_step1.jpg",
                  steps: [
                    {"title": "Assist the victim to be comfortable", "image": "assets/allergic1.jpg"},
                    {"title": "Assist with prescribed medicine", "image": "assets/allergic2.jpg"},
                    {"title": "Reaction caused by a chemical or liquid", "image": "assets/allergic3.jpg"},
                  ],
                ),
                firstAidCard(
                  context,
                  "Stroke",
                  Icons.local_hospital,
                  imageUrl: "assets/stroke_step1.jpg",
                  steps: [
                    {"title": "Check FAST", "image": "assets/stroke1.jpg"},
                    {"title": "Assess level of consiousness", "image": "assets/stroke2.jpg"},
                    {"title": "Monitor vital signs regularly", "image": "assets/stroke3.jpg"},
                    {"title": "Seek medical attention", "image": "assets/medicine.jpg"},
                  ],
                ),
                firstAidCard(
                  context,
                  "Seizures",
                  Icons.warning,
                  imageUrl: "assets/seizure_step1.jpg",
                  steps: [
                    {"title": "Protect the victim from injury", "image": "assets/seizure1.jpg"},
                    {"title": "Stay with the victim,loosen clothing", "image": "assets/seizure2.jpg"},
                    {"title": "Child seizure", "image": "assets/seizure3.jpg"},
                    {"title": "Recovery position", "image": "assets/seizure4.jpg"},
                    {"title": "Reassure the victim", "image": "assets/seizure5.jpg"},
                    {"title": "Monitor vital signs regularly", "image": "assets/seizure6.jpg"},
                    {"title": "Seek medical attention", "image": "assets/medicine.jpg"},
                  ],
                ),
                firstAidCard(
                  context,
                  "Snake Bite",
                  Icons.pool,
                  imageUrl: "assets/drowning_step1.jpg",
                  steps: [
                    {"title": "Manage danger", "image": "assets/bite1.jpg"},
                    {"title": "Stop & drop", "image": "assets/bite2.jpg"},
                    {"title": "Remove watch,jewellery,rings", "image": "assets/bite3.jpg"},
                    {"title": "Apply SMART(pressure) bandage", "image": "assets/bite4.jpg"},
                    {"title": "Splint & immobilise", "image": "assets/bite5.jpg"},
                    {"title": "Monitor & reassure the victim", "image": "assets/bite6.jpg"},
                    {"title": "Bring transport to the victim", "image": "assets/bite7.jpg"},
                  ],
                ),
                firstAidCard(
                  context,
                  "Shock",
                  Icons.local_hospital,
                  imageUrl: "assets/shock_step1.jpg",
                  steps: [
                    {"title": "Lie the victim flat", "image": "assets/shock1.jpg"},
                    {"title": "Treat any illnes or injury", "image": "assets/shock2.jpg"},
                    {"title": "Reassure victim", "image": "assets/shock3.jpg"},
                    {"title": "Maintain victim's body temperature", "image": "assets/shock4.jpg"},
                    {"title": "Monitor vital signs", "image": "assets/shock5.jpg"},
                    {"title": "Seek medical assistance", "image": "assets/medicine.jpg"},
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget firstAidCard(
    BuildContext context,
    String title,
    IconData icon, {
    String? imageUrl,
    List<Map<String, String>>? steps,
  }) {
    return InkWell(
      onTap: () {
        if (steps != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StepByStepDetailPage(
                title: title,
                steps: steps,
              ),
            ),
          );
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF013924), Color(0xFF01D6A4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 25, color: Colors.white),
              const SizedBox(height: 4),
              Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

class StepByStepDetailPage extends StatefulWidget {
  final String title;
  final List<Map<String, String>> steps;

  const StepByStepDetailPage({super.key, required this.title, required this.steps});

  @override
  State<StepByStepDetailPage> createState() => _StepByStepDetailPageState();
}

class _StepByStepDetailPageState extends State<StepByStepDetailPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF056443),
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.steps.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final step = widget.steps[index];
                return Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF013924), Color(0xFF01D6A4)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Step ${index + 1}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            step['title']!,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                step['image']!,
                                fit: BoxFit.contain, // Changed to contain to show full image
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey,
                                    child: const Center(
                                      child: Text(
                                        'Image not found',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.steps.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  width: 8.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? Colors.white : Colors.white38,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => launchUrl(Uri.parse('tel:108')),
        backgroundColor: const Color(0xFF01D6A4),
        child: const Icon(Icons.local_hospital, color: Colors.white),
      ),
    );
  }
}