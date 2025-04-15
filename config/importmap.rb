# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "app/javascript/custom", under: "custom"

=begin CODE from app/javascript/application.js

// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
//= require jquery3
//= require popper
//= require bootstrap-sprockets
import "@hotwired/turbo-rails";
import "controllers";
import { beers } from "custom/utils";

beers();
=end

=begin CODE from app/javascript/custom/utils.js

const handleResponse = (data) => {
  const beerList = beers.map((beer) => `<li>${beer.name}</li>`);

  document.getElementById("beers").innerHTML = `<ul> ${beerList.join(
    ""
  )} </ul>`;
};

const beers = () => {
  fetch("beers.json")
    .then((response) => response.json())
    .then(handleResponse);
};

export { beers };

=end

=begin CODE from app/views/beers/list.html.erb

<h2>Beerlist</h2>

<div id="beers">

<!-- div id="beers" not calling hello() as course material suggests-->
<script type="module">
  import { beers } from "custom/utils";
  beers();
</script>
</div>

=end