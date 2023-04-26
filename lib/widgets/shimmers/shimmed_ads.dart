import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmedAds extends StatelessWidget {
  final Widget child;
  const ShimmedAds({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: child));
  }
}
