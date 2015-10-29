# Scenarios 2 and 3 can't be tested now
# New data can be added. Source data can not be changed
# I don't know how this passed before

Feature: See up-to-date metadata for GIS datasets in Ichabod
  In order to trust that the information I'm viewing is accurate
  As an NYU Patron
  I would like to confirm that external data updates are reflected in Ihcabod


  Scenario: Check value of Publisher field before update
    Given I limit my search to "Geospatial Data" under the "Format" category
    And I search for "2013 Hospital Zone Areas in Buenos Aires"
    When I navigate to details display of the first result
    Then I should see the value "Buenos Aires (Argentina)." in the "Publisher:" field

  @wip 
  Scenario: Update data and check for new value of Publisher field
    Given I change the "Spatial Data Repository" source data in the "publisher" field to "Buenos Aires Dept of City Planning" for the record identified by "hdl-handle-net-2451-34036"
    And I reload the "Spatial Data Repository" source data into Ichabod
    When I limit my search to "Geospatial Data" under the "Format" category
    And I search for "2013 Hospital Zone Areas in Buenos Aires"
    And I navigate to details display of the first result
    Then I should see the value "Buenos Aires Dept of City Planning" in the "Publisher:" field

  @wip
  Scenario: Revert data and check for original value of Publisher field
    Given I revert the "Spatial Data Repository" source data in the "publisher" field to "Buenos Aires (Argentina)." for the record identified by "sdr:hdl-handle-net-2451-34036"
    And I reload the "Spatial Data Repository" source data into Ichabod
    When I limit my search to "Geospatial Data" under the "Format" category
    And I search for "2013 Hospital Zone Areas in Buenos Aires"
    And I navigate to details display of the first result
    Then I should see the value "Buenos Aires (Argentina)." in the "Publisher:" field
