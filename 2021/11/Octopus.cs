namespace _11
{
    internal class Octopus
    {
        public Octopus(in int startEnergy, in int maxEnergy)
        {
            Energy = startEnergy;
            MaxEnergy = maxEnergy;
        }

        /// <summary>
        /// The current energy.
        /// </summary>
        public int Energy { get; set; }

        public event Action Flash;

        /// <summary>
        /// The max energy. If this is reached or topped, the <see cref="Octopus"/> flashes.
        /// </summary>
        public int MaxEnergy { get; }

        /// <summary>
        /// Indicates whether a <see cref="Octopus"/> has flashed.
        /// </summary>
        public bool HasFlashed { get; internal set; }

        public void IncreaseEnergy(in int nrIncr = 1)
        {
            Energy += nrIncr;
        }

        internal void CheckFlash()
        {
            if (Energy > MaxEnergy && !HasFlashed)
            {
                HasFlashed = true;  // set flash-flag before flashing to prevent "flash-backs" (pun intended)
                Flash();
            }
        }

        internal void Reset()
        {
            if (HasFlashed)
            {
                HasFlashed = false;
                Energy = 0;
            }
        }

        internal void IncreaseEnergyThenFlash()
        {
            IncreaseEnergy();
            CheckFlash();
        }
    }
}
