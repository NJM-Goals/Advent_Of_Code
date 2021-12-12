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

        internal void Visit(Path path)
        {
            // make sure no small cave is visited more than once
            foreach (var cave in path.Caves)
            {
                bool isSmallCave = cave.Name.All(char.IsLower);
                if (isSmallCave && cave.Name == Name)
                {
                    // this cave is revisited, which is not allowed
                    Debug.WriteLine($"DeadPath: {path}");

                    return;
                }
            }

            path.Add(this);

            if (IsEnd)
            {
                AllPathsToEnd.Add(path);
                Debug.WriteLine($"End Path: {path}");
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
    }
}
