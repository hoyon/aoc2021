#!/usr/bin/awk -f

BEGIN{
    a=0
}

{
    if (NR > 1) {
        if ($0 > prev) {
            a+=1
        }
    }
    prev=$0
}

END{
    print "Part A:", a
}

BEGIN{
    b=0
}

{
    if (NR > 3) {
        if (window[3] + window[2] + window[1] < window[2] + window[1] + $0) {
            b+=1
        }
    }
    window[3]=window[2]
    window[2]=window[1]
    window[1]=$0
}

END{
    print "Part B:", b
}
