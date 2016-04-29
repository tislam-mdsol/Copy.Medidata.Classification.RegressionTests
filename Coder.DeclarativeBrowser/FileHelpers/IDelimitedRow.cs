using System;

namespace Coder.DeclarativeBrowser.FileHelpers
{
    public interface IDelimitedRow
    {
        char Delimiter { get; }
        char QuoteChar { get; }
    }
}
