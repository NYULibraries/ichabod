@vcr
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
    When I search on the phrase "nyc"
    Then I should see search results
