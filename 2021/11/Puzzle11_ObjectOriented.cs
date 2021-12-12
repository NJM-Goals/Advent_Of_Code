using System.Diagnostics;

namespace _11
{
    internal class Puzzle11_ObjectOriented
    {
        const int MaxEnergyOfOctopus = 9;

        public IReadOnlyList<string> Lines { get; }
        public int NrOctopuses { get; }
        /// <summary>
        /// All octopuses.
        /// </summary>
        private List<Octopus> Octi { get; set; }
        public int TotalFlashes { get; private set; }
        public int NrFlashesOfStep { get; private set; }
        public List<int> StepsOfAllOctiFlashing { get; private set; }

        internal static Puzzle11Result Start(in IReadOnlyList<string> lines, in int nrOctopuses, in int steps = -1)
        {
            var puzzle = new Puzzle11_ObjectOriented(lines, nrOctopuses);

            puzzle.Run(steps);

            return new Puzzle11Result(
                puzzle.TotalFlashes,
                puzzle.StepsOfAllOctiFlashing
            );
        }

        public Puzzle11_ObjectOriented(IReadOnlyList<string> lines, in int nrOctopuses)
        {
            Lines = lines;
            NrOctopuses = nrOctopuses;
            var octi = new List<Octopus>(nrOctopuses);

            foreach (var line in lines)
            {
                var chars = line.ToCharArray();
                foreach (var ch in chars)
                {
                    var startEnergy = int.Parse(ch.ToString());
                    octi.Add(new Octopus(startEnergy, MaxEnergyOfOctopus));
                }
            }

            Octi = octi;
            StepsOfAllOctiFlashing = new List<int>();


            // determine neighbors of octopuses
            DetermineNeighbors();


            // listen for all flashes
            Octi.ForEach(oct => oct.Flash += AnyOctFlashes);
        }

        /// <summary>
        /// Runs all the steps for the octopuses increasing energy and flashing.
        /// </summary>
        private void Run(in int steps)
        {
            int givenSteps = steps;

            // One step:
            //  1. Increase energy of each octopus
            //  2. Process flashes
            //  3. Reset energies of octopuses
            int maxSteps = steps == -1 ? 100000 : steps;
            for (int i = 1; i <= maxSteps; ++i)
            {
                BeginStep();
                Octi.ForEach(oct => oct.IncreaseEnergy());
                Octi.ForEach(oct => oct.CheckFlash());
                Octi.ForEach(oct => oct.Reset());
                EndStep(i, out bool allOctopusesFlashed);

                if (allOctopusesFlashed && givenSteps == -1)
                    break;  // we want to detect only the step, when all octopuses flash
            }
        }

        private void EndStep(in int step, out bool allOctopusesFlashed)
        {
            if (NrFlashesOfStep == NrOctopuses)
            {
                Debug.WriteLine($"All octopuses have flashed this step. Wooooh! It's sooo bright.\n\t{nameof(step)} = {step}, {nameof(NrFlashesOfStep)} = {NrFlashesOfStep}");
                StepsOfAllOctiFlashing.Add(step);
                allOctopusesFlashed = true;
            }
            else if (NrFlashesOfStep > NrOctopuses)
            {
                Debug.WriteLine($"Arrrg, too bright! This step had more flashes than octopuses.\n\t{nameof(step)} = {step}, {nameof(NrFlashesOfStep)} = {NrFlashesOfStep}");
                allOctopusesFlashed = true;
            }
            else
            {
                allOctopusesFlashed = false;
            }
        }

        private void BeginStep()
        {
            NrFlashesOfStep = 0;
        }

        private void AnyOctFlashes()
        {
            TotalFlashes++;
            NrFlashesOfStep++;
        }

        private void DetermineNeighbors()
        {
            const int octiInRowAndCol = 10;

            // offsets to adjacent neighbors, from top-left clockwise to left.
            const int nrNeighbors = 8;
            int[] neighborOffsets = new int[nrNeighbors];
            neighborOffsets[0] = -(octiInRowAndCol + 1);
            neighborOffsets[1] = -octiInRowAndCol;
            neighborOffsets[2] = -(octiInRowAndCol - 1);
            neighborOffsets[3] = 1;
            neighborOffsets[4] = octiInRowAndCol + 1;
            neighborOffsets[5] = octiInRowAndCol;
            neighborOffsets[6] = octiInRowAndCol - 1;
            neighborOffsets[7] = -1;


            // determine neighbors
            for (int i = 0; i < Octi.Count; ++i)
            {
                int row = i / octiInRowAndCol;
                int col = i % octiInRowAndCol;


                // check whether there are neighbors
                bool hasTop = row > 0;
                bool hasRight = col < (octiInRowAndCol - 1);
                bool hasBottom = row < (octiInRowAndCol - 1);
                bool hasLeft = col > 0;

                bool hasTopLeft = hasTop && hasLeft;
                bool hasTopRight = hasTop && hasRight;
                bool hasBottomRight = hasBottom && hasRight;
                bool hasBottomLeft = hasBottom && hasLeft;

                bool[] hasNeighbor = new bool[] { hasTopLeft, hasTop, hasTopRight, hasRight, hasBottomRight, hasBottom, hasBottomLeft, hasLeft };  // TODO reuse array instead of always new
                if (hasNeighbor.Length != neighborOffsets.Length)
                    throw new InvalidOperationException();

                // process neighbors clockwise from top-left to left
                for (int j = 0; j < nrNeighbors; j++)
                {
                    if (hasNeighbor[j])
                    {
                        int offset = neighborOffsets[j];
                        int neighborIdx = i + offset;
                        if (neighborIdx < 0 || neighborIdx >= NrOctopuses)
                            throw new InvalidOperationException();

                        var neighbor = Octi[neighborIdx];

                        // register the neighbor for a flash of current octopus
                        Octi[i].Flash += neighbor.IncreaseEnergyThenFlash;  // TODO deregister
                    }
                }
            }
        }
    }
}
