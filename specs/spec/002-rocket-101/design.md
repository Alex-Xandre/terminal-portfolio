# Design — `/recommendations` page for the terminal-portfolio harness

Branch `spec/002-rocket-101` · stage `design` · run `a6424dc2-c60f-404a-a6fa-c85c1bc040ec` · loop 1 · attempt `ss_spec_002-rocket-101_1793763204079_0`

Answers open question **Q003** of `specs/spec/002-rocket-101/task-plan.json`
(bound input, commit `5fb2423`, sha256 `25576bbf…6182ed` — verified): what a
recommendation entry looks like on `/recommendations` inside the harness's
constraints. Decisions D001 (harness-only scope), D002 (`/recommendations`
naming), D004 (truthfulness) and D005 (no homepage section, no ticker stat)
are kept as-is; D003 was the planner's candidate and is amended below.

## Grounding

- **Snapshot:** none. `preview snapshot --wait` and `preview snapshot-url
  --internal` both return `snapshot_unavailable`. `preview status` → "no
  preview for this feature". `preview up --dev` refuses: "this branch has no
  preview recipe". **Snapshot commit: n/a · coverage: 0 routes · gaps: every
  route.** Cause, not a transient: the repository tracks only `AGENTS.md`,
  `CLAUDE-import.md`, `README.md`, `prompt` and the task plan — no
  `package.json`, no `src/`, no `devos.env.yaml`. There is no application to
  record, boot, or mock against, and no "before" the platform can freeze
  (`design-compare status`: frozen before none, still to freeze `/`).
- **What is real here:** the harness. `AGENTS.md` is the design system that
  every generated copy of this portfolio follows — token block, rules 1–10,
  layout skeleton and the pattern language. The design was built from it
  verbatim: amber token block (and the green-phosphor preset for the palette
  check), `mx-auto w-full max-w-5xl px-4 sm:px-6` alignment, the command
  header markup, the dashed-vs-solid border split, the `# comment` idiom, the
  markdown `border-l-2 border-l-accent-muted` rule, the 15px sans body size,
  reduced-motion and a11y floor.
- **Design skills:** `.claude/skills/design/` (pod-provisioned, untracked)
  was read. `taste-skill-v1` conflicts with the harness on most points it
  makes (framer stagger/perpetual motion, cards ban, Geist/Satoshi fonts,
  `max-w-7xl`); the harness wins by its own first paragraph, so those
  directives were not applied. Its "empty state" and "full interaction
  cycle" rules are honoured (empty state is designed; hover/focus/reduced
  motion are specified).
- **Reference site:** `xandremicua.vercel.app/recommendations` is a "Coming
  Soon" stub (plan D001); it provides no anatomy to preserve.
- **Fidelity:** the mock is a hand-written static HTML page that uses the
  harness's exact CSS custom properties and IBM Plex Mono/Sans loaded from
  Google Fonts (both confirmed loaded in every capture). It renders the
  Appbar row, the page and the footer bottom bar; the ticker is omitted (it
  would need invented stats, which rule "only TRUE claims" forbids). The
  three entries are **fictional fixtures** and are labelled so in the page
  itself (`# design fixture — …`). Mobile-panel nav, the footer cat and the
  interactive shell are out of frame — none of them change for this page.
- **Limitations:** no DOM-mock round could be applied or verified (nothing
  to apply it to); no before/after comparison exists; `design-mocks push` is
  used only to register the proposal so the review window has a round.

## Scope

Within D001: the output of this design is the specification the harness
will carry (T001) and the README reflection (T002) — not app code. The
design fixes the **entry anatomy, attribution and date placement, source-link
treatment, mobile stacking, empty state, hover/focus and reduced-motion
behaviour** of the page. Out of scope (unchanged from the plan): homepage
section, ticker stat, headshots/logos/ratings/carousels, live fetching,
new tokens or primitives, `/testimonials` naming.

## Changes (the proposed pattern)

**Command header** — `{SHELL} $ cat recommendations/*.md` using the
pattern-language markup; subtitle `{n} files · quoted verbatim, with
permission · newest first` (`1 file` when singular). `cat` because the
content is prose, like `cat {slug}.md` on a post; the glob says "all of them,
in order".

