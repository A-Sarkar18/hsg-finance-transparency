<p align="center"><img src="images/hsg-logo.png" alt="HSG logo" width="110"></p>

<h1 align="center">HSG Finance Committee Transparency Report</h1>

<p align="center">
How Harris Student Government funds Harris Student Organizations (HSOs): what each one asked for, what it received, and why.
<br><br>
<a href="https://a-sarkar18.github.io/hsg-finance-transparency/"><b>📊 Read the report</b></a> ·
<a href="policy/Fall%202026%20Funding%20-%20One-Page%20Guide%20for%20HSOs.md"><b>📄 One-page guide</b></a> ·
<a href="METHODOLOGY.md"><b>🧮 Methodology</b></a> ·
<a href="policy/"><b>📁 Policy documents</b></a>
</p>

---

## Fall 2026 at a glance

| Budget | Allocated | Requested | HSOs funded | Equal base share |
|:---:|:---:|:---:|:---:|:---:|
| **$20,000** | **$19,460** | **$72,067** | **24** | **$208** each |

Requests were about **3.6×** the budget, so every HSO received part of what it asked for.

## How funding works, in 30 seconds

1. **Everyone gets a base share.** A quarter of the budget ($5,000) is split equally among every HSO that applied on time.
2. **The rest is shared by score.** The other $15,000 is split in proportion to each HSO's **committee score × eligible request**.
3. **Real people score every application.** Committee members score Thoughtful budgeting (30%), Inclusion & collaboration (25%) and Impact (45%) from 1 to 5. One automatic score from the application data is added as one more voice. Small communities count just as much as large ones.
4. **Food limits set the eligible request.** Cultural events: all food is covered. Programmatic events: food up to 60% of the event budget. Social events: up to $400 per co-hosting HSO.
5. **Rollover counts, unless it's earmarked.** Your HarrisHub "Available" balance is your rollover. Money restricted by a sponsor, donor or grant, committed under a signed contract, or saved for a specific event later in the academic year is set aside when you document or itemize it.
6. **Nobody gets more than they can use.** Allocations are capped at base share + eligible request and rounded to the nearest $10.

Full details: [Methodology summary](METHODOLOGY.md) · [Allocation Policy](policy/Fall%202026%20Allocation%20Policy%20and%20Methodology.md) · [Scoring README and Reviewer Manual](policy/Fall%202026%20Scoring%20README%20and%20Reviewer%20Manual.md)

## Fall 2026 allocations

| HSO | Requested | Eligible request | Committee score | Allocated | Note |
|:---|---:|---:|:---:|---:|:---|
| BAPPS | $8,758 | $4,444 | 4.80 | **$2,060** | |
| TAP | $5,320 | $4,917 | 3.46 | **$1,690** | |
| PFA | $3,600 | $3,550 | 3.65 | **$1,330** | |
| LAM | $4,100 | $3,620 | 3.51 | **$1,310** | |
| MASH | $3,600 | $3,140 | 4.01 | **$1,300** | |
| MiPPS | $5,000 | $4,560 | 2.50 | **$1,220** | |
| HEEA | $6,950 | $3,510 | 3.26 | **$1,200** | |
| SSC | $3,550 | $3,515 | 2.65 | **$1,020** | |
| OUTPolitik | $3,260 | $1,798 | 2.93 | **$870** | Committee adjustment: additional $200 for midterm-election programming. |
| UC3P | $2,789 | $2,789 | 2.44 | **$800** | |
| SASPA | $3,000 | $2,343 | 2.27 | **$670** | |
| PMPSA | $2,300 | $1,934 | 2.57 | **$640** | |
| ACPF | $2,000 | $1,514 | 3.13 | **$620** | |
| HII | $1,700 | $1,150 | 3.45 | **$550** | |
| EPSA | $1,700 | $1,400 | 2.82 | **$550** | |
| HNI | $1,500 | $1,244 | 2.93 | **$530** | |
| HIVE | $1,625 | $1,554 | 2.20 | **$500** | |
| RPD | $980 | $798 | 3.91 | **$480** | |
| WiPP | $1,700 | $1,260 | 2.52 | **$480** | |
| ALAS | $1,380 | $1,000 | 2.48 | **$420** | |
| HCA | $1,540 | $916 | 2.21 | **$380** | |
| Agora | $965 | $719 | 2.33 | **$350** | |
| HCC | $750 | $400 | 2.39 | **$290** | |
| MPP | $4,000 | $4,000 | 2.10 | **$200** | Committee adjustment. Can be revisited once an itemized event budget is submitted. |
| **Total** | **$72,067** | **$56,075** | | **$19,460** | |

BEPP, HFG, HSfP did not apply this quarter. Charts, food-rule totals and comparisons with past quarters are in the [full report](https://a-sarkar18.github.io/hsg-finance-transparency/).

## What's in this repository

| Folder or file | What's inside |
|:---|:---|
| [`docs/`](docs/) | The published website. `index.html` is the latest quarter. |
| [`policy/`](policy/) | The committee's Fall 2026 policy documents, in Word and Markdown. |
| [`METHODOLOGY.md`](METHODOLOGY.md) | A short summary of the rules and formulas. |
| [`data/Fall 2026/`](data/Fall%202026/) | `allocations.csv` (one row per HSO), `food_summary.csv` (totals by event type) and `parameters.csv` (budget, weights, limits). |
| [`data/history_allocations.csv`](data/history_allocations.csv) | Requests and allocations from earlier quarters, with the source for each. |
| [`notes/`](notes/) | Each quarter's "what changed" text and the public notes for committee adjustments. |
| `report.Rmd`, `report.R`, `extract_data.R`, `run.R`, `style.css` | The code that builds the report. |

**What is not published:** the raw allocation workbook, individual reviewer scores and comments, event-by-event details, and student contact information. Only committee-level results are released.

## Updating for a new quarter

You need R with the `tidyverse`, `readxl` and `rmarkdown` packages.

1. Save the quarter's allocation workbook as `data/raw/<Quarter Year>.xlsx` (for example `data/raw/Winter 2027.xlsx`). Open and save it once in Excel so formula results are stored. This folder is never uploaded.
2. In `run.R`, set `quarter` and increase `quarter_order` by one.
3. Copy `notes/Fall 2026.md` to `notes/<Quarter Year>.md` and update the text.
4. If the committee changed any allocation by hand, add a one-line public note for that HSO to `notes/<Quarter Year> adjustments.csv`. The build stops until every adjustment has one.
5. Run `run.R`. It writes `data/<Quarter Year>/`, `docs/<Quarter Year>.html` and `docs/index.html`.
6. Add the previous quarter to `data/history_allocations.csv`, update the numbers in this README, then commit and push. The website updates within a few minutes.

## Data notes

* Renamed HSOs are matched to their current names: Unum → Agora, RAC → RPD, HE&EA → HEEA, ACPSF → ACPF.
* Rollover is each HSO's HarrisHub "Available" balance on the day allocations were calculated, less any earmarked funds the committee approved.
* Fall 2024 includes a separate special-allocation round (`round = Special`). Records for Fall 2025 and Winter 2026 aren't included yet.

## Credit

Adapted from the [HSG Finance Committee transparency report](https://github.com/notkarenyi/hsg-fc) by Karen Yi. Maintained by the HSG Finance Committee, 2026–27.
