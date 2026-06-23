import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import '../models/attraction.dart';

class FavoritesProvider with ChangeNotifier {
  Database? _db;
  List<Attraction> _favorites = [];
  Map<String, double> _ratings = {};
  Map<String, dynamic>? _currentUser;

  List<Attraction> get favorites => _favorites;
  Map<String, double> get ratings => _ratings;
  Map<String, dynamic>? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  bool isFavorite(String id) => _favorites.any((a) => a.id == id);
  double getRating(String id) => _ratings[id] ?? 0.0;

  // Get current user's ID
  int get _userId => _currentUser?['id'] as int? ?? 0;

  Future<void> init() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), 'travel_guide.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE favorites('
          'id TEXT NOT NULL, '
          'userId INTEGER NOT NULL, '
          'name TEXT, category TEXT, '
          'description TEXT, imageUrl TEXT, '
          'latitude REAL, longitude REAL, address TEXT, '
          'PRIMARY KEY (id, userId))',
        );
        await db.execute(
          'CREATE TABLE ratings('
          'id TEXT NOT NULL, '
          'userId INTEGER NOT NULL, '
          'rating REAL, '
          'PRIMARY KEY (id, userId))',
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
          await db.execute('DROP TABLE IF EXISTS favorites');
          await db.execute('DROP TABLE IF EXISTS ratings');
          await db.execute(
            'CREATE TABLE favorites('
            'id TEXT NOT NULL, '
            'userId INTEGER NOT NULL, '
            'name TEXT, category TEXT, '
            'description TEXT, imageUrl TEXT, '
            'latitude REAL, longitude REAL, address TEXT, '
            'PRIMARY KEY (id, userId))',
          );
          await db.execute(
            'CREATE TABLE ratings('
            'id TEXT NOT NULL, '
            'userId INTEGER NOT NULL, '
            'rating REAL, '
            'PRIMARY KEY (id, userId))',
          );
        }
      },
      version: 3, 
    );
  }

  // ── Favorites ─────────────────────────────────────────

  Future<void> _loadFavorites() async {
    if (_db == null || _userId == 0) return;
    final maps = await _db!.query(
      'favorites',
      where: 'userId = ?',
      whereArgs: [_userId],
    );
    _favorites = maps.map((m) => Attraction.fromMap(m)).toList();
    notifyListeners();
  }

  Future<void> toggleFavorite(Attraction attraction) async {
    if (_userId == 0) return;
    if (isFavorite(attraction.id)) {
      await _db!.delete(
        'favorites',
        where: 'id = ? AND userId = ?',
        whereArgs: [attraction.id, _userId],
      );
      _favorites.removeWhere((a) => a.id == attraction.id);
    } else {
      final map = attraction.toMap();
      map['userId'] = _userId;
      await _db!.insert(
        'favorites',
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      _favorites.add(attraction);
    }
    notifyListeners();
  }

  // ── Ratings ───────────────────────────────────────────

  Future<void> _loadRatings() async {
    if (_db == null || _userId == 0) return;
    final maps = await _db!.query(
      'ratings',
      where: 'userId = ?',
      whereArgs: [_userId],
    );
    _ratings = {
      for (var m in maps) m['id'] as String: m['rating'] as double
    };
    notifyListeners();
  }

  Future<void> setRating(String id, double rating) async {
    if (_userId == 0) return;
    await _db!.insert(
      'ratings',
      {'id': id, 'userId': _userId, 'rating': rating},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _ratings[id] = rating;
    notifyListeners();
  }

  // ── Auth & Profile State ──────────────────────────────

  // Checks device storage for a saved userId on app start
  Future<bool> checkPersistedSession() async {
    if (_db == null) await init(); // Safety fallback if DB isn't running yet
    
    final prefs = await SharedPreferences.getInstance();
    final savedUserId = prefs.getInt('userId');
    
    if (savedUserId != null && savedUserId != 0) {
      final users = await _db!.query(
        'users',
        where: 'id = ?',
        whereArgs: [savedUserId],
      );
      
      if (users.isNotEmpty) {
        _currentUser = Map<String, dynamic>.from(users.first);
        await _loadFavorites();
        await _loadRatings();
        return true; // Valid session loaded successfully
      }
    }
    return false; // No session found
  }

  Future<String?> register(
      String fullName, String email, String password) async {
    try {
      final existing = await _db!.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );
      if (existing.isNotEmpty) return 'Email already registered';
      
      final id = await _db!.insert('users', {
        'fullName': fullName,
        'email': email,
        'password': password,
      });

      // Log the user in contextually
      _currentUser = {
        'id': id,
        'fullName': fullName,
        'email': email,
      };

      // Persist registration session instantly
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', id);

      _favorites = [];
      _ratings = {};
      notifyListeners();
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
      
      // Persist user ID to device local storage sandbox
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', _userId);
      
      await _loadFavorites();
      await _loadRatings();
      return null;
    } catch (e) {
      return 'Login failed. Try again.';
    }
  }

  void logout() async {
    _currentUser = null;
    _favorites = [];
    _ratings = {};
    
    // Clear persistent token on sign-out
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    
    notifyListeners();
  }

  void updateProfileImage(String? newPath) {
    if (_currentUser != null) {
      _currentUser = {
        ..._currentUser!,
        'imagePath': newPath,
      };
      notifyListeners();
    }
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