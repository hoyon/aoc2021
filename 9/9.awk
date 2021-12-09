#!/usr/bin/awk -f

BEGIN {
    FS=""
}

function maybe_add_adjacent(x, y, adjacent) {
    if (typeof(heights[x, y]) != "unassigned") {
        adjacent[length(adjacent) + 1] = heights[x, y]
    }
}

function adjacent_heights(x, y, adjacent) {
    maybe_add_adjacent(x-1, y, adjacent)
    maybe_add_adjacent(x+1, y, adjacent)
    maybe_add_adjacent(x, y-1, adjacent)
    maybe_add_adjacent(x, y+1, adjacent)
}

function add_to_queue_helper(x, y) {
    if (typeof(heights[x,y]) != "unassigned" && heights[x,y] != 9 && basin[x,y] != 1) {
        idx=length(queue)+1
        queue[idx]["x"]=x
        queue[idx]["y"]=y
    }
}

function queue_adjacent(x, y) {
    add_to_queue_helper(x-1,y)
    add_to_queue_helper(x+1,y)
    add_to_queue_helper(x,y-1)
    add_to_queue_helper(x,y+1)
}

{
    for (i=1;i<=NF;i++) {
        heights[i,NR]=$i
    }
    width=NF
    height=NR
}

END {
    delete low_points
    delete sizes

    for (i=1;i<=width;i++) {
        for (j=1;j<=height;j++) {
            delete adjacent
            adjacent_heights(i, j, adjacent)

            is_low_point=1
            for (k=1;k<=length(adjacent);k++) {
                if (adjacent[k] <= heights[i,j]) {
                    is_low_point=0
                }
            }

            if (is_low_point == 1) {
                idx=length(low_points) + 1
                low_points[idx]["x"] = i
                low_points[idx]["y"] = j

                sum+=heights[i,j] + 1
            }
        }
    } 

    print "Part A: ", sum

    for (i=1;i<=length(low_points);i++) {
        delete basin
        delete low_point
        delete queue

        low_point["x"]=low_points[i]["x"]
        low_point["y"]=low_points[i]["y"]

        basin[low_point["x"],low_point["y"]]=1

        queue_adjacent(low_point["x"], low_point["y"])
        ptr=1
        while (ptr <= length(queue)) {
            x=queue[ptr]["x"]
            y=queue[ptr]["y"]
            basin[x,y]=1

            queue_adjacent(x, y)

            ptr++
        }
        sizes[length(sizes) + 1]=length(basin)
    }
    asort(sizes)

    l=length(sizes)
    print "Part B: ", sizes[l] * sizes[l-1] * sizes[l-2]
}
