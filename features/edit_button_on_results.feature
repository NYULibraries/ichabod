Feature: Edit button on the detailed search results page
  As an authorized Ichabod user
  I want to be able to use the existing search interface to find records to edit
  And then click an "edit" link on the resulting detail page

  @loggedin @wip
  Scenario:authorized user can call edit form and edit a record using search interface
    Given I am logged in as an admin
    And the record "Story" exists
    And I search for "Story"
    And I navigate to details display of the first result
    And I click on the first "Edit" link
    Then I should get to the edit form for "Story"
    When I enter the fields:
      | Title        | Advice |
    And I save the record
    Then I should see the message "Item was successfully updated."
    When I search on the phrase "Advice"
    Then I should see search results

  @loggedin @wip
  Scenario:authorized user can call edit form and edit a record using search interface
    Given I am logged in as an admin
    And the record "Big Novel" exists
    And I search for "Big Novel"
    And I click on the first "Edit" link
    Then I should get to the edit form for "Big Novel"
    When I enter the fields:
      | Title        | War and Peace |
    And I save the record
    Then I should see the message "Item was successfully updated."
    When I search on the phrase "War and Peace"
    Then I should see search results
