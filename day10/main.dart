// import 'dart:collection';
import 'dart:io';
// import 'dart:math' as Math;

int bitmaskCoord(int x, int y) {
    return (x << 16) | y;
}

bool listHasList<T>(List<List<T>> listList, List<T> list) {
    for (var i = 0; i < listList.length; i++) {
        final item = listList[i];
        if (item[0] == list[0] && item[1] == list[1]) {
            return true;
        }
    }
    return false;
}

List<List<int>> getPeaks(int x, int y, List<List<int>> map) {
    final height = map[y][x];
    List<List<int>> paths = [];
    if (x > 0 && map[y][x - 1] == height + 1) {
        paths.add([x-1, y]);
    }
    if (x < map[0].length - 1 && map[y][x + 1] == height + 1) {
        paths.add([x+1, y]);
    }
    if (y > 0 && map[y - 1][x] == height + 1) {
        paths.add([x, y - 1]);
    }
    if (y < map.length - 1 && map[y + 1][x] == height + 1) {
        paths.add([x, y + 1]);
    }

    List<List<int>> peaks = [];
    for (var i = 0; i < paths.length; i++) {
        final p = paths[i];
        if (map[p[1]][p[0]] == 9) {
            if (!listHasList(peaks, p)) {
                peaks.add(p);
            }
        } else {
            final nextPeaks = getPeaks(p[0], p[1], map);
            for (var j = 0; j < nextPeaks.length; j++) {
                if (!listHasList(peaks, nextPeaks[j])) {
                    peaks.add(nextPeaks[j]);
                }
            }
        }
    }

    return peaks;
}

class Node {
    late int x;
    late int y;
    // int maxDepth = 0;
    Node? parent = null;
    List<Node> nextNodes = [];

    Node(int x, int y, [Node? parent]) {
        this.x = x;
        this.y = y;
        this.parent = parent;
    }

    void findNextNodes(List<List<int>> map) {
        final x = this.x;
        final y = this.y;
        final height = map[y][x];
        if (x > 0 && map[y][x - 1] == height + 1) {
            this.nextNodes.add(Node(x-1, y, this));
        }
        if (x < map[0].length - 1 && map[y][x + 1] == height + 1) {
            this.nextNodes.add(Node(x+1, y, this));
        }
        if (y > 0 && map[y - 1][x] == height + 1) {
            this.nextNodes.add(Node(x, y-1, this));
        }
        if (y < map.length - 1 && map[y + 1][x] == height + 1) {
            this.nextNodes.add(Node(x, y+1, this));
        }

        for (var i = 0; i < this.nextNodes.length; i++) {
            this.nextNodes[i].findNextNodes(map);
        }
    }

    void genRows(List<List<Node>> all, List<Node> prev, Node curr, int ree) {
        var arr = prev.sublist(0);
        arr.add(curr);
        for (var i = 0; i < curr.nextNodes.length; i++) {
            if (ree > 1) {
                genRows(all, arr, curr.nextNodes[i], ree - 1);
            } else {
                var arr2 = arr.sublist(0);
                arr2.add(curr.nextNodes[i]);
                all.add(arr2);
            }
        }
    }

    List<List<Node>> toArrays([List<List<Node>>? arr]) {
        List<List<Node>> out = [];
        genRows(out, [], this, 9);
        return out;
    }

    int calcPossibilities() {
        var sum = this.nextNodes.length;
        for (var i = 0; i < this.nextNodes.length; i++) {
            sum += this.nextNodes[i].calcPossibilities();
        }
        return sum;
    }

    String toString() {
        return "[$x $y]";
    }
}

void main() {
    File("./input.txt").readAsString().then((String txt) {
        final startTime = DateTime.now().millisecondsSinceEpoch;
        
        List<List<int>> map = txt.split("\n").map((l) => l.split("").map((s) => int.parse(s)).toList()).toList();
        List<List<String>> display = txt.split("\n").map((l) => l.split("")).toList();

        var totalScore = 0;
        var totalRank = 0;
        for (var y = 0; y < map.length; y++) {
            for (var x = 0; x < map[y].length; x++) {
                if (map[y][x] == 0) {
                    final score = getPeaks(x, y, map).length;
                    totalScore += score;

                    var myNode = Node(x, y);
                    myNode.findNextNodes(map);
                    totalRank += myNode.toArrays().length;
                } else {
                    display[y][x] = '.';
                }
            }
        }
        print(display.map((r) => r.join("")).join("\n"));
        print("totalScore: $totalScore");
        print("totalRank: $totalRank");
        
        final endTime = DateTime.now().millisecondsSinceEpoch;
        print("millis: ${endTime - startTime}");
    });
}
