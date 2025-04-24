import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../data/models/unsplash_photo_model.dart';
import 'package:photo_view/photo_view.dart';

class PhotoTile extends StatelessWidget {
  final UnsplashPhoto photo;

  const PhotoTile({super.key, required this.photo});

  void _openFullScreen(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withOpacity(0.95),
        pageBuilder: (_, __, ___) =>
            PhotoFullScreenViewer(imageUrl: photo.fullImageUrl),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openFullScreen(context),
      child: Hero(
        tag: photo.id,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: photo.fullImageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => _buildShimmer(),
            errorWidget: (context, url, error) => const Icon(Icons.broken_image),
          ),
        ),
      ),
    );
  }
}




class PhotoFullScreenViewer extends StatelessWidget {
  final String imageUrl;
  const PhotoFullScreenViewer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            PhotoView(
              imageProvider: CachedNetworkImageProvider(imageUrl),
              loadingBuilder: (context, event) =>
              const Center(child: CircularProgressIndicator()),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
