var filename = args[0];
var lines = (new Core.FileHandler(filename)).ReadLines();

// split the dive-direction from corresponding steps (dive-length)
// e.g. "forward 9"
var commands = new List<KeyValuePair<string, int>>();
foreach(var line in lines)
{
    var splits = line.Split(' ');
    var command = splits[0];
    var steps = int.Parse(splits[1]);

    commands.Add(new KeyValuePair<string, int>(command, steps));
}

// calc diving position resulting from chain of commands
int x = 0, y = 0, xWithAim = 0, yWithAim = 0;  // x and y coordinates of current position
int aim = 0;
foreach(var command in commands)
{
    var direction = command.Key;
    var steps = command.Value;

    if (direction == "forward")
    {
        x += steps;
        xWithAim += steps;
        yWithAim += steps * aim;
    }
    else if (direction == "down")
    {
        y += steps;
        aim += steps;
    }
    else if (direction == "up")
    {
        y -= steps;
        aim -= steps;
    }
}

var product = x * y;
var productWithAim = xWithAim * yWithAim;

// Print results
Console.WriteLine($"Resulting diving position is          ({x}, {y}).               Product is {product}.");
Console.WriteLine($"Resulting diving position with aim is ({xWithAim}, {yWithAim}). Product is {productWithAim}.");
