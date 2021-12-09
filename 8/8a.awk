#!/usr/bin/awk -f

BEGIN {
    FS=" | \\| "
    sum=0
}

{
    for (i=11;i<=14;i++) {
        l=length($i)
        if (l==2 || l==4 || l==3 || l==7) {
            sum+=1
        }
    }
}

END {
    print sum
}
