import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:socialmediaapp/api/firebase_api.dart';
import 'package:socialmediaapp/models/user.dart';

class UsersProvider extends ChangeNotifier {
  final _usersSnapshot = <DocumentSnapshot>[];
  String _errorMessage = '';
  int documentLimit = 2;
  bool _hasNext = true;
  bool _isFetchingUsers = false;

  String get errorMessage => _errorMessage;

  bool get hasNext => _hasNext;

  List<User> get users => _usersSnapshot.map((snap) {
    final user = snap.data();

    return User(
      name: user['name'],
      rank: user['rank'],
      imageUrl: user['imageUrl'],
    );
  }).toList();

  Future fetchNextUsers() async {
    if (_isFetchingUsers) return;

    _errorMessage = '';
    _isFetchingUsers = true;

    try {
      final snap = await FirebaseApi.getUsers(
        documentLimit,
        startAfter: _usersSnapshot.isNotEmpty ? _usersSnapshot.last : null,
      );
      _usersSnapshot.addAll(snap.docs);

      if (snap.docs.length < documentLimit) _hasNext = false;
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }

    _isFetchingUsers = false;
  }
}