using System.Diagnostics;

namespace _11
{
    /// <summary>
    /// Puzzle 11 of AoC 2021. Uses an object oriented approach to solve the puzzle.<br/>
    /// The puzzle contains flashing octopuses that propagate their flash to neighboring octopuses.
    /// </summary>
    internal class Puzzle11_ObjectOriented
    {
        /// <summary>
        /// The maximum energy for an octopus to flash. Can be used for intializing octopuses.
        /// </summary>
        const int MaxEnergyOfOctopus = 9;

        /// <summary>
        /// A maximum of steps to prevent endless runs, if the algorithm is run to search for the step of all
        /// octopuses flashing.
        /// </summary>
        const int MaxSteps = 100000;

        private int NrOctopuses { get; }

        /// <summary>
        /// All octopuses.<br/>
        /// jo: I used a one-dimensional list here, because I knew it like this from the
        /// A-Star algorithm. Is it also faster like this than with a two-dimenionsal array (or list)?<br/>
        /// TODO: Try it with a two-dimensional array.
        /// </summary>
        private List<Octopus> Octi { get; set; }

        /// <summary>
        /// Total amount of flashes of all octopuses.
        /// </summary>
        private int TotalFlashes { get; set; }

        /// <summary>
        /// Amount of flashes in one step.
        /// </summary>
        private int NrFlashesOfStep { get; set; }

        /// <summary>
        /// The indices of the steps, where all octopuses flashed simultaneously.
        /// </summary>
        private List<int> StepsOfAllOctiFlashing { get; set; }

        /// <summary>
        /// Parses the <paramref name="lines"/> to create <see cref="Octopus"/>es.<br/>
        /// Call <see cref="Start"/> afterwards to process the flashing of octopuses.
        /// </summary>
        private Puzzle11_ObjectOriented(IReadOnlyList<string> lines, in int nrOctopuses)
        {
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
        /// Starts the algorithm.
        /// </summary>
        /// <param name="lines">The lines, that are parsed for the initial states of the octopuses.</param>
        /// <param name="nrOctopuses">Amount of octopuses to create.</param>
        /// <param name="steps">
        /// Amount of steps to run the algorithm.
        /// A value of -1 executes the algorithm until all octopuses flash. But there is an internal limit to prevent long runs: <see cref="MaxSteps"/>.</param>
        /// <returns>The result to solve this puzzle.</returns>
        internal static Puzzle11Result Start(in IReadOnlyList<string> lines, in int nrOctopuses, in int steps = -1)
        {
            var puzzle = new Puzzle11_ObjectOriented(lines, nrOctopuses);

            puzzle.Run(steps);

            return new Puzzle11Result(
                puzzle.TotalFlashes,
                puzzle.StepsOfAllOctiFlashing
            );
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
            int maxSteps = steps == -1 ? MaxSteps : steps;
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

        /// <summary>
        /// Must be called at begin/start of each step.
        /// </summary>
        private void BeginStep()
        {
            NrFlashesOfStep = 0;
        }

        /// <summary>
        /// Must be called at end of each step.
        /// </summary>
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

        private void AnyOctFlashes()
        {
            TotalFlashes++;
            NrFlashesOfStep++;
        }

        /// <summary>
        /// Determines all neighboring octopuses of each octopus.
        /// </summary>
        /// <exception cref="InvalidOperationException"></exception>
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
