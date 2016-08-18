using System;
using System.Collections.Generic;
using System.Linq;
using Coder.DeclarativeBrowser.ExtensionMethods;
using Coypu;
using HtmlAgilityPack;

namespace Coder.DeclarativeBrowser
{
    internal sealed class SessionElementScope
    {
        private readonly DriverScope  _DriverScope;
        private readonly ElementScope _ElementScope;
        private readonly Options      _Options;

        internal SessionElementScope(ElementScope elementScope, DriverScope driverScope)
        {
            if (ReferenceEquals(elementScope, null))    throw new ArgumentNullException("elementScope");
            if (ReferenceEquals(driverScope, null))     throw new ArgumentNullException("driverScope");

            _DriverScope    = driverScope;
            _ElementScope   = elementScope;
            _Options        = Config.GetDefaultCoypuOptions();
        }

        internal SessionElementScope(ElementScope elementScope, SessionElementScope session)
            : this(elementScope, session._DriverScope) { }

        internal string OuterHTML                       { get { return _ElementScope.OuterHTML;         } }
        internal string InnerHTML                       { get { return _ElementScope.InnerHTML;         } }
        internal string SelectedOption                  { get { return _ElementScope.SelectedOption;    } }
        internal string Text                            { get { return _ElementScope.Text;              } }
        internal string Value                           { get { return _ElementScope.Value;             } }
        internal string Id                              { get { return _ElementScope.Id;                } }
        internal string Class                           { get { return _ElementScope["class"];          } }
        internal string Type                            { get { return _ElementScope["type"];           } }
        internal bool Disabled                          { get { return _ElementScope.Disabled;          } }

        internal string GetAttribute(string attributeName)
        {
            if (String.IsNullOrEmpty(attributeName)) throw new ArgumentNullException("attributeName");

            var result = _ElementScope[attributeName];

            return result;
        }

        internal bool Exists(Options options = null)
        {
            bool result;

            if (ReferenceEquals(options, null))
                result = _ElementScope.Exists(Config.ExistsOptions);
            else
                result = _ElementScope.Exists(options);

            return result;
        }

        internal void ClickWhenAvailable()
        {
            _ElementScope.ClickWhenAvailable(_DriverScope);
        }

        internal void Click()
        {
            _ElementScope.Click(_Options);
        }

        internal void Check()
        {
            _ElementScope.Check(_Options);
        }

        internal void Uncheck()
        {
            _ElementScope.Uncheck(_Options);
        }

        internal void Hover()
        {
            _ElementScope.Hover(_Options);
        }

        internal void HoverAndClick()
        {
            _ElementScope.Hover(_Options);
            _ElementScope.Click(_Options);
        }

        internal bool Missing()
        {
            var isMissing = _ElementScope.Missing();
            return isMissing;
        }

        internal bool Missing(Options options)
        {
            bool result;

            if (ReferenceEquals(options, null))
                result = _ElementScope.Missing(Config.ExistsOptions);
            else
                result = _ElementScope.Missing(options);

            return result;
        }

        internal SessionElementScope FindSessionElementById(string id)
        {
            if (String.IsNullOrEmpty(id)) throw new ArgumentNullException("id");

            var result = _ElementScope.FindId(id, _Options).WithSession(_DriverScope);
            return result;
        }

        internal SessionElementScope FillInWith(string value)
        {
            if (String.IsNullOrEmpty(value)) throw new ArgumentNullException("value");

            var result = _ElementScope
                .FillInWithOptions(_DriverScope, value)
                .WithSession(_DriverScope);

            return result;
        }

        internal SessionElementScope FindSessionElementByXPath(string xPath)
        {
            if (String.IsNullOrEmpty(xPath)) throw new ArgumentNullException("xPath");

            var result = _ElementScope.FindXPath(xPath, _Options).WithSession(_DriverScope);
            return result;
        }

        internal string FindInvisibleElementTextByXPath(string xPath)
        {
            if (String.IsNullOrEmpty(xPath)) throw new ArgumentNullException("xPath");

            var options = _Options;
            options.ConsiderInvisibleElements = true;

            var element = _ElementScope.FindXPath(xPath, _Options).WithSession(_DriverScope);

            if (ReferenceEquals(element, null))               return String.Empty;
            if (String.IsNullOrWhiteSpace(element.OuterHTML)) return String.Empty;

            HtmlNode htmlNode = HtmlNode.CreateNode(element.OuterHTML);

            var result = htmlNode.InnerText ?? String.Empty;
            
            return result;
        }

        internal SessionElementScope FindSessionElementByLink(string linkText)
        {
            if (String.IsNullOrWhiteSpace(linkText)) throw new ArgumentNullException("linkText");

            var result = _ElementScope.FindLink(linkText, _Options).WithSession(_DriverScope);
            return result;
        }

        internal IList<SessionElementScope> FindAllSessionElementsByXPath(string xPath)
        {
            if (String.IsNullOrEmpty(xPath)) throw new ArgumentNullException("xPath");

            var elements = _ElementScope
                .FindAllXPath(xPath, options: _Options);

            var elementScopes = elements.SyncSnapshots();

            return elementScopes;
        }

        internal void SelectOption(string option)
        {
            if (String.IsNullOrEmpty(option)) throw new ArgumentNullException("option");

            _ElementScope.SelectOption(option, _Options);
        }

