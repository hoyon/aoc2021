#!/usr/bin/awk -f

function linear_cost(n) {
    return n * (n + 1) / 2
}

BEGIN {
    RS=","
}

{
    # constant cost
    for (i=0;i<$0;i++) {
        cost_a[i]+=$0-i
    }

    for (i=$0 + 1;i<2000;i++) {
        cost_a[i]+=i-$0
    }

    # linear cost
    for (i=0;i<$0;i++) {
        cost_b[i]+=linear_cost($0-i)
    }

    for (i=$0 + 1;i<2000;i++) {
        cost_b[i]+=linear_cost(i-$0)
    }
}


END {
    min_a=cost_a[0]
    for (i=0;i<2000;i++) {
        if (cost_a[i] < min_a) {
            min_a = cost_a[i] 
        }
    }
    print "Part A: ", min_a

    min_b=cost_b[0]
    for (i=0;i<2000;i++) {
        if (cost_b[i] < min_b) {
            min_b = cost_b[i] 
        }
    }
    print "Part B: ", min_b
}
