Feature: Add, edit and delete collections
  As a collection curator,
  I want to see my resources organized in Ichabod by collection,
  which I can add, delete and edit

  @loggedin
  Scenario: New Collection form
    Given I am logged in as an admin
    And I am on the "New Collection" form
    Then field "title" should be marked as required
    And field "discoverable" should be marked as required
    And field "discoverable" should be checked

  @loggedin
  Scenario: Adding a collection
    Given I am logged in as an admin
    And I am on the "New Collection" form
    When I enter the fields:
      | Collection Name        | Old Russian Books |
      | Provider      | Unknown Russian Immigrant    |
      | Department    |  Russian Literature Department   |
      | Abstract  | Collection of underground Soviet poetry |
      | Rights       | All rights          |

    And I click on "Create Collection"
    Then I should see the message "Collection was successfully created."

 @loggedin
 Scenario: Editing a record
    Given I am logged in as an admin
    And the collection "Audio Collection" exists
    And I am on the "Edit Collection" form for "Audio Collection"
    When I enter the fields:
      | Collection Name        | The Underground Soviet Rock |
    And I click on "Update Collection"
    Then I should see the message "Collection was successfully updated."
    When I am on the collections list
    Then I should see title "The Underground Soviet Rock" in the collections list

  @loggedin
  Scenario: Editing a collection with multiple values in all multiple fields
    Given I am logged in as an admin
    And the collection "Collection of Old Videos" exists
    And I am on the "Edit Collection" form for "Collection of Old Videos"
    When I enter the fields:
      | collection_creator   | Video Owners |
      | collection_publisher   | Video Archive |
    When I click on "Update Collection"
    And I click on "Edit"
    Then I should see the fields:
      | collection_creator0       | Special Collections            |
      | collection_creator1    | Video Owners |
      | collection_publisher0       | Special Collections           |
      | collection_publisher1       | DLTS             |
      | collection_publisher2    | Video Archive |

  @loggedin
  Scenario: Deleting a record
    Given I am logged in as an admin
    And the collection "The Photo Collection" exists
    When I am on the collections list
    And I click on the "Delete" link for "The Photo Collection"
    Then I should see the message "Collection was successfully deleted."
    And I should not see title "The Photo Collection" in the collections list