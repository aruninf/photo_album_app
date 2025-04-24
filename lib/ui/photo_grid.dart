import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../data/models/unsplash_photo_model.dart';
import 'photo_tile.dart';

class PhotoGrid extends StatelessWidget {
  final List<UnsplashPhoto> photos;
  final ScrollController scrollController;
  final bool hasMore;

  const PhotoGrid({
    super.key,
    required this.photos,
    required this.scrollController,
    required this.hasMore,
  });

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      controller: scrollController,
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      padding: const EdgeInsets.all(8),
      itemCount: hasMore ? photos.length + 1 : photos.length,
      itemBuilder: (context, index) {
        if (index >= photos.length) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ));
        }
        return PhotoTile(photo: photos[index]);
      },
    );
  }
}
