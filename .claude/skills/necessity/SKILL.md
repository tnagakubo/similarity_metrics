---
description: Necessity and binding analysis — which conclusion fails if each study, scenario or cell is deleted; which results bind nothing; which results in the repository the paper never bills; Mike maps, Louis attacks
model: opus
argument-hint: "[study | all]"
---

# Research Lab: Necessity（simulation の必要性と binding — RESEARCH_FRAMEWORK S19）

問いは一つ: **「この simulation を消したら、どの結論が落ちるか」**。落ちる結論が無い simulation は confirmatory であって necessary ではない。逆に、本文に結論があって binding cell が無いなら、それは主張であって結果ではない。Claude Science は Study 1 の 7 scenario のうち 3 つが何も bind せず、Discussion の 1 段落が自分の CSV に反している（「n で落ちない」→ 実際は落ちて非ゼロ plateau に収束）のを見つけた。
対象: $ARGUMENTS（空なら全 study）。Output: `projects/{project}/review_response/NECESSITY_{YYYYMMDD}.md`

## Execution
1. **Donna**: `python3 scripts/evidence_coverage.py projects/{p} --out projects/{p}/review_response/EVIDENCE_COVERAGE_{date}.md`。unbilled results・missing evidence paths・unused figures の一覧を机に
2. **Mike**: `CLAIMS.md` の simulation / application 行ごとに **binding cell** を書く — その claim を決めている scenario × n × measure の 1 セル（例: 「n ≥ 100 推奨」は S2 の coverage 0.703 at n=50 が決める）。表: claim | binding cell | CSV 列 | 値 | MCSE | 次点の cell
3. **Mike**: 逆向きに、各 study の各 scenario / cell について「bind する claim」を書く。空欄 = confirmatory。interpolative（隣の 2 cell の間に全統計量が収まる）も confirmatory
3b. **Harvey**: **Aim ↔ Results 対応表**（S22）— `LAB_STATUS.md` の Question / Aims（目的）と **Results that answer A1**（R1, R2, …）を行に、Results の小節と CLAIMS の行を列に。Aim の文が方法（Study 名・推定量・データ名）になっていればそれ自体が finding（Tak 2026-10-12）。Aim に答えない Results（→ `/idea` か `exploratory/` か削除）と Results の無い Aim（→ Aim を narrow するか結果を足す）はどちらも finding。表は `NECESSITY_{date}.md` の先頭に置く
4. **Louis**（`Agent(subagent_type: "louis")`、渡すのは本文の simulation 由来の文の一覧と CSV のパス。隔離は指示によるもので tool scope ではない）: 本文の simulation 由来の文を一つずつ CSV の列と**方向**で照合（「落ちない」「頭打ち」「一様に」「全セルで」）。MCSE で noise か判定。自分の出力に反する claim は Critical
5. **Harvey**: confirmatory な scenario の扱い（本文に残して「load-bearing でない」と明記 / supplement へ — ただし supplement は作らない方針 → 削るか残すか）、unbilled results の扱い（claim を付けて cite / `exploratory/` に移して README に記す / 削除）を `/decide`
6. **Donna**: `NECESSITY_{date}.md` に両方向の表、SUITS.md に scene（TOP）。Phase 4→5・6→7 の gate evidence（`/phase next` の両一覧に載る）

## Rules
- 「必要」は binding cell を名指せる時だけ。「realistic だから」は necessary の理由にならない（realism check として残すのは可、evidence と呼ばない）
- unbilled result は黙って置かない。cite するか exploratory と書くか消す。`evidence_coverage.py` の unbilled 件数は ratchet（`scripts/baseline/`）で増えない
- 本文の方向語（did not fall / plateau / uniformly / across all）は CSV の列で 1 件ずつ確認。語っただけは ❌

## SUITS.md Scene（add at TOP）

```markdown
### [YYYY-MM-DD HH:MM] Scene: Necessity — {study}

**INT. PEARSON SPECTER LITT - BULLPEN - DAY**

*Mike がホワイトボードに claim と cell を線で結ぶ。線の無い cell が {k} 個。*

**Mike**: 「I got it! {claim} を決めているのは {cell} だ。{scenario} は何も bind しない — 隣の 2 つの間に全部収まる。」

**Louis**: 「L{l} の『{方向語}』は CSV と逆だ。{列} は {値} → {値}。MCSE {se}。You just got Litt up」

**Harvey**: 「{方針}」

---
```
