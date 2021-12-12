namespace _12;

internal class Puzzle12_ObjectOriented
{
    /// <summary>
    /// All caves.
    /// </summary>
    public Dictionary<string, Cave> Caves { get; }
    public Cave StartCave { get; private set; }
    public Puzzle12Result PuzzleResult { get; private set; } = new Puzzle12Result();

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
            var caveLine0 = cavesLine.First();
            var caveLine1 = cavesLine.Last();


            // create or get cave0
            var cave0 = caveLine0.Value;
            bool caveAdded = Caves.TryAdd(caveLine0.Key, cave0);
            if (!caveAdded)
            {
                bool gotCave = Caves.TryGetValue(caveLine0.Key, out cave0);
                if (!gotCave)
                    throw new InvalidOperationException();
            }


            // create or get cave1
            var cave1 = caveLine1.Value;
            caveAdded = Caves.TryAdd(caveLine1.Key, cave1);
            if (!caveAdded)
            {
                bool gotCave = Caves.TryGetValue(caveLine1.Key, out cave1);
                if (!gotCave)
                    throw new InvalidOperationException();
            }


            // Add neighboring caves to each other
            if (cave0 is null || cave1 is null || cave0 == cave1)
                throw new InvalidOperationException();

            cave0.AddNeighbor(cave1);
            cave1.AddNeighbor(cave0);
        }

        StartCave = Caves["start"];
    }

    public void Run()
    {
        var path = new Path();
        StartCave.Visit(path);

        var foundPaths = Cave.AllPathsToEnd.Count;
        OutPaths();

        PuzzleResult.NrPaths = foundPaths;
        Cave.AllPathsToEnd.Clear();
    }

    private static void OutPaths()
    {
        foreach (var path in Cave.AllPathsToEnd)
        {
            Console.WriteLine(path);
        }
    }

    private static Dictionary<string, Cave> CreateCaves(string line)
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

        return caves;
    }
}