import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_boats/data/boat_model.dart';
import 'package:the_boats/data/static_data.dart';
import 'package:the_boats/ui/boat_widget.dart';
import 'package:the_boats/ui/detail_screen.dart';

import 'custom_app_bar.dart';

class BoatsScreen extends StatefulWidget {
  const BoatsScreen({Key? key}) : super(key: key);

  @override
  _BoatsScreenState createState() => _BoatsScreenState();
}

class _BoatsScreenState extends State<BoatsScreen> {
  late ValueNotifier<bool> _isAppBarAnimate;
  late ValueNotifier<double> _pageFactor;
  late PageController _pageController;

  void _pageListener() {
    print('page value:: ${_pageController.page}');
    _pageFactor.value = _pageController.page!;
  }

  @override
  void initState() {
    super.initState();
    _isAppBarAnimate = ValueNotifier(false);
    _pageFactor = ValueNotifier(0.0);
    _pageController = PageController(viewportFraction: .6);
    _pageController.addListener(_pageListener);
  }

  @override
  void dispose() {
    _pageController.removeListener(_pageListener);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        SafeArea(
          child: ValueListenableBuilder(
            valueListenable: _isAppBarAnimate,
            builder: (BuildContext context, bool value, Widget? child) {
              return CustomAppBar(animate: value);
            },
          ),
        ),
        Expanded(
          child: PageView.builder(
              controller: _pageController,
              itemCount: boats.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final boat = boats[index];

                return ValueListenableBuilder(
                  valueListenable: _pageFactor,
                  builder: (BuildContext context, double value, Widget? child) {
                    return BoatWidget(
                      boat: boat,
                      onTap: () => onSpecTap(boat),
                      factor: (value - index).abs(),
                    );
                  },
                );
              }),
        ),
      ],
    );
  }

  void onSpecTap(Boat boat) {
    _isAppBarAnimate.value = true;
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return FadeTransition(
            opacity: animation,
            child: DetailScreen(boat: boat),
          );
        },
      ),
    ).then((value) {
      _isAppBarAnimate.value = false;
    });
  }
}
