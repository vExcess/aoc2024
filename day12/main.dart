import 'dart:io';

void floodFill(List<List<String>> map, int x, int y, String crop) {
    if (x < 0 || x >= map[0].length || y < 0 || y >= map.length || map[y][x] != crop) {
        return;
    }

    map[y][x] = "#";

    floodFill(map, x-1, y, crop);
    floodFill(map, x+1, y, crop);
    floodFill(map, x, y-1, crop);
    floodFill(map, x, y+1, crop);
}

(int, int) getAreaPerimeter(List<List<String>> map) {
    int area = 0;
    int perimeter = 0;
    for (var y = 0; y < map.length; y++) {
        for (var x = 0; x < map[y].length; x++) {
            if (map[y][x] == "#") {
                area++;
                if (x == 0 || map[y][x-1] != "#")
                    perimeter++;
                if (x == map[y].length-1 || map[y][x+1] != "#")
                    perimeter++;
                if (y == 0 || map[y-1][x] != "#")
                    perimeter++;
                if (y == map.length-1 || map[y+1][x] != "#")
                    perimeter++;
            }
        }
    }
    return (area, perimeter);
}

void resetZone(List<List<String>> map) {
    for (var y = 0; y < map.length; y++) {
        for (var x = 0; x < map[y].length; x++) {
            if (map[y][x] == "#") {
                map[y][x] = " ";
            }
        }
    }
}

class Side {
    late int x;
    late int y;
    late int w;
    late int h;
    late int dir;
    Side(this.x, this.y, this.w, this.h, this.dir);

    String toString() {
        return "$x $y $w $h $dir";
    }
}

List<Side> getSides(List<List<String>> map) {
    List<Side> sides = [];
    for (var y = 0; y < map.length; y++) {
        for (var x = 0; x < map[y].length; x++) {
            if (map[y][x] == "#") {
                if (x == 0 || map[y][x-1] != "#")
                    sides.add(Side(x, y, 1, 1, 0));
                if (x == map[y].length-1 || map[y][x+1] != "#")
                    sides.add(Side(x, y, 1, 1, 1));
                if (y == 0 || map[y-1][x] != "#")
                    sides.add(Side(x, y, 1, 1, 2));
                if (y == map.length-1 || map[y+1][x] != "#")
                    sides.add(Side(x, y, 1, 1, 3));
            }
        }
    }

    for (var i = 0; i < sides.length; i++) {
        var a = sides[i];
        for (var j = 0; j < sides.length; j++) {
            var b = sides[j];
            if (b.x > a.x && b.x <= a.x + a.w && b.y == a.y && b.dir == a.dir) {
                a.w++;
                sides.remove(b);
                j--;
            }
            if (b.y > a.y && b.y <= a.y + a.h && b.x == a.x && b.dir == a.dir) {
                a.h++;
                sides.remove(b);
                j--;
            }
        }
    }

    return sides;
}

void main() {
    File("./input.txt").readAsString().then((String txt) {
        final startTime = DateTime.now().millisecondsSinceEpoch;

        List<List<String>> map = txt.split("\n").map((l) => l.split("")).toList();
        var price1 = 0;
        var price2 = 0;
        for (var y = 0; y < map.length; y++) {
            for (var x = 0; x < map[y].length; x++) {
                final crop = map[y][x];
                if (crop != ' ') {
                    floodFill(map, x, y, crop);
                    final stats = getAreaPerimeter(map);
                    final area = stats.$1;
                    final perimeter = stats.$2;
                    price1 += area * perimeter;
                    price2 += area * getSides(map).length;
                    resetZone(map);
                }
            }
        }

        print("part1: $price1");
        print("part2: $price2");
        
        final endTime = DateTime.now().millisecondsSinceEpoch;
        print("millis: ${endTime - startTime}");
    });
}
