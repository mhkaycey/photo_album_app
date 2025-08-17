import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_album/model/album.dart';
import 'package:photo_album/model/user.dart';
import 'package:photo_album/services/api_service.dart';

final albumsProvider = FutureProvider<List<Album>>((ref) async {
  return ApiService.fetchAlbums();
});

final usersProvider = FutureProvider<List<User>>((ref) async {
  return ApiService.fetchUsers();
});

final albumsByUserProvider = FutureProvider.family<List<Album>, int>((
  ref,
  userId,
) async {
  return ApiService.fetchAlbumsByUser(userId);
});

final selectedUserProvider = StateProvider<User?>((ref) => null);
