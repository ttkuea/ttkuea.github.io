(() => {
  const yearNode = document.querySelector("#current-year");
  if (yearNode) {
    yearNode.textContent = String(new Date().getFullYear());
  }

  const sections = [...document.querySelectorAll("main section[id]")];
  const navLinks = [...document.querySelectorAll(".nav-links a")];
  const revealNodes = [...document.querySelectorAll(".reveal")];

  if ("IntersectionObserver" in window) {
    const revealObserver = new IntersectionObserver(
      (entries) => {
        for (const entry of entries) {
          if (entry.isIntersecting) {
            entry.target.classList.add("is-visible");
            revealObserver.unobserve(entry.target);
          }
        }
      },
      { threshold: 0.16 }
    );

    revealNodes.forEach((node) => revealObserver.observe(node));

    const navObserver = new IntersectionObserver(
      (entries) => {
        for (const entry of entries) {
          if (!entry.isIntersecting) {
            continue;
          }
          const id = entry.target.getAttribute("id");
          for (const link of navLinks) {
            const matches = link.getAttribute("href") === `#${id}`;
            link.classList.toggle("active", Boolean(matches));
          }
        }
      },
      { threshold: 0.5 }
    );

    sections.forEach((section) => navObserver.observe(section));
  } else {
    revealNodes.forEach((node) => node.classList.add("is-visible"));
  }
})();
