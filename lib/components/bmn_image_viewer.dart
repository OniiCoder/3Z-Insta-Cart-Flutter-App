import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:threezinstacart/theme/bmn_theme.dart';

class BmnImageViewer extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const BmnImageViewer({super.key, required this.imageUrls, this.initialIndex = 0});

  @override
  State<BmnImageViewer> createState() => _BmnImageViewerState();
}

class _BmnImageViewerState extends State<BmnImageViewer> {
  late PageController _pageController;
  late int _currentIndex;
  bool _showOverlay = true;
  late List<TransformationController> _transformationControllers;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _transformationControllers = List.generate(widget.imageUrls.length, (_) => TransformationController());
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _transformationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Reset zoom on the other pages
    for (int i = 0; i < _transformationControllers.length; i++) {
      if (i != index && _transformationControllers[i].value != Matrix4.identity()) {
        _transformationControllers[i].value = Matrix4.identity();
      }
    }
  }

  void _toggleOverlay() {
    setState(() {
      _showOverlay = !_showOverlay;
    });
  }

  void _zoomDoubleTap(int index, TapDownDetails details) {
    final controller = _transformationControllers[index];
    final position = details.localPosition;

    if (controller.value != Matrix4.identity()) {
      // Reset zoom
      setState(() {
        controller.value = Matrix4.identity();
      });
    } else {
      // Zoom in to 2.5x at tap location
      const double scale = 2.5;
      final x = -position.dx * (scale - 1);
      final y = -position.dy * (scale - 1);

      final Matrix4 matrix = Matrix4.identity();
      matrix.setEntry(0, 0, scale);
      matrix.setEntry(1, 1, scale);
      matrix.setEntry(0, 3, x);
      matrix.setEntry(1, 3, y);

      setState(() {
        controller.value = matrix;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text('No images available', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main Swiper / PageView
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleOverlay,
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.imageUrls.length,
                onPageChanged: _onPageChanged,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return InteractiveViewer(
                    transformationController: _transformationControllers[index],
                    minScale: 1.0,
                    maxScale: 4.0,
                    child: GestureDetector(
                      onDoubleTapDown: (details) => _zoomDoubleTap(index, details),
                      child: Center(
                        child: Hero(
                          tag: widget.imageUrls[index],
                          child: CachedNetworkImage(
                            imageUrl: widget.imageUrls[index],
                            fit: BoxFit.contain,
                            placeholder: (context, url) => Center(
                              child: SizedBox(
                                width: 32,
                                height: 32,
                                child: CircularProgressIndicator(strokeWidth: 2, color: BmnColors.brandGreen400),
                              ),
                            ),
                            errorWidget: (context, url, error) => const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(IconsaxPlusLinear.image, color: BmnColors.gray600, size: 64),
                                SizedBox(height: 12),
                                Text('Failed to load image', style: TextStyle(color: BmnColors.gray400, fontSize: 14)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Animated Top Overlay (Title, Close Button, Fractional Index)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            top: _showOverlay ? 0 : -120,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8, bottom: 16, left: 16, right: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Close Button
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), shape: BoxShape.circle),
                      child: const Icon(IconsaxPlusLinear.arrow_left, color: Colors.white, size: 20),
                    ),
                  ),

                  // Title / Count Indicator
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Challenge Images',
                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_currentIndex + 1} of ${widget.imageUrls.length}',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12),
                      ),
                    ],
                  ),

                  // Spacer to center the title
                  const SizedBox(width: 40),
                ],
              ),
            ),
          ),

          // Animated Bottom Overlay (Thumbnails Carousel)
          if (widget.imageUrls.length > 1)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              bottom: _showOverlay ? 0 : -140,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  top: 16,
                  bottom: MediaQuery.of(context).padding.bottom + 16,
                  left: 16,
                  right: 16,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.imageUrls.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final isSelected = index == _currentIndex;
                          return GestureDetector(
                            onTap: () {
                              _pageController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 60,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected ? BmnColors.brandGreen400 : Colors.white.withValues(alpha: 0.3),
                                  width: isSelected ? 2.5 : 1,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: CachedNetworkImage(
                                  imageUrl: widget.imageUrls[index],
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(color: BmnColors.gray900),
                                  errorWidget: (context, url, error) => Container(
                                    color: BmnColors.gray900,
                                    child: const Icon(IconsaxPlusLinear.image, color: Colors.white24, size: 20),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
