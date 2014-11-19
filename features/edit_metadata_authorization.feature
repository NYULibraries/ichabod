Feature: Permission to edit metadata only to authorized users
  In order to protect my own metadata and others from inadvertent modification
  As a logged in cataloger
  I want to have permission to edit metadata only for items of which I am an authorized user

  @loggedin
  Scenario: Edit option for GIS records is available to GIS cataloger
    Given I am logged in as "GIS Cataloger"
    And I view record with id "sdr:DSS-NYCDCP_Mappluto_Test_11v1-DSS-jam_mappluto_7OR"
    Then the record should have link "Edit"

  @loggedin
  Scenario: Edit option for GIS records is not available to FDA cataloger
    Given I am logged in as "FDA Cataloger"
    And I view record with id "sdr:DSS-NYCDCP_Mappluto_Test_11v1-DSS-jam_mappluto_7OR"
    Then the record should not have link "Edit"

  Scenario: Edit option for GIS records is not available to unathenticated user
    Given I am not logged in
    And I view record with id "sdr:DSS-NYCDCP_Mappluto_Test_11v1-DSS-jam_mappluto_7OR"
    Then the record should not have link "Edit"

  @loggedin
  Scenario: Edit option is available to AFC group for ArchiveIt ACCW records
    Given I am logged in as an admin
    And I view record with id "ai-accw:261ca521648b64ea12e077a254b58553"
    Then the record should have link "Edit"

  @loggedin
  Scenario: Edit option is not available to GIS Cataloger for ArchiveIt ACCW records
    Given I am logged in as "GIS Cataloger"
    And I view record with id "ai-accw:261ca521648b64ea12e077a254b58553"
    Then the record should not have link "Edit"

  Scenario: Edit option is not available to an unauthenticated user for ArchiveIt ACCW records
    Given I am not logged in
    And I view record with id "ai-accw:261ca521648b64ea12e077a254b58553"
    Then the record should not have link "Edit"

  Scenario: Edit option for GIS records is available to GIS cataloger on the main search page
    Given I am logged in as "GIS Cataloger"
    And I search for "MapPluto"
    Then the record should have link "Edit"

  @loggedin
  Scenario: Edit option for GIS records is available to GIS cataloger on the details display search page
    Given I am logged in as "GIS Cataloger"
    And I search for "MapPluto"
    And I navigate to details display of the first result
    Then the record should have link "Edit"

  @loggedin
  Scenario: Edit option for GIS records is not available to FDA cataloger on the main search page
    Given I am logged in as "FDA Cataloger"
    And I search for "MapPluto"
    Then the record should not have link "Edit"

 @loggedin
  Scenario: Edit option for GIS records is not available to FDA cataloger on the details display search page
    Given I am logged in as "FDA Cataloger"
    And I search for "MapPluto"
    And I navigate to details display of the first result
    Then the record should not have link "Edit"

  Scenario: Edit option for GIS records is not available to unathenticated user on the main search page
    Given I am not logged in
    And I search for "MapPluto"
    Then the record should not have link "Edit"

 Scenario: Edit option for GIS records is not available to unathenticated user on the details display search page
    Given I am not logged in
    And I search for "MapPluto"
    And I navigate to details display of the first result
