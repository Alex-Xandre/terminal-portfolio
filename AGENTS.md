# AGENTS.md — Terminal Portfolio ("@sh" theme)

> Source of truth for how this codebase is designed, extended, and
> personalized. `CLAUDE.md` contains only `@AGENTS.md` and imports this
> file — edit HERE, never in two places. Read fully before generating or
> modifying any page. When a rule here conflicts with a habit or a "usual"
> pattern, this file wins.

## What this is

A dark, single-accent, terminal-styled portfolio for Next.js (App Router,
Tailwind v4). Every page is framed as shell output: commands introduce
sections, navigation reads as filesystem moves, data renders as `ls`,
`cat`, `git log`, and `npm ls` output. The aesthetic is a **trading
terminal** (amber phosphor by default), not a Matrix/hacker cliché.

The design's power is restraint. Most bugs in this codebase are additions.

## Non-negotiable rules

1. **One accent color.** The accent (default: amber) is the only saturated
   color for UI. `--positive` (green) and `--negative` (red) exist for
   trading-semantic status ONLY: live dots, ▲, failed states, traffic
   lights. Never use them decoratively.
2. **No brand logos or icon grids.** Tech names are text. Lucide icons are
   allowed only as functional glyphs (arrows, menu, copy, lock).
3. **Mono is the site's voice; sans is for reading.** IBM Plex Mono for
   all chrome, headers, commands, labels, names. IBM Plex Sans
   (`font-sans`) for any paragraph a human reads: descriptions, excerpts,
   article bodies.
4. **Sharp corners.** No `rounded-*` except tiny status dots
   (`rounded-full` on 2–3px dots and traffic lights only). This includes
   scrollbar thumbs.
5. **Dark only.** No theme toggle, no next-themes. `<html class="dark">`
   is hardcoded; `.dark` tokens mirror `:root`.
6. **One alignment system.** Every page and the header inner wrapper use
   `mx-auto w-full max-w-5xl px-4 sm:px-6`. Never reintroduce responsive
   padding schemes (`md:px-32 xl:px-54 ...`) — they drift.
7. **Every color comes from a token.** No `neutral-*`, no hex in
   components. If a new shade is needed, add a token first.
8. **Content images yes, ornament images no.** Screenshots appear only
   inside window/browser chrome frames. No decorative illustrations, maps,
   or blobs.
9. **Accessibility floor:** `prefers-reduced-motion` disables every
   animation (typing, ticker, cat, transitions get a static fallback);
   decorative elements are `aria-hidden`; interactive elements have
   `aria-label` / `aria-current`; focus rings use the accent token.
10. **Copy is part of the design.** Lowercase for terminal chrome. Dry,
    specific, first-person voice. Never generic filler.

## Token system (globals.css)

All theming lives in `:root` (mirrored in `.dark`). Retheming the entire
site = editing this one block. Components must never bypass it.

```css
:root {
  --background: #0d0b07;            /* warm near-black — never pure #000 */
  --foreground: #e9e1d2;
  --text-primary: #e9e1d2;
  --text-secondary: #8f8574;        /* dim ink: secondary copy, timestamps */
  --border: #2b2317;                /* hairlines */
  --secondary-background: #151109;  /* raised: cards, ticker, code blocks */
  --secondary-background-hover: #1c1710;
  --secondary-border: #3a2f1e;      /* hover border */
  --accent: #f2a33c;                /* THE color */
  --accent-hover: #ffb654;
  --accent-muted: #9a7440;          /* prompts, # comments, tree branches */
  --positive: #5fbf77;              /* status only */
  --negative: #d96a5a;              /* status only */
  --glow-accent: 0 0 18px rgb(242 163 60 / 0.35);
  --glow-positive: 0 0 8px rgb(95 191 119 / 0.6);
}
```

Exposed to Tailwind via `@theme inline` as: `background`, `foreground`,
`text-primary`, `text-secondary`, `border`, `secondary-background`,
`secondary-background-hover`, `secondary-border`, `accent`,
`accent-hover`, `accent-muted`, `positive`, `negative`. Fonts:
`--font-mono` (Plex Mono), `--font-sans` (Plex Sans), loaded via next/font
in layout.

