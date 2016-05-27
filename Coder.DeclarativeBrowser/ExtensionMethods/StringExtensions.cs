using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Coder.DeclarativeBrowser.Helpers;

namespace Coder.DeclarativeBrowser.ExtensionMethods
{
    public static class StringExtensions
    {
        public static string WrapStringWithQuotes(this string value)
        {
            if (String.IsNullOrEmpty(value)) throw new ArgumentNullException("value"); 

            var result = "\"" + value + "\"";

            return result;
        }

        public static string AppendRandomString(this string value)
        {
            if (String.IsNullOrEmpty(value)) throw new ArgumentNullException("value"); 

            var result = value + BrowserUtility.RandomString();
            return result;
        }

        public static bool IsNumeric(this string text)
        {
            if (String.IsNullOrEmpty(text)) throw new ArgumentNullException("text"); 

            int number;
            return int.TryParse(text, out number);
        }

        public static DateTime? ToNullableDate(this string text)
        {
            DateTime date;

            if (DateTime.TryParse(text, out date))
            {
                return date;
            }

            return null;
        }

        public static DateTime ToDate(this string text)
        {
            if (String.IsNullOrWhiteSpace(text)) throw new ArgumentNullException("text"); 

            DateTime date;

            if (DateTime.TryParse(text, out date))
            {
                return date;
            }

            throw new InvalidCastException("Unable to convert string to date");
        }

        public static int? ToNullableInteger(this string text)
        {
            int number;

            if (Int32.TryParse(text, out number))
            {
                return number;
            }

            return null;
        }

        public static int ToInteger(this string text)
        {
            if (String.IsNullOrEmpty(text)) throw new ArgumentNullException("text"); 

            int number;

            if (Int32.TryParse(text, out number))
            {
                return number;
            }

            return 0;
        }

        public static bool ToBoolean(this string text)
        {
            if (String.IsNullOrEmpty(text)) throw new ArgumentNullException("text");

            bool result;

            if (Boolean.TryParse(text, out result))
            {
                return result;
            }

            throw new InvalidCastException("Unable to convert string to boolean");
        }

        public static string ConvertToFullDictionaryLevelName(this string level)
        {
            if (String.IsNullOrEmpty(level)) throw new ArgumentNullException("level"); 

            switch (level.ToUpper())
            {
                case "PRODUCT":
                    return "Preferred Name";

                case "LLT":
                    return "Low Level Term";
                default:
                    throw new KeyNotFoundException(string.Format("Level: \"{0}\" not found", level));
            }
        }

        public static String GetProperty<T>(this T target, string propertyName)
        {
            if (String.IsNullOrEmpty(propertyName)) throw new ArgumentNullException("propertyName"); 

            var properties = typeof(T).GetProperties();

            foreach (var property in properties.Where(property => property.Name.Equals(propertyName)))
            {
                return property.GetValue(target, null).ToString();
            }

            var methodName = "Get" + propertyName;

            var methods =
                typeof (T).GetMethods()
                    .Where(method => method.Name.Equals(methodName)
                        && (!method.GetParameters().Any()));

            foreach (var method in methods.Where(method => method.Name.EndsWith(propertyName)))
            {
                var methodValue = method.Invoke(target, null).ToString();
                return methodValue;
            }

            throw new ArgumentException(string.Format("Can't find property: {0} or method: Get{0}", propertyName));
        }

        public static String RemoveNonAlphanumeric(this String value)
        {
            if (ReferenceEquals(value, null))
                return value;

            var cleaned = value.Where(char.IsLetterOrDigit).ToArray();
            var result = new String(cleaned);
            return result;
        }

        public static bool ContainsAll(this String source, params string[] values)
        {
            if (String.IsNullOrWhiteSpace(source)) throw new ArgumentNullException("source");
            if (ReferenceEquals(values,null))      throw new ArgumentNullException("values");

            var containsAll = values.All(source.Contains);

            return containsAll;
        }

        public static bool Contains(this string source, string text, StringComparison comparision)
        {
            if (ReferenceEquals(source,null))    throw new ArgumentNullException("source");
            if (String.IsNullOrWhiteSpace(text)) throw new ArgumentNullException("text");

            var result = source.IndexOf(text, comparision) >= 0;

            return result;
        }

        public static string RemoveAllWhiteSpace(this string text)
        {
            if (String.IsNullOrWhiteSpace(text)) throw new ArgumentNullException("text");

            var result = text.Replace(" ", String.Empty);

            return result;
        }

        public static string ReplaceWith(this String source, string value)
        {
            if (String.IsNullOrWhiteSpace(source)) throw new ArgumentNullException("source");

            if (!String.IsNullOrWhiteSpace(value))
            {
                return value;
            }

            return source;
        }

        public static bool EqualsIgnoreCase(this string source, string target)
        {
            if (String.IsNullOrWhiteSpace(target)) throw new ArgumentNullException("target");

            var result = source.Equals(target, StringComparison.OrdinalIgnoreCase);

            return result;
        }
        
        public static bool IsNullOrEqualsIfRequired(this string actualValue, string expectedValue)
        {
            bool comparisonNotRequired = ReferenceEquals(expectedValue, null);
            if  (comparisonNotRequired)
            {
                return true;
            }

            bool valueShouldBeBlank = expectedValue.Equals(String.Empty);
            if  (valueShouldBeBlank)
            {
                return String.IsNullOrWhiteSpace(actualValue);
            }
            
            return actualValue.EqualsIgnoreCase(expectedValue);
        }

        public static string ElementAtOrEmpty(this string[] source, int index)
        {
            if (ReferenceEquals(source,null)) throw new ArgumentNullException("source");
            if (index < 0) throw new ArgumentOutOfRangeException("index must be >= 0");

            var result = source.ElementAtOrDefault(index) ?? String.Empty;

            return result;
        }

