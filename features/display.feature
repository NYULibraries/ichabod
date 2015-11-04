Feature: Various display tests
  In order to use a Geospatial dataset
  As an on-campus NYU patron
  Once I’ve found a dataset in Ichabod, I need to be able to click on a download link
  Once I've found a geospatial dataset, I would like to know my access restrictions
  In order to use the NYU Press Open Access Books collection
  As an on-campus NYU patron
  Once I’ve found a record for a book in Ichabod
  I need to be able to see in the details display both "Format: Book" and "Creator: [X]"

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
 
  Scenario: Display "Access restrictions" field in search results
    Given I am on the default search page
    When I perform an empty search
    And I limit my results to "Geospatial Data" under the "Format" category
    Then I should get "Access Restrictions" field and its corresponding value "NYU Only" in all results
    
  Scenario: Display "Access restrictions" field in the details display
    Given I limit my search to "Geospatial Data" under the "Format" category
    And I search for "LION"
    When I navigate to details display of the first result
    Then I should see the value "NYU Only" in the "Access Restrictions:" field

  Scenario: Display "Book" field in the details display
    Given I limit my search to "NYU Press Open Access Books" under the "Collection" category
    And I search for "9780814712917"
    When I navigate to details display of the first result
    Then I should see the value "Book" in the "Format:" field

  Scenario: Display "Creator" field in the details display
    Given I limit my search to "NYU Press Open Access Books" under the "Collection" category
    And I search for "9780814712917"
    When I navigate to details display of the first result
    Then I should see the value "Gail R. Benjamin" in the "Creator:" field