### Browser chrome is themed too

- Scrollbars, globally in globals.css: `scrollbar-width: thin;
  scrollbar-color: var(--border) transparent;` for Firefox, and webkit
  rules (8px, transparent track, `var(--border)` thumb with
  `border-radius: 0`, `var(--secondary-border)` on hover, transparent
  corner). Square thumbs — the browser default pill would be the only
  rounded rectangle on the site.
- `themeColor` in the Next viewport export set to `--background`'s value
  (`#0d0b07` for amber) so mobile browser chrome matches.

### Palette presets (user-selectable)

When a user asks for a different palette, swap ONLY the token block (and
themeColor). Keep the same *relationships*: warm/cool near-black bg, one
accent, a muted version of the accent, dim ink secondary. Derive glows
from the accent at ~35% alpha. Presets:

**amber (default — trading terminal)**: as above.

**green phosphor (classic CRT)**
```css
--background: #070b08; --foreground: #d8e8dc;
--text-primary: #d8e8dc; --text-secondary: #7d9184;
--border: #17281c; --secondary-background: #0b120d;
--secondary-background-hover: #101a13; --secondary-border: #1f3a28;
--accent: #4ade80; --accent-hover: #6ef29e; --accent-muted: #3a7d55;
--positive: #4ade80; --negative: #e06c5f;
--glow-accent: 0 0 18px rgb(74 222 128 / 0.35);
--glow-positive: 0 0 8px rgb(74 222 128 / 0.6);
```
Note: in green, accent and positive collide — acceptable; status dots
still read via glow and position.

**ice blue (modern console)**
```css
--background: #06090d; --foreground: #dbe6ee;
--text-primary: #dbe6ee; --text-secondary: #7c8b99;
--border: #16222d; --secondary-background: #0a1017;
--secondary-background-hover: #0f1720; --secondary-border: #22384a;
--accent: #56b6f2; --accent-hover: #7cc8ff; --accent-muted: #3d7196;
--positive: #5fbf77; --negative: #d96a5a;
--glow-accent: 0 0 18px rgb(86 182 242 / 0.35);
```

**paper (light experiment — off the golden path, ship at own risk)**:
invert bg/foreground relationships; scanlines become rgb(0 0 0 / 0.05);
glows become box-shadows at 20%. Not officially supported.

## Identity data (what a new user edits)

All personal content lives in data files and a few constants. To make the
site "theirs", a user edits ONLY these — components never hardcode
identity:

- Shell handle: `{name}@sh:~` appears in the Appbar, every command header,
  and the hero. It must live as a single constant `SHELL` in
  `src/lib/site.ts` (create if absent) alongside SITE_URL, EMAIL,
  CALENDLY, and socials; all components read from there.
- `(features)/projects/project-data.ts` — projects (title, banner[],
  web_link, stack[], description, features[], type, year?, github?).
- `(features)/stacks/stacks-data.ts` — `{ name, note?, group:
  "core"|"comfortable"|"tools" }`. Notes must be ≤ ~20 chars (they
  truncate on mobile).
- `(features)/experiences/timeline-data.ts` — entries; `endYear: null`
  marks the current role (renders as HEAD). Milestone titles are listed
  in the page's `MILESTONES` set.
- `(features)/trading/trading-data.ts` — optional page; delete the route
  if the user isn't a trader, and remove the nav item.
- `lib/posts.ts` + markdown files — blog.
- Appbar `SIDEBAR_MENU` — nav items.
- Ticker `STATS` array — must contain only TRUE claims; numbers here must
  agree with numbers elsewhere on the site (see Consistency).
- Layout metadata block — titles, OG, icons, themeColor.

## Layout skeleton

