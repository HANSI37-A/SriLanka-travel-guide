import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/attraction.dart';
import '../services/settings_services.dart';

class FavoritesProvider with ChangeNotifier {
  Database? _db;
  List<Attraction> _favorites = [];
  Map<String, double> _ratings = {};
  Map<String, dynamic>? _currentUser;
  String? _profileImagePath;

  List<Attraction> get favorites => _favorites;
  Map<String, double> get ratings => _ratings;
  Map<String, dynamic>? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  String? get profileImagePath => _currentUser?['imagePath'] ?? _profileImagePath;

  bool isFavorite(String id) => _favorites.any((a) => a.id == id);
  double getRating(String id) => _ratings[id] ?? 0.0;

  Future<void> init() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), 'travel_guide.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE favorites('
          'id TEXT PRIMARY KEY, name TEXT, category TEXT, '
          'description TEXT, imageUrl TEXT, '
          'latitude REAL, longitude REAL, address TEXT)',
        );
        await db.execute(
          'CREATE TABLE ratings(id TEXT PRIMARY KEY, rating REAL)',
        );
        await db.execute(
          'CREATE TABLE users('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'fullName TEXT, email TEXT UNIQUE, password TEXT)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'CREATE TABLE IF NOT EXISTS users('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'fullName TEXT, email TEXT UNIQUE, password TEXT)',
          );
        }
        if (oldVersion < 3) {
          await db.execute(
            'CREATE TABLE IF NOT EXISTS ratings('
            'id TEXT PRIMARY KEY, rating REAL)',
          );
        }
      },
      version: 2,
    );
    await _loadFavorites();
    await _loadRatings();
    _profileImagePath = await SettingsServices.getProfileImage();
    notifyListeners();
  }

  // ── Favorites ─────────────────────────────────────────

  Future<void> _loadFavorites() async {
    final maps = await _db!.query('favorites');
    _favorites = maps.map((m) => Attraction.fromMap(m)).toList();
    notifyListeners();
  }

  Future<void> toggleFavorite(Attraction attraction) async {
    if (isFavorite(attraction.id)) {
      await _db!.delete('favorites',
          where: 'id = ?', whereArgs: [attraction.id]);
      _favorites.removeWhere((a) => a.id == attraction.id);
    } else {
      await _db!.insert('favorites', attraction.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      _favorites.add(attraction);
    }
    notifyListeners();
  }

  // ── Ratings ───────────────────────────────────────────

  Future<void> _loadRatings() async {
    final maps = await _db!.query('ratings');
    _ratings = {
      for (var m in maps) m['id'] as String: m['rating'] as double
    };
    notifyListeners();
  }

  Future<void> setRating(String id, double rating) async {
    await _db!.insert(
      'ratings',
      {'id': id, 'rating': rating},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _ratings[id] = rating;
    notifyListeners();
  }

  // ── Auth ──────────────────────────────────────────────

  Future<String?> register(
      String fullName, String email, String password) async {
    try {
      final existing = await _db!.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );
      if (existing.isNotEmpty) return 'Email already registered';
      await _db!.insert('users', {
        'fullName': fullName,
        'email': email,
        'password': password,
      });
      return null;
    } catch (e) {
      return 'Registration failed. Try again.';
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      final users = await _db!.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
      );
      if (users.isEmpty) return 'Invalid email or password';
      _currentUser = Map<String, dynamic>.from(users.first);
      notifyListeners();
      return null;
    } catch (e) {
      return 'Login failed. Try again.';
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void updateUserInfo(String name, String email, String? imagePath) {
    if (_currentUser != null) {
      _currentUser = {
        ..._currentUser!,
        'fullName': name,
        'email': email,
        if (imagePath != null) 'imagePath': imagePath,
      };
      notifyListeners();
    }
  }

  void updateProfileImage(String? imagePath) {
    if (imagePath != null) {
      _profileImagePath = imagePath;
      if (_currentUser != null) {
        _currentUser = {
          ..._currentUser!,
          'imagePath': imagePath,
        };
      }
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email, String newPassword) async {
    try {
      await _db!.update(
        'users',
        {'password': newPassword},
        where: 'email = ?',
        whereArgs: [email],
      );
    } catch (e) {
      debugPrint('Reset password error: $e');
    }
  }

} 