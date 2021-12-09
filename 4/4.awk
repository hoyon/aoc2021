#!/usr/bin/awk -f

function card_drawn(board, x, y) {
    idx = (x - 1) + ((y - 1) * 5) + 1
    for (i=1; i <= drawn; i++) {
        if (numbers[i] == boards[board][idx]) {
            return 1
        }
    }

    return 0
}

function calculate_score(board, d) {
    sum=0
    for (a=1; a <= 25; a++) {
        found=0
        for (b=1; b <= d; b++) {
            if (boards[board][a] == numbers[b]) {
                found=1
            }
        }

        if (found == 0) {
            sum+=boards[board][a]
        }
    }
    return sum * numbers[d]
}

{
    if (NR == 1) {
        split($0, numbers, ",")

        RS="\n\n"
    } else {
        for (i=1; i <= 25; i++) {
            boards[NR - 1][i] = $i
        }
    }
}

END {
    drawn = 0
    first_bingo=0
    last_bingo=0
    first_bingo_drawn=0
    last_bingo_drawn=0

    bingoed[1] = 0

    for (i=1; i <= length(numbers); i++) {
        drawn+=1

        for (j=1; j <= length(boards); j++) {

            # Skip already bingoed boards
            found=0
            for (z=1; z <= length(bingoed); z++) {
                if (bingoed[z] == j) {
                    found=1
                    break
                }
            }

            if (found == 1) {
                continue
            }

            # columns
            for (x=1; x <= 5; x++) {
                got=0
                for (y=1; y <= 5; y++) {
                    if (card_drawn(j, x, y) == 1) {
                        got+=1
                    }
                }
                if (got == 5) {
                    bingoed[length(bingoed) + 1] = j

                    if (first_bingo == 0) {
                        first_bingo=j
                        first_bingo_drawn=drawn
                    }
                    last_bingo=j
                    last_bingo_drawn=drawn
                }
            }

            # rows
            for (y=1; y <= 5; y++) {
                got=0
                for (x=1; x <= 5; x++) {
                    if (card_drawn(j, x, y) == 1) {
                        got+=1
                    }
                }
                if (got == 5) {
                    bingoed[length(bingoed) + 1] = j

                    if (first_bingo == 0) {
                        first_bingo=j
                        first_bingo_drawn=drawn
                    }
                    last_bingo=j
                    last_bingo_drawn=drawn
                }
            }
        }

    }
    print "Part A: ", calculate_score(first_bingo, first_bingo_drawn)
    print "Part B: ", calculate_score(last_bingo, last_bingo_drawn)
}
