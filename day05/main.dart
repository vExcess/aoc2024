import 'dart:collection';
import 'dart:io';

bool inRightOrder(List<int> update, List<int> sortMapList) {
    var arr = update.sublist(0);
    for (var i = 0; i < arr.length; i++) {
        arr[i] = sortMapList[arr[i]];
    }
    for (var i = 0; i < arr.length - 1; i++) {
        if (arr[i] > arr[i + 1]) {
            return false;
        }
    }
    return true;
}

List<int> generateSortMapList(List<List<int>> rules) {
    var sortList = [];
    for (var i = 0; i < rules.length; i++) {
        final [ra, rb] = rules[i];
        final idxA = sortList.indexOf(ra);
        final idxB = sortList.indexOf(rb);
        final hasA = idxA != -1;
        final hasB = idxB != -1;
        if (!hasA && !hasB) {
            sortList.add(ra);
            sortList.add(rb);
        } else if (!hasA && hasB) {
            sortList.insert(idxB, ra);
        } else if (hasA && !hasB) {
            sortList.insert(idxA + 1, rb);
        } else {
            if (idxA > idxB) {
                sortList.removeAt(idxA);
                sortList.insert(sortList.indexOf(rb), ra);
                i = -1;
            }
        }
    }

    var sortMapList = List.filled(100, 0);
    for (var i = 0; i < sortList.length; i++) {
        sortMapList[sortList[i]] = i;
    }

    return sortMapList;
}

int hash(List<int> arr) {
    int h = 7;
    for (int i = 0; i < arr.length; i++) {
        h = h*31 + arr[i];
    }
    return h;
}

Map<int, List<int>> sortMapListCache = HashMap();

int getSumOfOrdered(List<List<int>> rules, List<List<int>> updates) {
    var sum = 0;
    for (var i = 0; i < updates.length; i++) {
        final update = updates[i];
        final subRules = rules.where((r) => update.contains(r[0]) && update.contains(r[1])).toList();
        final updateHash = hash(update);
        var sortMapList;
        if (sortMapListCache[updateHash] == null) {
            sortMapList = generateSortMapList(subRules);
            sortMapListCache[updateHash] = sortMapList;
        } else {
            sortMapList = sortMapListCache[updateHash];
        }
        if (inRightOrder(update, sortMapList)) {
            final midPoint = update[update.length ~/ 2];
            sum += midPoint;
        }
    }
    return sum;
}

int getSumOfDisordered(List<List<int>> rules, List<List<int>> updates) {
    var sum = 0;
    for (var i = 0; i < updates.length; i++) {
        final update = updates[i];
        final subRules = rules.where((r) => update.contains(r[0]) && update.contains(r[1])).toList();
        final updateHash = hash(update);
        var sortMapList;
        if (sortMapListCache[updateHash] == null) {
            sortMapList = generateSortMapList(subRules);
            sortMapListCache[updateHash] = sortMapList;
        } else {
            sortMapList = sortMapListCache[updateHash];
        }
        if (!inRightOrder(update, sortMapList)) {
            update.sort((a, b) => sortMapList[a] - sortMapList[b]);
            final midPoint = update[update.length ~/ 2];
            sum += midPoint;
        }
    }
    return sum;
}

void main() {
    File("./input.txt").readAsString().then((String txt) {
        final temp = txt.split("\n\n");
        final rules = temp[0].split("\n").map((l) => l.split("|").map((s) => int.parse(s)).toList()).toList();
        final updates = temp[1].split("\n").map((l) => l.split(",").map((s) => int.parse(s)).toList()).toList();

        print("ordered sum: ${getSumOfOrdered(rules, updates)}");
        print("disordered sum: ${getSumOfDisordered(rules, updates)}");
    });
}