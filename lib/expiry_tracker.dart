import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExpiryTrackerPage extends StatefulWidget {
  final String username;
  final String email;

  const ExpiryTrackerPage({
    super.key,
    required this.username,
    required this.email,
  });

  @override
  State<ExpiryTrackerPage> createState() => _ExpiryTrackerPageState();
}

class _ExpiryTrackerPageState extends State<ExpiryTrackerPage> {
  final TextEditingController _nameController = TextEditingController();
  DateTime? _selectedDate;
  bool _isSaving = false;

  bool get _isFormValid =>
      _nameController.text.trim().isNotEmpty && _selectedDate != null && !_isSaving;

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 10),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF01D6A4),
              onPrimary: Colors.white,
              surface: Colors.black,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF101010),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = DateTime(picked.year, picked.month, picked.day));
    }
  }

  Future<void> _addMedicine() async {
    if (!_isFormValid) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isSaving = true);
    try {
      // Write using REQUIRED collection & fields:
      // collection: medicine_expiry_tracker
      // fields: addedAt, expiryDate, medicineName, userId
      await FirebaseFirestore.instance.collection('medicine_expiry_tracker').add({
        'userId': user.uid,
        'medicineName': _nameController.text.trim(),
        // Write dates as concrete DateTime so they are non-null immediately (avoids flicker)
        'addedAt': DateTime.now(),
        'expiryDate': _selectedDate,
      });

      _nameController.clear();
      setState(() => _selectedDate = null);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Medicine added')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Failed to add: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _confirmAndDelete(String docId) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete medicine?', style: TextStyle(color: Colors.redAccent)),
        content: const Text(
          'This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.greenAccent)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await FirebaseFirestore.instance
            .collection('medicine_expiry_tracker')
            .doc(docId)
            .delete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🗑️ Deleted')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Delete failed: $e')),
        );
      }
    }
  }

  String _formatYmd(DateTime d) {
    // Simple YYYY-MM-DD without intl
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
    }

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Expiry Tracker',
          style: TextStyle(color: Colors.greenAccent, fontSize: 24),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Color(0xFF01D6A4)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter medicine name',
                hintStyle: const TextStyle(color: Colors.greenAccent),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF00A57E)),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF01D6A4)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? 'No date selected'
                        : 'Selected: ${_formatYmd(_selectedDate!)}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
                ElevatedButton(
                  onPressed: _pickDate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF01D6A4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Pick Date', style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Add Medicine button (same style as your "Get Recommendation" button)
            GestureDetector(
              onTap: _isFormValid ? _addMedicine : null,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: _isFormValid
                      ? const LinearGradient(
                          colors: [Color(0xFF056443), Color(0xFF013924)],
                        )
                      : const LinearGradient(
                          colors: [Colors.grey, Colors.grey],
                        ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFF00A57E), width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x6600A57E),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _isSaving ? 'Saving...' : 'Add Medicine',
                    style: TextStyle(
                      color: _isFormValid ? Colors.white : Colors.black38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Saved Medicines',
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Stream WITHOUT orderBy => no composite index required.
            // We sort client-side by addedAt desc to keep a stable order.
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('medicine_expiry_tracker')
                    .where('userId', isEqualTo: uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
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
                        'No medicines saved yet.',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    );
                  }

                  // Map + client-side sort by addedAt desc (avoids index requirement & flicker)
                  final items = docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final addedTs = data['addedAt'];
                    DateTime addedAt;
                    if (addedTs is Timestamp) {
                      addedAt = addedTs.toDate();
                    } else if (addedTs is DateTime) {
                      addedAt = addedTs;
                    } else {
                      addedAt = DateTime.fromMillisecondsSinceEpoch(0);
                    }

                    final expTs = data['expiryDate'];
                    DateTime? expiryDate;
                    if (expTs is Timestamp) {
                      expiryDate = expTs.toDate();
                    } else if (expTs is DateTime) {
                      expiryDate = expTs;
                    }

                    return {
                      'id': doc.id,
                      'medicineName': data['medicineName'] ?? 'Unknown',
                      'addedAt': addedAt,
                      'expiryDate': expiryDate,
                    };
                  }).toList()
                    ..sort((a, b) =>
                        (b['addedAt'] as DateTime).compareTo(a['addedAt'] as DateTime));

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final id = item['id'] as String;
                      final name = item['medicineName'] as String;
                      final expiryDate = item['expiryDate'] as DateTime?;
                      final addedAt = item['addedAt'] as DateTime;

                      return Card(
                        color: const Color(0xFF013924),
                        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(
                            name,
                            style: const TextStyle(
                                color: Colors.greenAccent, fontSize: 18),
                          ),
                          subtitle: Text(
                            [
                              if (expiryDate != null) 'Expiry: ${_formatYmd(expiryDate)}',
                              'Added: ${_formatYmd(addedAt)}',
                            ].join('   '),
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () => _confirmAndDelete(id),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
