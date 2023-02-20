import dom from "@left4code/tw-starter/dist/js/dom";

document.addEventListener("turbo:load", function () {
  dom("body").on("click", "[role='tab']", function () {
    show(this);
  });
});

function show(el) {
  dom(el)
    .closest("[role='tablist']")
    .find("[role='tab']")
    .each(function () {
      // Trigger "hide.tw.tab" callback function
      if (dom(this).hasClass("active") && this !== el) {
        const event = new Event("hide.tw.tab");
        dom(this)[0].dispatchEvent(event);
      }

      // Trigger "show.tw.tab" callback function
      if (!dom(this).hasClass("active") && this === el) {
        const event = new Event("show.tw.tab");
        dom(this)[0].dispatchEvent(event);
      }
    });

  // Set active tab nav
  dom(el)
    .closest("[role='tablist']")
    .find("[role='tab']")
    .removeClass("active")
    .attr("aria-selected", false);
  dom(el).addClass("active").attr("aria-selected", true);

  // Set active tab content
  let elementId = dom(el).attr("data-tw-target");
  let tabContentWidth = dom(elementId).closest(".tab-content").width();
  dom(elementId)
    .closest(".tab-content")
    .children(".tab-pane")
    .removeAttr("style")
    .removeClass("active");
  dom(elementId)
    .css("width", tabContentWidth + "px")
    .addClass("active");
}
