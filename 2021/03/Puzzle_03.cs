var filename = args[0];
var lines = (new Core.FileHandler(filename)).ReadLines();

var binaryPlaces = lines[0].Length;

var binaryPlaceCount = new int[binaryPlaces];

foreach (var line in lines)
{
    var lineChars = line.ToCharArray();

    for (int i = 0; i < binaryPlaces; i++)
    {
        if (lineChars[i] == '1')
        {
            ++(binaryPlaceCount[i]);
        }
        else
            --(binaryPlaceCount[i]);
    }
}

string gammaRateStr = string.Empty;
foreach (var item in binaryPlaceCount)
{
    gammaRateStr += item > 0 ? "1" : "0";
}

int gammaRate = Convert.ToInt32(gammaRateStr, 2);
int epsilonRate = gammaRate ^ 0b111111111111; 

var product = gammaRate * epsilonRate;


// print results
Console.WriteLine($"{nameof(gammaRate)} {gammaRate}");
Console.WriteLine($"{nameof(epsilonRate)} {epsilonRate}");
Console.WriteLine($"{nameof(product)} {product}");
