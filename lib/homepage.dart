import 'package:flutter/material.dart';
import 'package:healthmate/disease_prediction/diseaseprediction.dart';
import 'package:healthmate/firstaidguide.dart';
import 'package:healthmate/medicine_recommendation/medicinerecommendation.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    // Responsive font sizes
    double titleFontSize = screenWidth < 400
        ? 24
        : screenWidth < 800
            ? 29
            : 34;
    double tileTitleFontSize = screenWidth < 400
        ? 16
        : screenWidth < 800
            ? 19
            : 22;
    double tileTextFontSize = screenWidth < 400
        ? 12
        : screenWidth < 800
            ? 14
            : 16;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
  child: Text(
    "\n\n\n\nAI-Powered Health at Your Fingertips",
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: titleFontSize, // responsive size
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
                          builder: (_) => DiseasePredictionPage(),
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
                          builder: (_) =>
                              const MedicineRecommendationPage(),
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

/// Animated tile with hover lift, glow, dynamic height, and arrow animation
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
  _AnimatedFeatureTileState createState() => _AnimatedFeatureTileState();
}

class _AnimatedFeatureTileState extends State<AnimatedFeatureTile>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  bool _hover = false;
  double _elevation = 0;

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.95);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    // Calculate dynamic height
    double baseHeight = 120; // icon + padding
    double titleHeight = widget.tileTitleFontSize * 1.5;
    double textHeight = widget.tileTextFontSize * widget.tiletext.length / 20;
    double dynamicHeight = baseHeight + titleHeight + textHeight;

    return MouseRegion(
      onEnter: (_) => setState(() {
        _hover = true;
        _elevation = 10; // lift
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
                    color: Color(0x9901D6A4), // subtle glow
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
                      padding: EdgeInsets.only(
                        left: _hover ? 8 : 0, // slide arrow on hover
                      ),
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
