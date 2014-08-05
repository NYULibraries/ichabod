@vcr
Feature: Permission to edit metadata only to authorized users
  In order to protect my own metadata and others from inadvertent modification
  As a logged in cataloger
  I want to have permission to edit metadata only for items of which I am an authorized user

  @loggedin
  Scenario: Edit option available to GIS cataloger for GIS records
    Given I am logged in as "GIS Cataloger"
    And I view record with id "sdr:DSS-NYCDCP_Mappluto_Test_11v1-DSS-jam_mappluto_7OR"
    Then the record should have link "Edit"

  @loggedin
  Scenario: Edit option not available to FDA cataloger for GIS records
    Given I am logged in as "FDA Cataloger"
    And I view record with id "sdr:DSS-NYCDCP_Mappluto_Test_11v1-DSS-jam_mappluto_7OR"
    Then the record should not have link "Edit"

  Scenario: Edit option not available to unathenticated user for GIS records
    Given I am not logged in
    And I view record with id "sdr:DSS-NYCDCP_Mappluto_Test_11v1-DSS-jam_mappluto_7OR"
    Then the record should not have link "Edit"
