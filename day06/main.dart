import 'dart:collection';
import 'dart:io';
import 'dart:math' as Math;

List<int> findCharacter(List<List<String>> map) {
    for (var y = 0; y < map.length; y++) {
        for (var x = 0; x < map[y].length; x++) {
            if (map[y][x] == '^') {
                return [x, y];
            }
        }
    }
    throw "character not found";
}

int countVisited(List<List<String>> map) {
    int visited = 0;
    for (var y = 0; y < map.length; y++) {
        for (var x = 0; x < map[y].length; x++) {
            if (map[y][x] == '@') {
                visited++;
            }
        }
    }
    return visited;
}

bool isOffMap(List<List<String>> map, List<int> characterPos) {
    return characterPos[0] < 0 || characterPos[0] >= map[0].length ||
        characterPos[1] < 0 || characterPos[1] >= map.length;
}

int bitmaskCoord(int x, int y) {
    return (x << 16) | y;
}

bool isLoop(List<List<String>> map, List<int> constCharacterPos, double characterDir) {
    Map<int, List<bool>> path = HashMap();

    var characterPos = constCharacterPos.sublist(0);
    while (!isOffMap(map, characterPos)) {
        final coordHash = bitmaskCoord(characterPos[0], characterPos[1]);
        if (path[coordHash] == null) {
            path[coordHash] = [false, false, false, false];
        }

        final intDir = (characterDir / (Math.pi * 2) * 4).round();
        final hasBeenBefore = (path[coordHash] as List<bool>)[intDir];
        if (hasBeenBefore) {
            return true;
        }
        (path[coordHash] as List<bool>)[intDir] = true;
        
        final newX = characterPos[0] + (Math.cos(characterDir)).round();
        final newY = characterPos[1] + (Math.sin(characterDir)).round();

        if (!isOffMap(map, [newX, newY]) && map[newY][newX] == '#') {
            characterDir = (characterDir + Math.pi / 2) % (Math.pi * 2);
            continue;
        }

        characterPos[0] = newX;
        characterPos[1] = newY;
    }

    return false;
}

void main() {
    File("./input.txt").readAsString().then((String txt) {
        List<List<String>> map = txt.split("\n").map((r) => r.split("")).toList();
        final origCharacterPos = findCharacter(map);
        final origCharacterDir = 3*Math.pi / 2;

        var characterPos = origCharacterPos.sublist(0);
        var characterDir = origCharacterDir;
        while (!isOffMap(map, characterPos)) {
            map[characterPos[1]][characterPos[0]] = "@";
            final newX = characterPos[0] + (Math.cos(characterDir)).round();
            final newY = characterPos[1] + (Math.sin(characterDir)).round();

            if (!isOffMap(map, [newX, newY]) && map[newY][newX] == '#') {
                characterDir += Math.pi / 2;
                continue;
            }

            characterPos[0] = newX;
            characterPos[1] = newY;
        }

        // number of visited positions
        print("visited: ${countVisited(map)}");
        
        var testMap = txt.split("\n").map((r) => r.split("")).toList();
        map = txt.split("\n").map((r) => r.split("")).toList();
        characterPos = origCharacterPos.sublist(0);
        characterDir = origCharacterDir;
        Map<int, bool> foundObstacles = HashMap();
        while (!isOffMap(map, characterPos)) {
            map[characterPos[1]][characterPos[0]] = "@";
            final newX = characterPos[0] + (Math.cos(characterDir)).round();
            final newY = characterPos[1] + (Math.sin(characterDir)).round();

            if (isOffMap(map, [newX, newY])) {
                break;
            }

            final origMapChar = testMap[newY][newX];
            testMap[newY][newX] = "#";
            if (origMapChar != '^' && isLoop(testMap, origCharacterPos, origCharacterDir)) {
                foundObstacles[bitmaskCoord(newX, newY)] = true;
            }
            testMap[newY][newX] = origMapChar;

            if (map[newY][newX] == '#') {
                characterDir += Math.pi / 2;
                continue;
            }

            characterPos[0] = newX;
            characterPos[1] = newY;
        }

        print("obstacle possibilities: ${foundObstacles.length}");
    });
}
