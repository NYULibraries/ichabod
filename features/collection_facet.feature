Feature: Collection facet
  In order to home in on the collections that I am interested in
  As a user searching Ichabod
  I want to filter my search results by a "Collection" facet.

  Scenario: Filter by single collection
    Given I am on the default search page
    When I filter my search to "Spatial Data Repository" under the "Collection" category
    Then I should see search results

  @vcr
  Scenario: Filter by The Real Rosie the Riveter
    Given I am on the default search page
    When I filter my search to "The Real Rosie the Riveter" under the "Collection" category
    Then I should see search results
  @vcr
  Scenario: Filter by Voices of the Food Revolution
    Given I am on the default search page
    When I filter my search to "Voices of the Food Revolution" under the "Collection" category
    Then I should see search results

  Scenario: Filter by The Asian NGOs Reports
    Given I am on the default search page
    When I filter my search to "South Asian NGO and other reports" under the "Collection" category
    Then I should see search results

  Scenario: Filter by Archive of Contemporary Composers Websites
    Given I am on the default search page
    When I filter my search to "Archive of Contemporary Composers' Websites" under the "Collection" category
    Then I should see search results

  Scenario: Filter by The Masses
    Given I am on the default search page
    When I filter my search to "The Masses" under the "Collection" category
    Then I should see search results

  Scenario: Filter by The Data Service Collection
    Given I am on the default search page
    When I filter my search to "Data Services" under the "Collection" category
    Then I should see search results

  Scenario: Filter by The Spatial Data Repository
    Given I am on the default search page
    When I filter my search to "Spatial Data Repository" under the "Collection" category
    Then I should see search results

  @loggedin
  Scenario: Filter by Indian Ocean Collection for authorized users
    Given I am logged in as "IO Cataloger"
    And I am on the default search page
    When I filter my search to "Indian Ocean Postcards" under the "Collection" category
    Then I should see search results

  Scenario: Filter by Indian Ocean Collection for unauthorized users
    Given I am on the default search page
    Then I should not see a "Indian Ocean Collection" facet under the "Collection" category

  Scenario: Filter by Research Guides
    Given I am on the default search page
    When I filter my search to "Research Guides" under the "Collection" category
    Then I should see search results

  @vcr
  Scenario: Filter by David Wojnarowicz Papers
    Given I am on the default search page
    When I filter my search to "David Wojnarowicz Papers" under the "Collection" category
    Then I should see search results

