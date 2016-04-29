Medidata Classification Regression Tests Solution
=======================

Regression Tests intended to verify the classification of medical terms in Medidata products.

## Objective

The regression test solution includes feature scenarios, step definitions, browser and page objects to verify the classification of medical terms from Rave in Coder. There are currently three (3) feature projects to cover various classification scenarios.

## Coder Coder 
Coder Core tests verify the Coder UI and processes through simulation of Rave coding requests and UI interactions.
The project is currently named Coder.Regression and should be renamed to Coder Core.

## End to End
End to End tests verify the integration of Coder with other Medidata systems, Rave and iMedidata. These tests use a combination of UI interactions in all applications with API and DB stored procedures to execute scenarios.
https://learn.mdsol.com/display/CODERteam/2016/04/25/Coder+Rave+Integration+Automated+ETE+Test+Setup

## Application Monitoring
The Application	Monitoring tests are specialized End to End tests. They are intended to be executed in a production or test environment on a schedule to monitor issues in the target environment. These test only utilize UI interactions in iMedidata, Rave, and Coder to simulate true use of the system.
https://learn.mdsol.com/display/CODERteam/Coder+Production+Application+Monitoring

## Contributing

If you would like to help make Coder better, please read over our [contributing](CONTRIBUTING.md) document.
There you will find how to setup the environment and structuring your code to meet our standards.

## Issues

All issues for Coder are tracked in [JIRA](https://jira.mdsol.com).
The Coder development team is 11.  Our task board is [Team 11 (Coder)](https://jira.mdsol.com/secure/RapidBoard.jspa?rapidView=170).
The Coder Rave Integration team is 70.  Our task board is [Team 70 (Coder - Rave Integration Team)](https://jira.mdsol.com/secure/RapidBoard.jspa?rapidView=702).
