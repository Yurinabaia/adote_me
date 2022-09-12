import 'package:adoteme/ui/components/gallery_component.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselComponent extends StatefulWidget {
  final List<String?> listImages;
  final String? status;

  const CarouselComponent({
    Key? key,
    required this.listImages,
    required this.status,
  }) : super(key: key);

  @override
  State<CarouselComponent> createState() => _CarouselComponentState();
}

class _CarouselComponentState extends State<CarouselComponent> {
  int current = 0;
  final CarouselController controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: const Alignment(0.5, 0.9),
      children: [
        Builder(
          builder: (context) {
            return CarouselSlider(
              carouselController: controller,
              options: CarouselOptions(
                height: 300,
                viewportFraction: 1.0,
                autoPlay: widget.listImages.length > 1,
                onPageChanged: (index, reason) {
                  setState(() {
                    current = index;
                  });
                },
              ),
              items: widget.listImages
                  .map((item) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GalleryComponent(
                            initialIndex: current,
                            galleryItems: widget.listImages,
                          ),
                        ),
                      );
                    },
                      child: Stack(
                        children: [
                          Image.network(item!, fit: BoxFit.cover, width: MediaQuery.of(context).size.width),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.listImages.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => controller.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(current == entry.key ? 1 : 0.4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        if (widget.status == 'finished')
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              height: 75,
              width: 75,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 60,
              ),
            ),
          ),
      ],
    );
  }
}
