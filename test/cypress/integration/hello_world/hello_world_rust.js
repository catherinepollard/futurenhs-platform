describe("Hello World", () => {
  it("Makes request", () => {
    cy.request("http://127.0.0.1:3030/hello/Cypress").then((res) => {
      expect(res.status).to.equal(200);
      expect(res.body).to.contain("Hello, Cypress");
    });
  });
});
