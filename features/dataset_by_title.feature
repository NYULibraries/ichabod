@vcr
Feature: Find Geospatial dataset by title
    In order to find a Geospatial dataset with known title
    As a visitor
    I would like to limit my search to "Format" facet "Geospatial Data" and get relevant search results


    Scenario: Search dataset by title
        Given I Limit search to "Geospatial Data" in "Format" category
        And I search for "MapPLUTO"
        Then I get dataset with title "MapPLUTO"
         
        
        
