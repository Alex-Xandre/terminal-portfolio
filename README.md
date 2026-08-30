
# site preview
https://xandremicua.vercel.app/

# terminal-portfolio

A dark, single-accent, terminal-styled developer portfolio for Next.js.
Every page is framed as shell output: the hero types `whoami --verbose`,
projects render as `ls -l`, your career is a `git log` with a glowing
`HEAD`, your stack is an `npm ls` tree, and a pixel cat patrols the
footer above `process exited 0`.

Styled after a trading terminal — warm amber phosphor on near-black —
not the usual Matrix green. (Green is available if you insist. See
palettes.)

**Live demo:** https://xandremicua.vercel.app

<!-- TODO: hero screenshot -->

> **Status: harness-first.** This repo currently ships the complete
> design system as an agent harness — [`AGENTS.md`](./AGENTS.md)
> (imported by `CLAUDE.md` for Claude Code). Reference implementation
> and a "Use this template" flow are coming.

## Generate your portfolio with an AI agent

The harness encodes every rule, token, and pattern of the design: what
the command headers say per page, why navigation links are always `cd`,
which borders are dashed vs solid, how the stack tree truncates on
mobile, the exact palette blocks, and what an agent must never add.

Clone this repo, open it in Claude Code (or any AGENTS.md-aware tool),
and say:

> "Generate the portfolio this harness describes. I'm Sam, a backend
> engineer — here are my projects and links. Use the green palette."

The agent has everything it needs to build it correctly — including the
generation recipe at the bottom of the harness, in order.

## Features

- Command-prompt section headers that go **live** — filter projects by
  `--postgres` and the header reads `$ ls projects/ --postgres`
- Typed hero, ticker strip of your stats, window-chrome screenshot frames
- Experience as `git log`: current role = `HEAD`, milestones = tags,
  collapsible history
- Stack as an `npm ls` dependency tree with `# comment` annotations
- Blog with `slug.md` listings and markdown that renders its own `##`
  syntax
- One accent color, sharp corners, IBM Plex Mono/Sans, CRT scanlines
  (behind content, where they belong)
- A cat. (oneko sprite, patrols the footer, sits at the edges. One cat
  only — this is a rule.)
- Reduced-motion fallbacks for everything, dark-only, ~12 runtime deps

## Quick start (once reference code ships)

1. Click **Use this template** → create your repo
2. `npm install && npm run dev`
3. Make it yours by editing **only these files**:

| File | What it holds |
|---|---|
| `src/lib/site.ts` | Your shell handle, email, Calendly, socials, site URL |
| `src/app/(features)/projects/project-data.ts` | Projects |
| `src/app/(features)/stacks/stacks-data.ts` | Stack tree (notes ≤ ~20 chars) |
| `src/app/(features)/experiences/timeline-data.ts` | Career entries (`endYear: null` = current role) |
| `content/posts/*.md` | Blog posts |
| `src/app/layout.tsx` | Metadata, OG image |
| Appbar `SIDEBAR_MENU` + Ticker `STATS` | Nav items, your true numbers |

The trading page is optional — delete the route and its nav item if
that's not you.

4. Deploy to Vercel. Done.

## Palettes

The entire theme is one token block in `globals.css`. Swap it, and every
component follows — nothing else to touch. Presets included:

- **amber** — trading terminal (default)
- **green phosphor** — classic CRT
- **ice blue** — modern console

Full token blocks for each are in [`AGENTS.md`](./AGENTS.md#palette-presets-user-selectable).

## The rules (short version)

One accent color. No brand logos. Mono for chrome, sans for reading.
Sharp corners. Dark only. Every color from a token. Content images in
window frames only. The design's power is restraint — most bugs in this
codebase are additions. The long version, with reasons, lives in
`AGENTS.md`.

## Stack

Next.js (App Router) · Tailwind v4 · IBM Plex Mono + Sans · motion ·
react-markdown + remark-gfm

## Credits

- Cat sprite from [oneko.js](https://github.com/adryd325/oneko.js) by
  adryd325 (MIT)
- IBM Plex by IBM (OFL)

## License

MIT — do whatever you like, a link back is appreciated but not required.
