var fs = require('fs')

console.log("Advent of Code 2022 Day 1 - Copyright NJM-Goals")

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

            const alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

            const prio = alphabet.indexOf(dup_item) + 1;
            console.log(prio);
            prio_sum += prio;

        });

        console.log('prio_sum', prio_sum);
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



// Part 1
// wrong: 7437
// right: 8349

// Part 2