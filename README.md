# S2S — Student To Student

**Smart India Hackathon 2026 · Team LOGIC OVERDRIVE (Team ID: 119671)**

> "Seniors → Freshers. One trusted place for campus books and notes."

S2S is a campus-first, peer-to-peer marketplace where seniors sell, lend or rent used textbooks and notes to incoming first-year students at lower cost. Instead of scattered WhatsApp PDFs, unverified listings and courier delays, a fresher gets one verified place to search by course code, send a request, and meet the owner at a safe campus landmark. No shipping and no payment gateway are needed.

## Problem

Incoming first-year students struggle to find affordable textbooks and reliable study materials. The gap is a trusted, campus-level way to connect with seniors who already own them:

| Today | With S2S |
|---|---|
| Expensive new textbooks | Used books from seniors at lower cost |
| Scattered, unverified WhatsApp groups | One verified campus marketplace |
| National platforms with delivery waits | Same-day, in-person campus meetups |
| No way to search by syllabus | Search by course code and semester |

## Features

S2S is built around a three-screen core flow: **Search → Request → Meet**.

1. **Search** — Find books, notes and PYQs by title or course code (e.g. `ESC-CSE-101`), with filters for type, buy/rent and course, plus search history.
2. **Request** — Send a request to the owner with an optional message; the owner is notified and can accept or decline.
3. **Meet** — Pick a safe on-campus meetup spot (Main Library, Canteen, Hostel Gate, Academic Block Lobby) and a time, then rate each other after the exchange.

Supporting capabilities baked into the prototype:
- **Listings** for books, notes and PYQs, for sale or rent, managed from a "My Items" dashboard.
- **Student and College sign-up** — colleges register an official email domain so students can be verified under them, and unique S2S IDs are issued (`S2S-STU-XXXXXX`, `S2S-COL-XXXXXX`).
- **Sent and received request views** with in-app notifications and badges.
- **Reviews and ratings** on listings and on borrowers.
- **Karma and level system** — 🌱 New Trader → 🙂 Trusted Peer → ⭐ Reliable Trader → 🏅 Campus Star → 👑 S2S Legend, driven by the reviews a student receives.
- **Rental tracking** with due dates, overdue alerts, return confirmation and a dispute option.
- **Light and dark theme** and a first-time tutorial tour.
- **Account-linked persistence** — listings, requests, reviews and notifications are stored per user.

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Vanilla HTML / CSS / JavaScript (single-page, mobile-first app) |
| Backend | Supabase (Auth + Postgres) |
| Auth | Supabase Auth (email + password) |
| Data | Tables: `profiles`, `listings`, `requests`, `reviews`, `notifications`, view: `seller_stats` |
| Design | Figma, Google Fonts (Kalam, Work Sans, JetBrains Mono) |

### Architecture

    Student (search / list / request)
            │
            ▼
        S2S Web UI  ─────────►  Supabase Auth (college email)
            │                          │
            ▼                          ▼
      Core Screens               Postgres (RLS)
     (Search · Request ·     profiles · listings · requests
      Meet · My Items)          reviews · notifications
            │
            ▼
    In-person meetup at campus landmark → rating → karma

**Trust engine:** Every completed exchange produces ratings. Ratings feed the karma score and level shown next to a student's name, so users can see who is reliable before they meet.

## Current Status

This repo contains a working **front-end prototype** (`s2s-app.html`) built as a single self-contained file, demonstrating the full student journey end-to-end with live Supabase-backed accounts:

- Student and college registration and login work against a live backend.
- Listings, requests, reviews and notifications are real, stored per account.
- The Search → Request → Meet flow, rental tracking and karma levels are functional, not static mockups.
- Login currently uses email + password. OTP-based college-email verification is the next step (see Roadmap).

## Getting Started

1. Clone this repo and open `s2s-app.html` directly in a browser, or serve it with any static file server:

       npx serve .

   If you rename the file to `index.html`, enabling **GitHub Pages** on this repo (Settings → Pages → source: root of `main`) will serve it directly at a live demo URL.
2. The app connects to a pre-configured Supabase project for auth and data. To point it at your own project instead, replace the `SUPABASE_URL` and `SUPABASE_ANON_KEY` constants near the top of the script section.
3. **Own backend:** create the tables `profiles`, `listings`, `requests`, `reviews`, `notifications` and a `seller_stats` view, and enable **Row-Level Security** with policies on each table. Only the publishable/anon key belongs in frontend code, never the `service_role` key.

No build step is required. It's a single HTML file with everything inlined.

## Impact

| Metric | Target* |
|---|---|
| Textbook cost saving for freshers | 30–50% |
| Resale recovery for seniors | 40–60% |

\*Targets, to be validated in the campus pilot.

- **SDG 4** — Quality education and lower cost of access
- **SDG 12** — Reuse of books and less new print
- **Social** — Stronger student networks, less academic isolation, a culture of sharing
- **Economic** — Lower education cost through peer-to-peer commerce
- **Environmental** — Books reused across batches (circular economy)

## Roadmap

| Phase | Description |
|---|---|
| 01 · Prototype | Search + Request + Meet with listings, reviews and karma (this repo) |
| 02 · Test | Paper-mockup tests and interviews with 5–8 freshers and seniors |
| 03 · Campus Pilot | Fix issues and pilot on one campus, seeded with partner seniors before the book rush |
| 04 · Expand | OTP college-email login, FCM push alerts, Flutter/React PWA; each new college domain becomes a new campus |

**Known challenges & mitigations:**
- *Few listings at launch* → seed with partner seniors before the freshers' book rush
- *Trust and safety* → verified college email, ratings, karma levels, meetups only at campus landmarks
- *Competition (Amazon, OLX, groups)* → campus-only edge: no shipping, same-day meetups, course-code search
- *Copyright of notes* → only student-made notes; report button and takedown
- *Admin approval* → pitch as student welfare; seek department and library support

## Research Basis

S2S was built after studying textbook affordability research and existing marketplaces:

| Source / System | What it shows or does | What S2S adds |
|---|---|---|
| US PIRG — *Fixing the Broken Textbook Market* | Documents the cost burden of textbooks on students | A low-cost, reuse-based alternative at campus level |
| Chronicle of Higher Education — 7 in 10 students skipped a textbook | Students skip books because of cost | Affordable access through senior-to-fresher resale |
| Amazon / OLX | National second-hand marketplaces | Campus filter, verified students, same-day meetups |
| Doosradeal | India second-hand engineering book marketplace (2014), delivery-based | No delivery wait; in-person campus exchange |
| NBT Low Cost University Edition scheme | Subsidised print editions | Resale and lending of existing books |

References:
- [US PIRG — Fixing the Broken Textbook Market (2nd ed.)](https://pirg.org/edfund/resources/fixing-the-broken-textbook-market-second-edition/)
- [Student PIRGs — Textbook affordability during COVID-19 (3rd ed.)](https://studentpirgs.org/2021/02/24/fixing-the-broken-textbook-market-third-edition/)
- [Chronicle of Higher Education — 7 in 10 students have skipped buying a textbook](https://chronicle.com/article/7-in-10-students-have-skipped-buying-a-textbook-because-of-its-cost-survey-finds/)
- [Lok Sabha reply — NBT Low Cost University Edition scheme](https://eparlib.nic.in/bitstream/123456789/464672/1/9178.pdf)
- [Doosradeal — gust.com](https://gust.com/companies/doosradeal)

## Team

**LOGIC OVERDRIVE** — Team ID 119671 — Smart India Hackathon 2026, Student Innovation category.

## License

This project is licensed under the [MIT License](LICENSE).
