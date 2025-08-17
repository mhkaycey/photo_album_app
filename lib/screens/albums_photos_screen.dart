import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_album/model/album.dart';
import 'package:photo_album/providers/photos_provider.dart';
import 'package:photo_album/screens/photo_viewer_screen.dart';

class AlbumPhotosScreen extends ConsumerWidget {
  final Album album;

  const AlbumPhotosScreen({super.key, required this.album});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photosAsync = ref.watch(photosByAlbumProvider(album.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(album.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: photosAsync.when(
        data: (photos) => GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: photos.length,
          itemBuilder: (context, index) {
            final photo = photos[index];
            final imageUrl = 'https://picsum.photos/150/150?random=$index';
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PhotoViewerScreen(
                      photos: photos,
                      initialIndex: index,
                      imageIndex: index,
                    ),
                  ),
                );
              },
              child: Hero(
                tag: 'photo-${photo.id}',
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Error loading photos: $error')),
      ),
    );
  }
}
