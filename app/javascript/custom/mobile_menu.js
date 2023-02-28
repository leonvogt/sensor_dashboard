document.addEventListener("turbo:load", function () {
  document.querySelector(".mobile-menu-toggler")?.addEventListener("click", function () {
    document.querySelector(".mobile-menu").classList.toggle("mobile-menu--active");
  });
});
