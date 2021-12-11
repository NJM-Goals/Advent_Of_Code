namespace _11
{
    internal class Puzzle11Result
    {
        public Puzzle11Result(int totalFlashes, IReadOnlyCollection<int> stepsOfAllOctopusesFlashing)
        {
            TotalFlashes = totalFlashes;
            StepsOfAllOctopusesFlashing = stepsOfAllOctopusesFlashing;
        }

        public int TotalFlashes { get; }
        public IReadOnlyCollection<int> StepsOfAllOctopusesFlashing { get; }

        public void ConsoleOut()
        {
            Console.WriteLine($"Total amount of octopus' flashes: {TotalFlashes}");

            var superFlashes = StepsOfAllOctopusesFlashing;
            string superFlashesText = superFlashes == null || superFlashes.Count == 0 ? "None" : superFlashes.Count.ToString();
            Console.WriteLine($"Steps of all octopuses flashing (amount = {superFlashesText})");
            if (superFlashes != null)
            {
                foreach (var atStep in superFlashes)
                {
                    Console.WriteLine($"\t#{atStep}");
                }
            }

            Console.WriteLine();
        }
    }
}