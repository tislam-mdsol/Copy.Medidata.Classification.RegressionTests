using System;

namespace Coder.DeclarativeBrowser.FileHelpers
{
    public class CsvColumnNameAttribute : Attribute
    {
        public int Order   { get; set; }
        public string Name { get; set; }

        public CsvColumnNameAttribute()
        {
            Order = int.MaxValue;
        }
    }
}
