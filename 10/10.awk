#!/usr/bin/awk -f

function is_opening(c) {
    switch (c) {
        case "[":
        case "(":
        case "{":
        case "<":
            return 1
        default:
            return 0
    }
}

function is_closing(c) {
    switch (c) {
        case "]":
        case ")":
        case "}":
        case ">":
            return 1
        default:
            return 0
    }
}

function opening(c) {
    switch (c) {
        case "]":
            return "["
        case ")":
            return "("
        case "}":
            return "{"
        case ">":
            return "<"
    }
}

function corrupt_score(c) {
    switch (c) {
        case ")":
            return 3
        case "]":
            return 57
        case "}":
            return 1197
        case ">":
            return 25137
    }
}

function incomplete_score(c) {
    switch (c) {
        case "(":
            return 1
        case "[":
            return 2
        case "{":
            return 3
        case "<":
            return 4
    }
}

BEGIN {
    FS=""
    delete incomplete_scores
}

{
    delete stack
    top=0
    corrupted=0
    for (i=1;i<=NF;i++) {
        if (is_opening($i) == 1) {
            top+=1
            stack[top]=$i
        } else if (is_closing($i) == 1) {
            if (stack[top] == opening($i)) {
                top-=1
            } else {
                corrupted_sum+=corrupt_score($i)
                corrupted=1
                break
            }
        }
    }

    if (corrupted==0) {
        s=0
        for (i=top;i>=1;i--) {
            s*=5
            s+=incomplete_score(stack[i])
        }
        incomplete_scores[length(incomplete_scores) + 1]=s
    }
}

END {
    asort(incomplete_scores)
    middle=int(length(incomplete_scores) / 2) + 1

    print "Part A: ", corrupted_sum
    print "Part B: ", incomplete_scores[middle]
}
