namespace _12
{
    internal abstract class Cave
    {
        /// <summary>
        /// All neighboring caves.
        /// </summary>
        public HashSet<Cave> Neighbors { get; set; } = new HashSet<Cave>();

        public static List<Path> AllPaths = new List<Path>();

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

        internal /*virtual*/ void Visit(Path path)
        {
            path.Add(this);

            if (IsEnd)
            {
                AllPaths.Add(path);
                return;
            }
            else if (IsVisitable())
            {
                HasBeenVisited = true;
                foreach (var neighbor in Neighbors)
                {
                    var newPath = new Path(path);

                    neighbor.Visit(newPath);
                }
            }
            else  // dead end
            {
                // don't add path to all paths
                return;
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

        //protected static void CopyNeighbors(Cave from, Cave to)
        //{
        //    foreach (var neighbor in from.Neighbors)
        //    {
        //        to.Neighbors.Add(neighbor.Copy());
        //    }
        //}
    }
}
