namespace _12;

internal class Puzzle12Result
{
    public List<Path> AllPathsToEnd { get; internal set; } = new();

    /// <summary>
    /// Amount of paths found from start to end cave.
    /// </summary>
    public int NrPaths { get; set; }
}
