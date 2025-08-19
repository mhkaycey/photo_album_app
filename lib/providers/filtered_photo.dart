import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_album/model/photo.dart';
import 'package:photo_album/providers/photos_provider.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

class FilteredPhotosNotifier extends AsyncNotifier<List<Photo>> {
  @override
  Future<List<Photo>> build() async {
    final searchQuery = ref.watch(searchQueryProvider);
    final photosAsync = ref.watch(photosProvider);
    return photosAsync.when(
      data: (photos) {
        if (searchQuery.isEmpty) {
          return photos;
        }
        return photos
            .where(
              (photo) =>
                  photo.title.toLowerCase().contains(searchQuery.toLowerCase()),
            )
            .toList();
      },
      error: (error, stackTrace) => throw error,
      loading: () => throw const AsyncLoading(),
    );
  }

  void updateFilter() {
    ref.invalidateSelf();
  }
}

final filteredPhotosprovider =
    AsyncNotifierProvider<FilteredPhotosNotifier, List<Photo>>(
      () => FilteredPhotosNotifier(),
    );
