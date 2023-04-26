import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmedList extends StatelessWidget {
  final Widget child;
  const ShimmedList({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Shimmer.fromColors(
            baseColor: Theme.of(context).hintColor.withOpacity(0.2),
            highlightColor: Colors.grey.shade400,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.list, size: 30),
                  shimmedContainer(200, 6),
                  const Divider(),
                ],
              ),
            ),
          );
        } else if (index == 1) {
          return shimmedFilter(context);
        }
        return Shimmer.fromColors(
          baseColor: Theme.of(context).hintColor.withOpacity(0.2),
          highlightColor: Colors.grey.shade400,
          child: child,
        );
      },
    );
  }

  Widget shimmedContainer(double width, double height) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), color: Colors.red),
        ),
      );

  Widget shimmedFilter(BuildContext context) => Shimmer.fromColors(
        baseColor: Theme.of(context).hintColor.withOpacity(0.2),
        highlightColor: Colors.grey.shade400,
        child: Row(
          children: List.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                height: 30,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black),
                ),
              ),
            ),
          ),
        ),
      );
}
