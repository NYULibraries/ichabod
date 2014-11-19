Feature: Edit and Destroy button on detailed search results page
  As an authorized Ichabod user
  I want to be able to use the existing search interface to find records to edit
  And then click an "edit" link on the resulting detail page
  
  @loggedin
  Scenario:authorized user can call edit form and edit a record using search interface
    Given I am logged in as an admin
    And the record "Novel" exists
    And I search for "Novel"
    And I navigate to details display of the first result
    And I click on the first "Edit" link
    Then I should get to the edit form for "Novel"
    When I enter the fields:
      | Title        | Crime and Panishment |
    And I save the record
    Then I should see the message "Item was successfully updated."
    When I search on the phrase "Crime and Panishment"
    Then I should see search results

  @loggedin
  Scenario:authorized user can call edit form and edit a record using search interface
    Given I am logged in as an admin
    And the record "The Novel" exists
    And I search for "The Novel"
    And I click on the first "Edit" link 
    Then I should get to the edit form for "The Novel"
    When I enter the fields:
      | Title        | War and Peace |
    And I save the record
    Then I should see the message "Item was successfully updated."
    When I search on the phrase "War and Peace"
    Then I should see search results
