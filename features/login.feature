Feature: Login as a user
  In order to have permissions specific to me
  As a valid NYU user
  I want to be able to login to Ichabod

  @loggedin
  Scenario: Logged in GIS Cataloger
    Given I am logged in as "GIS Cataloger"
    And I am on the default search page
    Then I should see "Log-out"

  @loggedin
  Scenario: Logged in FDA Cataloger
    Given I am logged in as "FDA Cataloger"
    And I am on the default search page
    Then I should see "Log-out"

  @loggedin
  Scenario: Logged in and searching
    Given I am logged in as "GIS Cataloger"
    And I am on the default search page
    When I search on the phrase "nyc"
    Then I should see search results
    And I should see "Log-out"
