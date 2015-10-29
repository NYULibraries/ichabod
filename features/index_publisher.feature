Feature: Index publisher
  In order to use GIS dataset data in my research
  As an NYU patron
  I want to find GIS datasets from a known publisher

  Scenario: Search by keyword (publisher) and limit search by facet
    Given I am on the default search page
    When I search on the phrase "Buenos Aires"
    Then I should see search results
    And I should see a "Geospatial Data" facet under the "Format" category
