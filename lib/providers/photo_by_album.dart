import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_album/model/photo.dart';
import 'package:photo_album/services/api_service.dart';

class PhotosByAlbumNotifier extends FamilyAsyncNotifier<List<Photo>, int> {
  @override
  Future<List<Photo>> build(int albumId) async {
    return await ApiService.fetchPhotosByAlbum(albumId);
  }

  Future<void> refresh(int albumId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ApiService.fetchPhotosByAlbum(albumId),
    );
  }
}

final photosByAlbumProvider =
    AsyncNotifierProvider.family<PhotosByAlbumNotifier, List<Photo>, int>(
      () => PhotosByAlbumNotifier(),
    );
