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

  @loggedin @wip
  Scenario: Adding a record with multiple values in all multiple fields
    Given I am logged in as "GIS Cataloger"
    And I am on the "New Item" form
    And I click on all the "+" buttons
    When I enter the fields:
      | Title        | As You Like It      |
      | Available    | DSS.ShakeIt         |
      | Available    | DSS.ShakeIt1        |
      | Type         | Text                |
      | Type         | Text1               |
      | Description  | As You Like It      |
      | Description  | As You Like It1     |
      | Edition      | 1st                 |
      | Edition      | 1st1                |
      | Series       | ESRI_10_STREETMAP   |
      | Series       | ESRI_10_STREETMAP1  |
      | Version      | 2nd                 |
      | Version      | 2nd1                |
      | Date         | 1594                |
      | Date         | 15941               |
      | Format       | Geospatial data     |
      | Format       | Geospatial data1    |
      | Language     | English             |
      | Language     | English1            |
      | Relation     | Not sure what this is  |
      | Relation     | Not sure what this is1 |
      | Rights       | All rights          |
      | Rights       | All rights1         |
      | Subject      | Plays               |
      | Subject      | Plays1              |
      | Citation     | B Shakes, SPC       |
      | Citation     | B Shakes, SPC1      |
    And I save the record
    Then I should see the message "Item was successfully created."
    When I click on "Edit"
    Then I should see the fields:
      | Title        | As You Like It      |
      | Available    | DSS.ShakeIt         |
      | Available    | DSS.ShakeIt1        |
      | Type         | Text                |
      | Type         | Text1               |
      | Description  | As You Like It      |
      | Description  | As You Like It1     |
      | Edition      | 1st                 |
      | Edition      | 1st1                |
      | Series       | ESRI_10_STREETMAP   |
      | Series       | ESRI_10_STREETMAP1  |
      | Version      | 2nd                 |
      | Version      | 2nd1                |
      | Date         | 1594                |
      | Date         | 15941               |
      | Format       | Geospatial data     |
      | Format       | Geospatial data1    |
      | Language     | English             |
      | Language     | English1            |
      | Relation     | Not sure what this is  |
      | Relation     | Not sure what this is1 |
      | Rights       | All rights          |
      | Rights       | All rights1         |
      | Subject      | Plays               |
      | Subject      | Plays1              |
      | Citation     | B Shakes, SPC       |
      | Citation     | B Shakes, SPC1      |

  @loggedin
  Scenario: Editing a record
    Given I am logged in as "GIS Cataloger"
    And the record "Cymbeline" exists
    And I am on the "Edit Item" form for "Cymbeline"
    When I enter the fields:
      | Title        | The Tale of Imogen |
    And I save the record
    Then I should see the message "Item was successfully updated."
    When I search on the phrase "The Tale of Imogen"
    Then I should see search results

  @loggedin
  Scenario: Deleting a record
    Given I am logged in as "GIS Cataloger"
    And the record "The Tempest" exists
    When I delete the record
    Then I search on the phrase "The Tempest"
    And I should not see search results
