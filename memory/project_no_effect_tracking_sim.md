---
name: project-no-effect-tracking-sim
description: 効果関数 θ(x) を特定して治療効果差を追跡するシミュレーションは行わない。θ の選択に結果が依存して一般性を失い、KR 双対性により W₁ が定義上最適になる循環論法になる
metadata:
  type: project
---
**Source**: `.claude/skills/protocol/SKILL.md` 禁止事項、`RESEARCH_FRAMEWORK.md` §2、`projects/similarity-metric/PAPER_LOGIC.md` 統治ルール、`.claude/agent-memory/louis/`（circular-kr）、`SUITS.md` 2026-09-26「harm 削除（KR 双対の循環）」。

**なぜ**:
1. **一般性**: θ を一つ置けば結果はその θ の下での話にしかならない。論文の claim は identification（分布差を見落とさないか）であり、特定の効果曲線の下での性能ではない
2. **循環**: Kantorovich–Rubinstein 双対 $W_1(F_1,F_2)=\sup_{\|\theta\|_{\mathrm{Lip}}\le 1}\left|\int\theta\,dF_1-\int\theta\,dF_2\right|$ により、Lipschitz な θ に対する効果差の上限を達成するのは W₁ そのもの。θ を Lipschitz に置いて W₁ を評価すれば、W₁ が定義上勝つ

**許される設計**: Study 1（identification — 分布差の識別、ground truth は生成機構）、Study 2（推定特性 — bias / coverage / MCSE）、実データ調査（descriptive、事前登録）。KR bound（Prop. 1）は定理として述べ、sim で「確認」しない。

**チェック**: `/protocol` §6 で Louis が「KR 双対で W₁ が定義上最適になる設計か」を必ず問う。
