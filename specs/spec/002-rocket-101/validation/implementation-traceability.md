# Implementation traceability — `specs/spec/002-rocket-101`

Stage `implement` · run `a6424dc2-c60f-404a-a6fa-c85c1bc040ec` · loop 1 ·
attempt `ss_spec_002-rocket-101_1793769277645_2`.

Bound inputs: `task_plan` = `specs/spec/002-rocket-101/design.md` at
`85e10b8` (sha256 `cb964202…81e8b3`, verified before use) with the plan it
answers, `specs/spec/002-rocket-101/task-plan.json` (status `ready`, T001
re-derived from design D012–D016). Design approval receipt
`5f1fb897-e477-411f-adc5-5cf0a2c0d14c` (stage `design`, loop 1) applies;
`validation_remediation` and `review_remediation` were null (first pass).

All checks live in `specs/spec/002-rocket-101/validation/check.sh`
(`bash specs/spec/002-rocket-101/validation/check.sh` from the repo root;
each line prints `PASS|FAIL <task>/<AC>`). It embeds the plan's V001–V006
verbatim plus finer per-criterion assertions. TDD order observed: script
written and run first at `85e10b8` → RED (6 of 80 pass, the six being the
negative checks that hold on an unmodified tree); T001 applied → 75/80
(only README-dependent checks red); T002 applied → 80/80 GREEN. The plan's
six commands were also run raw after T002: V001–V006 all pass.

| Task | Changed source paths | Checks (exact ids in `check.sh`) | Acceptance criteria proven |
|---|---|---|---|
| T001 | `AGENTS.md` — Identity data bullet (`recommendations-data.ts`), Command header › commands per surface, new `### Recommendations = cat quotes` subsection (between Markdown and Signature gag), `SIDEBAR_MENU` bullet, Interactive shell paragraph, recipe steps 4 and 7, Known deliberate omissions | `T001/AC-T001-1 (V001)`, `T001/AC-T001-1 commands-per-surface`; `T001/AC-T001-2 identity bullet: *` (11 needles); `T001/AC-T001-3 subsection inside pattern language`, `T001/AC-T001-3 subsection names: *` (49 needles); `T001/AC-T001-4 (V002)`, `T001 (7) omission line removed`; `T001/AC-T001-5 no /testimonials in AGENTS.md`; `T001/AC-T001-6 (V004)`, `T001/AC-T001-6 subsection token-only`; `T001/AC-T001-7 + T002/AC-T002-4 (V005)`, `T001/AC-T001-7 rules-list untouched`; `T001 (4) SIDEBAR_MENU bullet…`, `T001 (4) recipe step 4…`, `T001 (5) interactive shell…`, `T001 (6) recipe mentions…` | AC-T001-1 … AC-T001-7; design AC-D1–AC-D7 via the subsection needles (D1 anatomy classes, D2 data shape in the identity bullet, D3 empty-state/subtitle strings, D4 prohibition line + casing, D5 motion/a11y names, D6 token-only grep, D7 mobile bullet) |
| T002 | `README.md` — Quick-start table row directly after `timeline-data.ts`; one Features bullet | `T002/AC-T002-1 table row after timeline-data row`; `T002/AC-T002-2 (V006)`, `T002/AC-T002-2 bullet is in the Features list`; `T002/AC-T002-3 no /testimonials in README.md`, `T002 testimonials synonym at most once`; `T001/AC-T001-2,AC-T001-5 + T002/AC-T002-1,AC-T002-3 (V003)`; `T001/AC-T001-7 + T002/AC-T002-4 (V005)` | AC-T002-1 … AC-T002-4 |

## Decisions made during implementation

- **I001 — subsection placement.** `### Recommendations = cat quotes` sits
  after `### Markdown (blog bodies)` because the quote reuses that section's
  `border-l-2 border-l-accent-muted` rule; T001 fixed the heading text and
  parent section but not the position.
- **I002 — plan item (6) satisfied by extending recipe step 7** ("Pages per
  the pattern language above, including `/recommendations` (= cat
  quotes)") rather than adding a step, per the task's "one mention, no
  duplication". Step 4 gained the nav-order clause required by item (4).
- **I003 — Interactive shell wording.** One clause appended to the existing
  "Commands that name a section…" sentence; no existing pattern wording was
  rewritten (T001 constraint).
- **I004 — check harness.** `check()` evaluates in a subshell of the script
  (`( eval … )`), not `bash -c`, so the `section` helper is in scope. The
  first green run after T001 exposed this; fixed before T001 was committed.

## Unresolved / notes for validation

- The consistency invariant `git grep -n "neutral-"` → "only allowed in
  not-yet-themed routes" (AGENTS.md › Consistency invariants) is now
  vacuous — no route is unthemed. It is hyphenated, so V002/AC-T001-4
  (`not yet themed`, spaces) do not match it. Left untouched: outside T001's
  seven enumerated edits and not a pattern. Flagged, not silently dropped.
- Design D011 still stands: `design/mocks/round-0001.json` is unverified
  against a DOM and must be re-applied on the first branch that ships the
  reference implementation. Nothing in this stage changes that (no app
  code exists; scope D001).
- No ADR authored (plan D006: repository has no ADR convention).
