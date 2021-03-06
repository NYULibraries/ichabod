Feature: Perform a basic search
  In order to retrieve results from the respository
  As an NYU user
  I want to perform a basic search and get results

  Scenario: Empty search
    Given I am on the default search page
    When I perform an empty search
    Then I should see search results

  Scenario: Search by keyword
    Given I am on the default search page
    When I search on the phrase "new york city"
    Then I should see search results


  Scenario: Search by keyword and limit results by facet
    Given I am on the default search page
    When I search on the phrase "books"
    And I limit my results to "Book" under the "Format" category
    Then I should see search results

  Scenario: Search by geographic location and limit results by facet
    Given I am on the default search page
    When I search on the phrase "New York City"
    And I limit my results to "Geospatial Data" under the "Format" category
    Then I should see search results


  Scenario: Search by geographic location and topic and limit results by facet
    Given I am on the default search page
    When I search on the phrase "Buenos Aires"
    And I limit my results to "Geospatial Data" under the "Format" category
    Then I should see search results

  Scenario: Limit language by iso 639-2 English term
    Given I am on the default search page
    And I limit my results to "English" under the "Language" category
    Then I should see search results

  @vcr
  Scenario: Search for Rosie the Riveter interview subject's name
    Given I am on the default search page
    When I search on the phrase "Jerre Kalbas"
    Then I should see search results

  @vcr
  Scenario: Search for Voices of the Food Foundation interview subject's name
    Given I am on the default search page
    When I search on the phrase "Dan Barber"
    Then I should see search results

  Scenario: Search for a Research Guide title and limit by "Format"
    Given I am on the default search page
    When I search on the phrase "Data Services"
    And I limit my results to "Research Guide" under the "Format" category
    Then I should see search results

  Scenario: Search for Asian NGO report title and limit by "Format"
    Given I am on the default search page
    When I search on the phrase "Hijras"
    And I limit my results to "Report" under the "Format" category
    Then I should see search results

  Scenario: Search for Archive of Contemporary Composers Websites title
    Given I am on the default search page
    When I search on the phrase "www.louiskarchin.com"
    Then I should see search results

  Scenario: Search for The Masses entity title
    Given I am on the default search page
    When I search on the phrase "March 1911"
    Then I should see search results

  @vcr
  Scenario: Search by ISBN
    Given I am on the default search page
    When I search on the phrase "9780814706404"
    Then I should see search results

  @vcr
  Scenario: Search for NYU Press
    Given I am on the default search page
    When I limit my results to "NYU Press Open Access Books" under the "Collection" category
    When I navigate to details display of the first result
    Then I should see the value "9780814706404" in the "ISBN:" field

  Scenario: Search for The Data Services Collection title
    Given I am on the default search page
    When I search on the phrase "Gallup GPSS"
    Then I should see search results

  @vcr
  Scenario: Search for David Wojnarowicz Papers records title
    Given I am on the default search page
    When I search on the phrase "Human Head III"
    Then I should see search results

  @loggedin
  Scenario: Search for The Indian Ocean Collection title for authorized user
    Given I am logged in as "IO Cataloger"
    And I am on the default search page
    When I search on the phrase "VII Battaglione Eritreo"
    Then I should see search results

  Scenario: Search for The Indian Ocean Collection title for un-authorized user
    And I am on the default search page
    When I search on the phrase "VII Battaglione Eritreo"
    Then I should not see search results
