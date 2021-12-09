#!/usr/bin/awk -f

function calculate(cycle, days) {
    for (day=1;day<=days;day++) {
        born = cycle[0]
        for (i=0;i<=7;i++) {
            cycle[i]=cycle[i+1]
        }
        cycle[8]=born
        cycle[6]+=born
    }

    sum=0
    for (i=0;i<=8;i++) {
        sum+=cycle[i]
    }

    return sum
}

BEGIN {
    RS=","
    for (i=0;i<=8;i++) {
        cycle[i]=0
    }
}

{
    cycle_a[$1]+=1
    cycle_b[$1]+=1
}

END {
    print "Part A: ", calculate(cycle_a, 80)
    print "Part B: ", calculate(cycle_b, 256)
}
