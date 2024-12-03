import 'dart:io';

int abs(int n) {
    return n < 0 ? -n : n;
}

bool isSafe(List<int> report) {
    var increasing = false;
    for (var i = 0; i < report.length - 1; i++) {
        var d = report[i + 1] - report[i];
        var ad = abs(d);
        if (!(ad >= 1 && ad <= 3)) {
            return false;
        }
        if (i == 0) {
            increasing = d > 0;
        } else {
            if ((increasing && d < 0) || (!increasing && d > 0)) {
                return false;
            }
        }
    }
    return true;
}

void main() {
    File("./input.txt").readAsString().then((String txt) {
        List<List<String>> lines = txt.split("\n")
            .map((ln) => ln.split(" ")).toList();
        List<List<int>> reports = [];
        lines.forEach((l) {
            reports.add(l.map((n) => int.parse(n)).toList());
        });

        var safeCount = 0;
        for (var i = 0; i < reports.length; i++) {
            final report = reports[i];
            var safe = isSafe(report);

            if (!safe) {
                for (var j = 0; j < report.length; j++) {
                    final subReport = report.sublist(0);
                    subReport.removeAt(j);
                    safe = safe || isSafe(subReport);
                    if (safe) {
                        break;
                    }
                }
            }

            if (safe)
                safeCount++;
        }
        print("safeCount: " + safeCount.toString());
    });
}