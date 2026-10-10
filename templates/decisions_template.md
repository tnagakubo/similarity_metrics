# DECISIONS — {project} 判断記録（append-only）

**Rule**: 方針を決めた・覆した・保留した、のすべてを 1 件 1 entry で残す。「決定 X と矛盾するから却下」は理由にならない — 却下の理由そのものを書く（Louis memory: reasonless ledger rejections）。覆すときは新 entry を作り、旧 entry の Status を `superseded by D-…` にする。削除はしない。

番号: `D-YYYYMMDD-n`。最新を **下**に追加（SUITS.md とは逆。時系列で読むため）。

---

### D-YYYYMMDD-1: {title}

- **Date**: YYYY-MM-DD  **Raised by**: {member}  **Decided by**: Tak / Harvey / Jessica
- **Question**: 何を決めるのか（1 文）
- **Options**:
  - A（最小）: 変更内容 / 影響範囲 / trade-off
  - B（構造）: …
  - C（折衷）: …
- **Decision**: 採った option と、その文言
- **Reasons**: なぜ他を捨てたか（証拠・原則・Tak の指示を引く）
- **Evidence / references**: files, `SUITS.md` scene `[YYYY-MM-DD HH:MM]`, CLAIMS IDs
- **Reversibility**: 何が分かれば reopen するか
- **Affected artifacts**: §/¶、scripts、figures、CLAIMS IDs（更新したか）
- **Status**: active / superseded by D-… / reopened

---
