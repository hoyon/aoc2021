#!/usr/bin/awk -f

function bin2dec(bin) {
    split(bin, chars, "")

    dec=0
    for (i=12; i > 0; i--) {
        dec+=2^(12-i)*chars[i]
    }
    return dec
}

function bit_diff(file, bit) {
    prev=bit-1
    diff=0
    for (i = 1; i <= length(file[prev]); i++) {
        line=file[prev][i]
        split(line, chars, "")

        if (chars[bit] == 1) {
            diff+=1
        } else {
            diff-=1
        }
    }

    return diff

}

function filter_wanted_bit(file, bit, wanted) {
    prev=bit-1
    for (i = 1; i <= length(file[prev]); i++) {
        line=file[prev][i]
        split(line, chars, "")

        if (chars[bit] == wanted) {
            file[bit][length(file[bit]) + 1] = line
        }
    }
}

{
    o2_input[0][NR]=$0
    co2_input[0][NR]=$0
}

END {
    done=0
    bit=1
    while (done == 0) {
        diff = bit_diff(o2_input, bit)

        if (diff >= 0) {
            most=1
        } else {
            most=0
        }

        filter_wanted_bit(o2_input, bit, most)

        if (length(o2_input[bit]) > 1) {
            bit+=1
        } else  {
            o2=o2_input[bit][1]
            done=1
        }
    }

    done=0
    bit=1
    while (done == 0) {
        diff = bit_diff(co2_input, bit)

        if (diff >= 0) {
            least=0
        } else {
            least=1
        }

        filter_wanted_bit(co2_input, bit, least)

        if (length(co2_input[bit]) > 1) {
            bit+=1
        } else  {
            co2=co2_input[bit][1]
            done=1
        }
    }

    print bin2dec(o2) * bin2dec(co2)
}
