import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_album/model/user.dart';
import 'package:photo_album/services/api_service.dart';

class UsersNotifier extends AsyncNotifier<List<User>> {
  @override
  Future<List<User>> build() async {
    return await ApiService.fetchUsers();
  }

  Future<void> refreshUser() async {
    state = const AsyncLoading();
    try {
      final users = await ApiService.fetchUsers();
      state = AsyncData(users);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

final usersProvider = AsyncNotifierProvider<UsersNotifier, List<User>>(
  () => UsersNotifier(),
);