        internal void SelectOption(string option, int index)
        {
            if (String.IsNullOrEmpty(option))           throw new ArgumentNullException(nameof(option));
            if (String.IsNullOrEmpty(index.ToString())) throw new ArgumentNullException(nameof(option));

            var normalizePath   = String.Format("//option[normalize-space(text())='{0}']", option);

            var optionsToSelect = _ElementScope.FindAllSessionElementsByXPath(normalizePath);

            optionsToSelect[index].Click();
        }

        internal void SendKeys(string keys)
        {
            if (String.IsNullOrEmpty(keys)) throw new ArgumentNullException("keys");

            _ElementScope.SendKeys(keys, _Options);
        }

        //TODO: KILL below method afte refactoring everything to use bool overload
        internal void SetCheckBoxState(string checkBox)
        {
            if (String.IsNullOrEmpty(checkBox)) throw new ArgumentNullException("checkBox");

            _ElementScope.SetCheckBoxState(_DriverScope, checkBox);
        }

        internal void SetCheckBoxState(bool state)
        {
            RetryPolicy.FindElementShort.Execute(
                () =>
                {
                    if (state)
                    {
                        _ElementScope.Check();
                    }
                    else
                    {
                        _ElementScope.Uncheck();
                    }

                    if (!_ElementScope.Selected.Equals(state))
                    {
                        throw new MissingHtmlException("Checkbox not successfully checked");
                    }
                });
        }

        internal void SelectOptionAlphanumericOnly(string optionText)
        {
            if (String.IsNullOrEmpty(optionText)) return;

            var option = RetryPolicy.FindElement.Execute(
                () =>
                GetOption(optionText));

            _ElementScope.SelectOption(option);
        }

        internal void SelectClosestOption(string optionText)
        {
            if (String.IsNullOrEmpty(optionText)) return;

            var option = RetryPolicy.FindElement.Execute(
                () =>
                GetClosestOption(optionText));

            _ElementScope.SelectOption(option);
        }

        private string GetOption(string optionText)
        {
            if (String.IsNullOrWhiteSpace(optionText)) throw new ArgumentNullException("optionText");

            var optionsDictionary = RetryPolicy.SyncStaleElement.Execute(() => GetOptionsDictionaryAlphanumericOnly());

            var searchText = optionText.RemoveNonAlphanumeric();

            var option = optionsDictionary.FirstOrDefault(x => x.Value.Equals(searchText, StringComparison.OrdinalIgnoreCase)).Key;

            if (ReferenceEquals(option, null))
            {
                option = optionsDictionary.FirstOrDefault(x => x.Value.Contains(searchText, StringComparison.OrdinalIgnoreCase)).Key;
            }

            if (ReferenceEquals(option, null))
            {
                throw new MissingHtmlException(
                    String.Format("option {0} was not found in element with selected option: {1}", optionText, _ElementScope.SelectedOption));
            }

            return option;
        }

        private string GetClosestOption(string optionText)
        {
            if (String.IsNullOrWhiteSpace(optionText)) throw new ArgumentNullException("optionText");

            var optionsDictionary = RetryPolicy.SyncStaleElement.Execute(() => GetOptionsDictionaryAlphanumericOnly());
            var searchText        = optionText.RemoveNonAlphanumeric();

            if (String.IsNullOrWhiteSpace(searchText))
            {
                optionsDictionary = RetryPolicy.SyncStaleElement.Execute(() => GetOptionsDictionary());
                searchText        = optionText;
            }

            var option = optionsDictionary.FirstOrDefault(x => x.Value.Equals(searchText, StringComparison.OrdinalIgnoreCase)).Key;

            if (ReferenceEquals(option, null))
            {
                option = optionsDictionary.FirstOrDefault(x => x.Value.Contains(searchText, StringComparison.OrdinalIgnoreCase)).Key;
            }

            if (ReferenceEquals(option, null))
            {
                throw new MissingHtmlException(
                    String.Format("close option {0} was not found in element with selected option: {1}", optionText, _ElementScope.SelectedOption));
            }

            return option;
        }

        private IDictionary<string, string> GetOptionsDictionary()
        {
            var selectOptions = FindAllSessionElementsByXPath("option");

            if (!selectOptions.Any()) throw new InvalidOperationException("Element has no options");

            var optionsDictionary = selectOptions.ToDictionary(d => d.GetAttribute("value"), d => d.Text);

            return optionsDictionary;
        }

        private IDictionary<string, string> GetOptionsDictionaryAlphanumericOnly()
        {
            var selectOptions = FindAllSessionElementsByXPath("option");

            if (!selectOptions.Any()) throw new InvalidOperationException("Element has no options");

            var optionsDictionary = selectOptions.ToDictionary(d => d.GetAttribute("value"), d => d.Text.RemoveNonAlphanumeric());

            return optionsDictionary;
        }

        internal IEnumerable<string> GetSelectListOptions()
        {
            var selectOptionsElements = FindAllSessionElementsByXPath("option");

            if (!selectOptionsElements.Any()) throw new InvalidOperationException("Element has no options");

            var selectOptions = selectOptionsElements.Select(d => d.Text);

            return selectOptions;
        }

        internal void SelectSingleListBoxOption(string optionText)
        {
            if (String.IsNullOrWhiteSpace(optionText)) throw new ArgumentNullException("optionText");

            var originalOption = _ElementScope.SelectedOption;

            SelectOptionAlphanumericOnly(optionText);

            //de-select the original option in the case where list box can accept multiple selection but doesn't contain an empty option value
            SelectOptionAlphanumericOnly(originalOption);
        }
    }
}
