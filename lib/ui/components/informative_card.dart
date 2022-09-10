import 'package:flutter/material.dart';

class InformativeCard extends StatelessWidget {
  final String? image;
  final String title;
  final String description;

  const InformativeCard({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: image != null
          ? ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 220,
                minWidth: 220,
                maxHeight: 300,
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    image!,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: double.infinity,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        color: const Color(0xff2789E3),
                        child: const Text(
                          'ver mais',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 250),
              child: Container(
                color: const Color(0xff2789E3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            description,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: double.infinity,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.white,
                          child: const Text(
                            'ver mais',
                            style: TextStyle(
                              color: Color(0xff2789E3),
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
