# Review recurrence patterns（Louis、2026-10-11）

Louis の review で見つかり、再発しうる型を 3 つ。原稿を書く側（Harvey / Mike / Katrina）が先に自分で潰す。

1. **区間の overlap を同等性に格上げしない。** 二つの推定の marginal な 95% 区間が重なることは「区別できない／同等」の根拠ではない（paired なら尚更）。書くのは「区間は重ならない（差あり、保守的）」か「区間は重なる（差を示せない）」。原稿例: required n の W₁ vs KS、shape-symmetric mixture（曲線が目標付近で交差していた）。
2. **弁明の文書は、実行した確認だけを引用する。** prior-look の開示や protocol の「〜でも結論は変わらない」は、CSV を見て書く。見ずに書いた一文が shape-symmetric mixture で偽だった（閾値 0.8 で順位が逆転）。
3. **cascade は原稿だけで終わらせない。** 文言を狭めたら、CLAIMS.md の同じ主張を持つ他の行（C-38）、表番号の凡例、protocol の該当文、SUITS の記述まで同じ日に揃える。`grep` で旧文言の残存を確認してから終える。

付随: Monte Carlo の noise 幅は、1 cell を nominal と比べるなら約 2×MCSE、2 cell の差なら $z_{0.975}\sqrt{2} \approx 2.8$×MCSE。"twice" を使い分けずに書かない。

Reference: SUITS.md 2026-10-11 の Louis review scene、`projects/similarity-metric/DECISIONS.md` D-20261011-7。
