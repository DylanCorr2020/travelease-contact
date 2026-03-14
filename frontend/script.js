//Get the form element
const form = document.getElementById("contactForm");

//Listen for form submission
form.addEventListener("submit", async function (event) {
  //Stop page reload
  event.preventDefault();

  //Get input values
  const first_name = document.getElementById("first_name").value;
  const email = document.getElementById("email").value;

  //Send data to API Gateway
  const response = await fetch(
    "https://c5lp02doge.execute-api.eu-west-1.amazonaws.com/submit",
    {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      //converts JavaScript object into JSON.
      body: JSON.stringify({
        first_name: first_name,
        email: email,
      }),
    },
  );

  //Read the response if shows us if Lambda posted successfully
  const data = await response.json();
  document.getElementById("responseMessage").innerText = data.message;
});
