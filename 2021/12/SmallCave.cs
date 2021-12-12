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

        public override Cave Copy()
        {
            var newCave = new SmallCave(Name);
            if (HasBeenVisited)
            {
                newCave.HasBeenVisited = true;
            }

            CopyNeighborReferences(this, newCave);

            return newCave;
        }
    }
}
