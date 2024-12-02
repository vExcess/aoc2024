import 'dart:io';

int abs(int n) {
    return n < 0 ? -n : n;
}

int numberOfIn(int n, List<int> arr) {
    int count = 0;
    for (var i = 0; i < arr.length; i++) {
        if (arr[i] == n)
            count++;
    }
    return count;
}

void main() {
    File("./input.txt").readAsString().then((String txt) {
        List<List<String>> lines = txt.split("\n")
            .map((ln) => ln.split("   ")).toList();
        List<int> list1 = [];
        List<int> list2 = [];
        lines.forEach((l) {
            list1.add(int.parse(l[0]));
            list2.add(int.parse(l[1]));
        });
        list1.sort();
        list2.sort();

        var sumDiff = 0;
        var similarity = 0;
        for (var i = 0; i < list1.length; i++) {
            sumDiff += abs(list1[i] - list2[i]);
            similarity += list1[i] * numberOfIn(list1[i], list2);
        }
        print("diff: " + sumDiff.toString());
        print("sim: " + similarity.toString());
    });
}