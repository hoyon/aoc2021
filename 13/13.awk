#!/usr/bin/awk -f

function add_fold(dir, ord) {
    fold=dir " " ord
    folds[length(folds)+1]=fold
}

function map(x, ord) {
    if (int(x) > int(ord)) {
        diff=x-ord
        return ord-diff
    } else {
        return x
    }
}

BEGIN {
    FS=","
    delete folds
}

/,/ {
    dots[1][$1][$2] = 1
}

/^$/ {
    FS=" |="
}

/fold along/ {
    add_fold($3, $4)
}

END {
    for (f=1;f<=length(folds);f++) {
        split(folds[f], parts, " ")
        dir=parts[1]
        fold=parts[2]
        for (i in dots[f]) {
            for (j in dots[f][i]) {
                if (dir == "x") {
                    dots[f+1][map(i, fold)][j]=1
                    last_x=fold
                } else if (dir == "y") {
                    dots[f+1][i][map(j, fold)]=1
                    last_y=fold
                }
            }
        }

        if (f==1) {
            count=0
            for (i in dots[f+1]) {
                for (j in dots[f+1][i]) {
                    count++
                }
            }
            print "Part A:", count
        }
    }

    print "Part B:"

    for (y=0;y<last_y;y++) {
        line=""
        for (x=0;x<last_x;x++) {
            if (typeof(dots[f][x][y]) == "unassigned") {
                line=line "."
            } else {
                line=line "x"
            }
        }
        print line
    }
}
