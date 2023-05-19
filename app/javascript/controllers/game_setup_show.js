document.addEventListener("DOMContentLoaded", () => {
  const userSelections = document.querySelectorAll('.user-selection');
  const fixtureTeams = document.querySelectorAll('.team-pick');
  const activeClass = 'active';
  const submitButton = document.querySelector('input[type="submit"]');

  // By default, highlight the first user selection and hide all the other user selections
  userSelections[0].classList.add(activeClass);
  for (let i = 1; i < userSelections.length; i++) {
    userSelections[i].style.display = 'none';
  }

  // When a user selects a team, prevent the default form submission, highlight the selection, and submit the form via AJAX
  fixtureTeams.forEach((team) => {
    team.addEventListener('click', (event) => {
      event.preventDefault();

      // Get the currently active user selection
      const activeUserSelection = document.querySelector('.user-selection.active');

      // Get the hidden input field for the currently active user selection
      const hiddenInput = activeUserSelection.querySelector('input[type="hidden"]');

      // Set the value of the hidden input field to the ID of the selected team
      hiddenInput.value = team.dataset.teamId;

      // Highlight the selected team and remove the highlight from all other teams
      fixtureTeams.forEach((team) => {
        team.classList.remove(activeClass);
      });
      team.classList.add(activeClass);

      // Submit the form via AJAX
      const form = activeUserSelection.querySelector('form');
      const formData = new FormData(form);
      fetch(form.action, {
        method: 'POST',
        body: formData
      })
        .then(response => response.json())
        .then(data => console.log(data))
        .catch(error => console.error(error));

      // If this was the last user selection, show the submit button
      const nextUserSelection = activeUserSelection.nextElementSibling;
      if (nextUserSelection) {
        // Highlight the next user selection and hide all the other user selections
        activeUserSelection.classList.remove(activeClass);
        nextUserSelection.classList.add(activeClass);
        for (let i = 0; i < userSelections.length; i++) {
          if (userSelections[i] !== nextUserSelection) {
            userSelections[i].style.display = 'none';
          }
        }

        // Update the text of the header to reflect the next user selection
        const headerText = document.querySelector('h4');
        headerText.textContent = `Great, now choose your ${nextUserSelection.dataset.entryNumber} entry!`;

        // Show the fixture teams for the next user selection
        const nextFixtureTeams = nextUserSelection.querySelectorAll('.team-pick');
        nextFixtureTeams.forEach((team) => {
          team.classList.remove(activeClass);
        });
      } else {
        submitButton.style.display = 'block';
      }
    });
  });
});
