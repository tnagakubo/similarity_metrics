# Marp Slides — Overflow Handling

Prevents slide content from silently leaking off 16:9 slide bounds at export time.

## Two layers of defense

### 1. CSS — clip + red warning (always on)

The lab Marp theme (`templates/marp_theme.css` and the inline style in
`templates/marp_slide_template.md`) sets `overflow: hidden` on every
`section`, so nothing ever escapes the slide box silently.

If an author deliberately leaves a slide oversized, or the validator
flags one, adding this directive at the top of the slide renders it
with a red outline + "OVERFLOW" ribbon so it is obvious in the export:

```markdown
<!-- _class: overflow -->
# This slide has too much content
- ...
```

Images and code blocks are also capped (`max-width: 100%`, `max-height: …`)
so oversized figures no longer push content off-screen.

### 2. Validation script — `scripts/check_marp_overflow.js`

A zero-dependency Node script that heuristically estimates rendered
height per slide and flags likely overflow. Run it before publishing:

```bash
# single deck
node scripts/check_marp_overflow.js path/to/deck.md

# multiple decks
node scripts/check_marp_overflow.js projects/similarity-metric/paper/slides/*.md

# include every slide in the report, not just warnings
node scripts/check_marp_overflow.js deck.md --verbose
```

Output is one line per deck when clean, or a per-slide report when
there are warnings:

```
== path/to/deck.md ==
  [WARN] slide #7   rendered=18.6 / budget=13  (table=6r)
  [ACK ] slide #12  rendered=22.1 / budget=13  [has _class: overflow]

Summary: 1 deck(s) checked, 1 un-acknowledged warning(s), 1 acknowledged.
```

**Exit codes** — CI-friendly:

| Code | Meaning |
|------|---------|
| 0    | No un-acknowledged warnings |
| 1    | At least one un-acknowledged warning |
| 2    | Usage / I/O error |

Acknowledged slides (those with `<!-- _class: overflow -->`) do **not**
fail the run — the author has explicitly opted into the visible warning.

## Using the theme in a new deck

Either:

- **Inline (easiest)** — copy `templates/marp_slide_template.md` as a
  starting point. The style block already contains the overflow rules.
- **External theme** — pass `--theme templates/marp_theme.css` to Marp
  CLI, or register the theme via `.vscode/settings.json` for VS Code.

```bash
# export to HTML with the external theme
npx @marp-team/marp-cli my_deck.md --theme templates/marp_theme.css --html -o my_deck.html

# export to PDF
npx @marp-team/marp-cli my_deck.md --theme templates/marp_theme.css --pdf -o my_deck.pdf
```

## Caveats

- The CSS clip **prevents silent overflow** but will hide content whose
  author did not acknowledge it. Run the validation script before export
  to catch these cases.
- The validator is **heuristic** — it over/under-shoots at the margins.
  It is tuned for 28px body text, 16:9, no custom font-size overrides.
  Changing the base font size in the theme requires recalibrating the
  `BUDGET_LINES_*` constants in `scripts/check_marp_overflow.js`.
- Images still need sensible authoring; the CSS caps width/height but a
  very large image can still dominate a slide visually.
- Marp CLI is not installed as a repo dependency. Use
  `npx @marp-team/marp-cli …` for ad hoc exports, or install locally with
  `npm i -D @marp-team/marp-cli` if you want pinned behavior.

## Demo / test

`templates/marp_slide_template.md` contains a commented-out demo slide at
the very end that shows the `<!-- _class: overflow -->` directive. Uncomment
it and export the template to see the red ribbon.
