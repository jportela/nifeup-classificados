Feature: Show ad details (US3)
  In order to know more information about an ad and see if it really interests me
  As a user
  I want to see the details of an ad, such as a description, related photos, contact information, comments and more

  Scenario: Visiting the details page of an ad
    Given the system has already an ad with id "1"
    When I open the details page for ad "1"
    Then the request should succeed

  Scenario: Showing the full details of an ad
    Given the system has already an ad with id "1"
      And it has information in all its fields
    When I open the details page for ad "1"
    Then I should see the ad's title
      And I should see its author, creation date and keywords
      And I should see its description
      And I should see its comments
