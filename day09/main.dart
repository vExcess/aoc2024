// import 'dart:collection';
import 'dart:io';
// import 'dart:math' as Math;

bool fileFitsAt(List<int> drive, int idx, int sz) {
    for (var i = idx; i < idx + sz; i++) {
        if (drive[i] != -1)
            return false;
    }
    return true;
}

void moveFile(List<int> drive, int fromIdx, int toIdx, int fileSize) {
    for (var i = 0; i < fileSize; i++) {
        drive[toIdx + i] = drive[fromIdx + i];
        drive[fromIdx + i] = -1;
    }
}

int hashDrive(List<int> drive) {
    int val = 0;
    for (var i = 0; i < drive.length; i++) {
        if (drive[i] == -1)
            continue;
        val += drive[i] * i;
    }
    return val;
}

void main() {
    File("./input.txt").readAsString().then((String txt) {
        final startTime = DateTime.now().millisecondsSinceEpoch;
        
        // calc drive size
        List<int> table = txt.split('').map((s) => int.parse(s)).toList();
        int driveSize = 0;
        for (var i = 0; i < table.length; i++) {
            driveSize += table[i];
        }

        // init drive
        List<int> drive = List.filled(driveSize, 0);
        var drivePtr = 0;
        int id = 0;
        for (var i = 0; i < table.length; i++) {
            final segmentLength = table[i];
            final content;
            if (i % 2 == 0) {
                content = id;
                id++;
            } else {
                content = -1;
            }
            for (var j = 0; j < segmentLength; j++) {
                drive[drivePtr++] = content;
            }
        }

        // clone drive for part 2
        var drive2 = drive.sublist(0);

        // fragment drive
        for (var i = drive.length - 1; i > 0; i--) {
            for (var j = 0; j < i; j++) {
                if (drive[j] == -1) {
                    drive[j] = drive[i];
                    drive[i] = -1;
                    break;
                }
            }
        }

        print("part 1 drive hash: ${hashDrive(drive)}");

        // defragment drive
        drive = drive2;
        for (var i = drive.length - 1; i > 0; i--) {
            final oldI = i;
            while (i > 0 && drive[i-1] == drive[i]) {
                i--;
            }
            final fileSize = oldI - i + 1;

            for (var j = 0; j < i; j++) {
                if (fileFitsAt(drive, j, fileSize)) {
                    moveFile(drive, i, j, fileSize);
                    break;
                }
            }
        }

        print("part 2 drive hash: ${hashDrive(drive)}");
        
        final endTime = DateTime.now().millisecondsSinceEpoch;
        print("millis: ${endTime - startTime}");
    });
}
