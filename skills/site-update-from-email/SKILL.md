---
name: Site Update From Email
description: >
  Scan Outlook/M365 emails for CrashTech VLSI 2026 updates, extract
  actionable information (dates, venue, rules, challenges, teams,
  logistics), compare against the current website content, and apply
  changes to index.html, style.css, and app.js. Use when the user says
  "update the site", "check emails for updates", or "sync site with
  email".
---

# Site Update From Email

Automated workflow: read recent emails → extract CrashTech updates → diff against current site → apply changes.

---

## Step 1 — Search Emails for CrashTech Content

Use the M365 Graph email tools to find relevant messages.

### Search queries to run (in order)

Run **all** of these searches. Combine the results and deduplicate by message ID.

| # | Search query | Purpose |
|---|-------------|---------|
| 1 | `CrashTech` | Primary event name |
| 2 | `VLSI 2026` | Event + year |
| 3 | `CrashTech VLSI` | Combined |
| 4 | `DE10-Lite` | Hardware references |
| 5 | `Technion hackathon` | Venue + format |

Use `mcp_m365-graph_email_search` with each query. Set a reasonable result limit (10–20 per query). Focus on recent emails (last 60 days).

After searching, read the full body of each unique email using `mcp_m365-graph_email_get`.

---

## Step 2 — Extract Actionable Updates

Parse each email body for information that maps to a website section. Look for these categories:

### Update Categories

| Category | Maps to site section | What to look for |
|----------|---------------------|-----------------|
| **Event date** | Home hero, countdown timer (`app.js` EVENT_DATE) | Confirmed date, date change |
| **Venue / location** | Home hero, The Event page | Room, building, campus details |
| **Schedule / timeline** | The Event, Event Day | Pre-event dates, event-day timeline, ceremony times |
| **Hardware kit** | Hardware page | Kit contents change, pickup logistics, new peripherals |
| **Practice challenges** | Practice Challenges page | New challenges, modified requirements, hints |
| **Competition challenges** | Event Day page | Challenge pool info, scoring updates, point values |
| **Rules** | The Event page | Team size, constraints, judging criteria |
| **Registration** | Register page | Registration link, deadline, form fields |
| **AI tools / skills** | AI Tools page | New skills files, tool recommendations |
| **Sponsors / branding** | Home, footer | Logos, sponsor names, branding assets |
| **General announcements** | Any section | Anything that should appear on the site |

For each extracted update, record:
- **Source**: email subject + sender + date
- **Category**: from the table above
- **Current site content**: what the site says now (read from `index.html` / `docs/website-spec.md`)
- **New content**: what the email says it should be
- **Confidence**: high (explicit instruction) / medium (implied) / low (ambiguous)

---

## Step 3 — Present Update Plan to User

Before making any changes, present a summary table:

```
| # | Category | Current | New | Source email | Confidence |
|---|---------|---------|-----|-------------|-----------|
| 1 | Event date | "Date TBA" | "July 3, 2026" | "Re: CrashTech dates" from alice@ | High |
| 2 | ...  | ... | ... | ... | ... |
```

Ask the user: **"Apply all updates? Or select specific ones?"**

---

## Step 4 — Apply Changes to Site Files

### File locations

| File | Contains |
|------|----------|
| `index.html` | All page content (single-page app with tab sections) |
| `style.css` | Styles — only modify if layout/branding changes |
| `app.js` | Navigation + countdown timer (EVENT_DATE constant) |
| `docs/website-spec.md` | Source-of-truth spec — update to keep in sync |

### Site structure reference

The site is a single-page app. Each tab is a `<section class="page-section" id="...">` in `index.html`:

| Tab | Section ID | Current state |
|-----|-----------|--------------|
| Home | `#home` | **Implemented** — hero, countdown, philosophy cards, flow steps, quick links |
| The Event | `#event` | **Placeholder** — needs full content |
| Hardware | `#hardware` | **Implemented** — DE10-Lite + ESP32 specs, connection info, kit checklist |
| Get Started | `#getstarted` | **Placeholder** — needs setup checklist, training materials |
| Practice Challenges | `#challenges` | **Placeholder** — needs 3 challenge cards (Internet Clock, Retro Arcade, Volt Meter) |
| AI Tools | `#aitools` | **Placeholder** — needs Copilot setup, skills download links |
| Event Day | `#eventday` | **Placeholder** — competition hub, active during event only |
| Leaderboard | `#leaderboard` | **Placeholder** — live standings |
| Register | `#register` | **Placeholder** — registration form |

### Placeholder replacement pattern

Current placeholder sections look like this:

```html
<section class="page-section" id="SECTION_ID">
    <div class="placeholder">
        <div class="placeholder-icon">EMOJI</div>
        <h2>Title</h2>
        <p>Description</p>
    </div>
</section>
```

Replace the inner `<div class="placeholder">...</div>` with full content using the same patterns as the implemented pages (e.g., `section-block`, `card-grid`, `card`, `spec-table`, etc.).

### Countdown timer update

If the event date is confirmed, update `app.js`:

```js
// Month is 0-indexed: January=0, June=5, July=6
const EVENT_DATE = new Date(YYYY, M-1, D, HH, MM, 0);
```

Also update the hero text in `index.html` from `"Date TBA"` to the actual date string.

---

## Step 5 — Update the Spec

After applying changes to the site files, also update `docs/website-spec.md` to reflect any resolved "Open Items" or changed requirements. This keeps the spec as the single source of truth.

---

## Important Rules

1. **Never fabricate information.** Only use facts from actual emails. If an email is ambiguous, mark confidence as "low" and ask the user.
2. **Preserve existing implemented content.** Don't overwrite working sections unless the email explicitly changes them.
3. **Keep the visual style consistent.** Use the same CSS classes and HTML patterns as existing implemented sections.
4. **Show the user what will change before changing it.** Always present the update plan first.
5. **One commit per update batch.** After applying, suggest the user review and commit.
