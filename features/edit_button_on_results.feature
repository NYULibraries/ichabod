Feature: Edit and Destroy button on detailed search results page
  As an authorized Ichabod user
  I want to be able to use the existing search interface to find records to edit
  And then click an "edit" link on the resulting detail page
  
  @loggedin
  Scenario: Edit button available to loggedin user on detailed search result page and user can edit
    an item, using it
    Given I am logged in as an admin
    And I search for "Map"
    When I navigate to details display of the first result
    Then the record should have link "Edit"
    When I click on "Edit"
    Then I should get to the "edit" form

  @loggedin
  Scenario: Destroy button available to loggedin user on the detailed search results page and user can destroy
    an item, using it
    Given I am logged in as an admin
    And the record "The Crab" exists
    And I search for "The Crab"
    When I navigate to details display of the first result
    Then the record should have link "Destroy"
    When I click on "Destroy"
    And I search for "The Crab"
    Then I should not see search results

  Scenario: Edit and Destory option not available to unathenticated user on the detailed search results page
    Given I am not logged in
    And I search for "Map"
    When I navigate to details display of the first result
    Then the record should not have link "Edit"
    Then the record should not have link "Destroy"

  @loggedin
  Scenario: Edit button available to loggedin user on search result page and user can edit
    an item, using it
    Given I am logged in as an admin
    And I search for "Map"
    Then the search results should have link "Edit"
    When I click on the first "Edit" link
    Then I should get to the "edit" form

  @loggedin
  Scenario: Destroy button available to loggedin user on search result page and user can destroy
    an item, using it
    Given I am logged in as an admin
    And the record "The Crab" exists
    And I search for "The Crab"
    Then the search results should have link "Destroy"
    When I click on the first "Destroy" link
    Then I should not see search results

  Scenario: Edit option not available to unathenticated user on search result page
    Given I am not logged in
    And I search for "Map"
    Then the record should not have link "Edit"
    Then the record should not have link "Destroy"
