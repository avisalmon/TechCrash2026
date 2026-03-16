/* CrashTech VLSI 2026 — Navigation & Countdown */

(function () {
    // ---- Tab Navigation ----
    const navLinks = document.querySelectorAll('[data-page]');
    const sections = document.querySelectorAll('.page-section');
    const navTabs = document.getElementById('navTabs');
    const navToggle = document.getElementById('navToggle');

    function showPage(pageId) {
        sections.forEach(s => s.classList.remove('active'));
        const target = document.getElementById(pageId);
        if (target) target.classList.add('active');

        navLinks.forEach(a => a.classList.remove('active'));
        document.querySelectorAll(`.nav-tabs [data-page="${pageId}"]`).forEach(a => a.classList.add('active'));

        navTabs.classList.remove('open');
        window.scrollTo(0, 0);
    }

    navLinks.forEach(link => {
        link.addEventListener('click', function (e) {
            e.preventDefault();
            const page = this.getAttribute('data-page');
            showPage(page);
            history.pushState(null, '', '#' + page);
        });
    });

    // Handle browser back/forward
    window.addEventListener('popstate', function () {
        const hash = location.hash.replace('#', '') || 'home';
        showPage(hash);
    });

    // Load correct page from URL hash on initial load
    const initialPage = location.hash.replace('#', '') || 'home';
    showPage(initialPage);

    // Mobile hamburger toggle
    navToggle.addEventListener('click', function () {
        navTabs.classList.toggle('open');
    });

    // ---- Countdown Timer ----
    // Tentative event date: April 30, 2026, 18:00 (may shift due to exam schedule)
    // Set DATE_CONFIRMED to true once the date is final — this unhides the countdown
    const EVENT_DATE = new Date(2026, 3, 30, 18, 0, 0); // April 30, 2026, 18:00
    const DATE_CONFIRMED = false; // flip to true when date is locked

    const countdownEl = document.getElementById('countdown');
    if (!DATE_CONFIRMED && countdownEl) {
        countdownEl.classList.add('hidden');
    } else if (DATE_CONFIRMED && countdownEl) {
        countdownEl.classList.remove('hidden');
    }

    function updateCountdown() {
        if (!DATE_CONFIRMED) return;
        const now = new Date();
        const diff = EVENT_DATE - now;

        if (diff <= 0) {
            document.getElementById('cd-days').textContent = '00';
            document.getElementById('cd-hours').textContent = '00';
            document.getElementById('cd-minutes').textContent = '00';
            document.getElementById('cd-seconds').textContent = '00';
            return;
        }

        const days = Math.floor(diff / (1000 * 60 * 60 * 24));
        const hours = Math.floor((diff / (1000 * 60 * 60)) % 24);
        const minutes = Math.floor((diff / (1000 * 60)) % 60);
        const seconds = Math.floor((diff / 1000) % 60);

        document.getElementById('cd-days').textContent = String(days).padStart(2, '0');
        document.getElementById('cd-hours').textContent = String(hours).padStart(2, '0');
        document.getElementById('cd-minutes').textContent = String(minutes).padStart(2, '0');
        document.getElementById('cd-seconds').textContent = String(seconds).padStart(2, '0');
    }

    updateCountdown();
    setInterval(updateCountdown, 1000);
})();
