Feature: Collection facet
  In order to home in on the collections that I am interested in
  As a user searching Ichabod
  I want to filter my search results by a "Collection" facet.

  Scenario: Filter by single collection
    Given I am on the default search page
    When I filter my search to "ESRI" under the "Collection" category
    Then I should see search results

  Scenario: Filter by multiple intersecting collections
    Given I am on the default search page
    When I filter my search to "ESRI" under the "Collection" category
    And I filter my search to "Spatial Data Repository" under the "Collection" category
    Then I should see search results

  @vcr_collection
  Scenario: Filter by The Real Rosie the Riveter
    Given I am on the default search page
    When I filter my search to "The Real Rosie the Riveter" under the "Collection" category
    Then I should see search results

  @vcr_collection
  Scenario: Filter by Voices of the Food Revolution
    Given I am on the default search page
    When I filter my search to "Voices of the Food Revolution" under the "Collection" category
    Then I should see search results
