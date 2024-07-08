import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travel_ui/models/activity_model.dart';
import 'package:travel_ui/models/destination_model.dart';

import '../effects/parallax_flow_delegate.dart';

class DestinationScreen extends StatefulWidget {
  final Destination destination;

  const DestinationScreen({super.key, required this.destination});

  @override
  State<DestinationScreen> createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backgroundImageKey = GlobalKey();

  late Animation _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: const Duration(milliseconds: 500), vsync: this)
          ..addListener(() {
            setState(() {});
          });
    _animation = Tween(
      begin: 40.0,
      end: 0.0,
    ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(_animation.value),
                    bottomLeft: const Radius.circular(40.0),
                    topRight: Radius.circular(_animation.value),
                    bottomRight: const Radius.circular(40.0)),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black45,
                      offset: Offset(0.0, 2.0),
                      blurRadius: 6.0)
                ]),
            child: Stack(
              children: [
                Hero(
                  tag: widget.destination,
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(_animation.value),
                          bottomLeft: const Radius.circular(40.0),
                          topRight: Radius.circular(_animation.value),
                          bottomRight: const Radius.circular(40.0)),
                      child: Image.asset(
                        widget.destination.imageUrl,
                        height: MediaQuery.of(context).size.height * 0.45,
                        fit: BoxFit.cover,
                      )),
                ),
                Positioned(
                  top: 30,
                  right: 20,
                  left: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(FontAwesomeIcons.arrowLeftLong),
                        color: Colors.white,
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Row(
                        children: [
                          Icon(FontAwesomeIcons.search, color: Colors.white70),
                          SizedBox(width: 10),
                          Icon(Icons.filter_list_rounded,
                              size: 35, color: Colors.white70),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 20.0,
                  bottom: 25.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.destination.city,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            fontSize: 34.0),
                      ),
                      Row(
                        children: [
                          const Icon(
                            FontAwesomeIcons.locationArrow,
                            size: 16.0,
                            color: Colors.white70,
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Text(widget.destination.country,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 24)),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                Activity activity = widget.destination.activities[index];

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        ParallaxImage(imagePath: activity.imageUrl),
                        _buildGradient(),
                        _buildTitleAndSubtitle(activity.name),
                      ],
                    ),
                  ),
                );
              },
              itemCount: activities.length,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildParallaxBackground(BuildContext context, String imageUrl) {
    return ClipRRect(
      // Create rounded corners for the image
      borderRadius: BorderRadius.circular(20.0),
      child: AspectRatio(
        // Define the aspect ratio for the image

        aspectRatio: 16 / 9,
        child: Flow(
          delegate: ParallaxFlowDelegate(
            /// Access the scrollable widget
            scrollable: Scrollable.of(context),

            // Context of the list item
            listItemContext: context,

            // Pass the background image key
            backgroundImageKey: _backgroundImageKey,
          ),
          // Apply anti-aliasing to the clipping
          clipBehavior: Clip.antiAlias,
          children: [
            Image.asset(
              imageUrl,
              // Use the provided key for this image
              key: _backgroundImageKey,
              fit: BoxFit.cover, // Set the image to cover the available space
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradient() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.6, 0.95],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndSubtitle(String name) {
    return Positioned(
      left: 20,
      bottom: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "Country",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class ParallaxImage extends StatelessWidget {
  ParallaxImage({super.key, required this.imagePath});

  final GlobalKey _backgroundImageKey = GlobalKey();
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // Create rounded corners for the image
      borderRadius: BorderRadius.circular(20.0),
      child: AspectRatio(
        // Define the aspect ratio for the image

        aspectRatio: 16 / 9,
        child: Flow(
          delegate: ParallaxFlowDelegate(
            /// Access the scrollable widget
            scrollable: Scrollable.of(context),

            // Context of the list item
            listItemContext: context,

            // Pass the background image key
            backgroundImageKey: _backgroundImageKey,
          ),
          children: [
            Image.asset(
              imagePath,
              // Use the provided key for this image
              key: _backgroundImageKey,
              fit: BoxFit.cover, // Set the image to cover the available space
            ),
          ],
        ),
      ),
    );
  }
}
