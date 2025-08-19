import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_album/model/photo.dart';
import 'package:photo_album/services/favourite_service.dart';

class FavoriteProviderNotifier extends AsyncNotifier<List<Photo>> {
  @override
  Future<List<Photo>> build() async =>
      await FavoritesService.getFavoritePhotos();

  Future<void> refreshFavorites() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => FavoritesService.getFavoritePhotos());
  }

  Future<void> addToFavorite(Photo photo) async {
    try {
      await FavoritesService.addToFavorites(photo);
      final currentFavorites = state.value ?? [];
      if (!currentFavorites.any((photo) => photo.id == photo.id)) {
        state = AsyncValue.data([...currentFavorites, photo]);
      }
    } catch (e, sk) {
      state = AsyncError(e, sk);
    }
  }
}

final favoriteProvider =
    AsyncNotifierProvider<FavoriteProviderNotifier, List<Photo>>(
      () => FavoriteProviderNotifier(),
    );
