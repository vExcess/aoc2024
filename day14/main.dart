import 'dart:io';

final mapWidth = 101;
final mapHeight = 103;

class Robot {
    late (int, int) pos;
    late (int, int) vel;

    Robot(List<int> pos, List<int> vel) {
        this.pos = (pos[0], pos[1]);
        this.vel = (vel[0], vel[1]);
    }

    void move() {
        var newX = (this.pos.$1 + this.vel.$1) % mapWidth;
        var newY = (this.pos.$2 + this.vel.$2) % mapHeight;

        while (newX < 0)
            newX += mapWidth;
        while (newY < 0)
            newY += mapHeight;

        this.pos = (newX, newY);
    }

    int getQuadrant() {
        final xLim = (mapWidth / 2).toInt();
        final yLim = (mapHeight / 2).toInt();
        if (this.pos.$1 < xLim) {
            if (this.pos.$2 < yLim) {
                return 0;
            } else if (this.pos.$2 > yLim) {
                return 1;
            }
        } else if (this.pos.$1 > xLim) {
            if (this.pos.$2 < yLim) {
                return 2;
            } else if (this.pos.$2 > yLim) {
                return 3;
            }
        }
        return -1;
    }
}

List<List<int>> renderRobots(List<Robot> robots) {
    List<List<int>> map = [];
    for (var y = 0; y < mapHeight; y++) {
        map.add(List.filled(mapWidth, 0));
    }

    for (var i = 0; i < robots.length; i++) {
        var bot = robots[i];
        map[bot.pos.$2][bot.pos.$1]++;
    }

    return map;
}

bool mapHasRepeat(List<List<int>> map, int repeats) {
    for (var y = 0; y < map.length; y++) {
        int count = 0;
        for (var x = 0; x < map[y].length; x++) {
            if (map[y][x] != 0) {
                count++;
                if (count == repeats)
                    return true;
            } else {
                count = 0;
            }
        }
    }
    return false;
}

void main() {
    File("./input.txt").readAsString().then((String txt) {
        final startTime = DateTime.now().millisecondsSinceEpoch;

        List<Robot> robots = txt.split("\n").map((r) {
            final items = r.split(" ");
            final pos = items[0].substring(2).split(",").map((s) => int.parse(s)).toList();
            final vel = items[1].substring(2).split(",").map((s) => int.parse(s)).toList();
            return Robot(pos, vel);
        }).toList();

        // simulate robots
        for (var second = 0; second < 100; second++) {
            for (var i = 0; i < robots.length; i++) {
                robots[i].move();
            }
        }

        // count bots in quadrants
        var quadrantCounts = [0, 0, 0, 0];
        for (var i = 0; i < robots.length; i++) {
            final quadrant = robots[i].getQuadrant();
            if (quadrant != -1) {
                quadrantCounts[quadrant]++;
            }
        }

        // calc safety
        var safetyFactor = 1;
        for (var i = 0; i < quadrantCounts.length; i++) {
            safetyFactor *= quadrantCounts[i];
        }

        // reset robots        
        robots = txt.split("\n").map((r) {
            final items = r.split(" ");
            final pos = items[0].substring(2).split(",").map((s) => int.parse(s)).toList();
            final vel = items[1].substring(2).split(",").map((s) => int.parse(s)).toList();
            return Robot(pos, vel);
        }).toList();

        // simulate robots
        var second = 0;
        while (true) {
            for (var i = 0; i < robots.length; i++) {
                robots[i].move();
            }
            second++;
            final map = renderRobots(robots);
            if (mapHasRepeat(map, 10)) {
                print(map.map((r) => r.join("").replaceAll('0', '.')).join("\n"));
                print("part1: $safetyFactor");
                print("part2: $second");
                break;
            }
        }

        final endTime = DateTime.now().millisecondsSinceEpoch;
        print("millis: ${endTime - startTime}");
    });
}
