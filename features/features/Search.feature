Feature: Search for cheese on google

  Scenario: Searching for cheese
    Given the user is on the google searchpage
    When I search for "cheese"
    Then I should see search results for "cheese"
