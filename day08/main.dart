import 'dart:collection';
import 'dart:io';
import 'dart:math' as Math;

double dist(int x1, int y1, int x2, int y2) {
    final a = x2 - x1;
    final b = y2 - y1;
    return Math.sqrt(a*a + b*b);
}

T abs<T>(T n) {
    if (T == int) {
        final intN = n as int;
        return (intN < 0 ? -intN : intN) as T;
    } else if (T == double) {
        final intN = n as double;
        return (intN < 0 ? -intN : intN) as T;
    }
    throw "unsupported type passed to abs";
}

bool feq(double a, double b) {
    return abs(a - b) < 0.0000000001;
}

int calcAntennaCount(List<List<String>> map, Map<String, List<List<int>>> antennas, bool part2) {
    for (final frequency in antennas.keys) {
        var subAntennas = antennas[frequency] as List<List<int>>;
        for (var i = 0; i < subAntennas.length; i++) {
            final a1 = subAntennas[i];
            for (var j = 0; j < subAntennas.length; j++) {
                final a2 = subAntennas[j];
                var slope;
                if (a2[0] == a1[0]) {
                    slope = double.infinity;
                } else {
                    slope = (a2[1] - a1[1]) / (a2[0] - a1[0]);
                }
                final b = -(slope * a1[0] - a1[1]);
                for (var y = 0; y < map.length; y++) {
                    for (var x = 0; x < map[y].length; x++) {
                        if (feq(y.toDouble(), slope * x + b)) {
                            final d1 = dist(x, y, a1[0], a1[1]);
                            final d2 = dist(x, y, a2[0], a2[1]);
                            if (part2 || feq(d1, d2 * 2) || feq(d1 * 2, d2)) {
                                map[y][x] = '#';
                            }
                        }
                    }
                }
            }   
        }
    }

    var antennaCount = 0;
    for (var y = 0; y < map.length; y++) {
        for (var x = 0; x < map[y].length; x++) {
            if (map[y][x] == '#') {
                antennaCount++;
            }
        }
    }

    return antennaCount;
}

void main() {
    File("./input.txt").readAsString().then((String txt) {
        final startTime = DateTime.now().millisecondsSinceEpoch;
        
        final frequencies = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

        List<List<String>> map = txt.split('\n').map((l) => l.split('').toList()).toList();
        Map<String, List<List<int>>> antennas = HashMap();
        for (var i = 0; i < frequencies.length; i++) {
            antennas[frequencies[i]] = [];
        }
        for (var y = 0; y < map.length; y++) {
            for (var x = 0; x < map[y].length; x++) {
                final value = map[y][x];
                if (value != '.' && value != '#') {
                    (antennas[value] as List<List<int>>).add([x, y]);
                }
            }
        }
        print("part1: ${calcAntennaCount(map,  antennas, false)}");

        map = txt.split('\n').map((l) => l.split('').toList()).toList();
        antennas = HashMap();
        for (var i = 0; i < frequencies.length; i++) {
            antennas[frequencies[i]] = [];
        }
        for (var y = 0; y < map.length; y++) {
            for (var x = 0; x < map[y].length; x++) {
                final value = map[y][x];
                if (value != '.' && value != '#') {
                    (antennas[value] as List<List<int>>).add([x, y]);
                }
            }
        }
        print("part2: ${calcAntennaCount(map,  antennas, true)}");

        final endTime = DateTime.now().millisecondsSinceEpoch;
        print("millis: ${endTime - startTime}");
    });
}