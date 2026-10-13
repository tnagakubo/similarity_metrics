---
name: feedback_idea_stock
description: 議論の展開で新たな論文のネタが出たら、その場で root の IDEAS_BACKLOG.md にストックする（/idea、I-YYYYMMDD-n）。現論文の scope 外に出した論点は捨てずに保存し、良し悪しはその場で議論しない（Tak 2026-10-12）
metadata:
  type: feedback
---
**Source**: Tak 2026-10-12 10:09「システム改修」指示（SUITS.md scene 2026-10-12 10:29）。RESEARCH_FRAMEWORK.md §12 / S23。

**Tak の言葉**（verbatim）: 「議論の展開で、新たな論文のネタとなりそうなものが出てきた場合、そのネタをストックしておく。」

**Why:** scope 外に出した論点 — 効果追跡 sim（[[project_no_effect_tracking_sim]]）、Neyman smooth test の 2 標本版（Claude Science の exploratory）、clustering / silhouette 拡張（09-27 に原稿から外した、`PROTOCOL_silhouette_extension.md`）、相対効果の因果推論的再考 — は SUITS の scene と archive に埋もれて検索できない。`IDEAS_BACKLOG.md` は 2026-02-03 以来 1 件しか無かった。絞る（[[feedback_diverge_converge]]）ことと捨てることは別。

**How to apply:**
1. 誰でも気づいたら `/idea <一行>`。Donna が `I-YYYYMMDD-n` で `IDEAS_BACKLOG.md`（root、cross-project）に登録 — date / source（scene・D-ID・review の #）/ 一行 / 現論文の scope 外である理由（どの Aim にも答えない）/ 必要な根拠・データ / status / by
2. 登録が義務になる場面: `/meeting` Phase 4 の発散論点、`/decide` で却下した option が別論文になるとき、`/explore` の No-Go、`/review` `/referee` の「scope 外」指摘、`/victory` Phase 9
3. ストックは**判定しない**。ネタの良し悪しをその場で議論すると本題が止まる。登録して本題に戻る
4. status: 💡 Incubating → 🔬 Exploring（`/explore <slug>`）→ 📄 Promoted（`/start` で新 project）/ 🗑 Dropped（理由）。Harvey が Phase 9 で見直し、次の Question を選ぶ
5. 根拠の無いネタは `[推測]` 付きで登録してよい（ストックは推測 OK、原稿は不可 — [[feedback_evidence_over_inference]]）
