#!/usr/bin/env node
/*
 * check_marp_overflow.js
 * ----------------------
 * Detect Marp slides whose content is likely to overflow the slide box.
 *
 * Primary mode (default, zero-dependency):
 *   Heuristic scan of the markdown — estimates rendered height per slide
 *   from line/bullet count, character count (for wrapping), code block
 *   lines, and table rows. Fast and approximate; no browser needed.
 *
 * Acknowledgement:
 *   If a slide has `<!-- _class: overflow -->` in it, the theme renders
 *   a red outline + ribbon at export time and this script treats it as
 *   acknowledged (counted but does not fail the run).
 *
 * Exit codes:
 *   0  no un-acknowledged overflow warnings
 *   1  at least one un-acknowledged overflow warning
 *   2  usage / I/O error
 *
 * Usage:
 *   node scripts/check_marp_overflow.js <deck.md> [<deck2.md> ...] [--verbose]
 *
 * Example:
 *   node scripts/check_marp_overflow.js templates/marp_slide_template.md
 *   node scripts/check_marp_overflow.js projects/similarity-metric/paper/slides/*.md
 *
 * For exact pixel-accurate overflow detection, export the deck:
 *   npx @marp-team/marp-cli deck.md --html -o deck.html
 * and open the HTML in a browser — the bundled theme outlines overflowing
 * slides in red (via `<!-- _class: overflow -->` or manual inspection).
 */

'use strict';

const fs = require('fs');
const path = require('path');

const args = process.argv.slice(2);
if (args.length === 0 || args.includes('--help') || args.includes('-h')) {
  console.error('Usage: node scripts/check_marp_overflow.js <deck.md> [...] [--verbose]');
  process.exit(2);
}

const VERBOSE = args.includes('--verbose');
const FILES = args.filter(a => !a.startsWith('--'));

// -------- heuristic thresholds (calibrated for 16:9 720px @ font 28px) -----
// Slide body after the h1 banner is ~520px tall. A line of 28px text with
// line-height 1.3 is ~36px — so about 14 text lines fit. Headings eat more.
const BUDGET_LINES_DEFAULT = 13;
const BUDGET_LINES_COLS    = 20;      // 2 cols effectively doubles capacity
const BUDGET_CHARS_PER_LINE = 70;     // approx wrap at 28px / ~1140px body
const CODE_LINE_COST = 1.2;           // monospace lines are near-full-height
const TABLE_ROW_COST = 1.3;           // header + padded rows

function splitSlides(md) {
  // Skip frontmatter (first `---` … `---`), then split on standalone `---`.
  let body = md;
  if (md.startsWith('---\n') || md.startsWith('---\r\n')) {
    const end = md.indexOf('\n---', 4);
    if (end !== -1) body = md.slice(md.indexOf('\n', end + 4) + 1);
  }
  return body.split(/^---\s*$/m).map(s => s.replace(/^\s+|\s+$/g, ''));
}

function classifySlide(slide) {
  const m = slide.match(/<!--\s*_class:\s*([\w\s-]+?)\s*-->/);
  if (!m) return { cls: '', acknowledged: false };
  const classes = m[1].split(/\s+/);
  return {
    cls: classes.join(' '),
    acknowledged: classes.includes('overflow'),
  };
}

function estimateLines(slide) {
  // Strip HTML comments (including Marp directives) before measuring.
  let txt = slide.replace(/<!--[\s\S]*?-->/g, '');

  let codeLines = 0;
  txt = txt.replace(/```[\s\S]*?```/g, (block) => {
    codeLines += Math.max(0, block.split('\n').length - 2);
    return '';
  });

  let tableRows = 0;
  const kept = [];
  for (const l of txt.split('\n')) {
    if (/^\s*\|.*\|\s*$/.test(l)) tableRows += 1;
    else kept.push(l);
  }
  const lines = kept.filter(l => l.trim().length > 0);

  let rendered = 0;
  for (const l of lines) {
    if (/^#\s/.test(l))       rendered += 2.5;
    else if (/^##\s/.test(l)) rendered += 2.0;
    else if (/^###\s/.test(l)) rendered += 1.6;
    else {
      const wrap = Math.max(1, Math.ceil(l.length / BUDGET_CHARS_PER_LINE));
      rendered += wrap;
    }
  }
  rendered += codeLines * CODE_LINE_COST;
  rendered += tableRows * TABLE_ROW_COST;
  return { rendered, codeLines, tableRows };
}

function analyze(file) {
  const md = fs.readFileSync(file, 'utf8');
  const slides = splitSlides(md);
  const reports = [];
  slides.forEach((slide, idx) => {
    if (!slide) return;
    const { cls, acknowledged } = classifySlide(slide);
    // Title / section divider / end slides are centered, not line-budgeted.
    if (/\b(title|section|end)\b/.test(cls)) return;
    const budget = /\bcols\b/.test(cls) ? BUDGET_LINES_COLS : BUDGET_LINES_DEFAULT;
    const { rendered, codeLines, tableRows } = estimateLines(slide);
    reports.push({
      file, idx: idx + 1,
      rendered: Math.round(rendered * 10) / 10,
      budget, acknowledged, codeLines, tableRows,
      overflow: rendered > budget,
    });
  });
  return reports;
}

let totalChecked = 0;
let failCount = 0;
let ackCount = 0;

for (const f of FILES) {
  const abs = path.resolve(f);
  if (!fs.existsSync(abs)) {
    console.error(`not found: ${f}`);
    process.exit(2);
  }
  const reports = analyze(abs);
  totalChecked += 1;
  const overflowing = reports.filter(r => r.overflow);
  const unack = overflowing.filter(r => !r.acknowledged);
  failCount += unack.length;
  ackCount  += overflowing.length - unack.length;

  if (overflowing.length === 0 && !VERBOSE) {
    console.log(`OK  ${f}  (no likely-overflowing slides)`);
    continue;
  }
  console.log(`\n== ${f} ==`);
  for (const r of reports) {
    if (!r.overflow && !VERBOSE) continue;
    const tag = r.overflow ? (r.acknowledged ? 'ACK ' : 'WARN') : 'ok  ';
    const extra = [];
    if (r.codeLines) extra.push(`code=${r.codeLines}L`);
    if (r.tableRows) extra.push(`table=${r.tableRows}r`);
    console.log(
      `  [${tag}] slide #${r.idx}  rendered=${r.rendered} / budget=${r.budget}` +
      (extra.length ? `  (${extra.join(', ')})` : '') +
      (r.acknowledged ? '  [has _class: overflow]' : '')
    );
  }
}

console.log(
  `\nSummary: ${totalChecked} deck(s) checked, ` +
  `${failCount} un-acknowledged warning(s), ${ackCount} acknowledged.`
);
if (failCount > 0) {
  console.log('Tip: fix the slide OR add `<!-- _class: overflow -->` at its top to acknowledge');
  console.log('     (the export will then show a red outline + "OVERFLOW" ribbon).');
  process.exit(1);
}
process.exit(0);
