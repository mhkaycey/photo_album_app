import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_album/providers/album_by_user.dart';
import 'package:photo_album/providers/album_provider.dart';

import 'package:photo_album/providers/photos_provider.dart';
import 'package:photo_album/providers/user_provider.dart';

class RefreshData extends StateNotifier<bool> {
  RefreshData(this.ref) : super(false);
  final Ref ref;
  Future<void> refreshData() async {
    if (state) return;
    state = true;
    try {
      final selectUser = ref.read(selectedUserProvider);

      ref.invalidate(usersProvider);

      if (selectUser != null) {
        ref.invalidate(albumByUserProvider(selectUser.id));
      } else {
        ref.invalidate(albumsProvider);
      }

      ref.invalidate(photosProvider);
    } catch (e) {
      print(e.toString());
    } finally {
      state = false;
    }
  }
}

final refreshDataProvider = StateNotifierProvider<RefreshData, bool>(
  (ref) => RefreshData(ref),
);