        public static string AppendFileType(this string source, string fileType)
        {
            if (String.IsNullOrWhiteSpace(source))   throw new ArgumentNullException("source");
            if (String.IsNullOrWhiteSpace(fileType)) throw new ArgumentNullException("fileType");

            var result = String.Format("{0}.{1}", source, fileType);

            return result;
        }

        public static string AppendFileNameToDirectoryPath(this string directoryPath, string fileName)
        {
            if (String.IsNullOrWhiteSpace(directoryPath)) throw new ArgumentNullException("directoryPath");
            if (String.IsNullOrWhiteSpace(fileName))      throw new ArgumentNullException("fileName");

            var filePath = Path.Combine(directoryPath, fileName);

            return filePath;
        }

        public static string AppendErrorFileNameToDirectoryPath(this string filePath)
        {
            if (String.IsNullOrWhiteSpace(filePath)) throw new ArgumentNullException("filePath");

            var errorFileName = filePath.Insert(filePath.IndexOf("."), "_Errors");

            return errorFileName;
        }

        public static string SetInstantiatedValue(this string target, string newValue)
        {
            if (!String.IsNullOrWhiteSpace(target))
            {
                return target;
            }

            if (!String.IsNullOrWhiteSpace(newValue))
            {
                return newValue;
            }

            return String.Empty;
        }

        public static string RemoveAdditionalInformationFromGridDataVerbatim(this string gridDataVerbatim)
        {
            if (String.IsNullOrEmpty(gridDataVerbatim)) throw new ArgumentNullException("gridDataVerbatim");

            return gridDataVerbatim.Split('(')[0];
        }

        public static bool HasValue(this string text)
        {
            var hasValue = !String.IsNullOrWhiteSpace(text);

            return hasValue;
        }

        public static IEnumerable<string> EscapeDelimitersWithQuotes(this IEnumerable<string> stringValues, char quoteChar, char delimiter)
        {
            if (ReferenceEquals(stringValues,null)) throw new ArgumentNullException("stringValues");

            var inputArray = stringValues.ToArray();

            var inputCount = inputArray.Length;
            var outputArray = new string[inputCount];

            for (int i = 0; i < inputCount; i++)
            {
                outputArray[i] = inputArray[i].EscapeDelimiterWithQuotes(quoteChar, delimiter);
            }

            return outputArray;
        }

        public static string EscapeDelimiterWithQuotes(this string stringValue, char quoteChar, char delimiter)
        {
            if (ReferenceEquals(stringValue,null)) throw new ArgumentNullException("stringValue");
            
            if (stringValue.IndexOf(delimiter) >= 0
                && !stringValue.StartsWith(quoteChar.ToString()) 
                && !stringValue.EndsWith(quoteChar.ToString()))
            {
                stringValue = String.Format("{0}{1}{0}", quoteChar, stringValue);
            }

            return stringValue;
        }

        public static string FormatSearchTextForExactSearch(this string searchText)
        {
            if (String.IsNullOrEmpty(searchText)) throw new ArgumentNullException("searchText");

            return searchText.Replace(' ', '*');
        }

        public static string ToStringOrDefault(this object property)
        {
            if (ReferenceEquals(property, null))
            {
                return null;
            }

            var propertyString = property.ToString();

            return propertyString;
        }

        public static string CreateUniqueRaveSubjectId(this string subjectInitials)
        {
            if (String.IsNullOrWhiteSpace(subjectInitials)) throw new ArgumentNullException("subjectInitials");

            const int MaxSubjectIdLengeth = 11;

            var subjectId = String.Format("{0}{1}", subjectInitials, Guid.NewGuid()).Substring(0, MaxSubjectIdLengeth);

            return subjectId;
        }

        public static string CreateUniqueRaveAdverseEventText(this string adverseEventTextPrefix)
        {
            if (String.IsNullOrWhiteSpace(adverseEventTextPrefix)) throw new ArgumentNullException("adverseEventTextPrefix");

            const int maxAdverseEventTextLength = 20;

            var adverseEventText = String.Format("{0}{1}", adverseEventTextPrefix, Guid.NewGuid()).RemoveNonAlphanumeric().Substring(0, maxAdverseEventTextLength);

            return adverseEventText;
        }

        public static string GetFirstSectionAppendedWithRandomNumbers(this Guid guid)
        {
            Random rnd = new Random();
            var randomSuffix = rnd.Next(1000, 10000).ToString();

            var guidString = guid.ToString();
            var suffix = guidString.Substring(0, guidString.IndexOf('-')) + randomSuffix;

            return suffix;
        }

        public static string GetRaveSearchText(this string raveObjectName)
        {
            if (String.IsNullOrWhiteSpace(raveObjectName)) throw new ArgumentNullException("raveObjectName");

            var firstNonAlphanumeric = raveObjectName.ToCharArray().FirstOrDefault(x=>!Char.IsLetterOrDigit(x) && !Char.IsWhiteSpace(x));

            if (firstNonAlphanumeric.Equals('\0'))
            {
                return raveObjectName;
            }

            var firstNonAlphanumericIndex = raveObjectName.IndexOf(firstNonAlphanumeric);

            var raveSearchString = raveObjectName.Remove(firstNonAlphanumericIndex);

            return raveSearchString;
        }

        public static string CreateUserEmail(this string userName)
        {
            if (String.IsNullOrWhiteSpace(userName)) throw new ArgumentNullException("userName");

            var email = String.Format("medidatacoder+{0}@gmail.com", userName);

            return email;
        }
    }
}
