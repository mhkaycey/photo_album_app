import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_album/model/album.dart';
import 'package:photo_album/model/user.dart';
import 'package:photo_album/services/api_service.dart';

class AlbumRefreshNotifier extends StateNotifier<bool> {
  AlbumRefreshNotifier(this.ref) : super(false);
  final Ref ref;

  Future<void> refreshData() async {
    if (state) return;
    state = true;
    try {
      final selectUser = ref.read(selectedUserProvider);

      ref.invalidate(usersProvider);

      if (selectUser != null) {
        ref.invalidate(albumsByUserProvider(selectUser.id));
        // await ref.read(albumsByUserProvider(selectUser.id).future);
      } else {
        ref.invalidate(albumsProvider);
        // await ref.read(albumsProvider.future);
      }
      // await ref.read(usersProvider.future);
    } catch (e) {
      log(e.toString());
    } finally {
      state = false;
    }
  }
}

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

final albumRefreshProvider = StateNotifierProvider<AlbumRefreshNotifier, bool>((
  ref,
) {
  return AlbumRefreshNotifier(ref);
});
