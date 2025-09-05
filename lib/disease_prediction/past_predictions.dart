import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PastPredictionsPage extends StatelessWidget {
  const PastPredictionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Past Predictions",
          style: TextStyle(color: Colors.greenAccent, fontSize: 24),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Color(0xFF01D6A4)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection("past_disease_predictions")
            .where("userId", isEqualTo: currentUserId) // filter by user
            .snapshots(), // no orderBy to avoid index
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
                "No past predictions found.",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            );
          }

          // Convert docs to a list of maps and sort by timestamp in Flutter
          final predictions = docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .where((data) => data["timestamp"] != null)
              .toList();

          predictions.sort((a, b) {
            final t1 = (a["timestamp"] as Timestamp).toDate();
            final t2 = (b["timestamp"] as Timestamp).toDate();
            return t2.compareTo(t1); // descending
          });

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: predictions.length,
            itemBuilder: (context, index) {
              final data = predictions[index];

              final diseaseName = data["diseaseName"] ?? "Unknown";
              final details = data["details"] ?? "";
              final symptoms =
                  List<String>.from(data["symptoms"] ?? ["Not specified"]);
              final precautions =
                  List<String>.from(data["precautions"] ?? []);
              final timestamp =
                  (data["timestamp"] as Timestamp).toDate();

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
                        diseaseName,
                        style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Symptoms: ${symptoms.join(", ")}",
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Details: $details",
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      if (precautions.isNotEmpty) ...[
                        const Text(
                          "Precautions:",
                          style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        ...precautions.map(
                          (p) => Text(
                            "- $p",
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 16),
                          ),
                        ),
                      ],
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
