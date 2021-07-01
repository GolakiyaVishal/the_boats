import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:the_boats/data/boat_model.dart';
import 'package:the_boats/data/static_data.dart';

class DetailScreen extends StatelessWidget {
  final Boat boat;

  final _boatAngle = (pi * -0.5);
  final _translateX = 80.0;
  final _translateY = 100.0;
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> scrollOffset = ValueNotifier(1);
  final ValueNotifier<bool> valueNotifier = ValueNotifier(false);

  DetailScreen({
    required this.boat,
    Key? key,
  }) : super(key: key) {
    _scrollController.addListener(() {
      scrollOffset.value = _scrollController.offset;
    });

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      valueNotifier.value = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _animatedBoat(Animation animation, HeroFlightDirection direction) {
    final isTop = HeroFlightDirection.pop == direction;
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final value = isTop
            ? Curves.easeInBack.transform(animation.value)
            : Curves.easeInOutBack.transform(animation.value);
        return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..rotateZ(_boatAngle * value)
              ..translate(_translateX * value, _translateY * value, 0),
            child: child);
      },
      child: _boatImage(boat.image),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: [
        // boat
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            ValueListenableBuilder2<bool, double>(
              valueNotifier,
              scrollOffset,
              key: UniqueKey(),
              builder: (context, value, offset, child) {
                print('animate:: $offset');
                return Hero(
                  tag: boat.name,
                  flightShuttleBuilder: (context, animation, direction, _, __) {
                    return _animatedBoat(animation, direction);
                  },
                  child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..rotateZ(_boatAngle)
                        ..translate(_translateX, _translateY + (4 * offset), 0),
                      child: _boatImage(boat.image)),
                );
              },
              child: _boatImage(boat.image),
            ),
          ],
        ),
        // Text Specs
        ValueListenableBuilder<double>(valueListenable: scrollOffset,
            builder: (context, value, child) {
              return Positioned(
                top: 200 - value,
                left: 0,
                right: 0,
                bottom: 0,
                child: ValueListenableBuilder(
                  valueListenable: valueNotifier,
                  builder: (BuildContext context, bool value, Widget? child) {
                    return TweenAnimationBuilder(
                      tween: Tween(begin: 1.0, end: value ? 0.0 : 1.0),
                      duration: const Duration(milliseconds: 500),
                      builder: (BuildContext context, double value, Widget? child) {
                        return Transform.translate(
                            offset: Offset(0, (-50.0 * value)),
                            child: Opacity(opacity: 1 - value, child: child!));
                      },
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    boat.name,
                                    style: Theme.of(context).textTheme.headline4,
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      text: 'By ',
                                      children: [
                                        TextSpan(
                                          text: boat.creator,
                                          style: TextStyle(
                                            color: Colors.grey[900],
                                          ),
                                        ),
                                      ],
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                    child: Text(
                                      boat.desc,
                                      style: Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(top: 6.0, bottom: 6.0),
                                    child: Text(
                                      'SPECS',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          ?.copyWith(fontSize: 18),
                                    ),
                                  ),
                                  _specTile(
                                      context, 'Boat length', boat.space.length),
                                  _specTile(context, 'Beam', boat.space.beam),
                                  _specTile(context, 'Weight', boat.space.weight),
                                  _specTile(
                                      context, 'Fuel Capacity', boat.space.fuel),
                                  const SizedBox(height: 20),
                                  Text(
                                    'GALLERY',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 200.0,
                              child: ListView.builder(
                                itemCount: gallery.length,
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.symmetric(horizontal: 12.0),
                                itemExtent: 220,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.only(right: 20),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20)),
                                    child: Image.asset(
                                      gallery[index],
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },),
        Align(
          alignment: Alignment(-.9, -.9),
          child: FloatingActionButton(
            mini: true,
            backgroundColor: Colors.grey,
            child: Icon(Icons.close),
            onPressed: () {
              valueNotifier.value = false;
              Navigator.pop(context);
            },
          ),
        )
      ],
    );
  }

  Widget _boatImage(String image) {
    return AspectRatio(
      aspectRatio: 0.85,
      child: Image.asset(image),
    );
  }

  Widget _specTile(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
              child: Text(
            label,
            style: Theme.of(context).textTheme.button?.copyWith(fontSize: 16),
          )),
          Expanded(
              child: Text(
            value,
            style: Theme.of(context).textTheme.subtitle1,
          )),
        ],
      ),
    );
  }
}

class ValueListenableBuilder2<A, B> extends StatelessWidget {
  ValueListenableBuilder2(
    this.first,
    this.second, {
    required Key key,
    required this.builder,
    required this.child,
  }) : super(key: key);

  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final Widget child;
  final Widget Function(BuildContext context, A a, B b, Widget child) builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (_, a, __) {
        return ValueListenableBuilder<B>(
          valueListenable: second,
          builder: (context, b, __) {
            return builder(context, a, b, child);
          },
        );
      },
    );
  }
}
