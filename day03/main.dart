import 'dart:io';

bool isInt(String intStr) {
    for (var i = 0; i < intStr.length; i++) {
        final cc = intStr.codeUnitAt(i);
        if (cc < 48 || cc > 57) {
            return false;
        }
    }
    return true;
}

bool strEq(String origString, int offset, String subString) {
    for (var i = 0; i < subString.length; i++) {
        if (i >= origString.length) {
            return false;
        }
        if (origString[offset + i] != subString[i]) {
            return false;
        }
    }
    return true;
}

void main() {
    File("./input.txt").readAsString().then((String txt) {
        final MULSTR = "mul(";
        final DOSTR = "do()";
        final DONTSTR = "don't()";

        var sum = 0;
        var enabled = true;
        var i = 0;
        while (i < txt.length) {
            if (strEq(txt, i, MULSTR)) {
                i += MULSTR.length;
                final origI = i;
                //  stop at instruction end or start of new instruction
                while (txt[i] != ')' && txt[i] != 'm' && txt[i] != 'd') {
                    i++;
                }
                final contents = txt.substring(origI, i).split(",");
                if (txt[i] == ')' && contents.length == 2 && isInt(contents[0]) && isInt(contents[1])) {
                    if (enabled) {
                        final a = int.parse(contents[0]);
                        final b = int.parse(contents[1]);
                        sum += a * b;
                    }
                }
            } else if (strEq(txt, i, DOSTR)) {
                enabled = true;
                i += DOSTR.length;
            } else if (strEq(txt, i, DONTSTR)) {
                enabled = false;
                i += DONTSTR.length;
            } else {
                i++;
            }
        }
        print("sum: " + sum.toString());
    });
}