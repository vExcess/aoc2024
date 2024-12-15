import 'dart:io';

double abs(double n) {
    return n < 0 ? -n : n;
}

List<int> parseStringCoords(String str) {
    return str.substring(str.indexOf(':') + 1)
        .replaceAll("+", "")
        .replaceAll("=", "")
        .replaceFirst("X", "")
        .replaceFirst("Y", "")
        .trim()
        .split(", ")
        .map((s) => int.parse(s))
        .toList();
}

/*

    x1, y1
    x2, y2
    x3, y3

    Q*x1 + W*x2 = x3
    Q*y1 + W*y2 = y3

    Q = (x3 - W*x2) / x1
    W = (x3 - Q*x1) / x2


    Q = (8400 - W*22) / 94
    Q = (5400 - W*67) / 34

    Q + (22/94)*W = 8400/94
    Q + (67/34)*W = 5400/34

      Q + (22/94)*W = 8400/94
    - Q + (67/34)*W = 5400/34
    =========================
      0 + (22/94 - 67/34) * W = 8400/94 - 5400/34

    W = (8400/94 - 5400/34) / (22/94 - 67/34)
    W = (x3/x1 - y3/y1) / (x2/x1 - y2/y1)

*/

class Machine {
    late (int, int) A;
    late (int, int) B;
    late (int, int) prize;

    Machine(List<int> a, List<int> b, List<int> prize) {
        this.A = (a[0], a[1]);
        this.B = (b[0], b[1]);
        this.prize = (prize[0], prize[1]);
    }

    (int, int, int)? part1Solution() {
        final (xa, ya) = this.A;
        final (xb, yb) = this.B;
        final (xp, yp) = this.prize;

        List<(int, int, int)> solutions = [];
        for (var Q = 0; Q < 100; Q += 1) {
            final doubleW = (xp - Q*xa) / xb;
            final W = doubleW.toInt();
            if (W == doubleW) {
                if (Q*xa + W*xb == xp && Q*ya + W*yb == yp) {
                    solutions.add((Q, W, Q*3 + W));
                }
            }
        }

        solutions.sort((a, b) => a.$3 - b.$3);

        return solutions.length > 0 ? solutions[0] : null;
    }

    (int, int, int)? part2Solution() {
        final (xa, ya) = this.A;
        final (xb, yb) = this.B;
        var (xp, yp) = this.prize;
        xp += 10000000000000;
        yp += 10000000000000;

        List<(int, int, int)> solutions = [];

        final W = (xp/xa - yp/ya) / (xb/xa - yb/ya);
        final Q = (xp - W*xb) / xa;
        final intQ = Q.round();
        final intW = W.round();

        if (abs(Q - intQ) < 0.001 && abs(W - intW) < 0.001) {
            return (intQ, intW, intQ*3 + intW);
        }

        solutions.sort((a, b) => a.$3 - b.$3);

        return solutions.length > 0 ? solutions[0] : null;
    }
}

void main() {
    File("./input.txt").readAsString().then((String txt) {
        final startTime = DateTime.now().millisecondsSinceEpoch;

        List<Machine> machines = txt.split("\n\n").map((m) {
            final items = m.split('\n');
            final a = parseStringCoords(items[0]);
            final b = parseStringCoords(items[1]);
            final prize = parseStringCoords(items[2]);
            return Machine(a, b, prize);
        }).toList();

        var tokens = 0;
        for (var i = 0; i < machines.length; i++) {
            final solution = machines[i].part1Solution();
            if (solution != null) {
                tokens += solution.$3;
            }
        }
        print("part1: $tokens");

        tokens = 0;
        for (var i = 0; i < machines.length; i++) {
            final solution = machines[i].part2Solution();
            if (solution != null) {
                tokens += solution.$3;
            }
        }
        print("part2: $tokens");
        
        final endTime = DateTime.now().millisecondsSinceEpoch;
        print("millis: ${endTime - startTime}");
    });
}
