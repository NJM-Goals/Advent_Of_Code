namespace _11
{
    /// <summary>
    /// An octopus with increasing energy, that flashes when it reaches a specific energy.
    /// </summary>
    internal class Octopus
    {
        /// <summary>
        /// Create an octopus with start- and max-energy.
        /// </summary>
        /// <param name="startEnergy">The initial energy for this <see cref="Octopus"/></param>
        /// <param name="maxEnergy"></param>
        public Octopus(in int startEnergy, in int maxEnergy)
        {
            Energy = startEnergy;
            MaxEnergy = maxEnergy;
        }

        /// <summary>
        /// The current energy.
        /// </summary>
        private int Energy { get; set; }

        internal event Action? Flash;

        /// <summary>
        /// The max energy. If this is reached or topped, the <see cref="Octopus"/> flashes.
        /// </summary>
        private int MaxEnergy { get; }

        /// <summary>
        /// Indicates whether a <see cref="Octopus"/> has flashed.
        /// </summary>
        private bool HasFlashed { get; set; }

        /// <summary>
        /// Increases (or decreases) the energy by <paramref name="nrIncr"/>.
        /// </summary>
        internal void IncreaseEnergy(in int nrIncr = 1)
        {
            Energy += nrIncr;
        }

        /// <summary>
        /// Checks, if a flash can be executed, and then does so.
        /// </summary>
        internal void CheckFlash()
        {
            if (Energy > MaxEnergy && !HasFlashed)
            {
                HasFlashed = true;  // set flash-flag before flashing to prevent "flash-backs" (pun intended)
                Flash?.Invoke();
            }
        }

        /// <summary>
        /// Resets this octocpus' energy, if it has flashed.
        /// </summary>
        internal void Reset()
        {
            if (HasFlashed)
            {
                HasFlashed = false;
                Energy = 0;
            }
        }

        /// <summary>
        /// Increases the energy and then executes a flash, if possible.
        /// </summary>
        internal void IncreaseEnergyThenFlash()
        {
            IncreaseEnergy();
            CheckFlash();
        }
    }
}
