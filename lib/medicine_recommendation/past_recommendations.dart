import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PastRecommendationsPage extends StatelessWidget {
  const PastRecommendationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Past Recommendations",
          style: TextStyle(color: Colors.greenAccent, fontSize: 24),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Color(0xFF01D6A4)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection("past_medicine_recommendations")
            .where("userId", isEqualTo: currentUserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF01D6A4)),
            );
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "No past recommendations found.",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            );
          }

          // ✅ Show all recommendations sorted by timestamp
          final recommendations = docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .where((data) => data["timestamp"] != null)
              .toList();

          recommendations.sort((a, b) {
            final t1 = (a["timestamp"] as Timestamp).toDate();
            final t2 = (b["timestamp"] as Timestamp).toDate();
            return t2.compareTo(t1); // newest first
          });

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              final data = recommendations[index];

              final diseaseName = data["diseaseName"] ?? "Unknown";
              final medicineName = data["medicineName"] ?? "Unknown";
              final timestamp = (data["timestamp"] as Timestamp).toDate();

              return Card(
                color: const Color(0xFF013924),
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Disease: $diseaseName",
                        style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Medicine: $medicineName",
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Date: ${timestamp.toLocal().toString().split(' ')[0]}",
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
