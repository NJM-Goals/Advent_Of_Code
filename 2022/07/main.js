var fs = require('fs');
const { uptime } = require('process');

console.log("Advent of Code 2022 Day 7 - Copyright NJM-Goals")


// main run function
function run(input) {
    if (input != null) {
        const lines = input.split("\n");

        const is_command = (line) => line[0] === "$";
        const is_dir = (line) => line[0] === "d";
        const get_dir = (line) => line.slice().split(' ')[1]
        const is_file = (line) => !isNaN(parseInt(line[0]))
        const get_file = (line) => line.slice().split(' ')


        const is_cd = (line) => is_command(line) && line[2] === "c"
        const get_cd_dir = (line) => line.split(" ")[2];
        const is_ls = (line) => is_command(line) && line[2] === "l"


        let path = [];
        const tree = {};
        path.push("/")

        let line_count = 0


        const inspect_dir = (lines, dir_name, parent) => {
            // console.log("parent", parent)
            if (parent == null) {
                console.error("parent is null")
                return;
            }

            for (let idx = 0; idx < lines.length; idx++) {
                const l = lines[idx];

                ++line_count;

                console.log(`current dir: ${dir_name}\n` , parent)
                console.log("> ", l)

                if (is_cd(l) && l.slice().split(' ')[2] === "..") { 
                    console.log(' directory up ^^^^ 0')
                    path.pop()
                    return
                }



                if (is_dir(l)) {
                    const dir = get_dir(l)
                    console.log("dir", dir)
                    if (parent[dir] == null) {
                        parent[dir] = {}
                    }
                }
                else if (is_file(l)) {idx
                    const [size, file] = get_file(l)
                    parent[file] = size;
                }
                else if (is_cd(l)) {
                    const cd_dir = get_cd_dir(l)
                    console.log("cd_dir", cd_dir)
                    console.log("parent when cd", parent)
                    if (cd_dir === "..") { 
                        console.log(' directory up ^^^^')
                        return "cd_up"
                    }
                    else {
                        path.push(cd_dir)
                        inspect_dir(lines.slice(idx + 2), cd_dir, parent[cd_dir])
                        // return;
                    }
                }
            }
        }


        inspect_dir(lines.slice(2), "/", tree)
        console.log("tree", tree)


        const sum_of_sizes = -1;
        // console.log('all_folders', all_folders)  // Part 1

        console.log('sum_of_sizes', sum_of_sizes)  // Part 1
    }
}


let input_my;
try {
    input_my = fs.readFileSync('./07/puzzle_input.txt', 'utf-8');
} catch (e) {
    console.error("Could not read file", e.stack)
}

let input_example;
try {
    input_example = fs.readFileSync('./07/puzzle_input_example.txt', 'utf-8');
} catch (e) {
    console.error("Could not read file", e.stack)
}


// run(input_my);
run(input_example);