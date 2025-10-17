document.addEventListener("DOMContentLoaded", () => {
  const navbar = document.getElementById("navbar");

  // Osserva quando viene caricato il contenuto della navbar
  const observer = new MutationObserver(() => {
    const menuBtn = document.querySelector(".menu-toggle");
    const sidebar = document.getElementById("sidebar");
    const overlay = document.getElementById("overlay");
    const closeBtn = document.querySelector(".close-btn");

    // Solo quando tutti gli elementi esistono
    if (menuBtn && sidebar && overlay && closeBtn) {
      menuBtn.addEventListener("click", () => {
        sidebar.classList.add("active");
        overlay.classList.add("active");
      });

      closeBtn.addEventListener("click", () => {
        sidebar.classList.remove("active");
        overlay.classList.remove("active");
      });

      overlay.addEventListener("click", () => {
        sidebar.classList.remove("active");
        overlay.classList.remove("active");
      });

      // ✅ Una volta collegati gli eventi, smetti di osservare
      observer.disconnect();
    }
  });

  observer.observe(navbar, { childList: true });
});
