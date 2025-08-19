import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_album/providers/filtered_photo.dart';
import 'package:photo_album/screens/photo_viewer_screen.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider);
    final filteredPhotosAsync = ref.watch(filteredPhotosprovider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Photos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search photos by title...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
            ),
          ),
          Expanded(
            child: filteredPhotosAsync.when(
              data: (photos) {
                if (photos.isEmpty && searchQuery.isNotEmpty) {
                  return const Center(
                    child: Text('No photos found matching your search.'),
                  );
                }
                if (photos.isEmpty && searchQuery.isEmpty) {
                  return const Center(
                    child: Text('Enter a search term to find photos.'),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: photos.length,
                  itemBuilder: (context, index) {
                    final photo = photos[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PhotoViewerScreen(
                              photos: photos,
                              initialIndex: index,
                            ),
                          ),
                        );
                      },
                      child: Hero(
                        tag: 'photo-${photo.id}',
                        child: CachedNetworkImage(
                          imageUrl: photo.thumbnailUrl,
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
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) =>
                  Center(child: Text('Error loading photos: $error')),
            ),
          ),
        ],
      ),
    );
  }
}
