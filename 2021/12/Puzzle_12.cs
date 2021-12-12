using Core;
using System.Diagnostics;
using _12;

string messageAssertFail = "Failed to find correct amount of paths.";

{
    var linesExample0 = (new FileHandler(args[0])).ReadLines();
    var puzzleResultExample0 = Puzzle12_ObjectOriented.Start(linesExample0);
    Debug.Assert(puzzleResultExample0.NrPaths == 10, messageAssertFail);
}

{
    var linesExample1 = (new FileHandler(args[1])).ReadLines();
    var puzzleResultExample1 = Puzzle12_ObjectOriented.Start(linesExample1);
    Debug.Assert(puzzleResultExample1.NrPaths == 19, messageAssertFail);
}

{
    var linesExample2 = (new FileHandler(args[2])).ReadLines();
    var puzzleResultExample2 = Puzzle12_ObjectOriented.Start(linesExample2);
    Debug.Assert(puzzleResultExample2.NrPaths == 226, messageAssertFail);
}

{
    var lines = (new FileHandler(args[3])).ReadLines();
    var puzzleResultExample2 = Puzzle12_ObjectOriented.Start(lines);
}

