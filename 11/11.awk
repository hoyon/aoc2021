#!/usr/bin/awk -f

function print_octo() {
    print "==========="
    for (y=1;y<=dim;y++)  {
        line=""
        for (x=1;x<=dim;x++) {
            char=octo[x,y]
            if (is_flash(x, y)) {
                char="x"
            }
            line=line char
        }
        print line
    }
}

function is_new_flash(x, y) {
    if (octo[x, y] > 9 && flashed[x,y] != 1) {
        return 1
    } else {
        return 0
    }
}

function is_flash(x, y) {
    if (octo[x, y] > 9) {
        return 1
    } else {
        return 0
    }
}

function has_adjacent_flash(x, y) {
    sum=is_new_flash(x-1,y-1) + is_new_flash(x,y-1) + is_new_flash(x+1,y-1) + is_new_flash(x-1,y) + is_new_flash(x+1,y) + is_new_flash(x-1,y+1) + is_new_flash(x,y+1) + is_new_flash(x+1,y+1)

    if (sum > 0) {
        return 1
    } else {
        return 0
    }
}

function increment_adjacent(x, y) {
    octo[x-1,y-1]+=1
    octo[x,y-1]+=1
    octo[x+1,y-1]+=1
    octo[x-1,y]+=1
    octo[x+1,y]+=1
    octo[x-1,y+1]+=1
    octo[x,y+1]+=1
    octo[x+1,y+1]+=1
}

function step(step_count) {
    for (y=1;y<=dim;y++)  {
        for (x=1;x<=dim;x++) {
            octo[x,y]+=1
        }
    }

    delete flashed
    do {
        new_flashes=0
        for (y=1;y<=dim;y++)  {
            for (x=1;x<=dim;x++) {
                if (is_new_flash(x, y) == 1) {
                    flashed[x,y] = 1
                    flash_count+=1
                    increment_adjacent(x, y)
                    new_flashes=1
                }
            }
        }
    } while (new_flashes != 0)

    for (y=1;y<=dim;y++)  {
        for (x=1;x<=dim;x++) {
            if (is_flash(x, y) == 1) {
                octo[x, y] = 0
            }
        }
    }

    if (length(flashed) == dim * dim) {
        full_flash=step_count
    }
}

BEGIN {
    FS=""
    dim=10
    flash_count=0
}

{
    for (i=1;i<=dim;i++) {
        octo[i,NR]=$i
    }
}

END {
    for (i=1;full_flash==0;i++) {
        step(i)

        if (i == 100) {
            print "Part A:", flash_count
        }
    }
    print "Part B:", full_flash
}
