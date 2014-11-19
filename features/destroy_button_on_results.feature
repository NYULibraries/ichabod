Feature: Destroy button on main and detailed search results pages
  As an authorized Ichabod user
  I want to be able to use the existing search interface to find records to delete
  And then use the "Delete" link to delete the record

  @loggedin
  Scenario: authorized user can delete record from the main search page and return to search results
    Given I am logged in as an admin
    And "12" records "The Crab" exists
    And I search for "The Crab"
    And I navigate to the page "2" of the search results
    And I click on the first "Delete" link
    Then the number of records should decrease to "11"
    And I should return to the page "1" of the search results

 @loggedin
  Scenario: authorized user can delete record from the details display page and return to search results
    Given I am logged in as an admin
    And "12" records "The Novel" exists
    And I search for "The Novel"
    And I navigate to the page "2" of the search results
    And I click on the last "Delete" link
    Then the number of records should decrease to "11"
    And I should return to the page "2" of the search results

  Scenario: unauthorized user shouldn't see destroy link on the main search page
    Given I am not logged in
    And I search for "Map"
    Then the record should not have link "Delete"

  Scenario: unauthorized user shouldn't see destroy link on the details display page
    Given I am not logged in
    And I search for "Map"
    And I navigate to details display of the first result
    Then the record should not have link "Delete"
