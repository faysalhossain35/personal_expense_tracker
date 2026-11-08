import 'package:flutter/material.dart';

class BuildSummaryCard extends StatefulWidget {
  const BuildSummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
    required this.isFeatured,
  });
  final String title;
  final String amount;
  final Color color;
  final IconData icon;
  final bool isFeatured;

  @override
  State<BuildSummaryCard> createState() => _BuildSummaryCardState();
}

class _BuildSummaryCardState extends State<BuildSummaryCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: widget.isFeatured
              ? [Colors.white, widget.color.withValues(alpha: 0.08)]
              : [Colors.white, widget.color.withValues(alpha: 0.05)],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: widget.color.withValues(alpha: 0.22),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.color.withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.icon, color: widget.color, size: 20),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.isFeatured ? 'Overview' : 'Total',
                  style: TextStyle(
                    color: widget.color,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            widget.title,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            child: Text(
              widget.amount,
              style: TextStyle(
                fontSize: widget.isFeatured ? 28 : 22,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
                letterSpacing: -0.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
