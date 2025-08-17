import 'dart:convert';
import 'package:photo_album/model/photo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorite_photos';

  static Future<List<Photo>> getFavoritePhotos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString(_favoritesKey);

    if (favoritesJson == null) return [];

    final List<dynamic> favoritesList = json.decode(favoritesJson);
    return favoritesList.map((json) => Photo.fromJson(json)).toList();
  }

  static Future<void> addToFavorites(Photo photo) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavoritePhotos();

    if (!favorites.any((p) => p.id == photo.id)) {
      favorites.add(photo);
      final String favoritesJson = json.encode(
        favorites.map((p) => p.toJson()).toList(),
      );
      await prefs.setString(_favoritesKey, favoritesJson);
    }
  }

  static Future<void> removeFromFavorites(int photoId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavoritePhotos();

    favorites.removeWhere((photo) => photo.id == photoId);
    final String favoritesJson = json.encode(
      favorites.map((p) => p.toJson()).toList(),
    );
    await prefs.setString(_favoritesKey, favoritesJson);
  }

  static Future<bool> isFavorite(int photoId) async {
    final favorites = await getFavoritePhotos();
    return favorites.any((photo) => photo.id == photoId);
  }
}
