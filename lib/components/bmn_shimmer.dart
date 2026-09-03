import 'package:flutter/material.dart';
import 'package:threezinstacart/theme/bmn_theme.dart';

class BmnShimmer extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;

  const BmnShimmer({
    super.key,
    required this.child,
    this.baseColor = const Color(0xFFE2E8F0),
    this.highlightColor = const Color(0xFFF8FAFC),
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<BmnShimmer> createState() => _BmnShimmerState();
}

class _BmnShimmerState extends State<BmnShimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            final double progress = _controller.value;
            return LinearGradient(
              begin: const Alignment(-1.0, -0.3),
              end: const Alignment(2.0, 0.3),
              stops: [
                (progress - 0.3).clamp(0.0, 1.0),
                progress.clamp(0.0, 1.0),
                (progress + 0.3).clamp(0.0, 1.0),
              ],
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class BmnShimmerBox extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;
  final Color? color;

  const BmnShimmerBox({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = 8.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class ChallengeDetailSkeleton extends StatelessWidget {
  const ChallengeDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: BmnColors.gray800),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: BmnShimmer(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Tag + Status Badge
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BmnShimmerBox(width: 140, height: 24, borderRadius: 12),
                    BmnShimmerBox(width: 70, height: 24, borderRadius: 12),
                  ],
                ),
                const SizedBox(height: 16),

                // Title lines
                const BmnShimmerBox(width: double.infinity, height: 28, borderRadius: 6),
                const SizedBox(height: 8),
                const BmnShimmerBox(width: 220, height: 24, borderRadius: 6),
                const SizedBox(height: 12),

                // Organizer
                const BmnShimmerBox(width: 130, height: 16, borderRadius: 4),
                const SizedBox(height: 24),

                // Spec 4-column Box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: List.generate(
                      4,
                      (index) => const Expanded(
                        child: Column(
                          children: [
                            BmnShimmerBox(width: 45, height: 10, borderRadius: 4),
                            SizedBox(height: 8),
                            BmnShimmerBox(width: 55, height: 16, borderRadius: 4),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // How Reward Works Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BmnShimmerBox(width: 160, height: 18, borderRadius: 6),
                      SizedBox(height: 12),
                      BmnShimmerBox(width: double.infinity, height: 14, borderRadius: 4),
                      SizedBox(height: 6),
                      BmnShimmerBox(width: double.infinity, height: 14, borderRadius: 4),
                      SizedBox(height: 6),
                      BmnShimmerBox(width: 200, height: 14, borderRadius: 4),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Description Header & Lines
                const BmnShimmerBox(width: 160, height: 18, borderRadius: 6),
                const SizedBox(height: 12),
                const BmnShimmerBox(width: double.infinity, height: 14, borderRadius: 4),
                const SizedBox(height: 6),
                const BmnShimmerBox(width: 260, height: 14, borderRadius: 4),
                const SizedBox(height: 24),

                // Rules Header & List
                const BmnShimmerBox(width: 180, height: 18, borderRadius: 6),
                const SizedBox(height: 16),
                ...List.generate(
                  3,
                  (index) => const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        BmnShimmerBox(width: 18, height: 18, borderRadius: 9),
                        SizedBox(width: 12),
                        Expanded(child: BmnShimmerBox(height: 14, borderRadius: 4)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // CTA Button Skeleton
                const BmnShimmerBox(width: double.infinity, height: 52, borderRadius: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChallengeProgressSkeleton extends StatelessWidget {
  const ChallengeProgressSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: BmnColors.gray800),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const SafeArea(
        child: BmnShimmer(
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                BmnShimmerBox(width: double.infinity, height: 260, borderRadius: 28),
                SizedBox(height: 20),
                BmnShimmerBox(width: double.infinity, height: 72, borderRadius: 20),
                SizedBox(height: 20),
                BmnShimmerBox(width: double.infinity, height: 180, borderRadius: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DiscoverChallengesSkeleton extends StatelessWidget {
  const DiscoverChallengesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return BmnShimmer(
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BmnShimmerBox(
                width: double.infinity,
                height: 120,
                borderRadius: 20,
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BmnShimmerBox(width: double.infinity, height: 14, borderRadius: 4),
                    SizedBox(height: 8),
                    BmnShimmerBox(width: 200, height: 14, borderRadius: 4),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BmnShimmerBox(width: 70, height: 24, borderRadius: 6),
                        BmnShimmerBox(width: 70, height: 24, borderRadius: 6),
                        BmnShimmerBox(width: 70, height: 24, borderRadius: 6),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeFeaturedChallengeSkeleton extends StatelessWidget {
  const HomeFeaturedChallengeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return BmnShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BmnShimmerBox(width: 210, height: 20, borderRadius: 6),
          const SizedBox(height: 12),
          Container(
            height: 200,
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BmnShimmerBox(width: 100, height: 24, borderRadius: 12),
                    BmnShimmerBox(width: 80, height: 24, borderRadius: 12),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BmnShimmerBox(width: double.infinity, height: 22, borderRadius: 6),
                    SizedBox(height: 8),
                    BmnShimmerBox(width: 160, height: 14, borderRadius: 4),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BmnShimmerBox(width: 110, height: 32, borderRadius: 8),
                    BmnShimmerBox(width: 90, height: 28, borderRadius: 10),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomeHorizontalChallengesSkeleton extends StatelessWidget {
  const HomeHorizontalChallengesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return BmnShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BmnShimmerBox(width: 170, height: 20, borderRadius: 6),
              BmnShimmerBox(width: 60, height: 16, borderRadius: 4),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 185,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 2,
              itemBuilder: (context, index) => Container(
                width: 270,
                margin: const EdgeInsets.only(right: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BmnShimmerBox(width: 140, height: 18, borderRadius: 4),
                        BmnShimmerBox(width: 65, height: 18, borderRadius: 10),
                      ],
                    ),
                    BmnShimmerBox(width: 100, height: 12, borderRadius: 4),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        BmnShimmerBox(width: 90, height: 28, borderRadius: 6),
                        BmnShimmerBox(width: 80, height: 24, borderRadius: 8),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeCommunityImpactSkeleton extends StatelessWidget {
  const HomeCommunityImpactSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return BmnShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BmnShimmerBox(width: 180, height: 20, borderRadius: 6),
          const SizedBox(height: 12),
          Container(
            height: 200,
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BmnShimmerBox(width: 120, height: 12, borderRadius: 4),
                SizedBox(height: 8),
                BmnShimmerBox(width: double.infinity, height: 20, borderRadius: 6),
                SizedBox(height: 6),
                BmnShimmerBox(width: 220, height: 14, borderRadius: 4),
                SizedBox(height: 12),
                BmnShimmerBox(width: 130, height: 22, borderRadius: 12),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BmnShimmerBox(width: 20, height: 6, borderRadius: 3),
              SizedBox(width: 6),
              BmnShimmerBox(width: 6, height: 6, borderRadius: 3),
              SizedBox(width: 6),
              BmnShimmerBox(width: 6, height: 6, borderRadius: 3),
            ],
          ),
        ],
      ),
    );
  }
}