- `layout.tsx`: fonts (Plex Mono 400/500/600 + italic, Plex Sans 400/500)
  via next/font with variables `--font-plex-mono` / `--font-plex-sans`;
  `<html lang class="dark" + font vars>`; body contains Analytics
  (optional), scanline overlay `<div class="scanlines fixed inset-0 z-0"
  aria-hidden>`, then `<main class="relative z-10 flex h-screen flex-1
  flex-col overflow-hidden font-mono">` with fixed Appbar and a scrollable
  `mt-20 flex-1 overflow-y-auto` region holding pages + SiteFooter.
- **Scanlines sit BEHIND content** (z-0 vs z-10) so images and filled
  buttons stay clean. `.scanlines`: repeating-linear-gradient, 3px
  transparent / 1px rgb(0 0 0 / .08–.14), opacity .35–.5.
- `Container` (client, motion fade-up, `animate` prop to disable):
  `mx-auto flex w-full max-w-5xl px-4 sm:px-6` — no items-center in base.
  Canonical page usage:
  `<Container className="flex-col overflow-hidden pt-12 md:pt-16
  min-h-[calc(100dvh-100px)]">`

## The pattern language (copy these exactly)

### Command header (every page/section)
```tsx
<p className="text-sm text-accent-muted">
  {SHELL} $ <span className="text-accent">{command}</span>
</p>
<p className="mt-1.5 text-xs text-text-secondary">{subtitle}</p>
```
Commands per surface: hero `whoami --verbose` (typed animation); projects
`ls projects/ --featured` / `ls projects/ [flags]` (LIVE: active filters
appear as flags in the command); blog `ls blog/ [--tag]`; post
`cat {slug}.md`; stacks `npm ls {name} --depth=1`; experience
`git log --career`; trading `./trading --status`; contact/CTA
`./contact --no-pitch`. Vary the header commands; they describe content.

### Navigation-away links (uniform)
Always `cd`: `cd /projects →`, `cd ..` (breadcrumb), `cd ../{slug}`
(prev/next). Never `cat dir/` or bare flags as links.

### Filter pills = flags
`--all` + `--{slugified-value}`; square, `border-border
text-text-secondary`, active = `border-accent bg-accent text-background`.
Active flags echo into the section's command header. Empty states speak
shell: `ls: no matches for --x — clear filters`.

### List rows
- Projects (home): `drwx——  {slug}/  …  {type} · {year?}` in a bordered
  raised block; description sans; stack chips `border-border px-2 py-0.5
  text-[11px] text-accent-muted`; hover `translate-x-1` +
  `border-secondary-border`. Year renders only if present (no dangling ·).
- Blog rows: `{slug}.md` titles, dashed dividers (`border-dashed`), ISO
  dates (build `YYYY-MM` manually — never toLocaleDateString), meta line
  shows tags as flags.
- Solid borders = projects; dashed = blog/trading lists. Keep the split.

### Window chrome (all screenshots)
Title bar: traffic lights `bg-negative/70 bg-accent/70 bg-positive/70`
(rounded-full, 2–2.5px), centered truncated URL from `displayUrl()` with
fallback `~/projects/{slug}`, optional year right. Image below with
`border-b border-border`; in card grids images sit at `opacity-90`, full
on hover.

### Experience = git log
Timeline dots: current = accent filled + `--glow-accent`, period text
"HEAD" in accent; role = accent-muted filled; milestone = hollow
(border-border bg-background) + small `tag` label. Collapsible list
(client component): shows 4, then `⋮  N earlier entries — git log --all`
button; expanded shows `collapse — git log -n 4`.

### Stacks = npm ls tree
Root `{name}@{year}`; groups as `{group}/` in accent; branch glyphs
`├── / └──` in accent-muted. Two-column grid on md+
(`md:grid-cols-[1.3fr_1fr]`, core left, rest stacked right, dim). Rows are
flex: branch and name `flex-none`, note `min-w-0 truncate` — ONE line
always, note truncates on small screens. Names padEnd-aligned on sm+ only
(paired hidden spans). Notes as `# comment` in text-secondary with
accent-muted `#`.

