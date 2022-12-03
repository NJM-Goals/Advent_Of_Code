var fs = require('fs')

console.log("Advent of Code 2022 Day 3 - Copyright NJM-Goals")

const alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

// for Part 2
function analyze_group(line0, line1, line2) {
    console.log('analyze_group', line0, line1, line2)
    const arr0 = line0.split('')
    const arr1 = line1.split('')
    const arr2 = line2.split('')

    const dup_items = []
    arr0.forEach(item0 => {
        if (arr1.includes(item0)) {
            dup_items.push(item0)
        }
    })
    console.log('dup_items', dup_items)

    let triple_item;
    dup_items.forEach(dup_item0 => {
        if (arr2.includes(dup_item0)) {
            triple_item = dup_item0
        }
    })

    console.log(triple_item)

    return calc_prio(triple_item)
}


// main run function
function run(input) {
    if (input != null) {
        const lines = input.split("\n");

        const compartments = [];
        lines.forEach(rucksack => {
            const comp = [];
            const comp0 = rucksack.substring(0, (rucksack.length / 2));
            const comp1 = rucksack.substring((rucksack.length / 2), rucksack.length);

            if (comp0.length !== comp1.length) {
                console.error("Different compartment length.");
            }

            comp.push(comp0, comp1);
            compartments.push(comp);
        });
        // console.log('compartments: ', compartments)

        let prio_sum = 0;
        compartments.forEach((comps) => {
            const comp0 = comps[0].split('');
            const comp1 = comps[1].split('');
            console.log(comp0, comp1);

            const dup_item = comp0.find(item0 => comp1.includes(item0));
            console.log('dup_item', dup_item);

            const prio = calc_prio(dup_item);
            console.log(prio);
            prio_sum += prio;

        });

        console.log('prio_sum', prio_sum);


        // Part 2
        let i0 = 0
        let i1 = 1
        let i2 = 2

        let sum_groups = 0
        while (i2 < lines.length) {

            const sum_group = analyze_group(lines[i0], lines[i1], lines[i2])
            sum_groups += sum_group

            i0 += 3
            i1 += 3
            i2 += 3
        }

        console.log('sum_groups', sum_groups)

    }
}


let input_my;
try {
    input_my = fs.readFileSync('./puzzle_input_03.txt', 'utf-8');
} catch (e) {
    console.error("Could not read file", e.stack)
}

let input_example;
try {
    input_example = fs.readFileSync('./puzzle_input_03_example.txt', 'utf-8');
} catch (e) {
    console.error("Could not read file", e.stack)
}

run(input_my);
// run(input_example);



function calc_prio(dup_item) {
    return alphabet.indexOf(dup_item) + 1;
}


// Part 1
// wrong: 7437
// right: 8349

// Part 2