using System.Diagnostics;

namespace Core
{
    public class FileHandler
    {
        public string FilePath { get; }

        public string FileName { get; }

        public FileHandler(in string fileName)
        {
            FileName = fileName;

            var currDir = Environment.CurrentDirectory;
            Debug.WriteLine($"{nameof(currDir)} {currDir}");

            FilePath = Path.Combine(new string[] { currDir, "..", "..", "..", FileName });
        }

        public List<string> ReadLines()
        {
            var file = File.OpenText(FilePath);

            var line = file.ReadLine();
            var lines = new List<string>();
            while (line != null)
            {
                lines.Add(line);
                line = file.ReadLine();
            }

            return lines;
        }
    }
}