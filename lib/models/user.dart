import 'package:flutter/foundation.dart';

class User {
  final String name;
  final String imageUrl;
  final int rank;

  const User({
    required this.name,
    required this.rank,
    required this.imageUrl,
  });
}