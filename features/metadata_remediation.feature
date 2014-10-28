Feature: Add, edit and delete records
  In order to provide complete records and maintain them within Ichabod
  As a record maintainer
  I want to be able to add, edit and delete records locally

  @loggedin
  Scenario: Adding a record
    Given I am logged in as an admin
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

  @loggedin
  Scenario: Adding a record with multiple values in all multiple fields
    Given I am logged in as an admin
    And I am on the "New Item" form
    And I click on all the "+" buttons
    When I enter the fields:
      | Title                 | As You Like It      |
      | nyucore_available     | DSS.ShakeIt         |
      | nyucore_available1    | DSS.ShakeIt1        |
      | nyucore_description   | As You Like It      |
      | nyucore_description1  | As You Like It1     |
      | nyucore_edition       | 1st                 |
      | nyucore_edition1      | 1st1                |
      | nyucore_series        | ESRI_10_STREETMAP   |
      | nyucore_series1       | ESRI_10_STREETMAP1  |
      | nyucore_version       | 2nd                 |
      | nyucore_version1      | 2nd1                |
      | nyucore_date          | 1594                |
      | nyucore_date1         | 15941               |
      | nyucore_format        | Geospatial data     |
      | nyucore_format1       | Geospatial data1    |
      | nyucore_language      | English             |
      | nyucore_language1     | English1            |
      | nyucore_relation      | Not sure what this is  |
      | nyucore_relation1     | Not sure what this is1 |
      | nyucore_rights        | All rights          |
      | nyucore_rights1       | All rights1         |
      | nyucore_subject       | Plays               |
      | nyucore_subject1      | Plays1              |
      | nyucore_citation      | B Shakes, SPC       |
      | nyucore_citation1     | B Shakes, SPC1      |
    And I save the record
    Then I should see the message "Item was successfully created."
    When I click on "Edit"
    Then I should see the fields:
      | nyucore_available     | DSS.ShakeIt         |
      | nyucore_available1    | DSS.ShakeIt1        |
      | nyucore_description   | As You Like It      |
      | nyucore_description1  | As You Like It1     |
      | nyucore_edition       | 1st                 |
      | nyucore_edition1      | 1st1                |
      | nyucore_series        | ESRI_10_STREETMAP   |
      | nyucore_series1       | ESRI_10_STREETMAP1  |
      | nyucore_version       | 2nd                 |
      | nyucore_version1      | 2nd1                |
      | nyucore_date          | 1594                |
      | nyucore_date1         | 15941               |
      | nyucore_format        | Geospatial data     |
      | nyucore_format1       | Geospatial data1    |
      | nyucore_language      | English             |
      | nyucore_language1     | English1            |
      | nyucore_relation      | Not sure what this is  |
      | nyucore_relation1     | Not sure what this is1 |
      | nyucore_rights        | All rights          |
      | nyucore_rights1       | All rights1         |
      | nyucore_subject       | Plays               |
      | nyucore_subject1      | Plays1              |
      | nyucore_citation      | B Shakes, SPC       |
      | nyucore_citation1     | B Shakes, SPC1      |

  @loggedin
  Scenario: Editing a record
    Given I am logged in as an admin
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
    Given I am logged in as an admin
    Given the record "The Tempest" exists
    Given I search for "The Tempest"
    When I delete the record
    Then I search on the phrase "The Tempest"
    And I should not see search results
