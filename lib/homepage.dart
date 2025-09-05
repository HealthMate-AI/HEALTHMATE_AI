import 'package:flutter/material.dart';
import 'package:healthmate/disease_prediction/diseaseprediction.dart';
import 'package:healthmate/firstaidguide.dart';
import 'package:healthmate/loginpage.dart';
import 'package:healthmate/medicine_recommendation/medicinerecommendation.dart';
import 'package:healthmate/disease_prediction/past_predictions.dart';
import 'package:healthmate/medicine_recommendation/past_recommendations.dart';
import 'package:healthmate/expiry_tracker.dart';

class Homepage extends StatelessWidget {
  final String username;
  final String email;

  const Homepage({
    super.key,
    required this.username,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    double titleFontSize = screenWidth < 400 ? 24 : screenWidth < 800 ? 29 : 34;
    double tileTitleFontSize = screenWidth < 400 ? 16 : screenWidth < 800 ? 19 : 22;
    double tileTextFontSize = screenWidth < 400 ? 12 : screenWidth < 800 ? 14 : 16;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF01D6A4)),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          "HealthMate",
          style: TextStyle(color: Color(0xFF01D6A4)),
        ),
      ),
      drawer: HomepageDrawer(username: username, email: email),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "\n\nAI-Powered Health at Your Fingertips",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [Color(0xFF01D6A4), Color(0xFF056443)],
                      ).createShader(const Rect.fromLTWH(0, 0, 300, 0)),
                  ),
                ),
              ),
              const SizedBox(height: 70),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  AnimatedFeatureTile(
                    title: "Disease Prediction",
                    tiletext: "\nAI-powered symptom analysis",
                    icon: Icons.coronavirus,
                    tileTitleFontSize: tileTitleFontSize,
                    tileTextFontSize: tileTextFontSize,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DiseasePredictionPage(
                            username: username,
                            email: email,
                          ),
                        ),
                      );
                    },
                  ),
                  AnimatedFeatureTile(
                    title: "Medicine Recommendation",
                    tiletext: "\nPersonalized medicine",
                    icon: Icons.medical_services,
                    tileTitleFontSize: tileTitleFontSize,
                    tileTextFontSize: tileTextFontSize,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MedicineRecommendationPage(
                            username: username,
                            email: email,
                          ),
                        ),
                      );
                    },
                  ),
                  AnimatedFeatureTile(
  title: "Expiry Tracker",
  tiletext: "\nTrack and get notified about expiry",
  icon: Icons.date_range,
  tileTitleFontSize: tileTitleFontSize,
  tileTextFontSize: tileTextFontSize,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExpiryTrackerPage(
          username: username,
          email: email,
        ),
      ),
    );
  },
),
                  AnimatedFeatureTile(
                    title: "First Aid Guide",
                    tiletext: "\nEssential procedures and tips",
                    icon: Icons.health_and_safety,
                    tileTitleFontSize: tileTitleFontSize,
                    tileTextFontSize: tileTextFontSize,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const Firstaidguide(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Drawer
class HomepageDrawer extends StatefulWidget {
  final String username;
  final String email;

  const HomepageDrawer({
    super.key,
    required this.username,
    required this.email,
  });

  @override
  State<HomepageDrawer> createState() => _HomepageDrawerState();
}

class _HomepageDrawerState extends State<HomepageDrawer> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color.fromARGB(255, 19, 19, 19),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              color: const Color.fromARGB(255, 19, 19, 19),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      CircleAvatar(
  radius: 30,
  backgroundColor: const Color(0xFF01D6A4), // choose your theme color
  child: Text(
    widget.username.isNotEmpty
        ? widget.username[0].toUpperCase()
        : "",
    style: const TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
  ),
),

                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.username,
                              style: const TextStyle(
                                  color: Color(0xFF01D6A4),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            Text(
                              widget.email,
                              style: const TextStyle(color: Color(0xFF01D6A4), fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          color: const Color(0xFF01D6A4),
                        ),
                        onPressed: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                      ),
                    ],
                  ),
                  if (_isExpanded)
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        ListTile(
                          leading: const Icon(Icons.logout, color: Color(0xFF01D6A4)),
                          title: const Text("Logout",
                              style: TextStyle(color: Color(0xFF01D6A4))),
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginPage()),
                              (route) => false,
                            );
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const Divider(color: Color.fromARGB(255, 67, 67, 67), thickness: 1),
            _drawerItem(context, "Dashboard", Icons.dashboard, () {
              Navigator.pop(context);
            }),
            _drawerItem(context, "Disease Prediction", Icons.coronavirus, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DiseasePredictionPage(
                    username: widget.username,
                    email: widget.email,
                  ),
                ),
              );
            }),
            _drawerItem(context, "Medicine Recommendation", Icons.medical_services, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MedicineRecommendationPage(
                    username: widget.username,
                    email: widget.email,
                  ),
                ),
              );
            }),
            _drawerItem(context, "Expiry Tracker", Icons.date_range, () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ExpiryTrackerPage(
        username: widget.username,
        email: widget.email,
      ),
    ),
  );
}),

            _drawerItem(context, "First Aid Guide", Icons.health_and_safety, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const Firstaidguide()));
            }),
            _drawerItem(context, "Past Predictions", Icons.history, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PastPredictionsPage()));
            }),
            _drawerItem(context, "Past Recommendations", Icons.history_toggle_off, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PastRecommendationsPage()));
            }),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF01D6A4)),
      title: Text(title, style: const TextStyle(color: Color(0xFF01D6A4))),
      onTap: onTap,
    );
  }
}

