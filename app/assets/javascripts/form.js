document.addEventListener('DOMContentLoaded', function() {
  const nameField = document.querySelector('#collection_name');
  const manufacturingLeadTimeField = document.querySelector('#collection_manufacturing_lead_time');
  const estimatedReleaseDateField = document.querySelector('#collection_estimated_release_date');
  const submitButton = document.querySelector('#submit-button');

  function enableSubmitButton() {
    if (nameField.value && manufacturingLeadTimeField.value && estimatedReleaseDateField.value) {
      submitButton.disabled = false;
    } else {
      submitButton.disabled = true;
    }
  }

  nameField.addEventListener('input', enableSubmitButton);
  manufacturingLeadTimeField.addEventListener('input', enableSubmitButton);
  estimatedReleaseDateField.addEventListener('input', enableSubmitButton);
});
