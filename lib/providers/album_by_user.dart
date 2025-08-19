import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_album/model/album.dart';
import 'package:photo_album/services/api_service.dart';

class AlbumByUser extends FamilyAsyncNotifier<List<Album>, int> {
  @override
  Future<List<Album>> build(int userId) async {
    return await ApiService.fetchAlbumsByUser(userId);
  }

  Future<void> refreshAlbums(int userId) async {
    state = const AsyncLoading();
    try {
      final albums = await ApiService.fetchAlbumsByUser(userId);
      state = AsyncData(albums);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

final albumByUserProvider =
    AsyncNotifierProvider.family<AlbumByUser, List<Album>, int>(
      () => AlbumByUser(),
    );
