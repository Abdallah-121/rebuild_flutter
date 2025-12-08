import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rebuild/utils/image_utils.dart';

class ReportImagesHeader extends StatelessWidget {
  final List images;
  const ReportImagesHeader({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 260,
      pinned: true,
      backgroundColor: Colors.black,
      flexibleSpace: FlexibleSpaceBar(background: ImageGallery(images: images)),
    );
  }
}

/// ✅ هذا كان ناقص
class ImageGallery extends StatefulWidget {
  final List images;
  const ImageGallery({super.key, required this.images});

  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        color: Colors.grey.shade300,
        child: const Center(child: Icon(Icons.image_not_supported, size: 60)),
      );
    }

    return Stack(
      children: [
        PageView.builder(
          itemCount: widget.images.length,
          onPageChanged: (i) => setState(() => currentIndex = i),
          itemBuilder: (_, index) {
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return _FullScreenImages(
                      images: widget.images,
                      startIndex: currentIndex,
                    );
                  },
                ),
              ),
              child: CachedNetworkImage(
                imageUrl: ImageUtils.format(widget.images[index]),
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (_, __) => Container(
                  color: Colors.black12,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (_, __, ___) => const Center(
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            );
          },
        ),

        /// dots
        Positioned(
          bottom: 14,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.images.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: currentIndex == i ? 10 : 6,
                height: currentIndex == i ? 10 : 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentIndex == i
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// ✅ fullscreen viewer
class _FullScreenImages extends StatelessWidget {
  final List images;
  final int startIndex;

  const _FullScreenImages({required this.images, required this.startIndex});

  @override
  Widget build(BuildContext context) {
    final controller = PageController(initialPage: startIndex);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: controller,
            itemCount: images.length,
            itemBuilder: (_, i) => InteractiveViewer(
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: ImageUtils.format(images[i]),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 12,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
