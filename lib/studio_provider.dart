import 'package:flutter/material.dart';
import 'studio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudioProvider with ChangeNotifier {
  List<Studio> _studios = [];
  bool _isLoading = true;

  List<Studio> get studios => _studios;
  bool get isLoading => _isLoading;

  Future<void> fetchStudios() async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('studios').get();

      _studios = snapshot.docs.map((doc) {
        return Studio.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}