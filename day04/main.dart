import 'dart:collection';
import 'dart:io';

String getCh(List<String> lines, int x, int y) {
    if (y < 0 || y >= lines.length || x < 0 || x >= lines[y].length)
        return "";
    return lines[y][x];
}

// (x, y)
List<List<int>> offsetLookup = [
    [ 0, -1],
    [ 1, -1],
    [ 1,  0],
    [ 1,  1],
    [ 0,  1],
    [-1,  1],
    [-1,  0],
    [-1, -1],
];

List<int> checkForAt(List<String> lines, String ch, int x, int y, int dir) {
    // searches for a character around a coordinate
    List<int> out = [];
    if (dir == -1) {
        for (var i = 0; i < offsetLookup.length; i++) {
            if (getCh(lines, x+offsetLookup[i][0], y+offsetLookup[i][1]) == ch) {
                out.add(i);
            }
        }
    } else {
        if (getCh(lines, x+offsetLookup[dir][0], y+offsetLookup[dir][1]) == ch) {
            out.add(dir);
        }
    }
    return out;
}

// returns list of directions of matches
List<int> checkAt(List<String> lines, String target, int xPos, int yPos, [int dir=-1]) {
    // finds all directions of full matches around a point
    final find = checkForAt(lines, target[0], xPos, yPos, dir);
    if (find.length == 0) {
        return [];
    }

    var subTarget = target.substring(1);
    if (subTarget.length == 0) {
        return [dir];
    }

    List<int> foundDirs = [];
    for (var i = 0; i < find.length; i++) {
        var oi = find[i];
        if (dir == -1 || oi == dir) {
            final results = checkAt(lines, subTarget, xPos + offsetLookup[oi][0], yPos + offsetLookup[oi][1], oi);
            for (var j = 0; j < results.length; j++) {
                foundDirs.add(results[j]);
            }
        }
    }

    return foundDirs;
}

bool isX(int dir1, int dir2) {
    return ((dir1 == 1 || dir1 == 5) && (dir2 == 3 || dir2 == 7)) ||
        ((dir2 == 1 || dir2 == 5) && (dir1 == 3 || dir1 == 7));
}

int bitmaskCoord(int x, int y) {
    return (x << 16) | y;
}

void main() {
    File("./input.txt").readAsString().then((String txt) {
        List<String> lines = txt.split("\n");
        final lookFor = "MAS";

        Map<int, List<int>> midPoints = HashMap();
        for (var y = 0; y < lines.length; y++) {
            for (var x = 0; x < lines[y].length; x++) {
                if (getCh(lines, x, y) == lookFor[0]) {
                    var matches = checkAt(lines, lookFor.substring(1), x, y);
                    
                    for (var i = 0; i < matches.length; i++) {
                        final dir = matches[i];
                        final midX = x + offsetLookup[dir][0];
                        final midY = y + offsetLookup[dir][1];
                        final hash = bitmaskCoord(midX, midY);
                        if (midPoints[hash] == null) {
                            midPoints[hash] = [dir];
                        } else {
                            (midPoints[hash] as List<int>).add(dir);
                        }
                    }
                }
            }
        }

        // filter the matches to only contain X's
        var foundCount = 0;
        for (final key in midPoints.keys) {
            final dirs = midPoints[key] as List<int>;
            if (dirs.length > 1) {
                for (var i = 0; i < dirs.length; i++) {
                    for (var j = 0; j < i; j++) {
                        if (isX(dirs[i], dirs[j])) {
                            foundCount++;
                        }
                    }
                }
            }
        }

        print("foundCount: ${foundCount}");
    });
}