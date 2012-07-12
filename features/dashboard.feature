Feature: Show dashboard (US1)
  In order to be able to see the ads that interest me most
  As a user
  I want to see a dashboard that shows a number of ads ordered by relevance and filtered by section

  Scenario: Visiting dashboard
    When I open the dashboard
    Then the request should succeed

  @javascript
  Scenario: Showing list of ads
    Given the system has some ads in section "Troco"
      And the system has some ads in section "Alugo"
    When I open the dashboard
      And I select the section "Alugo"
    Then I should see a list of ads
      And they should all be from the section "Alugo"
      And they should be ordered by relevance
