# HSG Finance Committee Transparency Report

Shows every Harris Student Government (HSG) funding decision for Harris Student Organizations (HSOs): what each HSO asked for, what it received, and why. It's built from the Finance Committee's allocation workbook each quarter.

**Live report:** https://a-sarkar18.github.io/hsg-finance-transparency/

**How funding is decided:** [METHODOLOGY.md](METHODOLOGY.md) (summary) and [policy/](policy/) (full Fall 2026 policy documents)

## What's in this repository

| Path | What it is |
|---|---|
| `data/<quarter>/allocations.csv` | One row per HSO: requested, rollover, eligible request, scores, flat and flexible shares, final allocation |
| `data/<quarter>/food_summary.csv` | Totals by event type (Cultural, Programmatic, Social): number of events, budget, food, and the amount excluded by the food rules. Event-level detail is not published. |
| `data/<quarter>/parameters.csv` | That quarter's budget, pools, weights and food limits |
| `data/history_allocations.csv` | Per-HSO requests and allocations from earlier quarters, with the source file for each |
| `report.Rmd`, `report.R` | The report and its charts |
| `notes/<quarter>.md` | Quarter-specific text: what changed, next steps, committee members |
| `docs/` | The published report (`index.html` is the latest quarter) |
| `METHODOLOGY.md` | A short summary of the rules and formulas |
| `policy/` | The committee's full Fall 2026 policy documents, in Word and Markdown: Allocation Policy and Methodology, Scoring README and Reviewer Manual, and the One-Page Guide for HSOs |

The raw workbook isn't published, because it contains individual reviewer scores and comments. Only committee-level results are released.

## Updating for a new quarter

You need R with the `tidyverse`, `readxl` and `rmarkdown` packages. RStudio or Positron includes everything else.

1. Download this repository (green **Code** button → **Download ZIP**, or `git clone`).
2. Save the quarter's allocation workbook as `data/raw/<Quarter Year>.xlsx`, for example `data/raw/Winter 2027.xlsx`. Open and save it once in Excel or Google Sheets, so formula results are stored.
3. In `run.R`, set `quarter` and increase `quarter_order` by one.
4. Copy `notes/Fall 2026.md` to `notes/<Quarter Year>.md` and update the text and committee members.
5. Run `run.R`. It writes `data/<Quarter Year>/*.csv`, `docs/<Quarter Year>.html` and `docs/index.html`.
6. Add the previous quarter's rows to `data/history_allocations.csv`, then commit and push. The live site updates automatically.

## Data notes

* Earlier quarters come from the committee's final allocation sheets; see the `source` column in `data/history_allocations.csv`. Records for Fall 2025 and Winter 2026 aren't included yet.
* Renamed HSOs are matched to their current names: Unum → Agora, RAC → RPD, HE&EA → HEEA, ACPSF → ACPF.
* Fall 2024 includes a separate special-allocation round (`round = Special`).

## Credit

Adapted from the HSG Finance Committee transparency report by Karen Yi: https://github.com/notkarenyi/hsg-fc
