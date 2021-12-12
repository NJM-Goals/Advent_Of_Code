namespace _12
{
    internal class Path
    {
        /// <summary>
        /// All caves in this path from start to end cave.
        /// </summary>
        public List<Cave> Caves { get; set; } = new List<Cave>();

        public Path()
        { }

        public Path(Path path)
        {
            // copy all caves, because each path has its own caves to detect, if it has been visited by this path.
            foreach (var cave in path.Caves)
            {
                Caves.Add(cave.Copy());
            }
        }

        public void Add(Cave cave)
        {
            Caves.Add(cave);
        }

        public override string? ToString()
        {
            string pathStr = string.Empty;
            foreach (var cave in Caves)
            {
                pathStr += cave.ToString();
                if (cave != Caves.Last())
                    pathStr += ",";
            }

            return pathStr;
        }
    }
}
