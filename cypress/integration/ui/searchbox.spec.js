describe('Search box', () => {
  beforeEach(() => {
    cy.login();
  });

  it("is present", () => {
    cy.menu("Configuration", "Providers");
    // Unsure what the point of the below was... but doesn't exist in any of the
    // "Configuration -> *" menus, so causes the spec to fail if it exists
    //
    // cy.get('div[class=panel-heading]').first().click();
    cy.search_box();
  });

  it("is not present", () => {
    cy.menu("Overview", "Dashboard");
    cy.no_search_box();
  });
});
