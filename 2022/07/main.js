var fs = require('fs')

console.log("Advent of Code 2022 Day 7 - Copyright NJM-Goals")


// main run function
function run(input) {
    if (input != null) {
        const lines = input.split("\n");

        const is_command = (line) => line[0] === "$";
        const is_dir

        const chars = lines[0].split('');

        let a = -3;
        let b = -2;
        let c = -1;

        let first_marker = -1;
        for (let i = 3; i < chars.length; i++) {
            const c0 = chars[i + a]
            const c1 = chars[i + b]
            const c2 = chars[i + c]
            const c3 = chars[i]
            if (
                c0 !== c1 && c0 !== c2 && c0 !== c3 &&
                c1 !== c2 && c1 !== c3 &&
                c2 !== c3
            ) {
                first_marker = i + 1;
                break;
            }
        }


        // Part 2
        let start_of_msg = -1;
        const distinct_chars = 14
        for (let i = 0; i < chars.length; i++) {

            let all_distinct = true;

            // compare all current 14 characters
            for (let m = 0; m < distinct_chars; m++) {
                for (let n = m + 1; n < distinct_chars; n++) {
                    const char0 = chars[i + m];
                    const char1 = chars[i + n];

                    // console.log("comparing", char0, char1, "loop idx", m, n)
                    if (char0 === char1) {
                        all_distinct = false
                        break;
                    }
                }

                if (!all_distinct) {
                    break;
                }
            }

            if (all_distinct) {
                start_of_msg = i + distinct_chars
                break;
            }
        }


        console.log('first_marker', first_marker)  // Part 1, right: 1282
        console.log('start_of_msg', start_of_msg)  // Part 2, right: 
    }
}


let input_my;
try {
    input_my = fs.readFileSync('./puzzle_input.txt', 'utf-8');
} catch (e) {
    console.error("Could not read file", e.stack)
}

let input_example;
try {
    input_example = fs.readFileSync('./puzzle_input_example.txt', 'utf-8');
} catch (e) {
    console.error("Could not read file", e.stack)
}


run(input_my);
run(input_example);


// Part 2
// wrong: too low: 739, 727