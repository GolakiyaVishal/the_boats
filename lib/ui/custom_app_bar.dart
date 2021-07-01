import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final bool animate;

  const CustomAppBar({
    Key? key,
    required this.animate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      curve: Curves.fastOutSlowIn,
      transform: Matrix4.translationValues(0, animate ? -kToolbarHeight : 0, 0),
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 600),
        opacity: animate ? 0 : 1,
        child: SizedBox(
          height: kToolbarHeight,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child:
                    Text("Boats", style: Theme.of(context).textTheme.headline4),
              )),
              IconButton(onPressed: () {}, icon: Icon(Icons.search_off))
            ],
          ),
        ),
      ),
    );
  }
}
