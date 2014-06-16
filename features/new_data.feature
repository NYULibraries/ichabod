@vcr
Feature: See up-to-date metadata for GIS datasets in Ichabod
  In order to trust that the information I'm viewing is accurate
  As an NYU Patron
  I would like to confirm that external data updates are reflected in Ihcabod

  Scenario: Check value of Publisher field before update
    Given I limit my search to "Geospatial Data" under the "Format" category
    And I search for "New York City Fire Battalions"
    When I navigate to details display of the first result
    Then I should see the value "New York City Department of City Planning" in the "Publisher:" field

  Scenario: Update data and check for new value of Publisher field
    Given I update "sdr" data to "spec/fixtures/new_battalions.xml" outside of Ichabod 
    And I limit my search to "Geospatial Data" under the "Format" category
    And I search for "New York City Fire Battalions"
    When I navigate to details display of the first result
    Then I should see the value "New York City Dept of City Planning" in the "Publisher:" field

  Scenario: Revert data and check for original value of Publisher field
    Given I update "sdr" data to "spec/fixtures/orig_battalions.xml" outside of Ichabod 
    And I limit my search to "Geospatial Data" under the "Format" category
    And I search for "New York City Fire Battalions"
    When I navigate to details display of the first result
    Then I should see the value "New York City Department of City Planning" in the "Publisher:" field
