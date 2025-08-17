import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_album/model/user.dart';
import 'package:photo_album/providers/album_provider.dart';
import 'package:photo_album/screens/albums_photos_screen.dart';
import 'package:photo_album/screens/favorites_screen.dart';
import 'package:photo_album/screens/search_screen.dart';

class AlbumsScreen extends ConsumerWidget {
  const AlbumsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);
    final selectedUser = ref.watch(selectedUserProvider);
    final albumsAsync = selectedUser != null
        ? ref.watch(albumsByUserProvider(selectedUser.id))
        : ref.watch(albumsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Albums'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // User filter dropdown
          Container(
            padding: const EdgeInsets.all(16.0),
            child: usersAsync.when(
              data: (users) => DropdownButtonFormField<User?>(
                decoration: const InputDecoration(
                  labelText: 'Filter by User',
                  border: OutlineInputBorder(),
                ),
                value: selectedUser,
                items: [
                  const DropdownMenuItem<User?>(
                    value: null,
                    child: Text('All Users'),
                  ),
                  ...users.map(
                    (user) =>
                        DropdownMenuItem(value: user, child: Text(user.name)),
                  ),
                ],
                onChanged: (User? user) {
                  ref.read(selectedUserProvider.notifier).state = user;
                },
              ),
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error loading users: $error'),
            ),
          ),
          // Albums grid
          Expanded(
            child: albumsAsync.when(
              data: (albums) => GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.2,
                ),
                itemCount: albums.length,
                itemBuilder: (context, index) {
                  final album = albums[index];
                  final imageUrl =
                      'https://picsum.photos/150/150?random=$index';
                  return Card(
                    elevation: 4,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AlbumPhotosScreen(album: album),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.error),
                            ),
                          ),
                          // Icon(
                          //   Icons.photo_album,
                          //   size: 48,
                          //   color: Theme.of(context).primaryColor,
                          // ),
                          // const SizedBox(height: 8),
                          // Text(
                          //   album.title,
                          //   textAlign: TextAlign.center,
                          //   style: const TextStyle(
                          //     fontSize: 14,
                          //     fontWeight: FontWeight.w500,
                          //   ),
                          //   maxLines: 2,
                          //   overflow: TextOverflow.ellipsis,
                          // ),
                          // const SizedBox(height: 4),
                          // Text(
                          //   'User ${album.userId}',
                          //   style: TextStyle(
                          //     fontSize: 12,
                          //     color: Colors.grey[600],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) =>
                  Center(child: Text('Error loading albums: $error')),
            ),
          ),
        ],
      ),
    );
  }
}
