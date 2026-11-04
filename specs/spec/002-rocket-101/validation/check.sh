#!/usr/bin/env bash
# Implementation checks for specs/spec/002-rocket-101 (tasks T001, T002).
# Each check cites the task-plan task id and acceptance criterion it proves.
# Run from the repository root:  bash specs/spec/002-rocket-101/validation/check.sh
# Exit status is non-zero when any check fails.

set -u
cd "$(git rev-parse --show-toplevel)"

BASE=32190a991ff3   # merge-base pinned by task-plan D008 (used by V004/V005)
fail=0
pass_n=0

check() {
  local id="$1"; shift
  if ( eval "$*" ) >/dev/null 2>&1; then
    printf 'PASS %s\n' "$id"; pass_n=$((pass_n + 1))
  else
    printf 'FAIL %s\n' "$id"; fail=1
  fi
}

# Extract a section of AGENTS.md between two heading regexes (first match of
# $1 up to, not including, the first later line matching $2).
section() {
  awk -v start="$1" -v stop="$2" '
    found && $0 ~ stop { exit }
    $0 ~ start { found = 1 }
    found { print }
  ' AGENTS.md
}

# ---------------------------------------------------------------- T001
# Plan validations V001–V005 (verbatim from task-plan.json).
check "T001/AC-T001-1 (V001)" "test \"\$(grep -c 'cat recommendations/\\*.md' AGENTS.md)\" -ge 2"
check "T001/AC-T001-4 (V002)" "! grep -q 'not yet themed' AGENTS.md && grep -q 'OG image still old-theme' AGENTS.md && grep -q 'Nothing else should be added without a fight' AGENTS.md"
check "T001/AC-T001-2,AC-T001-5 + T002/AC-T002-1,AC-T002-3 (V003)" "grep -q 'recommendations-data.ts' AGENTS.md && test \"\$(grep -c 'recommendations-data.ts' README.md)\" -eq 1 && ! grep -q '/testimonials' AGENTS.md README.md"
check "T001/AC-T001-6 (V004)" "! git diff $BASE -- AGENTS.md README.md | grep '^+' | grep -v '^+++' | grep -Eq 'neutral-|rounded-|#[0-9a-fA-F]{6}'"
check "T001/AC-T001-7 + T002/AC-T002-4 (V005)" "test \"\$(git diff --name-only $BASE -- . ':!specs' | sort | tr '\\n' ' ')\" = 'AGENTS.md README.md ' && ! git diff $BASE -- AGENTS.md | grep -E '^[-+]\\s*--(background|foreground|accent|border|positive|negative)'"

# AC-T001-7 (finer): no modified line inside the numbered 'Non-negotiable rules' list.
check "T001/AC-T001-7 rules-list untouched" "! git diff $BASE -- AGENTS.md | grep -Eq '^[-+] ?[0-9]+\\. \\*\\*'"

# AC-T001-1 (finer): the command appears in the commands-per-surface list.
check "T001/AC-T001-1 commands-per-surface" "section '^### Command header' '^### ' | grep -q 'recommendations \`cat recommendations/\\*.md\`'"

# AC-T001-2 (finer): the Identity-data bullet documents every field and the truthfulness rule.
IDENTITY='section "^## Identity data" "^## Layout skeleton"'
for needle in 'recommendations-data.ts' 'Recommendation[]' 'name' 'role' 'company?' 'quote' 'date?: "yyyy-mm"' 'source?: { label, url }' 'newest first' 'verbatim' 'permission'; do
  check "T001/AC-T001-2 identity bullet: $needle" "$IDENTITY | grep -qF -- '$needle'"
done

# AC-T001-3: the pattern subsection exists inside 'The pattern language' and names every part of design AC-D1–AC-D5, AC-D7.
check "T001/AC-T001-3 subsection inside pattern language" "section '^## The pattern language' '^## Consistency invariants' | grep -q '^### Recommendations = cat quotes'"
SUB='section "^### Recommendations = cat quotes" "^### |^## "'
for needle in \
  'cat recommendations/*.md' \
  'border-dashed' 'border-border' 'secondary-background' 'hover' 'secondary-border' 'no translate' \
  '{slug}.md' 'text-primary' 'text-secondary' 'truncat' 'yyyy-mm' '<time datetime' \
  '<blockquote' 'font-sans' '15px' 'border-l-2 border-l-accent-muted pl-3' 'max-w-prose' 'never truncated' \
  '— {name}' '{role} @ {company}' \
  '# via {label} ↗' 'accent-muted → accent' 'sm+' 'own line' 'rel="noopener noreferrer"' 'aria-label' \
  '<ol aria-label="recommendations">' 'newest first' \
  '{n} files · quoted verbatim, with permission · newest first' '1 file' '0 files' \
  'as written' 'lowercase' 'stored' \
  'cat: recommendations/*.md: No such file or directory' 'cd ~' \
  'headshots' 'logos' 'ratings' 'carousel' 'autoplay' 'truncation' 'CTA' \
  'reduced' 'fade-up' 'transition' \
  '<article>' 'focus'; do
  check "T001/AC-T001-3 subsection names: $needle" "$SUB | grep -qF -- '$needle'"
done

# AC-T001-6: the new subsection uses only tokens — no neutral-*, rounded-*, or hex.
check "T001/AC-T001-6 subsection token-only" "! $SUB | grep -Eq 'neutral-|rounded-|#[0-9a-fA-F]{6}'"

# AC-T001-5
check "T001/AC-T001-5 no /testimonials in AGENTS.md" "! grep -q '/testimonials' AGENTS.md"

# T001 description items (4)–(7): nav bullet, recipe step 4, shell section, recipe mention, omission removed.
check "T001 (4) SIDEBAR_MENU bullet names recommendations last after trading" "section '^- Appbar .SIDEBAR_MENU' '^- ' | grep -q 'recommendations'"
check "T001 (4) recipe step 4 names recommendations" "section '^4\\. Appbar' '^5\\. ' | grep -q 'recommendations'"
check "T001 (5) interactive shell lists recommendations" "section '^### Interactive shell' '^### ' | grep -q 'recommendations'"
check "T001 (6) recipe mentions the recommendations page once" "test \"\$(section '^## Generation recipe' '^## Known deliberate omissions' | grep -c 'recommendations')\" -ge 1"
check "T001 (7) omission line removed" "! grep -q '/recommendations. not yet themed' AGENTS.md"

# ---------------------------------------------------------------- T002
check "T002/AC-T002-2 (V006)" "test \"\$(grep -c 'cat recommendations' README.md)\" -eq 1"
check "T002/AC-T002-1 table row after timeline-data row" "
  t=\$(grep -n 'timeline-data.ts' README.md | head -1 | cut -d: -f1);
  r=\$(grep -n 'recommendations-data.ts' README.md | head -1 | cut -d: -f1);
  test -n \"\$t\" && test -n \"\$r\" && test \"\$r\" -eq \"\$((t + 1))\" &&
  grep -q '^| \`src/app/(features)/recommendations/recommendations-data.ts\` |' README.md"
check "T002/AC-T002-2 bullet is in the Features list" "awk '/^## Features/{f=1;next} /^## /{f=0} f' README.md | grep -q '^- .*cat recommendations'"
check "T002/AC-T002-3 no /testimonials in README.md" "! grep -q '/testimonials' README.md"
check "T002 testimonials synonym at most once" "test \"\$(grep -o -i 'testimonials' README.md | wc -l)\" -le 1"

printf '\n%s checks passed; overall: %s\n' "$pass_n" "$([ "$fail" -eq 0 ] && echo GREEN || echo RED)"
exit "$fail"
