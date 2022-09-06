import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryComponent extends StatefulWidget {
  final int initialIndex;
  final List<String?> galleryItems;

  const GalleryComponent({
    super.key,
    this.initialIndex = 0,
    required this.galleryItems,
  });

  @override
  State<GalleryComponent> createState() => _GalleryComponentState();
}

class _GalleryComponentState extends State<GalleryComponent> {
  late int currentIndex = widget.initialIndex;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.galleryItems.every((element) => element != null)
        ? Scaffold(
            body: Stack(
              children: <Widget>[
                PhotoViewGallery.builder(
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: (BuildContext context, int index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider:
                          NetworkImage(widget.galleryItems[currentIndex]!),
                      initialScale: PhotoViewComputedScale.contained,
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.contained * 10,
                      heroAttributes:
                          PhotoViewHeroAttributes(tag: currentIndex),
                    );
                  },
                  itemCount: widget.galleryItems.length,
                  onPageChanged: onPageChanged,
                  backgroundDecoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                ),
                Align(
                  alignment: const Alignment(0.9, 0.9),
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "${currentIndex + 1} / ${widget.galleryItems.length}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        : const Scaffold(
            body: Center(
              child: Text('Nenhuma imagem encontrada'),
            ),
          );
  }
}
