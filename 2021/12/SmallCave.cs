namespace _12
{
    internal class SmallCave : Cave
    {
        public SmallCave(string name)
        {
            Name = name;
        }

        /// <summary>
        /// A <see cref="SmallCave"/> can be visited only once during one path.
        /// </summary>
        //public bool HasBeenVisited { get; private set; }

        internal override bool IsVisitable()
        {
            return !HasBeenVisited;
        }

        //internal override void Visit(Path path)
        //{
        //    base.Visit(path);
        //    //HasBeenVisited = true;
        //}

        public override Cave Copy()
        {
            var newCave = new SmallCave(Name);
            if (HasBeenVisited)
            {
                HasBeenVisited = true;
            }

            CopyNeighborReferences(this, newCave);

            return newCave;
        }
    }
}
