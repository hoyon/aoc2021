#!/usr/bin/awk -f

BEGIN {
    FS=" | \\| "
    a=1 
    b=2 
    c=3 
    d=4 
    e=5 
    f=6 
    g=7 
}

function add_candidates(segment, signals) {
    candidates[segment][length(candidates[segment]) + 1] = signals
}

function print_state() {
    print ""
    print "=========================="
    for (i=1;i<=length(candidates);i++) {
        print "---- ", i
        if (isarray(candidates[i])) {
            for(j=1;j<=length(candidates[i]);j++) {
                print candidates[i][j]
            }
        } else {
            print candidates[i]        
        }
    }
}

function step() {
    found=0
    for (i=1;i<=length(candidates);i++) {
        if (!isarray(candidates[i])) {
            continue
        }

        delete counts
        for (j=1;j<=length(candidates[i]);j++) {
            split(candidates[i][j], chars, "")
            for(k=1;k<=length(chars);k++) {
                counts[chars[k]]+=1
            }
        }

        matches=0
        for (j in counts) {
            if (counts[j] == length(candidates[i])) {
                matches+=1
                m=j
            }
        }

        if (matches == 1) {
            found=m
            delete candidates[i]
            candidates[i] = m
            break
        }
    }

    if (found != 0) {
        for (i=1;i<=length(candidates);i++) {
            if (!isarray(candidates[i])) {
                continue
            }

            for (j=1;j<=length(candidates[i]);j++) {
                sub(found, "", candidates[i][j])
            }
        }
    } else {
        print "not found"
    }
}

function is_done() {
    done=1
    for (i=1;i<=length(candidates);i++) {
        if (isarray(candidates[i])) {
            done=0
        }
    }
    return done
}

function decode_segments(segments) {
    asort(segments)
    str=""
    for (s=1;s<=length(segments);s++) {
        str=str segments[s]
    }
    switch (str) {
        case "123567":
            return 0
        case "36":
            return 1
        case "13457":
            return 2
        case "13467":
            return 3
        case "2346":
            return 4
        case "12467":
            return 5
        case "124567":
            return 6
        case "136":
            return 7
        case "1234567":
            return 8
        case "123467":
            return 9
        default:
            print "oh no!"
            print str
            exit 1
    }
}

{
    delete candidates

    for (i=1;i<=10;i++) {
        signals=$i
        l=length(signals)

        switch (l) {
        case 2:
            add_candidates(c, signals)
            add_candidates(f, signals)
            break
        case 3:
            add_candidates(a, signals)
            add_candidates(c, signals)
            add_candidates(f, signals)
            break;
        case 4:
            add_candidates(b, signals)
            add_candidates(c, signals)
            add_candidates(d, signals)
            add_candidates(f, signals)
            break;
        case 5:
            add_candidates(a, signals)
            add_candidates(d, signals)
            add_candidates(g, signals)

            add_candidates(a, "abcdefg")
            add_candidates(b, "abcdefg")
            add_candidates(c, "abcdefg")
            add_candidates(d, "abcdefg")
            add_candidates(e, "abcdefg")
            add_candidates(f, "abcdefg")
            add_candidates(g, "abcdefg")
            break;
        case 6:
            add_candidates(a, signals)
            add_candidates(b, signals)
            add_candidates(f, signals)
            add_candidates(g, signals)

            add_candidates(a, "abcdefg")
            add_candidates(b, "abcdefg")
            add_candidates(c, "abcdefg")
            add_candidates(d, "abcdefg")
            add_candidates(e, "abcdefg")
            add_candidates(f, "abcdefg")
            add_candidates(g, "abcdefg")
            break;
        case 7:
            add_candidates(a, "abcdefg")
            add_candidates(b, "abcdefg")
            add_candidates(c, "abcdefg")
            add_candidates(d, "abcdefg")
            add_candidates(e, "abcdefg")
            add_candidates(f, "abcdefg")
            add_candidates(g, "abcdefg")
            break;
        }
    } 

    while (is_done() == 0) {
        step()
    }

    value=""
    for (i=11;i<=14;i++) {
        split($i, chars, "")

        delete segments
        for (j=1;j<=length(chars);j++) {
            for (k=1;k<=length(candidates);k++) {
                if (chars[j] == candidates[k]) {
                    segments[length(segments) + 1] = k
                }
            }
        }
        digit=decode_segments(segments)
        value=value digit
    }
    sum+=value
}

END {
    print sum
}
