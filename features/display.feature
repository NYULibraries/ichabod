@vcr
Feature: Click "Download" link for Geospatial dataset
  In order to download a Geospatial dataset
  As an on-campus NYU patron
  Once I’ve found a dataset in Ichabod, I need to be able to click on a download link

  Scenario: Display "Online Resource" field in search results
    Given I am on the default search page
    When I perform an empty search
    And I limit my results to "Geospatial Data" under the "Format" category
    Then I should get "Online Resource" field in all results

  Scenario: Display "Online Resource" field in details display
    Given I limit my search to "Geospatial Data" under the "Format" category
    And I search for "MapPLUTO"
    When I navigate to details display of the first result
    Then I should get "Online Resource" field in the details display

  Scenario: Click "Download" link for Geospatial dataset from search results
    Given I limit my search to "Geospatial Data" under the "Format" category
    And I search for "MapPLUTO"
    Then I should get a dataset with the link "Download"

  Scenario: Click "More Info" link for Geospatial dataset in from details display
    Given I limit my search to "Geospatial Data" under the "Format" category
    And I search for "MapPLUTO"
    When I navigate to details display of the first result
    Then I should see the link "GIS Dataset Instructions" in the "Additional Information:" field
