@vcr
Feature: Add, edit and delete records
  In order to provide complete records and maintain them within Ichabod
  As a record maintainer
  I want to be able to add, edit and delete records locally

  @loggedin
  Scenario: Adding a record
    Given I am logged in as "GIS Cataloger"
    And I am on the "New Item" form
    When I enter the fields:
      | Title        | A Comedy of Errors  |
      | Creator      | Bill Shakespeare    |
      | Publisher    | Penguin Classics    |
      | Identifier   | Id 123              |
      | Available    | DSS.ESRI_10_Streetmap\DSS.airports_ABU  |
      | Type         | Text                |
      | Description  | The Comedy of Errors is one of William Shakespeare's blah blahs |
      | Edition      | 1st                 |
      | Series       | ESRI_10_STREETMAP   |
      | Version      | 2nd                 |
      | Date         | 1594                |
      | Format       | Geospatial data     |
      | Language     | English             |
      | Relation     | Not sure what this is |
      | Rights       | All rights          |
      | Subject      | Plays               |
      | Citation     | B Shakes, SPC       |
    And I save the record
    Then I should see the message "Item was successfully created."
    When I search on the phrase "A Comedy of Errors"
    Then I should see search results

  Scenario: Editing a record

  Scenario: Deleting a record