// Feature Tile
class AnimatedFeatureTile extends StatefulWidget {
  final String title;
  final String tiletext;
  final IconData icon;
  final VoidCallback onTap;
  final double tileTitleFontSize;
  final double tileTextFontSize;

  const AnimatedFeatureTile({
    super.key,
    required this.title,
    required this.tiletext,
    required this.icon,
    required this.onTap,
    required this.tileTitleFontSize,
    required this.tileTextFontSize,
  });

  @override
  State<AnimatedFeatureTile> createState() => _AnimatedFeatureTileState();
}

class _AnimatedFeatureTileState extends State<AnimatedFeatureTile>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  bool _hover = false;
  double _elevation = 0;

  void _onTapDown(TapDownDetails details) => setState(() => _scale = 0.95);
  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
    widget.onTap();
  }
  void _onTapCancel() => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    double baseHeight = 120;
    double titleHeight = widget.tileTitleFontSize * 1.5;
    double textHeight = widget.tileTextFontSize * widget.tiletext.length / 20;
    double dynamicHeight = baseHeight + titleHeight + textHeight;

    return MouseRegion(
      onEnter: (_) => setState(() {
        _hover = true;
        _elevation = 10;
      }),
      onExit: (_) => setState(() {
        _hover = false;
        _elevation = 0;
      }),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            transform: Matrix4.translationValues(0, -_elevation, 0),
            width: 170,
            height: dynamicHeight.clamp(190, 250),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF056443), Color(0xFF013924)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF00A57E), width: 1),
              boxShadow: [
                const BoxShadow(
                  color: Color(0x6600A57E),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
                if (_hover)
                  const BoxShadow(
                    color: Color(0x9901D6A4),
                    blurRadius: 25,
                    spreadRadius: 5,
                  ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(widget.icon, size: 34, color: const Color(0xFF01D6A4)),
                const SizedBox(height: 12),
                Text(
                  widget.title,
                  style: TextStyle(
                    color: const Color(0xFF01D6A4),
                    fontSize: widget.tileTitleFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.tiletext,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 38, 143, 118),
                          fontSize: widget.tileTextFontSize,
                        ),
                      ),
                    ),
                    AnimatedPadding(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.only(left: _hover ? 8 : 0),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Color.fromARGB(255, 38, 143, 118),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
