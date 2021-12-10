string filename = args[0];

var lines = (new Core.FileHandler(filename)).ReadLines();

// convert lines to numbers
var numbers = new List<int>();
lines.ForEach(line => numbers.Add(int.Parse(line)));

int amountGreater = 0;

int previousNumber = int.MaxValue;
foreach (var number in numbers)
{
    if (number > previousNumber)
    {
        ++amountGreater;
    }
    previousNumber = number;
}

Console.WriteLine($"Amount numbers that are greater than their previous number: {amountGreater}");



// part 2 - three-measurement sliding window

var preNr = int.MaxValue;
var prePreNr = int.MaxValue;
int sum = int.MaxValue;
int preSum = int.MaxValue;
int amountGreaterSums = 0;
foreach (var nr in numbers)
{
    if (preNr == int.MaxValue)  // first iteration
    {
        preNr = nr;
        continue;
    }

    if (prePreNr == int.MaxValue)  // second iteration
    {
        prePreNr = preNr;
        preNr = nr;
        continue;
    }

    sum = nr + preNr + prePreNr;

    // count greater sums than preceding sum
    if (sum > preSum)
        ++amountGreaterSums;

    prePreNr = preNr;
    preNr = nr;

    preSum = sum;
}

Console.WriteLine($"Amount sums that are greater than their previous sum: {amountGreaterSums}");
