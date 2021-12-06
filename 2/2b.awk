#!/usr/bin/awk -f

BEGIN{
    horizontal=0
    depth=0
    aim=0
}

/forward/ {
    horizontal+=$2
    depth+=aim * $2
}

/down/ {
    aim+=$2
}

/up/ {
    aim-=$2
}

END{
    print horizontal * depth;
}
