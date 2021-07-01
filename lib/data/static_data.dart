import 'package:the_boats/common/images.dart';
import 'boat_model.dart';

const _desc = "You can fly over the surface of eater";

const _space = Space('24\"', '100\"', '2500 kg', '300 L');

final boats = <Boat>[
  Boat('X Speed', 'Vishal', Image.boat1, _desc, _space),
  Boat('Mortal M', 'Rakesh', Image.boat2, _desc, _space),
  Boat('XCC Kelli', 'Vishal', Image.boat3, _desc, _space),
  Boat('CW Force', 'Rakesh', Image.boat4, _desc, _space),
];

final gallery = [
  Image.gallery1,
  Image.gallery2,
  Image.gallery3,
  Image.gallery4,
  Image.gallery5,
];
