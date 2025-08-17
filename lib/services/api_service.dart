import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:photo_album/model/album.dart';
import 'package:photo_album/model/photo.dart';
import 'package:photo_album/model/user.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  static Future<List<Album>> fetchAlbums() async {
    final response = await http.get(Uri.parse('$baseUrl/albums'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Album.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load albums');
    }
  }

  static Future<List<Album>> fetchAlbumsByUser(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/albums?userId=$userId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Album.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load albums for user $userId');
    }
  }

  static Future<List<Photo>> fetchPhotos() async {
    final response = await http.get(Uri.parse('$baseUrl/photos'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Photo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load photos');
    }
  }

  static Future<List<Photo>> fetchPhotosByAlbum(int albumId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/photos?albumId=$albumId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Photo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load photos for album $albumId');
    }
  }

  static Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
