import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["fixturesContainer"];

  async filterCompetitions(event) {
    const selectedCompetition = event.target.value;
    const response = await fetch(`/games?competition=${selectedCompetition}`);
    const html = await response.text();
    document.querySelector("#games-container").innerHTML = html;
  }

  async fetchFixtures(event) {
    const gameId = event.target.form.dataset.gameId;
    const numberOfEntries = event.target.value;
    const response = await fetch(`/games/${gameId}/team_selections/new?number_of_entries=${numberOfEntries}`);
    const html = await response.text();
    document.querySelector(`#fixtures-container-${gameId}`).innerHTML = html;
  }

  async submitJoinGame(event) {
    event.preventDefault();
    const gameId = event.target.dataset.gameId;
    const form = event.target;
    const formData = new FormData(form);

    const response = await fetch(form.action, {
      method: "POST",
      body: formData,
    });

    if (response.ok) {
      alert('Team selection(s) successfully created!');
      location.reload();
      } else {
      alert('Error: Could not join the game');
      }
      }
    }
