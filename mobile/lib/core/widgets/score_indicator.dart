import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';

class ScoreIndicator extends StatefulWidget {
  final double score;
  final double size;
  final double strokeWidth;
  final String? label;
  final bool animate;
  final Duration animationDuration;

  const ScoreIndicator({
    super.key,
    required this.score,
    this.size = 120,
    this.strokeWidth = 10,
    this.label,
    this.animate = true,
    this.animationDuration = const Duration(milliseconds: 1000),
  });

  @override
  State<ScoreIndicator> createState() => _ScoreIndicatorState();
}

class _ScoreIndicatorState extends State<ScoreIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.score,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(ScoreIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score != widget.score) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.score,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final score = widget.animate ? _animation.value : widget.score;
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background arc
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _ScoreArcPainter(
                  score: 100,
                  strokeWidth: widget.strokeWidth,
                  color: AppColors.border,
                ),
              ),
              // Score arc
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _ScoreArcPainter(
                  score: score,
                  strokeWidth: widget.strokeWidth,
                  color: AppColors.getScoreColor(score),
                ),
              ),
              // Center text
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    score.toInt().toString(),
                    style: TextStyle(
                      fontSize: widget.size * 0.28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (widget.label != null)
                    Text(
                      widget.label!,
                      style: TextStyle(
                        fontSize: widget.size * 0.1,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ScoreArcPainter extends CustomPainter {
  final double score;
  final double strokeWidth;
  final Color color;

  _ScoreArcPainter({
    required this.score,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw arc starting from bottom (-90 degrees from top)
    const startAngle = math.pi * 0.75; // Start from bottom-left
    final sweepAngle = (score / 100) * math.pi * 1.5; // 270 degrees max

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ScoreArcPainter oldDelegate) {
    return oldDelegate.score != score || oldDelegate.color != color;
  }
}

class LinearScoreIndicator extends StatelessWidget {
  final String label;
  final double score;
  final double height;
  final bool showPercentage;

  const LinearScoreIndicator({
    super.key,
    required this.label,
    required this.score,
    this.height = 8,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            if (showPercentage)
              Text(
                '${score.toInt()}%',
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.getScoreColor(score),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: LinearProgressIndicator(
            value: score / 100,
            minHeight: height,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.getScoreColor(score),
            ),
          ),
        ),
      ],
    );
  }
}
