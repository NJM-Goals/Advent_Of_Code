using System.Diagnostics;

namespace _12
{
    internal abstract class Cave
    {
        /// <summary>
        /// All neighboring caves.
        /// </summary>
        public HashSet<Cave> Neighbors { get; set; } = new HashSet<Cave>();

        public static List<Path> AllPathsToEnd = new();

        /// <summary>
        /// A <see cref="SmallCave"/> can be visited only once during one path.
        /// </summary>
        public bool HasBeenVisited { get; protected set; }

        internal abstract bool IsVisitable();

        internal void AddNeighbor(Cave cave)
        {
            Neighbors.Add(cave);
        }

        public string Name = string.Empty;

        public bool IsEnd => Name == "end";
        public bool IsStart => Name == "start";

        internal void Visit(Path path)
        {
            if(!IsVisitable(this, path))  // check, if cave may be visited
            {
                return;
            }

            path.Add(this);

            if (IsEnd)
            {
                AllPathsToEnd.Add(path);
                return;
            }
            else if (IsVisitable())
            {
                HasBeenVisited = true;
                foreach (var neighbor in Neighbors)
                {
                    var newPath = new Path(path);

                    var neighborCopy = neighbor.Copy();
                    neighborCopy.Visit(newPath);
                }
            }
        }

        /// <summary>
        /// Checks, if the <paramref name="caveToCheck"/> can be visited on base of
        /// the <paramref name="path"/> so far.
        /// </summary>
        private static bool IsVisitable(Cave caveToCheck, Path path)
        {
            if (!caveToCheck.IsSmall)
                return true;

            Dictionary<string, int> smallCaveCount = CountSmallCaves(path);
            bool hasOneSmallCaveTwice = HasOneCaveTwice(smallCaveCount);

            if (!hasOneSmallCaveTwice)
            {
                return true;
            }
            else
            {
                bool caveIsInPath = IsInPath(caveToCheck, path);
                if (caveIsInPath)
                {
                    return false;
                }
            }

            return true;
        }

        private static bool IsInPath(Cave caveToCheck, Path path)
        {
            foreach (var caveInPath in path.Caves)
            {
                if (caveInPath.Name == caveToCheck.Name)
                {
                    return true;
                }
            }

            return false;
        }

        private static bool HasOneCaveTwice(Dictionary<string, int> smallCaveCount)
        {
            foreach (var caveCount in smallCaveCount)
            {
                if (caveCount.Value > 1)
                {
                    return true;
                }
            }

            return false;
        }

        private static Dictionary<string, int> CountSmallCaves(Path path)
        {
            var smallCaveCount = new Dictionary<string, int>();
            foreach (var cave in path.Caves)
            {
                if (cave.IsSmall && !cave.IsEnd && !cave.IsStart)
                {
                    if (smallCaveCount.ContainsKey(cave.Name))
                        smallCaveCount[cave.Name]++;
                    else
                        smallCaveCount.Add(cave.Name, 1);
                }
            }

            return smallCaveCount;
        }

        public abstract Cave Copy();

        public override string? ToString()
        {
            return Name;
        }

        protected static void CopyNeighborReferences(Cave from, Cave to)
        {
            foreach (var neighbor in from.Neighbors)
            {
                to.Neighbors.Add(neighbor);
            }
        }

        private bool IsSmall => Name.All(char.IsLower);
    }
}
