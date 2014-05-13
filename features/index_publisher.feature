@selenium
Feature: Index publisher
  In order to use GIS dataset data in my research
  As an NYU patron
  I want to find GIS datasets from a known publisher

Scenario: Search by keyword (publisher) and limit search by facet
  Given I am on the home page
#  Given NYU has loaded GIS dataset data published by ESRI
  When I search for "ESRI"
  Then I should see "ESRI" publications in the results
  And I should see a Geospatial Data facet under format
