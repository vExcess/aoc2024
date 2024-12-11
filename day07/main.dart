import 'dart:io';
import 'dart:math' as Math;

const Map<String, String> operatorMap = {
    "+": '0',
    "*": '1',
    "||": '2'
};

bool isPossible(int targetSum, List<int> parameters, String operators) {
    var total = parameters[0];
    for (var i = 1; i < parameters.length; i++) {
        final operation = operators[i - 1];
        if (operation == operatorMap['+']) {
            total += parameters[i];
        } else if (operation == operatorMap['*']) {
            total = total * parameters[i];
        } else /*if (operation == operatorMap['||'])*/ {
            total = int.parse(total.toString() + parameters[i].toString());
        }
        if (total > targetSum) {
            return false;
        }
    }
    return total == targetSum;
}

int numDigits(int base, int num) {
    if (num == 0)
        return 1;
    else
        return 1 + (Math.log(num) / Math.log(base)).toInt();
}

void main() {
    File("./input.txt").readAsString().then((String txt) {
        final startTime = DateTime.now().millisecondsSinceEpoch;
        List<List<int>> lines = txt.split("\n").map((r) => r.split(" ").map((l) => int.parse(l.replaceFirst(':', ''))).toList()).toList();

        var maxParamLen = 0;
        for (var i = 0; i < lines.length; i++) {
            final parameters = lines[i].sublist(1);
            if (parameters.length > maxParamLen) {
                maxParamLen = parameters.length;
            }
        }

        List<String> radixCache = List.filled(262144, "");
        var i = 0;
        while (true) {
            final operators = i.toRadixString(operatorMap.length).padLeft(maxParamLen, '0').split('').reversed.toList().join('');
            if (i < radixCache.length) {
                radixCache[i] = operators;
            } else {
                radixCache.add(operators);
            }
            
            if (numDigits(operatorMap.length, i) > maxParamLen - 1) {
                break;
            }
            i++;
        }

        var sum = 0;
        for (var i = 0; i < lines.length; i++) {
            final line = lines[i];
            final targetSum = line[0];
            final parameters = line.sublist(1);
            final numRequiredOperators = parameters.length - 1;

            var j = 0;
            while (true) {
                final numUsedOperators = numDigits(operatorMap.length, j);
                if (numUsedOperators > numRequiredOperators) {
                    break;
                }

                if (isPossible(targetSum, parameters, radixCache[j])) {
                    sum += targetSum;
                    break;
                }
                j++;
            }
        }

        print("sum: $sum");
        final endTime = DateTime.now().millisecondsSinceEpoch;
        print("millis: ${endTime - startTime}");
    });
}