**Entry** (`<article>` inside an `<ol aria-label="recommendations">`,
newest first), classes as the generated app will write them:

| part | spec |
|---|---|
| block | `border border-dashed border-border bg-secondary-background p-4 sm:p-5 transition-colors hover:border-secondary-border` — dashed because this is a text list (solid = projects). No `translate-x` on hover: the block is not a link. |
| header line | `flex items-baseline justify-between gap-3 text-xs`: left `{slug}.md` — slug in `text-text-primary`, `.md` in `text-text-secondary`, `min-w-0 truncate`; right `<time datetime="yyyy-mm">` in `text-text-secondary flex-none`. Mirrors the blog's `slug.md` listing and the project row's trailing `type · year`. |
| quote | `<blockquote class="mt-3 max-w-prose border-l-2 border-l-accent-muted pl-3 font-sans text-[15px] leading-relaxed text-text-primary">`, paragraphs separated by `mt-2`. The left rule is the markdown `pre`/blockquote treatment already in the system; it is the only "quote mark". Never truncated, never clamped. |
| attribution | `<footer class="mt-3 flex flex-wrap items-baseline gap-x-3 gap-y-1 text-xs">`: `— {name}` in `text-text-primary`; `{role} @ {company}` (or `{role}` alone) in `text-text-secondary`. |
| source link | optional `<a>` `# via {label} ↗` — `#` in `text-accent-muted`, link `text-accent-muted hover:text-accent`, `basis-full sm:basis-auto sm:ml-auto`, `target="_blank" rel="noopener noreferrer"`, `aria-label="recommendation from {name} on {label} (opens in a new tab)"`, `focus-visible:outline-accent`. Omitted entirely when `source` is absent — no placeholder. |
| spacing | list `mt-8 flex flex-col gap-3`; page uses the canonical Container usage. |

