namespace _12;

internal class Puzzle12_ObjectOriented
{
    public Dictionary<string, Cave> Caves { get; }
    public Cave StartCave { get; private set; }
    public Puzzle12Result PuzzleResult { get; private set; }

    internal static Puzzle12Result Start(in List<string> lines)
    {
        var puzzle = new Puzzle12_ObjectOriented(lines);

        puzzle.Run();

        return puzzle.PuzzleResult;
    }


    public Puzzle12_ObjectOriented(List<string> lines)
    {
        Caves = new Dictionary<string, Cave>();

        // parse lines to create unique caves
        foreach (var line in lines)
        {
            var cavesLine = CreateCaves(line);
            foreach (var cavesOfLine in cavesLine)
                Caves.TryAdd(cavesOfLine.Key, cavesOfLine.Value);


            // Add neighboring caves to each other
            var cave0 = cavesLine.First();
            var cave1 = cavesLine.Last();
            Caves[cave0.Key].AddNeighbor(cave1.Value);
            Caves[cave1.Key].AddNeighbor(cave0.Value);
        }
    }

    public void Run()
    {
        var path = new Path();
        StartCave.Visit(path);

        var foundPaths = Cave.AllPaths.Count;

        PuzzleResult = new Puzzle12Result();
        PuzzleResult.NrPaths = foundPaths;
    }

    private Dictionary<string, Cave> CreateCaves(string line)
    {
        var lineCaves = line.Split('-');
        var caveStr0 = lineCaves[0];
        var caveStr1 = lineCaves[1];

        if (caveStr0 == caveStr1)
            throw new InvalidOperationException();

        bool isSmallCave = caveStr0.All(char.IsLower);
        var caves = new Dictionary<string, Cave>();
        caves.Add(caveStr0, isSmallCave ? new SmallCave(caveStr0) : new BigCave(caveStr0));

        isSmallCave = caveStr1.All(char.IsLower);
        caves.Add(caveStr1, isSmallCave ? new SmallCave(caveStr1) : new BigCave(caveStr1));


        // store starting cave
        if (StartCave == null)
        {
            foreach (var cave in caves)
            {
                if (cave.Key == "start")
                {
                    StartCave = cave.Value;
                    break;
                }
            }
        }


        return caves;
    }
}