import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  destroy() {
    // Confirmation dialog for the user
    const confirmDelete = confirm(
      "Are you sure you want to delete these selected ratings?"
    );
    if (!confirmDelete) {
      return;
    }

    // Retrieve the selected rating IDs from the checkboxes
    const selectedRatingsIDs = Array.from(
      document.querySelectorAll('input[name="ratings[]"]:checked'),
      (checkbox) => checkbox.value
    );

    // Include the CSRF token in the request headers so that Rails recognizes us as the logged in user
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
    const headers = { "X-CSRF-Token": csrfToken };

    // Send a DELETE request to the ratings controller with the selected rating IDs
    fetch("/ratings", {
      method: "DELETE",
      headers: headers,
      body: selectedRatingsIDs.join(","),
    })
      .then((response) => {
        if (response.ok) {
          response.text().then((html) => {
            document.querySelector("div.ratings").innerHTML = html;
          });
        } else {
          throw new Error("Something went wrong");
        }
      })
      .catch((error) => {
        console.log(error);
      });
  }

  toggleSelection(event) {
    const checked = event.target.checked;
    this.element
      .querySelectorAll('input[type="checkbox"][name="ratings[]"]')
      .forEach((checkbox) => {
        checkbox.checked = checked;
      });
  }
}
