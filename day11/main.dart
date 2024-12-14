import 'dart:collection';
import 'dart:io';
// import 'dart:math' as Math;

bool isDoubleDigits(int num) {
    if (
        (num >= 10 && num <= 99) ||
        (num >= 1000 && num <= 9999) ||
        (num >= 100000 && num <= 999999) ||
        (num >= 10000000 && num <= 99999999) ||
        (num >= 1000000000 && num <= 9999999999) ||
        (num >= 100000000000 && num <= 999999999999)
    ) {
        return true;
    } else if (num > 9999999999) {
        print("BIG! $num");
        return num.toString().length % 2 == 0;
    } else {
        return false;
    }
}

class Node {
    late int num;
    Node? next = null;

    Node(int num, [Node? next]) {
        this.num = num;
        this.next = next;
    }

    int getListLength() {
        Node? rock = this;
        int counter = 0;
        while (rock != null) {
            counter++;
            rock = rock.next;
        }
        return counter;
    }

    void printList() {
        Node? rock = this;
        String data = "";
        while (rock != null) {
            data += rock.num.toString() + " ";
            rock = rock.next;
        }
        print(data);
    }
}

void iterate(Node firstRock) {
    Node? rock = firstRock;
    while (rock != null) {
        final num = rock.num;
        if (num == 0) {
            rock.num = 1;
        } else if (isDoubleDigits(num)) {
            int a, b;
            if (num <= 99) {
                a = (num / 10).toInt();
                b = num % 10;
            } else {
                final str = num.toString();
                final half = (str.length / 2).toInt();
                a = int.parse(str.substring(0, half));
                b = int.parse(str.substring(half));
            }

            rock.num = a;
            final insertRock = Node(b, rock.next);
            rock.next = insertRock;
            rock = rock.next;
        } else {
            rock.num *= 2024;
        }
        rock = (rock as Node).next;
    }
}

void part1(String txt) {
    List<Node> rocks = txt.split(" ").map((s) => Node(int.parse(s))).toList();
    for (var i = 0; i < rocks.length - 1; i++) {
        rocks[i].next = rocks[i + 1];
    }

    for (var rounds = 0; rounds < 25; rounds++) {
        iterate(rocks[0]);
    }
    print("Part1: ${rocks[0].getListLength()}");
}

int numberOf(int num, List<int> arr) {
    int count = 0;
    for (var i = 0; i < arr.length; i++) {
        if (arr[i] == num) {
            count++;
        }
    }
    return count;
}

void part2(String txt) {
    List<int> rocks = txt.split(" ").map((s) => int.parse(s)).toList();
    Map<int, int> firstGen = HashMap();
    for (var i = 0; i < rocks.length; i++) {
        final num = rocks[i];
        if (firstGen[num] == null) {
            firstGen[num] = numberOf(num, rocks);
        }
    }

    Map<int, int> currGen = firstGen;
    for (var rounds = 0; rounds < 75; rounds++) {
        Map<int, int> nextGen = HashMap();
        List<int> doubleDigitsQueue = [];
        for (int key in currGen.keys) {
            if (key == 0) {
                nextGen[1] = currGen[key]!;
            } else if (isDoubleDigits(key)) {
                doubleDigitsQueue.add(key);
            } else {
                nextGen[key * 2024] = currGen[key]!;
            }
        }

        for (var i = 0; i < doubleDigitsQueue.length; i++) {
            final key = doubleDigitsQueue[i];
            int a, b;
            if (key <= 99) {
                a = (key / 10).toInt();
                b = key % 10;
            } else {
                final str = key.toString();
                final half = (str.length / 2).toInt();
                a = int.parse(str.substring(0, half));
                b = int.parse(str.substring(half));
            }

            if (nextGen[a] == null) {
                nextGen[a] = currGen[key]!;
            } else {
                nextGen[a] = nextGen[a]! + currGen[key]!;
            }

            if (nextGen[b] == null) {
                nextGen[b] = currGen[key]!;
            } else {
                nextGen[b] = nextGen[b]! + currGen[key]!;
            }
        }
        currGen = nextGen;
    }

    var rockCount = 0;
    for (int key in currGen.keys) {
        rockCount += currGen[key]!;
    }
    print("Part2: ${rockCount}");
}

void main() {
    File("./input.txt").readAsString().then((String txt) {
        final startTime = DateTime.now().millisecondsSinceEpoch;

        part1(txt);
        part2(txt);
        
        final endTime = DateTime.now().millisecondsSinceEpoch;
        print("millis: ${endTime - startTime}");
    });
}
