# CLAIMS — {project} 主張↔証拠台帳

**Owner**: Harvey（主張の文言）/ Mike（証拠の所在と検証）/ Louis（攻撃）/ Donna（原稿との整合）
**Rule**: 原稿のあらゆる主張（abstract を含む）はこの台帳の 1 行に対応する。台帳に無い主張は書かない。証拠を削ったら主張を narrow し、C1 cascade（`templates/review_checklist.md`）で原稿の全出現箇所を直す。

## 動詞の許容（P5: 主張と証拠の比例）

| 証拠の型 | 許される動詞 | 禁止 |
|---|---|---|
| theory（命題・証明） | shows, establishes, implies | — |
| simulation | demonstrates, illustrates, indicates（設計した範囲内で） | proves, guarantees |
| application（実データ、ground truth なし） | illustrates, is consistent with | shows that W₁ is correct, outperforms |
| literature / guideline | describes, notes, permits（E17） | recommends, requires, mandates |

## 台帳

| ID | Claim（原稿の文言、1 文） | Type | Evidence（file:line / Prop. / CSV 列 / protocol） | Verb used | Carried by（§/¶; abstract に載るか） | Status | Last verified（who, date） |
|---|---|---|---|---|---|---|---|
| C-01 | | theory / simulation / application / literature | | | | pending / supported / narrowed / retracted | |

**Status の意味**: pending = 証拠未確認 / supported = 証拠がディスク上にあり verifier が確認 / narrowed = 証拠に合わせて文言を狭めた（旧文言を下に記録）/ retracted = 原稿から削除（残存 0 を grep で確認）

## Narrowed / retracted log（append-only）

| date | ID | 旧文言 | 新文言 or 削除 | 理由 | cascade 確認（grep 結果） |
|---|---|---|---|---|---|

## 使い方

- `/claims init` で原稿から主張を抽出して起票、`/claims check` で各行の Evidence がディスクに在るか・動詞が許容表に収まるかを検証
- `/protocol` の §2（licenses / does not license）は、この台帳の候補行
- `/pre-review` `/review` `/submission-check` は台帳の Status が全行 supported であることを要求する（abstract の主張は特に）
