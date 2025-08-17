import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_album/model/photo.dart';
import 'package:photo_album/services/api_service.dart';
import 'package:photo_album/services/favourite_service.dart';

final allPhotosProvider = FutureProvider<List<Photo>>((ref) async {
  return ApiService.fetchPhotos();
});

final photosByAlbumProvider = FutureProvider.family<List<Photo>, int>((
  ref,
  albumId,
) async {
  return ApiService.fetchPhotosByAlbum(albumId);
});

final favoritePhotosProvider = FutureProvider<List<Photo>>((ref) async {
  return FavoritesService.getFavoritePhotos();
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredPhotosProvider = Provider<AsyncValue<List<Photo>>>((ref) {
  final photosAsync = ref.watch(allPhotosProvider);
  final searchQuery = ref.watch(searchQueryProvider);

  return photosAsync.when(
    data: (photos) {
      if (searchQuery.isEmpty) {
        return AsyncValue.data(photos);
      }
      final filtered = photos
          .where(
            (photo) =>
                photo.title.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});
