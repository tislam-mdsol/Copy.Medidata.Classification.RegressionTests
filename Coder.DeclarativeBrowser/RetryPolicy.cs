using Coypu;
using NUnit.Framework;
using Polly;
using System;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using OpenQA.Selenium;

namespace Coder.DeclarativeBrowser
{
    internal static class RetryPolicy
    {
        internal static readonly Policy ValidateOperation =
            Policy
            .Handle<InvalidOperationException>()
            .WaitAndRetry(
                from attempt in Enumerable.Range(1, 6)
                select TimeSpan.FromSeconds(Math.Pow(2, attempt)));

        internal static readonly Policy CompletionAssertion =
            Policy
            .Handle<AssertionException>()
            .Or<NullReferenceException>()
            .WaitAndRetry(
                from attempt in Enumerable.Range(1, 6)
                select TimeSpan.FromSeconds(Math.Pow(2, attempt)));

        internal static readonly Policy CheckDownloadFileExists =
            Policy
            .Handle<FileNotFoundException>()
            .WaitAndRetry(
                from attempt in Enumerable.Range(1, 4)
                select TimeSpan.FromMilliseconds(1000));

        internal static readonly Policy CheckDownLoadFileComplete =
            Policy
            .Handle<AssertionException>()
            .WaitAndRetry(
                from attempt in Enumerable.Range(1, 60)
                select TimeSpan.FromMilliseconds(1000));

        internal static readonly Policy FilterCollection =
            Policy
            .Handle<ArgumentOutOfRangeException>()
            .Or<MissingHtmlException>()
            .WaitAndRetry(
                from attempt in Enumerable.Range(1, 6)
                select TimeSpan.FromSeconds(Math.Pow(2, attempt)));

        internal static readonly Policy FindElement =
            Policy
                .Handle<NullReferenceException>()
                .Or<MissingHtmlException>()
                .WaitAndRetry(
                    from attempt in Enumerable.Range(1, 6)
                    select TimeSpan.FromSeconds(Math.Pow(2, attempt)));

        internal static readonly Policy FindElementShort =
            Policy
                .Handle<MissingHtmlException>()
                .WaitAndRetry(5, retryAttempt =>
                    TimeSpan.FromMilliseconds(500));

        internal static readonly Policy GetUploadCompleted =
            Policy
                .Handle<AssertionException>()
                .Or<NullReferenceException>()
                .WaitAndRetry(
                    from attempt in Enumerable.Range(1, 10)
                    select TimeSpan.FromSeconds(Math.Pow(2, attempt)));

        internal static readonly Policy ValidateDownloadedFile =
            Policy
            .Handle<ApplicationException>()
            .WaitAndRetry(
                from attempt in Enumerable.Range(1, 5)
                select TimeSpan.FromSeconds(Math.Pow(2, attempt)));

        internal static readonly Policy GetAutoUpdatingElement =
            Policy
                .Handle<MissingHtmlException>()
                .Or<AssertionException>()
                .WaitAndRetry(120, retryAttempt =>
                TimeSpan.FromSeconds(5));

        internal static readonly Policy SyncStaleElement = 
            Policy
            .Handle<StaleElementException>()
            .Or<MissingHtmlException>()
            .WaitAndRetry(
                from attempt in Enumerable.Range(1, 5)
                select TimeSpan.FromSeconds(Math.Pow(2, attempt)));

        internal static readonly Policy RefreshAndFindHtml =
            Policy
                .Handle<MissingHtmlException>()
                .Or<AmbiguousException>()
                .Or<StaleElementException>()
                .Or<StaleElementReferenceException>()
                .Retry(2);

        internal static readonly Policy DatabaseRetry =
            Policy
                .Handle<SqlException>()
                .WaitAndRetry(
                from attempt in Enumerable.Range(1, 3)
                select TimeSpan.FromSeconds(Math.Pow(3, attempt)));
        
        internal static readonly Policy RaveCoderTransmission =
            Policy
                .Handle<MissingHtmlException>()
                .WaitAndRetry(10, retryAttempt =>
                TimeSpan.FromSeconds(30));
    }
}