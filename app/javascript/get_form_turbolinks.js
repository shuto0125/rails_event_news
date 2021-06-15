import Turbolinks from "turbolinks";

document.addEventListener("turbolinks:load", function (event) {
  const forms = document.querySelectorAll("form[method=get][data-remote=true]");
  console.log(forms);
  for (const form of forms) {
    form.addEventListener("ajax:beforeSend", function (event) {
      const options = event.detail[1];

      console.log(options);

      Turbolinks.visit(options.url);
      event.preventDefault();
    });
  }
});