### Ticker
Full-bleed strip under the nav row inside the fixed header (outside the
max-w wrapper). `.ticker-track`: width max-content, content rendered
TWICE, `animation: tick 32s linear infinite` to translateX(-50%), pause
on hover. `aria-hidden` (facts repeat elsewhere). ▲ in positive for
improving stats only.

### Buttons (components/button.tsx — API is stable, do not change props)
primary = accent outline → fills accent + glow on hover; secondary =
raised bordered; ghost = text → accent. Labels in-idiom:
`./book-meeting --30min`, `ls projects/`, `./open --live`, `git clone`.
The same action keeps the same label everywhere it appears.

### Footer
Key-value contact list (`key` in text-secondary min-w-[9ch], value link
in accent-muted → accent), email as copy-button (clipboard with mailto
fallback), bottom bar: `process exited 0 · © {year} {name lowercase}`.
Only claim "nothing tracked" if literally no analytics run.

### Markdown (blog bodies)
15px sans body; h2/h3 in mono with their own `##`/`###` rendered via
before:content in accent-muted; inline code = amber chips on raised bg;
pre = raised bg + `border-l-2 border-l-accent-muted`; dashed hr; amber
links/blockquotes; GFM tables as bordered mono grids.

### Signature gag: footer cat
`components/footer-cat.tsx` patrols above the bottom bar using
`public/oneko.gif` (MIT, adryd325/oneko.js sprite): 32px sprite, two-frame
E/W walk via background-position, SPEED 8px / TICK 150ms, rests ~12 ticks
at edges on the idle frame, `image-rendering: pixelated`,
`pointer-events-none` track, reduced-motion = sitting cat at right.
ONE cat. Do not add more mascots.

## Consistency invariants (check before every commit)

- Numbers agree site-wide: if the ticker says "30+ projects", no page says
  9 or "nine" without qualifying ("showing pinned").
- Naming exact: `Next.js`, `Node.js` (never "Next JS"); types lowercase
  in terminal chrome.
- `git grep -n "neutral-"` → only allowed in not-yet-themed routes.
- `git grep` for orphans after removing features; uninstall dead deps
  (never chain `grep || npm uninstall` — a failed grep false-triggers it).
- `npx tsc --noEmit` and `npm run build` pass.
- tsconfig.tsbuildinfo is gitignored.

## Generation recipe (for agents building a fresh copy)

1. Collect identity: name, handle, role line, bio (2 sentences, dry,
   specific), email, calendly, socials, palette choice.
2. Write tokens (chosen preset) + globals utilities (scanlines,
   cursor-block, blink, tick, scrollbars, reduced-motion block).
3. Layout: fonts, forced dark, themeColor, scanlines-behind, shell
   (Appbar + scroll region + footer).
4. Appbar: status dot + `{handle}` + lowercase text nav (breakpoint `lg`,
   burger below; row is flex-nowrap whitespace-nowrap — mono navs overflow
   early), mobile panel with `>` prefixes, Ticker last child of header.
5. Hero: typed `whoami --verbose` (type in useEffect from empty string —
   hydration-safe; reduced motion = instant), glow headline (short,
   declarative, user's own words), sans bio, status line with positive
   dot, lowercase social links, primary booking CTA + secondary
   `ls projects/`.
6. Homepage: Hero → project rows → blog cat-list → stack chips
   (`npm ls --depth=0`, `├──`-prefixed bordered chips) → CTA. No stats
   grid, no "now" section (ticker covers it).
7. Pages per the pattern language above. Detail pages get window chrome.
8. Footer + cat.
9. Run the consistency invariants. Delete every unused component the old
   design left behind (Title, theme toggle/provider, world map, dotted
   background, icon fields + react-icons, dotted-map).

## Known deliberate omissions

- `/recommendations` not yet themed (last `Title` + `neutral-` user).
- OG image still old-theme; regenerate to match (dark card, accent
  headline, handle).
- Approved for later, nothing started: interactive typeable prompt
  (`help`, `projects`, easter eggs) as v1.1; live ticker data via GitHub
  API (last commit, repo count). Nothing else should be added without a
  fight.
