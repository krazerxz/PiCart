Feature: Lists

  Scenario: Creating a list
    Given I am on the list index
    When I click the new list button
    And I fill in the list details
    Then a list should be created
