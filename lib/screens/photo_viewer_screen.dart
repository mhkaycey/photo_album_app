import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_album/model/photo.dart';
import 'package:photo_album/services/favourite_service.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewerScreen extends ConsumerStatefulWidget {
  final List<Photo> photos;
  final int initialIndex;
  final int? imageIndex;

  const PhotoViewerScreen({
    super.key,
    required this.photos,
    required this.initialIndex,
    this.imageIndex,
  });

  @override
  ConsumerState<PhotoViewerScreen> createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends ConsumerState<PhotoViewerScreen> {
  late PageController _pageController;
  late int _currentIndex;
  final Map<int, bool> _favoriteStatus = {};

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _loadFavoriteStatus();
  }

  void _loadFavoriteStatus() async {
    for (final photo in widget.photos) {
      final isFav = await FavoritesService.isFavorite(photo.id);
      setState(() {
        _favoriteStatus[photo.id] = isFav;
      });
    }
  }

  void _toggleFavorite() async {
    final currentPhoto = widget.photos[_currentIndex];
    final isFav = _favoriteStatus[currentPhoto.id] ?? false;

    if (isFav) {
      await FavoritesService.removeFromFavorites(currentPhoto.id);
    } else {
      await FavoritesService.addToFavorites(currentPhoto);
    }

    setState(() {
      _favoriteStatus[currentPhoto.id] = !isFav;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isFav ? 'Removed from favorites' : 'Added to favorites'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPhoto = widget.photos[_currentIndex];
    final isFavorite = _favoriteStatus[currentPhoto.id] ?? false;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          '${_currentIndex + 1} of ${widget.photos.length}',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              final photo = widget.photos[index];
              final imageUrl =
                  'https://picsum.photos/300/500?random=${widget.imageIndex}';
              return PhotoViewGalleryPageOptions(
                imageProvider: CachedNetworkImageProvider(
                  imageUrl,
                  cacheKey: photo.id.toString(),
                ),
                initialScale: PhotoViewComputedScale.contained,
                // minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 0.8,
                heroAttributes: PhotoViewHeroAttributes(
                  tag: 'photo-${photo.id}',
                ),
              );
            },
            itemCount: widget.photos.length,
            loadingBuilder: (context, event) => Center(
              child: SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  value: event?.expectedTotalBytes != null
                      ? event!.cumulativeBytesLoaded / event.expectedTotalBytes!
                      : null,
                ),
              ),
            ),
            pageController: _pageController,
            onPageChanged: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                currentPhoto.title,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
