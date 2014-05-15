@vcr
Feature: Login as a user
  In order to have permissions specific to me
  As a valid NYU user
  I want to be able to login to Ichabod

  @loggedin
  Scenario: Logged in GIS Cataloger
    Given I am on the default search page
    And I am logged in as "GIS Cataloger"
    Then I should see "Log-out"

  @loggedin
  Scenario: Logged in FDA Cataloger
    Given I am on the default search page
    And I am logged in as "FDA Cataloger"
    Then I should see "Log-out"
