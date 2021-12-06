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
        if (prev_3 + prev_2 + prev_1 < prev_2 + prev_1 + $0) {
            b+=1
        }
    }
    prev_3=prev_2
    prev_2=prev_1
    prev_1=$0
}

END{
    print "Part B:", b
}
