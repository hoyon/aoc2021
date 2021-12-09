#!/usr/bin/awk -f

function calculate(ages, days) {
    for (day=1;day<=days;day++) {
        born = ages[0]
        for (i=0;i<=7;i++) {
            ages[i]=ages[i+1]
        }
        ages[8]=born
        ages[6]+=born
    }

    sum=0
    for (i=0;i<=8;i++) {
        sum+=ages[i]
    }

    return sum
}

BEGIN {
    RS=","
    for (i=0;i<=8;i++) {
        ages[i]=0
    }
}

{
    ages_a[$1]+=1
    ages_b[$1]+=1
}

END {
    print "Part A: ", calculate(ages_a, 80)
    print "Part B: ", calculate(ages_b, 256)
}
