using _11;

var filename = args[0];
var lines = (new Core.FileHandler(filename)).ReadLines();

Puzzle11_ObjectOriented.Start(lines, nrOctopuses: 100, steps: 100);

Puzzle11_ObjectOriented.Start(lines, nrOctopuses: 100, steps: -1);