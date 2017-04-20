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
    And I view record with id "sdr:hdl-handle-net-2451-33876"
    When I click on "Edit"
    Then I should see the immutable fields:
      | Identifier    | http://hdl.handle.net/2451/33876            |
      | Available     | https://geo.nyu.edu/catalog/nyu_2451_33876  |
      | Title         | National Jewish Population Map by County    |
      | Creator       | Joshua Comenetz |
      | Type          | Geospatial Data                             |
      | Publisher     | The Jewish Federations of North America                   |
      | Description   | This file is an estimate of the number of Jewish persons in the U.S. by county in 2010 census geographies, based upon multiple sources of data, including Jewish community studies available at the Jewish Data Bank, the Data Bank's Current Jewish Population Report series, and the American Community Survey. Joshua Comenetz used indicators like language spoken and ancestry in the absence of standard demographic data to measure Jewish populations. For more information on the methodology used to compile this data set, see the Jewish Data Bank. |
      | Rights        | Public                                      |
      | Subject       | Judaism  |

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

  @loggedin
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
