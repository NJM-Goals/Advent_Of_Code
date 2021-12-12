namespace _12
{
    internal class BigCave : Cave
    {
        public BigCave(string name)
        {
            Name = name;
        }

        internal override bool IsVisitable() => true;


        public override Cave Copy()
        {
            var newCave = new BigCave(Name);

            CopyNeighborReferences(this, newCave);

            return newCave;
        }
    }
}
