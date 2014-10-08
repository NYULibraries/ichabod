Feature: Find Geospatial dataset by title
  In order to find a Geospatial dataset with a known title
  As a visitor
  I would like to limit my search to the "Format" facet "Geospatial Data" and get relevant search results

  Scenario: Search dataset by title
    Given I limit my search to "Geospatial Data" under the "Format" category
    And I search for "MapPLUTO"
    Then I get a dataset with the title "MapPLUTO"
