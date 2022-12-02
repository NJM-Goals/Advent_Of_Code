var fs = require('fs')

console.log("Advent of Code 2022 Day 1 - Copyright NJM-Goals")



let input;
try {
    input = fs.readFileSync('./puzzle_input_02.txt', 'utf-8');
} catch (e) {
    console.error("Could not read file", e.stack)
}

if (input != null) {
    const lines = input.split("\n")

    // Part 1 table
    const win_table = {
        "AX": 3,  // Rock, Rock
        "AY": 6,  // Rock, Paper
        "AZ": 0,  // Rock, Scissor
        "BX": 0,  // Paper, Rock
        "BY": 3,  // Paper, Paper
        "BZ": 6,  // Paper, Scissor
        "CX": 6,  // Scissor, Rock
        "CY": 0,  // Scissor, Paper
        "CZ": 3   // Scissor, Scissor
    }

    // Part 2 table
    // X == lose
    // Y == draw
    // Z == win
    const score_table = {
        "AX": 0 + 3,  // Rock, lose =>  Scissor
        "AY": 3 + 1,  // Rock, draw =>  Rock
        "AZ": 6 + 2,  // Rock, win =>   Paper
        "BX": 0 + 1,  // Paper, lose => Rock
        "BY": 3 + 2,  // Paper, draw => Paper
        "BZ": 6 + 3,  // Paper, win =>  Scissor
        "CX": 0 + 2,  // Scissor, lose => Paper
        "CY": 3 + 3,  // Scissor, draw => Scissor
        "CZ": 6 + 1   // Scissor, win =>  Rock
    }


    let total_score_part1 = 0;
    let total_score_part2 = 0;
    lines.forEach(line => {
        const [his, mine] = line.split(" ");
        
        const my_item_score = mine === 'X' ? 1 : (mine === 'Y' ? 2 : 3)

        const score = win_table[his + mine];

        const round_score = my_item_score + score;

        total_score_part1 += round_score

        total_score_part2 += score_table[his + mine]
    })

    console.log("total score part 1: ", total_score_part1)
    console.log("total score part 2: ", total_score_part2)
}

