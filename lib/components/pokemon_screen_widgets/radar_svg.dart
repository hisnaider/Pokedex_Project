import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../util/util.dart';

class RadarSvg extends StatelessWidget {
  final Color color;
  final Map<String, dynamic> status;
  final int x = 50;
  final int y = 50;
  final double r = 49.65;
  const RadarSvg({
    super.key,
    required this.color,
    required this.status,
  });

  double degree(value) {
    final result = (r * (value / 100));
    return result < r ? result : r;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, double> ponto1 = {
      "x": x + degree(status["hp"]) * cos(210 * pi / 180),
      "y": y + degree(status["hp"]) * sin(210 * pi / 180)
    };
    final Map<String, double> ponto2 = {
      "x": x + degree(status["speed"]) * cos(270 * pi / 180),
      "y": y + degree(status["speed"]) * sin(270 * pi / 180)
    };
    final Map<String, double> ponto3 = {
      "x": x + degree(status["sp_def"]) * cos(330 * pi / 180),
      "y": y + degree(status["sp_def"]) * sin(330 * pi / 180)
    };
    final Map<String, double> ponto4 = {
      "x": x + degree(status["sp_atk"]) * cos(30 * pi / 180),
      "y": y + degree(status["sp_atk"]) * sin(30 * pi / 180)
    };
    final Map<String, double> ponto5 = {
      "x": x + degree(status["defense"]) * cos(90 * pi / 180),
      "y": y + degree(status["defense"]) * sin(90 * pi / 180)
    };
    final Map<String, double> ponto6 = {
      "x": x + degree(status["attack"]) * cos(150 * pi / 180),
      "y": y + degree(status["attack"]) * sin(150 * pi / 180)
    };
    final String svgString = '''
  <svg width="100" height="100" viewBox="0 0 104 104" fill="none" xmlns="http://www.w3.org/2000/svg">
<circle cx="50" cy="50" r="49.65" fill="white" stroke="#E6E6E6" stroke-width="0.7"/>
<circle cx="50" cy="50" r="39.65" fill="white" stroke="#E6E6E6" stroke-width="0.7"/>
<circle cx="50" cy="50" r="29.65" fill="white" stroke="#E6E6E6" stroke-width="0.7"/>
<circle cx="50" cy="50" r="19.65" fill="white" stroke="#E6E6E6" stroke-width="0.7"/>
<circle cx="50" cy="50" r="9.65" fill="white" stroke="#E6E6E6" stroke-width="0.7"/>
<line x1="50" y1="0" x2="50" y2="100" stroke="#E6E6E6" stroke-width="0.7"/>
<line x1="50" y1="0" x2="50" y2="100" stroke="#E6E6E6" transform="rotate(60 50 50)" stroke-width="0.7"/>
<line x1="50" y1="0" x2="50" y2="100" stroke="#E6E6E6" transform="rotate(-60 50 50)" stroke-width="0.7"/>
<path d="
M${ponto1["x"]} ${ponto1["y"]}
L${ponto2["x"]} ${ponto2["y"]}
L${ponto3["x"]} ${ponto3["y"]}
L${ponto4["x"]} ${ponto4["y"]}
L${ponto5["x"]} ${ponto5["y"]}
L${ponto6["x"]} ${ponto6["y"]}
Z" fill="${Util.colorToHex(color)}"/>
</svg>

''';
    return SizedBox(
      height: 175,
      width: 175,
      child: Stack(children: [
        Center(
          child: Container(
            height: 175,
            transform: Matrix4.rotationZ(0),
            child: Column(
              children: [
                Text(
                  "Agilidade",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                Text(
                  "${status["speed"]}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Expanded(child: SizedBox()),
                Text(
                  "${status["defense"]}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  "Defesa",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ),
        Transform(
          transform: Matrix4.rotationZ(-1),
          alignment: Alignment.center,
          child: SizedBox(
            height: 175,
            child: Center(
              child: Column(
                children: [
                  Text(
                    "Vida",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  Text(
                    "${status["hp"]}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Expanded(child: SizedBox()),
                  Text(
                    "${status["sp_atk"]}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    "Ataque esp",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
          ),
        ),
        Transform(
          transform: Matrix4.rotationZ(1),
          alignment: Alignment.center,
          child: SizedBox(
            height: 175,
            child: Center(
              child: Column(
                children: [
                  Text(
                    "Defesa esp",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  Text(
                    "${status["defense"]}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Expanded(child: SizedBox()),
                  Text(
                    "${status["attack"]}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    "Ataque",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
          ),
        ),
        Center(
          child: SvgPicture.string(
            svgString,
            width: 105,
            height: 105,
          ),
        )
      ]),
    );
  }
}
