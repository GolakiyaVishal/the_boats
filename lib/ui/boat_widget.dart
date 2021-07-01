import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:the_boats/data/boat_model.dart';

class BoatWidget extends StatelessWidget {
  final Boat boat;
  final VoidCallback onTap;
  final double factor;

  const BoatWidget({
    Key? key,
    required this.boat,
    required this.onTap,
    required this.factor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: (1 - factor).clamp(0.0, 1.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Transform.scale(
                scale: lerpDouble(1.0, 0.8, factor)!,
                child: Hero(tag: boat.name, child: Image.asset(boat.image))),
          ),
          Text(
            boat.name,
            style: Theme.of(context).textTheme.headline4,
          ),
          Text(boat.creator, style: Theme.of(context).textTheme.subtitle1),
          TextButton(onPressed: onTap, child: Text('SPEC >'))
        ],
      ),
    );
  }
}
