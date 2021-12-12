using Core;
using System.Diagnostics;
using _12;

/// <summary>
/// Link to puzzle: https://adventofcode.com/2021/day/12
/// </summary>

string messageAssertFail = "Failed to find correct amount of paths.";

{
    var linesExample0 = (new FileHandler(args[0])).ReadLines();
    var puzzleResultExample0 = Puzzle12_ObjectOriented.Start(linesExample0);
    //Debug.Assert(puzzleResultExample0.NrPaths == 10, messageAssertFail);  // assert for Part 1
    Debug.Assert(puzzleResultExample0.NrPaths == 36, messageAssertFail);  // assert for Part 2

    // compare my paths of part 2 to example paths of part 2
    var pathsExample = (new FileHandler(args[4])).ReadLines();
    ComparePaths(pathsExample, puzzleResultExample0.AllPathsToEnd);
}

{
    var linesExample1 = (new FileHandler(args[1])).ReadLines();
    var puzzleResultExample1 = Puzzle12_ObjectOriented.Start(linesExample1);
    //Debug.Assert(puzzleResultExample1.NrPaths == 19, messageAssertFail);  // assert for Part 1
    Debug.Assert(puzzleResultExample1.NrPaths == 103, messageAssertFail);  // assert for Part 2
}

{
    var linesExample2 = (new FileHandler(args[2])).ReadLines();
    var puzzleResultExample2 = Puzzle12_ObjectOriented.Start(linesExample2);
    //Debug.Assert(puzzleResultExample2.NrPaths == 226, messageAssertFail);  // assert for Part 1
    Debug.Assert(puzzleResultExample2.NrPaths == 3509, messageAssertFail);  // assert for Part 2
}

{
    var lines = (new FileHandler(args[3])).ReadLines();
    var puzzleResultExample2 = Puzzle12_ObjectOriented.Start(lines);
    Console.WriteLine("Amount paths found: " + puzzleResultExample2.NrPaths);
}


void ComparePaths(List<string> pathsExample, List<_12.Path> allPathsToEnd)
{
    var myPaths = new List<string>();
    allPathsToEnd.ForEach(path => myPaths.Add(path.ToString() ?? throw new ArgumentException()));

    var myMissingPaths = new List<string>();
    foreach (var pathExample in pathsExample)
    {
        bool found = false;
        foreach (var path in myPaths)
        {
            if (path == pathExample)
            {
                found = true;
                break;
            }
        }
        if (!found)
            myMissingPaths.Add(pathExample);
    }

    if (myMissingPaths.Count > 0)
    {

        Console.WriteLine(nameof(myMissingPaths) + ":");
        myMissingPaths.ForEach(Console.WriteLine);
    }
}