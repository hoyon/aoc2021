#!/usr/bin/awk -f

BEGIN {
    FS=",| -> "
}

{
    x1=$1
    y1=$2
    x2=$3
    y2=$4

    if (x1 == x2) {
        if (y1 < y2) {
            a=y1
            b=y2
        } else {
            a=y2
            b=y1
        }
        for (y=a;y<=b;y++) {
            grid_a[x1,y]+=1
            grid_b[x1,y]+=1
        }
    } else if (y1 == y2) {
        if (x1 < x2) {
            a=x1
            b=x2
        } else {
            a=x2
            b=x1
        }
        for (x=a;x<=b;x++) {
            grid_a[x,y1]+=1
            grid_b[x,y1]+=1
        }
    } else {
        if (x1 < x2) {
            xdir=1
        } else {
            xdir=-1
        }

        if (y1 < y2) {
            ydir=1
        } else {
            ydir=-1
        }

        x=x1
        y=y1
        while (x != x2) {
            grid_b[x,y]+=1 
            x+=xdir
            y+=ydir
        } 
        grid_b[x2,y2]+=1 
    }
}

END {
    sum_a=0
    sum_b=0
    for (x=1;x<1000;x++) {
        for (y=1;y<1000;y++) {
            if (grid_a[x,y] > 1) {
                sum_a+=1
            }
            if (grid_b[x,y] > 1) {
                sum_b+=1
            }
        }
    }
    print "Part A: ", sum_a
    print "Part B: ", sum_b
}
