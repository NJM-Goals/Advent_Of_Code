var fs = require('fs')

console.log("Advent of Code 2022 Day 4 - Copyright NJM-Goals")


// main run function
function run(input) {
    if (input != null) {
        const lines = input.split("\n");

        let contained_count = 0
        let overlap_count = 0
        lines.forEach(pair => {

            let elve_pair = []
            pair.split(',').forEach((elf, idx) => {
                const ids = elf.split('-')
                elve_pair[idx] = [parseInt(ids[0]), parseInt(ids[1])]
            })

            console.log('elve_pair', elve_pair) 

            const is_contained_0 = elve_pair[0][0] <= elve_pair[1][0] && elve_pair[0][1] >= elve_pair[1][1]
            const is_contained_1 = elve_pair[1][0] <= elve_pair[0][0] && elve_pair[1][1] >= elve_pair[0][1]

            const is_contained = is_contained_0 || is_contained_1

            // console.log('is_contained', is_contained)

            if (is_contained) {
                contained_count++
            }


            // Part 2
            const n0 = elve_pair[0][0];
            const n1 = elve_pair[0][1];
            const n2 = elve_pair[1][0];
            const n3 = elve_pair[1][1];
            
            const is_overlap_0 = n0 >= n2 && n0 <= n3
            const is_overlap_1 = n1 >= n2 && n1 <= n3

            const is_overlap_2 = n2 >= n0 && n2 <= n1
            const is_overlap_3 = n3 >= n0 && n3 <= n1
            
            const is_overlap = is_overlap_0 || is_overlap_1 || is_overlap_2 || is_overlap_3

            console.log('is_overlap', is_overlap)

            if (is_overlap) {
                overlap_count++
            }

        })

        console.log('contained_count', contained_count)  // Part 1
        console.log('overlap_count', overlap_count)  // Part 2

    }
}


let input_my;
try {
    input_my = fs.readFileSync('./puzzle_input_04.txt', 'utf-8');
} catch (e) {
    console.error("Could not read file", e.stack)
}

let input_example;
try {
    input_example = fs.readFileSync('./puzzle_input_04_example.txt', 'utf-8');
} catch (e) {
    console.error("Could not read file", e.stack)
}


run(input_my);
run(input_example);


// Part 2
// wrong: too low: 739, 727