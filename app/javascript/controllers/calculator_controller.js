import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["customAmount", "amountSelect", "abv", "price"];
  static values = { vat: Number };

  calculate(event) {
    event.preventDefault();
    const amount = this.getAmount();
    const abv = parseFloat(this.abvTarget.value);
    const price = parseFloat(this.priceTarget.value);
    let alcoholTax = 0;
    switch (true) {
      case abv < 0.5:
        alcoholTax = 0;
      case abv <= 3.5:
        alcoholTax = 0.2835;
      case abv > 3.5:
        alcoholTax = 0.3805;
    }
    const beerTax = amount * abv * alcoholTax;
    const vatAmount = price - price / (1.0 + this.vatValue);
    const taxPercentage = ((beerTax + vatAmount) / price) * 100;

    const result = document.getElementById("result");
    result.innerHTML = `
      <p>Beer has ${beerTax.toFixed(
        2
      )} € of alcohol tax and ${vatAmount.toFixed(2)} € of value added tax.</p>
      <p> ${taxPercentage.toFixed(1)} % of the price is taxes.</p>`;
  }

  getAmount() {
    const selectValue = this.amountSelectTarget.value;
    if (selectValue) {
      return parseFloat(selectValue);
    } else {
      return parseFloat(this.customAmountTarget.value);
    }
  }

  clear(event) {
    event.preventDefault();
    const form = document.getElementById("calc-form");
    form.reset();
  }

  change(event) {
    if (event.target.value == "") {
      const result = document.getElementById("custom-field");
      result.innerHTML = `
        <label>Custom amount</label>
        <input type="number" min="0" step="0.01" value="0.00" data-calculator-target="customAmount" />
        <label>liters</label>`;
    } else {
      const result = document.getElementById("custom-field");
      result.innerHTML = `<div></div>`;
    }
  }
}
