var fs = require('fs')

console.log("Advent of Code 2022 Day 1 - Copyright NJM-Goals")


/** Part 2 - method 1 */
const with_sorting = elves => {
    // puzzle part 2 - with sorting
    sorted_elves = elves.sort((a, b) => { return a - b; })

    console.log("sorted elves vvv")
    sorted_elves.forEach(calory => console.log(calory))
    console.log("sorted elves ^^^")

    console.log("1 ", elves[elves.length - 1])
    console.log("2 ", elves[elves.length - 2])
    console.log("3 ", elves[elves.length - 3])

    const total1 = elves[elves.length - 1] + elves[elves.length - 2] + elves[elves.length - 3]
    console.log("total ", total1)
}


/** Part 2 - method 2 */
const without_sorting = elves => {
    // puzzle part 2 - with direct find
    let max = 0
    let second = 0
    let third = 0
    let elve_idx_max = 0;
    let elve_idx_second = 0;
    let elve_idx_third = 0;
    elves.forEach((elve_calories, idx) => {
        const old_max = max

        if (elve_calories > max) {
            // third = second
            // second = max
            max = elve_calories

            // elve_idx_third = elve_idx_second
            // elve_idx_second = elve_idx_max
            elve_idx_max = idx;
        }

        if (elve_calories > second && elve_calories < max) {
            second = elve_calories
        }

        if (elve_calories > third && elve_calories < second) {
            third = second
        }
    })


    console.log(`Amount elves ${elves.length}`)
    console.log(`Elve ${elve_idx_max} carries the most calories ${max}`)
    console.log(`Three top elves together carry ${max + second + third} calories`)

    console.log()
    console.log(`idx \tcalories`)
    console.log(`${elve_idx_max}\t${max}`)
    console.log(`${elve_idx_second}\t${second}`)
    console.log(`${elve_idx_third}\t${third}`)

    console.log()
    const total = max + second + third
    console.log(`Total\t${total}`)
}


let input;
try {
    input = fs.readFileSync('./puzzle_input_01.txt', 'utf-8');
} catch (e) {
    console.error("Could not read file", e.stack)
}

if (input != null) {
    console.log(typeof input);
    const lines = input.split("\n")
    console.log(lines)
    const elve_0_cal_0 = lines[0]
    console.log("elve_0_cal_0", parseInt(elve_0_cal_0))

    let elves = [];

    let current_elf_calories = 0
    lines.forEach((calory) => {
        if (calory == null || calory.length == 0) {
            elves.push(current_elf_calories)
            current_elf_calories = 0
        }
        else {
            current_elf_calories += parseInt(calory)
        }
    })

    with_sorting(elves.slice())

    without_sorting(elves.slice())
}


// My correct result:
// 1  69289
// 2  68321
// 3  68005
// total  205615


