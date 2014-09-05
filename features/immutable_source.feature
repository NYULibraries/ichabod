@vcr
Feature: Source fields immutable, edit native fields
  In order to protect batch loaded values and provide richer access
  As a record maintainer
  I want to be able to add and edit native fields without altering source data

  Scenario: Check value of Publisher field before update
    Given I limit my search to "Geospatial Data" under the "Format" category
    And I search for "New York City Fire Battalions"
    When I navigate to details display of the first result
    Then I should see the value "New York City Department of City Planning" in the "Publisher:" field

  @loggedin
  Scenario: Check that source metadata fields are not editable
    Given I am logged in as "GIS Cataloger"
    And I view record with id "sdr:DSS-NYCDCP_Admin_Bndry_10cav-DSS-nyfb_05R"
    When I click on "Edit"
    Then I should see the immutable fields:
      | Identifier    | DSS.NYCDCP_Admin_Bndry_10cav\DSS.nyfb_05R   |
      | Title         | New York City Fire Battalions               | 
      | Publisher     | New York City Department of City Planning   | 
      | Available     | http://magellan.home.nyu.edu/datasets/zips/NYCDCP_ADMIN_BNDRY_10CAV-nyfb_05R.zip | 
      | Type          | Geospatial Data                             | 
      | Description   | The service area boundaries for New York City's fire battalions. | 
      | Edition       | 10C                                         | 
      | Series        | NYCDCP_ADMIN_BNDRY_10CAV                    |
      | Version       | DSS.NYCDCP_Admin_Bndry_10cav\DSS.nyfb_05R  | 
    And I enter the fields:
      | nyucore_title1       | A Pile of Monkeys   |
      | nyucore_creator      | An Orangutan        |
      | nyucore_publisher1   | Penguin Publishing  |
    And I save the record
    Then I should see the message "Item was successfully updated."
    When I search on the phrase "A Pile of Monkeys"
    Then I should see search results