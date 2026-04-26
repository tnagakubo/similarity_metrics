---
marp: true
size: 16:9
paginate: true
theme: default
style: |
  section { font-size: 28px; line-height: 1.3; padding: 60px; }
  section.overflow::after {
    content: "OVERFLOW";
    position: absolute; top: 12px; right: 12px;
    background: red; color: white; padding: 4px 12px;
    font-weight: bold; z-index: 10;
  }
  section.overflow { outline: 4px solid red; }
  section { overflow: hidden; }
---

# Slide 1 — Normal (should pass)

- bullet one
- bullet two
- bullet three

Short content, no overflow.

---

# Slide 2 — Moderately long (should pass)

- item 1
- item 2
- item 3
- item 4
- item 5
- item 6
- item 7

A small paragraph fits within the budget without issue.

---

# Slide 3 — Intentional overflow (should WARN)

- point 1 with some additional explanatory text that wraps
- point 2 with some additional explanatory text that wraps
- point 3 with some additional explanatory text that wraps
- point 4 with some additional explanatory text that wraps
- point 5 with some additional explanatory text that wraps
- point 6 with some additional explanatory text that wraps
- point 7 with some additional explanatory text that wraps
- point 8 with some additional explanatory text that wraps
- point 9 with some additional explanatory text that wraps
- point 10 with some additional explanatory text that wraps
- point 11 with some additional explanatory text that wraps
- point 12 with some additional explanatory text that wraps
- point 13 with some additional explanatory text that wraps
- point 14 with some additional explanatory text that wraps
- point 15 with some additional explanatory text that wraps

---

<!-- _class: overflow -->

# Slide 4 — Intentional overflow, ACKNOWLEDGED

This slide has the same length as slide 3 but is acknowledged with `<!-- _class: overflow -->`.

- point 1 with some additional explanatory text that wraps
- point 2 with some additional explanatory text that wraps
- point 3 with some additional explanatory text that wraps
- point 4 with some additional explanatory text that wraps
- point 5 with some additional explanatory text that wraps
- point 6 with some additional explanatory text that wraps
- point 7 with some additional explanatory text that wraps
- point 8 with some additional explanatory text that wraps
- point 9 with some additional explanatory text that wraps
- point 10 with some additional explanatory text that wraps
- point 11 with some additional explanatory text that wraps
- point 12 with some additional explanatory text that wraps

---

# Slide 5 — Large table overflow (should WARN)

| Col A | Col B | Col C |
|-------|-------|-------|
| row1  | data  | data  |
| row2  | data  | data  |
| row3  | data  | data  |
| row4  | data  | data  |
| row5  | data  | data  |
| row6  | data  | data  |
| row7  | data  | data  |
| row8  | data  | data  |
| row9  | data  | data  |
| row10 | data  | data  |
| row11 | data  | data  |
| row12 | data  | data  |

Table row cost multiplier validation.
