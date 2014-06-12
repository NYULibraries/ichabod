@vcr
Feature: Permission to edit metadata only to authorized users
  As a GIS cataloger,
  I want to have permission to edit metadata
  Only for GIS items

  @loggedin_GIS
    Scenario: Edit option available to GIS cataloger for GIS records
    Given I am logged in as "GIS Cataloger"
    And I view record with id "sdr:DSS-NYCDCP_Mappluto_Test_11v1-DSS-jam_mappluto_7OR"
    Then the record should have link "Edit"

  @loggedin_FDA
    Scenario: Edit option not available to FDA cataloger for GIS records
    Given I am logged in as "FDA Cataloger"
    And I view record with id "sdr:DSS-NYCDCP_Mappluto_Test_11v1-DSS-jam_mappluto_7OR"
    Then the record should not have link "Edit"

  
    Scenario: Edit option not available to unathenticated user for GIS records
    Given I am not logged in
    And I view record with id "sdr:DSS-NYCDCP_Mappluto_Test_11v1-DSS-jam_mappluto_7OR"
    Then the record should not have link "Edit"
