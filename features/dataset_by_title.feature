Feature: Find Geospatial dataset by title
    In order to find a Geospatial dataset with known title
    A visitor
    Should limit search to Geospatial Data
    And type the title in the search window

    Scenario: Search dataset by title
        Given I Limit search to "Geospatial Data" in "Format"
        And I search for "MapPLUTO"
        Then I get dataset with title "MapPLUTO"
         
        
        
