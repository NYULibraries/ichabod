Feature: Source fields immutable, edit native fields
  In order to protect batch loaded values and provide richer access
  As a record maintainer
  I want to be able to add and edit native fields without altering source data


  Scenario: Check value of Publisher field before update
    Given I limit my search to "Geospatial Data" under the "Format" category
    And I search for "Buenos Aires"
    When I navigate to details display of the first result
    Then I should see the value "Buenos Aires (Argentina)." in the "Publisher:" field

  @loggedin
  Scenario: Check that source metadata fields are not editable
    Given I am logged in as "GIS Cataloger"
    And I view record with id "sdr:hdl-handle-net-2451-34036"
    When I click on "Edit"
    Then I should see the immutable fields:
      | Identifier    | http://hdl.handle.net/2451/34036            |
      | Available     | http://hdl.handle.net/2451/34036            |
      | Title         | 2013 Hospital Zone Areas in Buenos Aires    |
      | Creator       | Government of the Autonomous City of Buenos Aires |
      | Type          | Geospatial Data                             |
      | Publisher     | Buenos Aires (Argentina).                   |
      | Description   | This map is the boundaries and the names of the hospital zone areas in Buenos Aires, Argentina. It is taken from the City of Buenos Aires GIS and data center, and full documentation is available at http://data.buenosaires.gob.ar/dataset/areas-hospitalarias/resource/c1caac1d-6055-44fa-9367-c30c36424610 |
      | Date          | 07/02/2013                                  |
      | Language      | English                                     |
      | Rights        | Public                                      |
      | Subject       | Buenos Aires Metropolitan Area (Argentina)--Maps  |

  @loggedin
  Scenario: Check that native metadata fields are editable
    Given I am logged in as "GIS Cataloger"
    And I view record with id "sdr:hdl-handle-net-2451-34036"
    When I click on "Edit"
    And I enter the fields:
      | nyucore_title        | A Pile of Monkeys   |
      | nyucore_creator      | An Orangutan        |
      | nyucore_publisher    | Penguin Publishing  |
    And I save the record
    Then I should see the message "Item was successfully updated."
    When I search on the phrase "A Pile of Monkeys"
    Then I should see search results

  @loggedin
  Scenario: Check that native metadata multiples are editable
    Given I am logged in as "GIS Cataloger"
    And I view record with id "sdr:hdl-handle-net-2451-34036"
    When I click on "Edit"
    And I click on all the "+" buttons
    And I enter the fields:
      | nyucore_title1       | Another Monkey Title  |
      | nyucore_creator1     | An Echidna            |
      | nyucore_publisher1   | Another Imprint       |
      | nyucore_description  | A native description  |
      | nyucore_description1 | A 2nd native desc     |
      | nyucore_date         | Today                 |
      | nyucore_date1        | Tomorrow              |
    And I save the record
    Then I should see the message "Item was successfully updated."
    When I search on the phrase "Echidna"
    Then I should see search results

  @loggedin @me
  Scenario: Check that native doesn't overwrite source metadata
    Given I am logged in as "GIS Cataloger"
    And I view record with id "sdr:hdl-handle-net-2451-34036"
    When I click on "Edit"
    And I enter the fields:
      | nyucore_title        | A Pile of Monkeys   |
      | nyucore_creator      | An Orangutan        |
      | nyucore_publisher    | Penguin Publishing  |
    And I save the record
    Then I should see the message "Item was successfully updated."
    When I search on the phrase "Buenos Aires"
    Then I should see search results
    When I navigate to details display of the first result
    Then I should see the value "Buenos Aires (Argentina)." in the "Publisher:" field
    And I should see the value "Penguin Publishing" in the "Publisher:" field


  Scenario: Check that source doesn't overwrite native metadata
    Given I revert the "Spatial Data Repository" source data in the "publisher" field to "Buenos Aires (Argentina)." for the record identified by "sdr:hdl-handle-net-2451-34036"
    And I reload the "Spatial Data Repository" source data into Ichabod
    And I limit my search to "Geospatial Data" under the "Format" category
    And I search for "Buenos Aires"
    And I navigate to details display of the first result
    Then I should see the value "Buenos Aires (Argentina)." in the "Publisher:" field
    And I should see the value "Penguin Publishing" in the "Publisher:" field
