Feature: Add, edit and delete collections
  As a collection curator,
  I want to see my resources organized in Ichabod by collection,
  which I can add, delete and edit

  @loggedin
  Scenario: Adding a collection
    Given I am logged in as an admin
    And I am on the "New Collection" form
    When I enter the fields:
      | Collection Name        | Old Russian Books |
      | Provider      | Unknown Russian Immigrant    |
      | Publisher    |  Russian Leterature Department   |
      | Description  | Collection of underground soviet poetry |
      | Rights       | All rights          |
      
    And I save the record
    Then I should see the message "Collection was successfully created."


  @loggedin
  Scenario: Adding a collection with multiple values in all multiple fields
    Given I am logged in as an admin
    And I am on the "New Collection" form
    When I enter the fields:
      | collection_title       |      Collection of Old Videos       |
      | collection_creator       | Video Archive               |
      | collection_creator1    | Video Owners |
      | collection_publisher       | Department of Video Preservation              |
      | collection_publisher1    | Video Archive |
    Then I should see the message "Collection was successfully created."
    When I click on "Edit"
    Then I should see the fields:
      | collection_title       |      Collection of Old Videos       |
      | collection_creator       | Video Archive               |
      | collection_creator1    | Video Owners |
      | collection_publisher       | Department of Video Preservation            |
      | collection_publisher1    | Video Archive |

  @loggedin
  Scenario: Editing a record
    Given I am logged in as an admin
    And the collection "Audio Collection" exists
    And I am on the "Edit Collection" form for "Audio Collection"
    When I enter the fields:
      | Title        | The Underground Soviet Rock |
    And I save the record
    Then I should see the message "Collection was successfully updated."
    When I am on the collections list
    Then I should see "The Underground Soviet Rock"

  @loggedin
  Scenario: Deleting a record
    Given I am logged in as an admin
    And the collection "The Photo Collection" exists
    When I am on the collections list
    And I click on the "Delete" link for "The Photo Collection"
    Then the collection should be deleted