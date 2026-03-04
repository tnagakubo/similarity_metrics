# SUITS.md - Research Lab Live Script

> *"I don't have dreams. I have goals."* - Harvey Specter

---

### [2026-03-04 03:15] Scene: Meeting — IST効果修飾因子の確認と国別nABCD比較

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - NIGHT**

*Harvey がホワイトボードの前に立つ。Rachel、Mike、Katrina、Donna が着席。Louis がドア際で腕を組む。*

**Harvey**: （全員を見渡して）
「今日の議題は一つ。ISTの効果修飾因子は何なのか。あるなら国レベルでnABCDを出す。ないなら、baseline共変量 — つまり潜在的な効果修飾因子 — で比較する。論文のプロセスに従え。Rachel、文献から始めろ」

**Rachel**: （ファイルを開いて）
「"Hard work beats talent when talent doesn't work hard." 調査結果は明確。

**結論: ISTにはaspirinの確認された効果修飾因子は存在しない。**

根拠は3つ:

**1. Chen et al. (2000)** — CAST+IST統合解析 n=40,000
DOI: [10.1161/01.str.31.6.1240](https://doi.org/10.1161/01.str.31.6.1240)
- 10の基線特性で28サブグループを事前規定して検討
- 検討変数: age, sex, consciousness, AF, CT所見, BP, stroke subtype, heparin
- **χ²(18) = 20.9, NS — どのサブグループでも治療効果の異質性なし**
- 原文: "The absolute risk reduction does not differ substantially with respect to any subgroup"

**2. Leonardi-Bee et al. (2002)** — SBP分析
DOI: [10.1161/01.str.0000014509.11540.66](https://doi.org/10.1161/01.str.0000014509.11540.66)
- SBPはstrong prognostic factorだが、**治療効果の修飾因子としては非有意**

**3. Saxena et al. (2001)** — AF サブグループ
DOI: [10.1161/hs1001.097093](https://doi.org/10.1161/hs1001.097093)
- AF患者で高用量heparinの効果に差があるが、aspirin治療効果自体の修飾ではない」

**Harvey**: （頷いて）
「よし。確認された効果修飾因子はない。つまり論文のプロセスに従えば、baseline共変量 — 潜在的な効果修飾因子 — で比較する。Mike、国レベルの分析結果を出せ」

**Mike**: （モニターを指して）
「"I got it!" 24カ国（n≥100）で276ペアのnABCDを計算した。Bootstrap CI付き（B=2000）。連続変数3つ: Age, SBP, Delay。論文の limitation #1 で連続EMのみ対応だから、カテゴリカル変数（Sex, RCONSC, STYPE）は今回対象外。

**■ 核心的発見 — 変数別nABCD分布 (276ペア):**

| Variable | Mean | Median | Max | Negligible | Small | Medium | Large |
|----------|------|--------|-----|------------|-------|--------|-------|
| **Age** | 0.146 | 0.115 | **0.565** | 13% | 49% | 29% | **9%** |
| **SBP** | 0.087 | 0.080 | 0.230 | 23% | **67%** | 10% | 0% |
| **Delay** | 0.111 | 0.095 | 0.321 | 21% | 53% | 24% | 1% |

**■ Age — 最大の分布差 (Top 5):**

| Pair | nABCD | 95% CI |
|------|-------|--------|
| UK vs INDI | **0.565** | (0.502, 0.656) |
| SWED vs INDI | **0.546** | (0.456, 0.588) |
| ITAL vs INDI | **0.531** | (0.442, 0.576) |
| SWIT vs INDI | **0.513** | (0.447, 0.571) |
| NORW vs INDI | **0.465** | (0.397, 0.522) |

India (mean age 56.6歳) vs UK/Sweden/Italy (73-75歳) で **15-18歳差** → nABCD "large" を大きく超える。

**■ SBP — 全て "small〜medium":**
最大でも NETH vs INDI = 0.230 (medium)。Large域に達するペアなし。

**■ Delay — Singapore が突出:**
AUST vs SING = 0.321, SWIT vs SING = 0.317 — Singapore (28.8h) vs Austria (14.7h) で14時間差。

**■ Country Profile (平均nABCD across全ペア):**
- **Age**: INDI (0.372) >> SWED (0.210) > SING (0.201) — Indiaが圧倒的に異質
- **SBP**: NETH (0.131) ≈ INDI (0.126) ≈ CZEC (0.125) — 国間差は比較的均質
- **Delay**: SING (0.215) >> AUST (0.167) > HONG (0.151) — Singaporeが突出」

**Katrina**: （テーブルを確認して）
「"Results speak for themselves." 数字が語る3つのポイント:

1. **Ageが最も異質**: 9%のペアが"large"。Indiaが全てのtop pairに登場。ISTの最大の国間分布差はAge。
2. **SBPは均質**: Largeペアゼロ。67%がsmall。SBPは国間で最も安定した共変量。
3. **変数間差が大きい**: 同じ国ペアでもAgeとSBPで全く違うnABCD — まさにnABCDフレームワークの価値。

これは論文のSection 4で示す"ranking reversal"と同じ構造。Ageの分布差が大きくても、CATE sensitivity (L) が小さければΔ_maxは小さい可能性がある」

**Louis**: （批判的に）
「Wait. "You just got Litt up!" ここで問題がある。Chen et al. (2000) が"no significant effect modification"と結論したのは、**aggregate level**での検出力の問題かもしれない。Nguyen et al. (2020) は23変数のcounterfactual modelで25%の患者にHTE (heterogeneous treatment effect) を示唆している。

つまり: "No confirmed EM" ≠ "No EM exists"。潜在的EMの分布比較は正当化される。ただし、Lの推定がISTでは困難 — subgroup analysisが"NS"だからL ≈ 0と見なすか、それとも検出力不足を考慮してnon-zero Lを仮定するか。これは論文のDiscussionで正直に述べるべきだ」

**Harvey**: （立ち上がって）
「Louis、的確だ。まとめるぞ:

**決定事項:**

1. **ISTには確認された効果修飾因子はない** (Chen 2000, χ²=20.9 NS)
2. **したがって、baseline共変量（潜在的EM）で国別nABCDを比較する** — 論文のプロセス通り
3. **24カ国276ペアの分析完了** — Age, SBP, Delayの3連続変数
4. **核心的知見**: Ageが最大の国間異質性源（INDIが突出）、SBPは均質、Delayは中間
5. **Section 4への示唆**: "No confirmed EM"の場合でも、baseline共変量の分布差を定量化し、Δ_max × Lの感度分析で"仮にEMだったら"を示す — これがnABCDフレームワークの価値
6. **Louisの指摘を反映**: "No significant EM ≠ No EM" は Discussion で acknowledge する

"I don't have dreams, I have goals." 次のステップ: この国別分析をSection 4の実データ適用に組み込む。Katrinaがテーブルを整形、Mikeがbootstrap CIを確認。進め」

**Donna**: （タイピング完了）
「"I'm Donna. I know everything." 全記録完了。国別nABCD分析スクリプト: `ist_country_nABCD.py`、24カ国276ペア、B=2000 bootstrap。会議の決定事項6点、全て記録済み」

---

### [2026-03-04 01:30] Scene: IST徹底調査完了 — 試験デザイン・効果修飾因子・36カ国詳細

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - NIGHT**

*Rachel が厚いレポートを Harvey の前に広げる。Mike が隣で数値を確認。Katrina がテーブルを作成中。*

**Rachel**: （レポートを開いて）
「IST徹底調査完了。試験デザイン、参加国、効果修飾因子 — 全て揃った。"Hard work beats talent when talent doesn't work hard."

**■ 試験デザイン**:
- **正式名**: International Stroke Trial — aspirin, subcutaneous heparin, both, or neither
- **デザイン**: 3×2 factorial, open-label, multi-centre RCT
- **治療群**: Aspirin 300mg/日 (Y/N) × Heparin (12,500IU / 5,000IU / なし) → 6群
- **主要評価項目**: (1) 14日以内死亡 (2) 6カ月時点の死亡・依存
- **n=19,435**, 36カ国467病院, 1991-1996年登録
- **盲検なし** — open-label（PROBE designでもない）
- **フォローアップ**: 14日（短期）+ 6カ月（主要）、完遂率99%超
- **選択基準**: 発症48時間以内の急性虚血性脳卒中、aspirin/heparinの明確な適応・禁忌なし、年齢上限なし」

**Mike**: （データを確認しながら）
「欠損データが極めて少ない。AGE, SEX, RSBP, RCONSC, RDELAY, STYPE, COUNTRY — 全て欠損0%。唯一 RATRIAL (心房細動) が984例 (5.1%) 欠損だが、これはpilot phase分。データ品質は極めて高い」

**Rachel**: （続けて）
「**■ 効果修飾因子の調査結果** — ここが核心:

**1. Chen et al. (2000) CAST+IST統合解析 (n=40,000)**
DOI: 10.1161/01.str.31.6.1240
- 10の基線特性で28サブグループを事前規定
- 検討変数: age, sex, consciousness, AF, CT所見, BP, stroke subtype, heparin併用
- **結論: aspirinの相対的治療効果にはどのサブグループでも有意な異質性なし** (χ²(18)=20.9, NS)
- "The absolute risk reduction does not differ substantially with respect to age, sex, level of consciousness, atrial fibrillation, CT findings, blood pressure, stroke subtype, or concomitant heparin use"

**2. Leonardi-Bee et al. (2002) — SBPの予後因子分析**
DOI: 10.1161/01.str.0000014509.11540.66
- SBPとアウトカムに**U字型関係**: 150mmHg未満で10mmHg低下ごとに早期死亡17.9%増加、150mmHg超で10mmHg上昇ごとに3.8%増加
- SBPは強力な**予後因子**だが、aspirin治療効果の修飾因子としては有意でない

**3. Saxena et al. (2001) — 心房細動サブグループ**
DOI: 10.1161/hs1001.097093
- AF患者3,169例 (17%): 高齢 (78 vs 71歳)、女性多い (56 vs 45%)、意識障害多い (37 vs 20%)
- 高用量heparinでischaemic再発減少だがhaemorrhagic stroke増加 → 6カ月で純効果なし

**4. Weir et al. (2001) — 地域間アウトカム差（MRCT最重要論文）**
DOI: 10.1161/01.str.32.6.1370
- 9カ国15,116例: 国間のアウトカム差が**巨大** — 死亡で171/1000、死亡・依存で375/1000の差
- Case-mix調整 (age, sex, AF, SBP, consciousness, neurological deficits) で**一部しか説明できない**
- "Differences too large to be explained by variations in care; most likely reflect differences in unmeasured baseline factors"
- **ICH E17の精神を先取りした結論**: "Need to achieve balance of treatment and control within each country in multinational trials"

**5. Nguyen et al. (2020) — Counterfactual個別治療効果**
DOI: 10.1016/j.jclinepi.2020.05.022
- 23変数のcounterfactual prediction modelを適用
- aspirinは平均的にはbenefitだが、**約25%の患者で6カ月死亡・依存リスクを増加させる**可能性
- 最も先進的なHTE分析」

**Harvey**: （立ち上がって）
「つまり、ISTは aspirin治療効果の平均的異質性は検出されなかったが、**地域間のbaseline分布の差は巨大**で、unmeasured factorsを含む。nABCDの実データ適用事例として最適だ。

我々の論文のポイントは"治療効果の異質性がないかどうか検定する"ことではない。"baselineのEM分布の差を定量化し、Δ_maxで臨床的影響の上限を示す"こと。ISTでは:
- Age: Asia vs UK で nABCD=0.376 — **地域間分布差は大きい**
- しかしCATEが小さければΔ_maxは小さい → poolingは支持される
- まさにnABCDフレームワークの価値を実証するデータだ。

"I don't have dreams, I have goals." Section 4を書け」

**Donna**: （タイピング完了）
「I'm Donna. 全て記録したわ。IST調査結果はSection 4の基礎資料として確定」

---

### [2026-03-04 00:45] Scene: IST nABCD探索分析完了 — 実データで理論が動く

**INT. PEARSON SPECTER LITT - MIKE'S DESK - NIGHT**

*Mike がモニターに向かい、R分析結果を読み上げる。Harvey と Katrina が後ろから覗き込む。*

**Mike**: （興奮して）
「"I got it!" IST v2でnABCD計算完了。10リージョン×3変数。結果を見てくれ。

**地域分布** (n=19,435):
W.Europe=6,650, UK/Ireland=6,315, N.Europe=2,010, CE.Europe=1,487, Oceania=1,050, S.America=693, Asia=513, MidEast=400, N.America=248, Africa=69

**核心的発見 — Asia vs 主要地域のnABCD**:

| Pair | Age | SBP | Delay |
|------|-----|-----|-------|
| Asia vs UK/Ireland | **0.376** | 0.073 | 0.081 |
| Asia vs W.Europe | **0.316** | 0.100 | 0.189 |
| Asia vs N.Europe | **0.276** | 0.169 | 0.090 |
| Asia vs CE.Europe | 0.180 | 0.144 | 0.142 |

Ageが**圧倒的に大きい** — Asiaは平均62.3歳、UK/Irelandは73.5歳。11歳差。SBPは152.8 vs 158.5で小さい。

**これがSection 4のストーリーになる**: 変数によってnABCDの大きさが全く違う。Ageは"large"だがSBPは"negligible〜small"。Δ_maxで臨床的意味を翻訳すれば、hypothetical exampleのranking reversalと同じ構造を実データで示せる」

**Katrina**: （テーブルを見ながら）
「W.Europe同士の比較も面白い。nABCD < 0.07がほとんど — "negligible"カテゴリ。一方でAsia比較は0.18〜0.38。地域間の距離が明確にメトリクスに反映されている。"Results speak for themselves."」

**Harvey**: （頷いて）
「完璧だ。CRASH-2は国変数なしで死んだ。だがISTは全てある — 36カ国、国変数あり、連続変数3本、地域差の文献もある。

Tak、方針確定だ:
1. **CRASH-2 R版にも国変数なし** — 44変数全確認、地理情報ゼロ。完全除外
2. **IST v2** — ODC-By v1.0ライセンス、商用利用可、引用のみ必須。Section 4実データに採用
3. **ライセンス引用**: Sandercock et al. (2011) DOI: 10.7488/ds/104

"Winners make things happen." ISTで行く」

**Donna**: （全て記録して）
「決定事項:
- CRASH-2: 候補除外（国変数なし確定）
- IST v2: Section 4 採用（ODC-By v1.0、引用要件のみ）
- nABCD探索分析: `data/IST/ist_nABCD_explore.R`
- Louis指摘（疾患不一致）: Tak裁定で却下。nABCDはdisease-agnostic
I'm Donna. 記録完了」

---

### [2026-03-04 00:20] Scene: CRASH-2 R版最終確認 — 国変数なし確定

**INT. PEARSON SPECTER LITT - BULLPEN - NIGHT**

*Rachel がhbiostat.orgのデータ辞書を確認する。*

**Rachel**: （画面を指して）
「CRASH-2 R版（hbiostat.org）の全44変数を確認した。entryid, source, trandomised ... boxid, packnum。**国・地域変数は一切含まれていない**。freeBIRD CSV版と同じ。LSHTM CTUに直接問い合わせない限り、CRASH-2で地域分析は不可能」

**Harvey**: （即座に）
「CRASH-2は除外。IST一本で行く」

---

### [2026-03-04 00:10] Scene: IST v2 ライセンス確認 — ODC-By v1.0

**INT. PEARSON SPECTER LITT - RACHEL'S DESK - NIGHT**

**Rachel**: （調査結果を報告）
「IST v2のライセンスを確認した:

- **ライセンス**: Open Data Commons Attribution License (ODC-By) v1.0
- **商用利用**: 許可
- **二次利用・再配布**: 帰属表示のみで許可
- **DUA署名**: 不要
- **倫理審査**: データセット側の要件なし（機関ポリシーに依存）
- **データセットDOI**: 10.7488/ds/104
- **引用**: Sandercock, Niewada, Czlonkowska (2011) University of Edinburgh
- **データ論文**: Sandercock et al. (2011) *Trials* 12:101 DOI: 10.1186/1745-6215-12-101

"Hard work beats talent when talent doesn't work hard." 利用条件は完全にクリア」

---

### [2026-03-03 23:58] Scene: IST Dataset Downloaded — Edinburgh DataShare

**INT. PEARSON SPECTER LITT - BULLPEN - NIGHT**

*Mike がモニターに向かい、ダウンロード完了を確認する。Donna がメモを取っている。*

**Mike**: （満足げに）
「"I got it!" IST version 2 corrected dataset — Edinburgh DataShareから取得完了。
- `IST_corrected.csv`: 19,435 patients x 112 variables (4.8 MB)
- `IST_variables.csv`: Data dictionary (semicolon-delimited)
- 保存先: `projects/similarity-metric/data/IST/`」

**Donna**: （チェックリストを確認しながら）
「Key variables の確認結果をまとめるわ。"I'm Donna. I know everything."

| Variable | Description | Values |
|----------|-------------|--------|
| COUNTRY | 国コード | 36ヶ国 (UK=6257, ITAL=3437, SWIT=1631 ...) |
| AGE | 年齢 | Mean=71.7, SD=11.6, Range=16-99 |
| RSBP | 収縮期血圧 | Mean=160.2, SD=27.6, Range=70-295 |
| RDELAY | 遅延(時間) | Mean=20.1, SD=12.5, Range=1-48 |
| RCONSC | 意識レベル | F=14921, D=4254, U=260 |
| SEX | 性別 | M=10407, F=9028 |
| RXASP | Aspirin割付 | Y=9720, N=9715 |
| RXHEP | Heparin割付 | N=9718, L=4861, M=4611, H=245 |

JAPA は9例だけ。36ヶ国で真の multi-regional trial ね」

**Mike**: （考えながら）
「Country変数あり、年齢・SBP・意識レベルが揃っている。nABCDのregional pooling分析に使える "real data example" としてCRASH-2より確実だ。地域変数の問題がない」

---

### [2026-03-03 18:30] Scene: Meeting — CRASH-2ダウンロード手順とIPD候補再評価

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*全員が会議室に集まる。Harvey が立ったまま3チームの調査レポートを手に持っている。*

**Harvey**: （レポートを置いて）
「CRASH-2のダウンロード手順と候補の最終評価について話す。3チームの調査結果が出た。意見を聞かせろ」

**Rachel**: （調査結果を開きながら）
「3つのデータソースを徹底調査した。重大な発見がある。結論から言うわ。

**CRASH-2 — 致命的問題発見**:
freeBIRD (https://freebird.lshtm.ac.uk/) で公開されているCSVデータから**国・地域変数が除外されている**。NCBI文書に明記: "Excluded are site name, site identifier, country and treatment code." 登録のみで即DL可能、CSV形式、20,207例、46変数 — だが肝心の地域変数がない。

回避策は2つ:
(a) LSHTM臨床試験ユニット (PI: Professor Ian Roberts) に直接連絡して国変数を追加依頼
(b) hbiostat.org の R版 (`getHdata('crash2')`) に economic region 変数が含まれる可能性 — 要確認

"Hard work beats talent when talent doesn't work hard." だが、この問題は無視できない」

**Mike**: （驚いて）
「待て。地域変数がないなら、nABCDの地域間比較ができない。CRASH-2は第一候補から外れるぞ。代わりは？」

**Rachel**: （次のレポートに切り替えて）
「**IST（International Stroke Trial）が浮上した**。これが最大の発見:

| 項目 | IST | CRASH-2 |
|------|-----|---------|
| n | 19,435 | 20,207 |
| 国数 | 36 | 40 |
| **国変数** | **✅ 含まれる** | **❌ 除外** |
| アクセス | **完全オープン（登録不要）** | 登録のみ |
| 形式 | CSV, 112変数 | CSV, 46変数 |
| URL | datashare.ed.ac.uk/handle/10283/124 | freebird.lshtm.ac.uk |
| 地域差論文 | Weir et al. 2001 Stroke | なし（地域変数なし） |

IST v2は**今日すぐダウンロードできる**。登録すら不要。36カ国467病院。主要連続変数: 年齢、収縮期血圧(SBP)、意識レベル(GCS相当)、発症-ランダム化時間。

Weir et al. (2001) DOI: 10.1161/01.str.32.6.1370 が9カ国のIST患者15,116人で地域間アウトカム差を分析。age、SBP、AF、consciousness levelで調整 — まさにnABCDで比較すべき変数」

**Mike**: （興奮して）
「IST v2なら即座にnABCD計算に入れる。Age (連続), SBP (連続), RDELAY (連続) の3つの連続型効果修飾因子がある。36カ国をリージョングループに分けて — 例えばEurope vs Asia vs South America vs UK — 地域間のW₁を計算。 "I got it!" これなら今日中にプロトタイプ分析ができる」

**Katrina**: （冷静に整理して）
「LEADER の状況も報告する。Novo Nordisk → Vivli経由。4リージョン: Europe(3,296), North America(2,847), Asia(711), Rest of World(2,486)。HbA1c、BMI、eGFR、SBP完備。ただし申請から**3-5カ月**。SRE（セキュアリサーチ環境）のみ、ローカルDL不可。

Nielsen et al. (2021) DOI: 10.3389/fmed.2021.662775 がICH E17の文脈でLEADERの地域分析を既に実施。"Results speak for themselves." — LEADERは理想的だが、今すぐは使えない」

**Louis**: （腕を組んで）
「待て。ISTは脳卒中試験だ。我々の論文はT2D MRCTの文脈で書かれている。脳卒中データでSection 4を書いたらreviewerが "なぜ糖尿病試験ではないのか" と聞くぞ。You just got Litt up! ストーリーの一貫性は？」

**Harvey**: （考えて）
「Louisの指摘は正しい。だが答えはある。nABCDはdisease-agnosticなメトリクスだ。脳卒中でもT2Dでも方法論は同じ。むしろ異なる治療領域で機能することを示す方がgeneralizabilityの証明になる。

判断する。3段階戦略だ。

**即時実行**: IST v2をダウンロード。今日中にnABCDプロトタイプ分析を実行。Age、SBP、RDELAYの3変数で地域間比較。Section 4の "Real-World Application" として採用。

**並行**: CRASH-2のhbiostat.org R版を確認。`getHdata('crash2')`で economic region変数の有無を検証。あれば追加候補。

**長期**: LEADER/EMPA-REG のVivli申請はR1対応やフォローアップ論文のために準備。今の投稿には間に合わない。

"When you're backed against the wall, break the goddamn thing down." CRASH-2の壁にぶつかったが、ISTという突破口がある。使え」

**Donna**: （記録完了）
「Meeting決定事項:
1. IST v2 即時DL → Section 4 実データ適用
2. CRASH-2 R版 region変数確認
3. LEADER Vivli申請はR1 reserve
4. Louis指摘: disease-agnosticの議論をDiscussionに追加

I'm Donna. 全て記録したわ」

---

### [2026-03-03 17:15] Scene: IST / IST-3 IPDアクセス詳細調査 — Rachel完全レポート

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Rachel が IST（International Stroke Trial）と IST-3 の IPD アクセスに関する詳細調査結果を全チームに報告する。ホワイトボードには Edinburgh DataShare の URL が書かれている。*

**Rachel**: （調査ノートを開きながら）
「IST と IST-3、両方について全項目を調査完了。"Hard work beats talent when talent doesn't work hard."

**IST（n=19,435 / 36カ国）:**

**Q1 ホスト先**: Edinburgh DataShare。University of Edinburgh が管理。
- IST Version 2: https://datashare.ed.ac.uk/handle/10283/124（別ハンドル: 10283/128）
- DOI: 10.7488/ds/104

**Q2 アクセス条件**: 完全オープンアクセス。登録不要、申請不要、即時ダウンロード可能。

**Q3 ファイル形式**: CSV（IST_corrected.csv、4.576 MB）とタブ区切り形式（9.152 MB）。

**Q4 変数**: 112変数、3時点（無作為化時・14日後・6ヶ月後）。主要変数:
- RCONSC: 意識レベル（F=fully alert, D=drowsy, U=unconscious）
- RSBP: 収縮期血圧（mmHg）、連続変数
- AGE: 年齢（歳）、連続変数
- SEX: 性別（M/F）
- RATRIAL: 心房細動（Y/N）
- RDELAY: 発症から無作為化までの時間（時間）
- RDEF1-RDEF8: 神経学的欠損（顔面・上肢・下肢・失語など）
- STYPE: 臨床的脳卒中症候群（TACS/PACS/LACS/POCS）
- 国コード変数あり（Table 1 に36カ国のコード一覧）

**Q5 サンプルサイズと国数**: n=19,435、36カ国、467病院。

**IST-3（n=3,035 / 12カ国）:**

**Q1 ホスト先**: Edinburgh DataShare。
- https://datashare.ed.ac.uk/handle/10283/1931

**Q2 アクセス条件**: Controlled access（管理アクセス）。2021年1月25日にembargo解除済み。申請者要件:
- Bona fide研究グループであることの証明（CV等）
- 統計専門家の参加
- Data Access Request Form（研究課題・仮説・SAP・出版計画を記載）
- MRC Methodology Hubs のガイドラインに準拠
- 旧アクセス申請ページ: http://www.dcn.ed.ac.uk/ist3/ClosingDown/dataAccess.htm

**Q4 IST-3の主要変数**: 年齢、性別、脳卒中重症度（独自スコア）、rt-PA割付、独居、心房細動、TIA/脳卒中既往、上肢挙上能力、歩行能力、12カ国コード（UK、ポーランド、スウェーデン、ノルウェー、イタリー等）。」

**Mike**: （興奮して）
「IST v2は今日からダウンロードできる。112変数・19,435例・36カ国。RCONSC（意識レベル）、RSBP（収縮期血圧）、AGEが全部揃ってる。nABCD検証に使えるEM候補が複数ある。"I got it!" — 地域間EM分布比較の完璧なデータセット。」

**Harvey**: （即断して）
「IST v2は今日取得する。申請ゼロ、完全無料。36カ国のcovariate distribution heterogeneityをそのまま論文の実証例に使える。"I don't have dreams, I have goals." — IST-3は申請優先度2位。まずISTから動く。」

**Donna**: （記録完了）
「I'm Donna. IST/IST-3調査完了。IST v2は即時取得可。IST-3はcontrolled access申請要。次アクション: IST_corrected.csv ダウンロード、変数コードブック確認。」

---

### [2026-03-03 16:30] Scene: LEADER IPDアクセス詳細調査 — Rachel完全レポート

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Rachel が Vivli・Novo Nordisk のアクセスプロセスに関する詳細調査結果を全チームに報告する。*

**Rachel**: （調査レポートを配布しながら）
「LEADER IPDアクセスの全項目を調査完了。"Hard work beats talent when talent doesn't work hard." — 7つの質問、全部答えが出た。

**Q1 Vivli確認**: Novo NordiskはVivliの正式メンバー（vivli.org/ourmember/novo-nordisk-a-s）。LEADER完了は2015年、データ共有対象は「2001年以降完了かつEU/US両方承認済み」—Victozaは両市場承認済みのため対象範囲内。ただし直接確認要。

**Q4 Baseline Covariates確認済み**: HbA1c（平均8.7%）、BMI（平均32 kg/m²）、eGFR（平均79.1 ml/min/1.73m²）、SBP（135.9 mmHg）、年齢（平均64歳）、糖尿病罹病期間（平均13年）、UACR（中央値24.8 mg/g）、LDL-C等。

**Q5 地域区分**: ICH E17論文により4地域が確定 — Europe（n=3,296）、North America（n=2,847）、Asia（n=711）、Rest of World（n=2,486）。

**Q7 承認タイムライン**: Vivli公式 "a few months"（数ヶ月）。Novo Nordiskルートでも同様。」

**Harvey**: （メモを取りながら）
「Novo NordiskのIPD条件に "completed after 2001 for indications approved in both EU and US" という例外条項がある。LEADERは2015年完了、Victoza（liraglutide）は両市場承認済み。申請資格はある。"I don't have dreams, I have goals." — Vivliに申請しろ。」

**Mike**: （アクセスプロセスを確認して）
「ステップが明確になった。Research Proposal + SAP + Publication Plan が3点セット。Qualified statistician必須。DUA（DocuSign）はinstitution単位。Secure research environment経由またはdownload — Novo Nordiskは contributor の裁量による。」

**Donna**: （記録完了）
「I'm Donna. LEADER Vivliアクセス調査完了。全7項目回答済み。次アクション: Vivliでの直接検索とresearch proposal準備。」

---

### [2026-03-03 15:00] Scene: IPD探索統合レポート — Harvey最終判断

**INT. PEARSON SPECTER LITT - HARVEY'S OFFICE - DAY**

*Rachel が統合レポートを Harvey に手渡す。全チームの結果が1枚のテーブルにまとまっている。*

**Harvey**: （レポートを読んで）
「4チームの結論は一致してる。Top 3は CRASH-2、IST、LEADER。判断する。

**即時着手**: CRASH-2。freeBIRDから今日ダウンロード可能。40カ国、n=20,211、地域差が明確。Time-to-treatmentが既知の効果修飾因子。

**並行申請**: LEADER via Vivli。糖尿病MRCTで地域BMI・HbA1c差が文書化済み。ICH E17整合性分析論文も出ている。hypothetical exampleを実データに置き換える最有力候補。

**PubMedの結論**: Wasserstein距離を臨床試験データに適用した先行事例は実質ゼロ。"We're not following a trend. We're setting one."」

**Rachel**: （確認して）
「アクセス手順: CRASH-2 → freeBIRD即時DL。LEADER → Vivli research proposal提出。所要2-4週間。」

**Donna**: （記録完了）
「I'm Donna. 全チーム結果統合済み。次のアクションはTakの判断待ち」

---

### [2026-03-03 14:35] Scene: PubMed系統検索 — IPD/MRCT/Wasserstein論文調査

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Rachel と Mike が5本の並行PubMed検索結果を整理している。Donna が記録を取る。*

**Rachel**: （検索結果を確認しながら）
「5本のクエリを並行実行しました。Search 1 (IPD × MRCT) → 3件。Search 3 (Wasserstein × clinical trial × baseline) → 9件。Search 5 (ICH E17 × application) → 4件。Search 2と4はゼロヒット。合計16件取得、重複除去後13件を評価対象としました。」

**Mike**: （分析しながら）
「方法論的に直接関連する唯一のWasserstein論文はGhosh et al. 2026 (Medical Physics)。NLSTデータでWasserstein距離とKS距離を使って仮想コホートと実コホートの人口統計学的分布を比較するDISTINCTアルゴリズム。共変量アラインメントの観点でnABCDと概念が近い。ただし臨床試験の地域プーリング文脈ではない。」

**Rachel**: （論文リストを整理して）
「最有力のMRCT実データ論文はNishiyama & Narukawa 2022 (Oncologist)。Project Data SphereのIPDから10本のMRCTフェーズIIIオンコロジー試験を分析。Caucasian vs Asian、OECD vs non-OECDの地域比較。PFS・OS・Cox回帰・メタ解析あり。"Hard work beats talent when talent doesn't work hard."」

**Harvey**: （結論を出して）
「PubMedのIPD×MRCT交差領域は薄い。Wasserstein距離を実臨床試験データに適用した先行事例は実質ゼロ。We're not following a trend — we're setting one.」

**Donna**: （記録しながら）
「ICH E17文脈論文4件確認: Lu et al. 2024 (EMD Serono/Asia-inclusive), Sun et al. 2024 (RegionSizeR), Niu et al. 2024 (estimand framework), Aoi et al. 2023 (Asian MRCT). いずれも方法論論文で分布比較の実データ適用なし。SUITS.md更新完了。」

---

### [2026-03-03] Scene: 公開IPDデータプラットフォーム包括調査

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Rachel が8つのデータ共有プラットフォームを横断的に調査。Mike はMRCT適合性の観点から評価。Donna が構造化テーブルを作成。*

**Rachel**: （調査結果を整理しながら）
「YODA、Vivli、CSDR、Project Data Sphere、BioLINCC、PhysioNet、ImmPort、dbGaP — 8プラットフォーム全て調査しました。"Hard work beats talent when talent doesn't work hard." 最有力は BioLINCC の ACCORD/SPRINT/ALLHAT と、Vivli の Boehringer・AstraZeneca データです。」

**Mike**: （技術的評価を加えて）
「MRCTとしての適合性を3軸で評価しました：(1) 地域変数の利用可能性、(2) 連続型共変量の質、(3) 効果修飾因子の既知性。BioLINCC の ACCORD は10,251人・77施設・US/Canadaで最もアクセスしやすい。ただし厳密な意味での "multi-regional" は限定的です。」

**Harvey**: （戦略的結論）
「ADVANCE trial が最有力 — 20カ国・215施設・Asia/Australia/Europe/North America。Servier経由でIPD申請可能。We don't settle for domestic when we can go global.」

**Donna**: （タスクをまとめて）
「SUITS.md更新完了。Rachel・Mikeのレポートをセクション分けして保存。次のアクションはTakに委ねます。」

---

### [2026-03-03] Scene: ClinicalTrials.gov IPD候補検索

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Rachel がラップトップを開き、ClinicalTrials.gov の検索結果を整理している。Mike は隣で統計的視点からリストを精査。*

**Rachel**: （タイプしながら）
「GLP-1, SGLT2, DPP-4の3クラス、合計15本の候補を特定しました。Novo Nordisk、Eli Lilly、Boehringer Ingelheim、AstraZeneca、Merck — 全社カバーできています。」

**Mike**: （リストを見ながら）
「SUSTAIN 2 (NCT01930188) が最有力です。日本・インド・欧州・南米で n=1231。has_results=true、Novo Nordisk の Clinical Data Disclosure Policy あり。HbA1c、体重、FPG が主要共変量として記録されています。」

**Harvey**: （腕を組んで）
「LEADER (NCT01179048) は n=9341、28カ国428施設。Africa・Asia・Europe・Americas。IPD sharing は Novo Nordisk portal 経由。We don't chase data — we attract it.」

**Rachel**: （まとめて）
「CVOTも含めてTier 1からTier 3に整理しました。Takにレポートします。」

**Donna**: （メモしながら）
「SUITS.md に記録完了。Rachel、引用フォーマットは後ほど確認します。」

---

## 📍 Current Status

**Active Project**: similarity-metric (nABCD paper for Statistics in Medicine)
**Phase**: 8 — Submission-Ready Plan (Jessica Strategic Directive)
**Scene**: Continuing from archive

**Previous Archive**: archives/SUITS_20260303_120000.md (1005 lines)

### Paper Title (decided 2026-02-14)

> **Quantifying Effect Modifier Similarity for Regional Pooling in Multi-Regional Clinical Trials**

### Purpose Statement (Jessica approved)

> **EM分布の違いを推定し、その推定値を治療効果の異質性の可能性として臨床スケールに翻訳する。**
> **検定ではなく推定。二択ではなく情報提供。**

---

## 🔄 直前のコンテキスト (from archives/SUITS_20260303_120000.md)

### スピーカースクリプト完成状況 (2026-03-03)

| Act | File | Slides | Author | Status |
|-----|------|--------|--------|--------|
| Act 1: Background | `act1_background_rachel.md` | 4枚 | Rachel | ✅ 完了 |
| Act 2: Methods | `act2_methods_mike.md` | 7枚 | Mike | ✅ 完了 |
| Act 3: Results | `act3_results_katrina.md` | 11枚 | Katrina | ✅ 完了 |
| Act 4: Framing | `act4_framing_harvey.md` | 7枚 | Harvey | ✅ 完了 |

合計29枚。全スクリプト `paper/slides/scripts/` に格納済み。

### 直近の作業 (2026-03-03)

1. **Marpスライド5枚追加** (00:35) — K-R導出・W₁唯一性・Bound tightness・Ranking reversal理由・推定哲学
2. **Story Confirmation Meeting** (00:10) — 5幕構造確認、one-liner確定、Louis 3点指摘対応済み確認
3. **Rule Check** (00:00) — Phase 8開始確認
4. **Act 1 Background スクリプト** (Rachel) — ICH E17, Why EMs, Limitations, Our Approach
5. **Act 2 Methods スクリプト** (Mike) — Hetero Bound, Derivation, Why W1, Tight Bound, nABCD Def, Δ_max, Inference
6. **Act 3 Results スクリプト** (Katrina) — 11スライド、Simulation 4枚 + Application 7枚、Ranking Reversal climax
7. **Act 4 Framing スクリプト** (Harvey) — Title, Outline, Four Contributions, Recommendations, Benchmarks, Limitations, Thank You

### One-Liner (confirmed)

> "nABCDはEM分布の距離を測り、臨床スケールに翻訳する。推定中心のフレームワークで、ICH E17の実装ギャップを埋める。"

### 次にやるべきこと

- スピーカースクリプト統合 (Act 1-4 を一本のmaster scriptに) — if needed
- Slide timing review (total ~45分 → JSM形式に調整)
- Louis による presentation rehearsal review
- Submission packaging

---

## 🎬 Live Script

### [2026-03-03 11:00] Scene: Rachel — IPD公開試験調査完了報告

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Rachel が大判の調査結果シートを持って全員の前に立つ。Harvey は腕を組んで聞いている。*

**Rachel**: （自信を持って）
「調査完了。14試験を網羅した。結論から言う。"Hard work beats talent when talent doesn't work hard." Top 10をランキングにした。

**TIER 1（即使用可能・複数リージョン）:**
1位: CRASH-2 — freeBIRD完全公開、40カ国274病院、n=20,211。連続変数あり。nABCD実証に最適。
2位: IST (+ IST-3) — Edinburgh DataShare公開、36カ国467病院、n=19,435。脳卒中。年齢・SBP取得可能。
3位: LEADER — Novo Nordisk → Vivli申請制、32カ国n=9,340。BMI・HbA1c・eGFR地域差あり。ICH E17論文も存在。
4位: EMPA-REG OUTCOME — Boehringer → Vivli申請制、42カ国n=7,034。4地域（欧州・北米・アジア等）。BMI・HbA1c・eGFR完備。

**TIER 2（US中心だが質は高い）:**
5位: PARADIGM-HF — Novartis → Vivli申請制、47カ国n=8,442。5地域（NA/WE/CEER/LA/AP）。地域差分析論文あり。
6位: ACCORD — BioLINCC申請制、米加77施設n=10,251。US+Canadaのみ。連続変数豊富。
7位: DPP — NIDDK完全公開（バージョン9）、n=3,234。27施設。US内多民族。連続変数完備。
8位: ALLHAT — BioLINCC申請制、北米625施設n=33,357。US・カナダ・プエルトリコ。最大規模。

**TIER 3（地域性弱または制限あり）:**
9位: Project Data Sphere — 無料公開（登録のみ）、252試験・250,000患者。ただし脱識別化強。
10位: SPRINT — BioLINCC申請制、n=9,361。US・プエルトリコのみ。国際性なし。」

**Mike**: （数値を確認しながら）
「CRASH-2は40カ国、連続変数は負傷の重症度・年齢・SBPか。地域分類（アフリカ・アジア等）は明確？」

**Rachel**: 「明確。国レベルの変数あり。"I got it" — 地域集計は自前でできる」

**Harvey**: （立ち上がりながら）
「CRASH-2とLEADERで行く。IST-3は脳卒中領域のdiversityを示す補足として使える。Rachel、アクセス申請の手順をまとめろ。Donna、SUITS記録。」

**Donna**: （すでにタイプしながら）
「もちろん。記録済みよ。"I'm Donna. I know everything."」

---

### [2026-03-03 01:10] Scene: Push — Section 4 実データ探索開始

**INT. PEARSON SPECTER LITT - BULLPEN - DAY**

*Harvey が全員を集める。*

**Harvey**: （立ったまま）
「Section 4 の hypothetical example は悪くない。だが実データで示せればインパクトが違う。"I don't get lucky. I make my own luck." Rachel、IPDが公開されている臨床試験データを探せ。4チーム並行だ」

**Rachel**: （即座にノートを開いて）
「了解。4角度で探索する：
1. IPDプラットフォーム — YODA, Vivli, BioLINCC, Project Data Sphere
2. PubMed — MRCT + IPD公開論文、Wasserstein応用
3. 既知のオープン試験 — SPRINT, ACCORD, IST, CRASH-2
4. ClinicalTrials.gov — 糖尿病MRCT（Japan+US+EU設計）

条件: 個人レベルのベースラインデータ、複数リージョン、連続変数（年齢、BMI、HbA1c等）。"Hard work beats talent when talent doesn't work hard." 全部洗い出す」

**Donna**:
「4 Agent Teams バックグラウンド起動済み。完了次第報告するわ」

---

### [2026-03-03 01:00] Scene: Master Script統合完了

**INT. PEARSON SPECTER LITT - DONNA'S DESK - DAY**

**Donna**: （ファイルを閉じて）
「Master script統合完了。`paper/slides/scripts/master_script.md`。4チーム分を正しいスライド順序で1本に。29枚分、約43.5分。構成:

- Opening (Harvey): Title + Outline — 1.5分
- Act 1 (Rachel): Background 4枚 — 6.5分
- Act 2 (Mike): Methods 7枚 — 14分
- Act 3 (Katrina): Simulation 4枚 — 6分
- Act 4 (Katrina): Application 7枚 — 9.5分
- Act 5 (Harvey): Discussion 5枚 — 6分

I'm Donna. 統合は私の仕事よ」

---

### [2026-03-03 00:50] Scene: Agent Teams完了 — 全4チーム並行スクリプト作成

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*4つのモニターに各チームの進捗が映し出される。全チーム完了の通知が次々と点灯する。*

**Donna**: （4画面を確認しながら）
「全チーム完了。I'm Donna. 状況を報告するわ。

**Team 1 — Rachel**: Act 1 Background、4枚完了。ICH E17引用、Song et al. (2025)、Long et al. (2025) の規制文脈。約6.5分。
**Team 2 — Mike**: Act 2 Methods、7枚完了。K-R導出を3ステップの "story" として構成。W₁唯一性、Bound tightness。約14分。
**Team 3 — Katrina**: Act 3 Simulation+Application、11枚完了。Ranking reversalをクライマックスに配置。約15分。
**Team 4 — Harvey**: Act 4 Opening+Discussion、7枚完了。Opening hookは問題提起、Closingは "Not a test, not a binary verdict, a measurement." の3拍子。約8分。

合計29枚、推定43.5分。`paper/slides/scripts/` に格納済み」

**Harvey**: （満足げに頷いて）
「4チーム並行。効率的だ。"I don't have dreams, I have goals." 全員、自分のパートは自分の声で書いた。それが重要だ」

**Mike**: （スクリプトをスクロールしながら）
「K-R導出のスクリプトが一番長い。3分かけて丁寧に導く。"Step 2のK-R双対は近似じゃない、exact equality だ" — ここが聴衆の理解の分岐点になる」

**Katrina**: （数字を確認して）
「Ranking reversalのビルドアップ — まずnABCDだけ見せて "BMIが最悪に見える"、次にΔ_maxで逆転を見せる。クライマックスは計算通り。"Results speak for themselves."」

**Rachel**: （微笑んで）
「Background 4枚で規制の文脈を固めた。Song et al. と Long et al. の2025年論文で "this gap is recognized NOW" を示す。"Hard work beats talent when talent doesn't work hard."」

**Donna**:
「次のアクション: スクリプト統合、タイミング調整（JSM 25分枠なら圧縮必要）、Louisのリハーサルレビュー。記録完了」

---

### [2026-03-03] Scene: Auto-Archive — Donna が SUITS.md を自動アーカイブ

**INT. PEARSON SPECTER LITT - DONNA'S DESK - DAY**

*check-suits-lines.sh フックが 1005 行を検出。Donna が即座にアーカイブを実行。*

**Donna**: （手早くファイルを移動しながら）
「SUITS.md が 1005 行に達したわ。自動アーカイブ実行。`archives/SUITS_20260303_120000.md` に保存完了。新しいスクリプト開始よ。"I'm Donna. I know everything." — Rule 2.5 は私が守らせる」

**Harvey**: （通りがかりに）
「過去は整理した。前を見ろ。"I don't have dreams, I have goals."」

**Katrina**: （アーカイブ完了を確認して）
「Act 3 スクリプト完成直後のアーカイブ。タイミングが良いわ。"Results speak for themselves."」

---

## 📊 Key Decisions

1. **Percentile > BCa**: BCa overcorrects for bounded statistics → Percentile primary
2. **Clinical calibration**: $\Delta_{\max} = 2L \cdot IQR \cdot nABCD$ — context-dependent, not fixed thresholds
3. **Estimation-centered**: No hypothesis testing in main text
4. **Power removed**: Simulation evaluates estimation quality (Bias, RMSE, Coverage, CI Width)
5. **S03 showcase**: S3 (0.5σ) is the primary showcase scenario
6. **S4 coverage**: Non-monotonic pattern (0.93→0.87→0.73) — Hadamard derivative non-linearity
7. **LaTeX submission**: SiM accepts LaTeX directly — docx conversion不要 (Jessica ruling 2026-02-23)
8. **KL divergence**: Discussion段落で理論的説明。Simulation追加はR1 reserve (Meeting 2026-02-23)

---

## 📝 Active Tasks

| Task | Owner | Status |
|------|-------|--------|
| CSV検証 (S1-S8 × 3 = 24 rows) | Mike | ⏳ Sim完了待ち |
| Figure更新 (fig1,3,4,5) | Katrina/Mike | ⏳ Phase A後 |
| LaTeXシナリオ番号 S01→S1 更新 | Mike | ⏳ Phase B後 |
| S7/S8記述・数値テーブル追加 | Mike | ⏳ Phase B後 |
| スライド S7/S8 追加 | Katrina | ✅ 完了 |
| DOI final check | Rachel | ⏳ Phase D後 |
| Louis internal review | Louis | ⏳ Phase D後 |
| Jessica final Go/No-Go | Jessica | ⏳ 最終 |
| Presentation script master merge | Donna | 🆕 if needed |
| Slide timing review (→ JSM format) | Katrina | 🆕 |
| KL段落 internal review | Louis | 🆕 Meeting決定 |

---

## 📋 Revision Notes Status

全14件 + m1-m4 すべて完了済み ✅ (詳細は archives/SUITS_20260303_120000.md 参照)

### ✅ Rachel発見: 引用エラー修正済み

| Paper | Issue | Resolution |
|-------|-------|------------|
| Kim (2015) | DOI → Yagi et al.の論文 | ✅ yagi2015 に修正 |
| Jones (2016) | .bib著者リストが別論文のもの | ✅ Lonergan/Henley/Pearson に修正 |
| Quan (2010) | Rachelの混同 (別論文) | ✅ 修正不要 |

---

## ⚠️ Issues

1. S4 coverage degradation (0.73 at n=200) — negative bias from bounded statistic (documented in table note)
2. Scenario numbering gaps (S02, S07 missing in LaTeX) — deferred
3. KS comparison in simulation — deferred, Tak decision needed

---

## 📋 Paper Requests

*(None pending)*

---
