import 'package:flutter/material.dart';
import 'card_content.dart';

class FillImageCard extends StatelessWidget {
  const FillImageCard({
    Key? key,
    this.width,
    this.height,
    this.isloading=false,
    this.heightImage,
    this.borderRadius = 6,
    this.contentPadding,
    required this.imageProvider,
    this.tags,
    this.title,
    this.description,
    this.footer,
    this.color = Colors.white,
    this.tagSpacing,
    this.tagRunSpacing,
  }) : super(key: key);

  /// card width
  final double? width;

  // image loadig
  final bool isloading;

  /// card height
  final double? height;

  /// image height
  final double? heightImage;

  /// border radius value
  final double borderRadius;

  /// spacing between tag
  final double? tagSpacing;

  /// run spacing between line tag
  final double? tagRunSpacing;

  /// content padding
  final EdgeInsetsGeometry? contentPadding;

  /// image provider
  final Image imageProvider;

  /// list of widgets
  final List<Widget>? tags;

  /// card color
  final Color color;

  /// widget title of card
  final Widget? title;

  /// widget description of card
  final Widget? description;

  /// widget footer of card
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: color,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(borderRadius),
                    topRight: Radius.circular(borderRadius),
                  ),
                  child: imageProvider,
                ),
                ImageCardContent(
                  contentPadding: contentPadding,
                  tags: tags,
                  title: title,
                  footer: footer,
                  description: description,
                  tagSpacing: tagSpacing,
                  tagRunSpacing: tagRunSpacing,
                ),
              ],
            ),
            // isloading?Container(
            //   height: height,
            //   width: width,
            //                 color: Colors.white.withOpacity(0.5),
            //                 child: const Center(
            //                   child: Text("generating your image..."),
            //                 ),
            //               )
            //             : const SizedBox.shrink()
          ],
        ));
  }
}
