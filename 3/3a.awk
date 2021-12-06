#!/usr/bin/awk -f

BEGIN {
    FS=""
    bits=12
}

function bin2dec(bin) {
    split(bin, chars, "")

    dec=0
    for (i=bits; i > 0; i--) {
        dec+=2^(bits-i)*chars[i]
    }
    return dec
}

{
    for(i=1; i <= bits; i++) {
        if ($i == 0) {
            diff[i]-=1
        } else {
            diff[i]+=1
        }
    }
}

END {
    for(i=1; i <= bits; i++) {
        if (diff[i] > 1) {
            gamma=gamma "1"
        } else {
            gamma=gamma "0"
        }
    }

    for(i=1; i <= bits; i++) {
        if (diff[i] > 1) {
            epsilon=epsilon "0"
        } else {
            epsilon=epsilon "1"
        }
    }

    print bin2dec(gamma) * bin2dec(epsilon)
}
