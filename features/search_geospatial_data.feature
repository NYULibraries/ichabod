Feature: Search geospatial data
  In order to have a complete search
  As a user
  I want to do a keyword search and limit search by facet

  Scenario: Search by keyword/phrase and limit search by facet
     Given I have datasets with terms like New York City highways
     When I enter the keyword highways 
     And I enter the phrase New York City 
     Then I find results
     And limit the results by a facet Geospatial Data

