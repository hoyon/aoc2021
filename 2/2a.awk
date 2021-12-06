#!/usr/bin/awk -f

BEGIN{
    horizontal=0
    depth=0
}

/forward/ {
    horizontal+=$2
}

/down/ {
    depth+=$2
}

/up/ {
    depth-=$2
}

END{
    print horizontal * depth;
}