**Casing & data** — `name` and `company` render exactly as the person
writes them (rule 10's lowercase applies to terminal chrome, not to people);
`role` is lowercase. `date` is stored as the string `"yyyy-mm"` and printed
as-is — no `Date` object exists on this page, so the `Date.toString()` bug
class cannot occur. `slug` is `slugify(name)` and the data rule requires it
to be unique.

**Mobile (< 640px)** — header line keeps one row (slug truncates, date
never wraps); attribution wraps to `— name` / `role @ company` / `# via …`
on successive lines. Nothing stacks into columns; nothing hides.

**Empty state** — `cat: recommendations/*.md: No such file or directory` in
`text-sm text-text-secondary`, followed by a `cd ~ →` link in
`text-accent-muted hover:text-accent`. Subtitle reads `0 files`.

**What the page does not have** — no CTA, no trailing `cd` link (the footer
follows), no count badge, no headshots, logos, stars, carousels, autoplay,
"read more" truncation, or per-entry links other than the source.

**Palette-agnostic** — every color is a token; the green render in the
evidence is the same markup with the harness's green-phosphor block.

**Reduced motion** — the only motion on the page is the Container fade-up
(already disabled by the global reduced-motion block) and the 150ms
border/color transitions, which the global block also zeroes. Static render
is identical in content.

**Nav & shell** — `recommendations` is the last `SIDEBAR_MENU` item (after
`trading`); the shell's `recommendations` section command prints the file
list and `router.push`es; the 404 tree picks the route up automatically.

## Mocks

- `design/mocks/round-0001.html` — the static mock (source of every capture).
  Flags: `?empty=1`, `?theme=green`.
- `design/mocks/round-0001.json` — the same populated screen in the contract
  format: one `insertHTML` op on route `/recommendations`, selector `main`
  (the only element `AGENTS.md`'s layout skeleton guarantees), inline
  `var(--token)` styles so it renders without Tailwind having compiled the
  classes. **Unverified**: it was not applied in Playwright because no
  preview exists on this branch; the `failed` list is therefore unknown, not
  empty. It is registered with `design-mocks push` so the review window has
  a round to show; it must be re-applied and verified on the first branch
  that ships the reference implementation.

## Scope amendments

- **D003 → amended (D012–D015 in task-plan.json).** Attribution moves
  *below* the quote as a sign-off; a `{slug}.md` + date header line is added
  on top so each block still reads as one `cat`-ed file; the quote gets the
  markdown left rule; dates are stored as strings rather than built from a
  `Date`. Rationale: readers expect quote-then-signature, and the filename
  line keeps the `cat recommendations/*.md` framing honest.
- No scope added or removed otherwise (D001, D002, D004, D005 stand).

## Acceptance criteria

- **AC-D1** — The harness subsection `### Recommendations = cat quotes` specifies: dashed `border-border` block on `secondary-background`, hover `secondary-border` only (no translate); header line `{slug}.md` left (`text-primary`, `.md` `text-secondary`) and `yyyy-mm` right (`text-secondary`); `font-sans` 15px quote with `border-l-2 border-l-accent-muted pl-3` and `max-w-prose`, never truncated; footer `— {name}` (`text-primary`) + `{role} @ {company}` (`text-secondary`); optional `# via {label} ↗` link `accent-muted → accent`, right-aligned on `sm+`, own line below, `rel="noopener noreferrer"` + `aria-label`.
- **AC-D2** — The data bullet documents `Recommendation { name, role, company?, quote, date?: "yyyy-mm", source?: { label, url } }`, newest first, unique `slugify(name)`, `date` printed as the stored string (no `Date`), and the real/verbatim/permissioned rule.
- **AC-D3** — Empty state text is exactly `cat: recommendations/*.md: No such file or directory` with a `cd ~` link; subtitle format is `{n} files · quoted verbatim, with permission · newest first` (`1 file` singular, `0 files` empty).
- **AC-D4** — The subsection states explicitly: no headshots, logos, ratings, carousels, autoplay, truncation or CTA on the page; name/company rendered as written, role lowercase.
- **AC-D5** — Reduced motion: the subsection names the Container fade-up and the border transition as the only motion, both covered by the global reduced-motion block; `<ol aria-label>`, `<article>`, `<blockquote>`, `<time datetime>` and the accent focus ring are named.
- **AC-D6** — Every color named in the subsection is one of the existing tokens; no `rounded-*`, no hex, no `neutral-*`; the green render shows the pattern needs no palette-specific rule.
- **AC-D7** — Mobile: header line stays one row (slug truncates, date `flex-none`); attribution wraps with the source link on its own line; nothing hides.

## Evidence

All captures are of the static mock at `design/mocks/round-0001.html`
(Chromium 1217 via the pod's Playwright 1.59.1, DPR 2, Plex fonts loaded —
logged per capture). They are visual evidence of the proposal, not of
implemented behaviour.

- `design/evidence/round-0001-desktop.png` — 1280px, populated, full page.
- `design/evidence/round-0001-mobile.png` — 390px, populated, full page
  (attribution stacking, slug/date row).
- `design/evidence/round-0001-empty.png` — 1280px, `?empty=1`.
- `design/evidence/round-0001-green.png` — 1280px, green-phosphor token
  block, same markup.
- `design/evidence/round-0001-hover.png` — first entry with the block and
  the `# via` link hovered (border → `secondary-border`, link → accent).

Before/after: not available — `design-compare` has nothing to freeze or
capture on a branch with no app; recorded here rather than faked.

## Review log

- **2026-11-04 · loop 1 · attempt `ss_spec_002-rocket-101_1793763204079_0` · round 0001 proposed.**
  No snapshot/preview possible (no app on branch); static token-faithful
  mock + five captures produced; round JSON authored (unverified) and
  registered; task-plan.json updated with D011–D016, T001/AC-T001-3
  re-derived, Q003 marked answered pending approval. `design-mocks push`
  → "round 1 registered (1 ops on 1 route(s)) … stored without a
  screenshot". `design-compare capture --route /recommendations` → "cannot
  capture: the app is not running yet" (no before/after possible). Holding
  `needs_human` for the person to accept the anatomy or request a round
  0002.
