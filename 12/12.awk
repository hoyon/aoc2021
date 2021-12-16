#!/usr/bin/awk -f

function add_conn(a, b) {
    conn[a][length(conn[a]) + 1] = b
}

function paths(from) {
    idx=1
    delete res[tried_ptr]
    if (isarray(conn[from])) {
        for (n in conn[from]) {
            res[tried_ptr][idx++]=conn[from][n]
        }
    }

}

function push_step(step) {
    stack[stack_ptr++]=step
    tried_ptr++
}

function pop_step() {
    stack_ptr--
    tried_ptr--
}

function can_visit(cave) {
    if (cave ~ /[a-z]/) {
        found=0
        for(a=1;a<stack_ptr;a++) {
            if (stack[a] == cave) {
                found++
            }
        }
        if ((cave == "start" || cave == "end") && found > 0) {
            return 0
        } else if (found == 0) {
            return 1
        } else if (dupe_allowed == 0) {
            return 0
        } else {
            delete counts
            has_dupe=0
            for (x=1;x<stack_ptr;x++) {
                if (stack[x] ~ /[a-z]/) {
                    counts[stack[x]]+=1
                    if (counts[stack[x]] > 1) {
                        has_dupe=1
                    }
                }
            }

            if (has_dupe == 1) {
                return 0
            } else {
                return 1
            }
        }
    }

    return 1
}

function solve(current) {
    paths(current)

    if (length(res[tried_ptr]) == 0) {
        pop_step()
        return
    }

    if (current == "end") {
        # line=""
        # for (a=1;a<stack_ptr;a++) {
        #     line=line "," stack[a]
        # }
        # print line

        path_count++
        pop_step()
        return
    }

    while (length(res[tried_ptr]) > 0) {
        for (k in res[tried_ptr]) {
            s=res[tried_ptr][k]
            delete res[tried_ptr][k]
            if (can_visit(s) == 1) {
                push_step(s)
                solve(s)
                break
            }
        }
    }

    pop_step()
}

BEGIN {
    FS="-"
}

{
    add_conn($1, $2)
    add_conn($2, $1)
}

END {
    stack_ptr=1
    tried_ptr=1
    path_count=0
    dupe_allowed=0
    push_step("start")
    solve("start")
    part_a=path_count
    print "Part A:", part_a

    stack_ptr=1
    tried_ptr=1
    path_count=0
    dupe_allowed=1
    push_step("start")
    solve("start")

    print "Part B:", path_count
}
