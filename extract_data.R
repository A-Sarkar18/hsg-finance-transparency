# Extracts the public data from a quarter's allocation workbook.
#
# Input:  data/raw/<quarter>.xlsx  -- the Finance Committee allocation workbook.
#         Git-ignored, because it holds individual reviewer scores and comments.
#         Save it from Excel or Google Sheets first so formula results are cached.
# Output: data/<quarter>/allocations.csv  one row per HSO
#         data/<quarter>/food_summary.csv totals by event type (event-level detail is not published;
#                                         it is kept in data/raw/<quarter> events.csv, which is git-ignored)
#         data/<quarter>/parameters.csv   budget, pools, weights, food limits
#
# Committee adjustments are published with the short note in notes/<quarter> adjustments.csv,
# never with the workbook's internal justification text.
#
# Columns are found by their header text, not their letter, so inserting or
# removing reviewer columns in the workbook does not break the extraction.

library(tidyverse)
library(readxl)

read_block <- function(wb, sheet, header_row) {
  read_excel(wb, sheet, skip = header_row - 1, .name_repair = "minimal") %>%
    select(which(names(.) != ""))
}

# Keeps rows from the top of a table down to the first blank or "Total" HSO cell.
table_rows <- function(df, key = "HSO") {
  k <- df[[key]]
  stop_at <- which(is.na(k) | k == "Total")[1]
  if (!is.na(stop_at)) df <- df[seq_len(stop_at - 1), ]
  df
}

extract_quarter <- function(quarter) {
  wb <- file.path("data", "raw", paste0(quarter, ".xlsx"))
  if (!file.exists(wb)) stop("Put the allocation workbook at ", wb)
  out <- file.path("data", quarter)
  dir.create(out, showWarnings = FALSE, recursive = TRUE)

  # Parameters --------------------------------------------------------------
  params <- read_excel(wb, "Main", range = "A5:B17", col_names = c("parameter", "value"),
                       col_types = c("text", "numeric")) %>%
    filter(!is.na(parameter), !is.na(value))
  write_csv(params, file.path(out, "parameters.csv"))

  # Intake: what each club asked for -----------------------------------------
  intake <- read_block(wb, "Intake", 3) %>% table_rows() %>%
    transmute(
      org = HSO, status = Status,
      requested = `Requested ($)`,
      rollover_external = `Rollover + external ($)`,
      events = `# Events`,
      event_budget_total = `Event budget total ($)`,
      food = `Food ($)`,
      excluded_food_policy = `Excluded by food policy ($)`,
      eligible_request = `Eligible request ($)`,
      expected_attendees = `Expected attendees`
    )

  # Results: how the money was set ---------------------------------------------
  results <- read_block(wb, "Results", 3) %>% table_rows() %>%
    transmute(
      org = HSO,
      flat = `Flat ($)`,
      flexible = `Flexible ($)`,
      formula_allocation = `Total Allocated ($)`,
      allocated = `Committee Nomination ($)`
    )

  # Public notes for committee adjustments. The workbook's internal override
  # justifications are not published; each adjustment needs a short public note
  # in notes/<quarter> adjustments.csv (columns: org, public_note).
  notes_file <- file.path("notes", paste0(quarter, " adjustments.csv"))
  public_notes <- if (file.exists(notes_file)) read_csv(notes_file, show_col_types = FALSE) else
    tibble(org = character(), public_note = character())
  adjusted <- results$org[!is.na(results$allocated) & results$allocated != results$formula_allocation]
  missing <- setdiff(adjusted, public_notes$org)
  if (length(missing)) stop("Add a public note to ", notes_file, " for: ", paste(missing, collapse = ", "))
  results <- results %>%
    left_join(public_notes, by = "org") %>%
    mutate(adjustment_note = if_else(org %in% adjusted, public_note, NA_character_)) %>%
    select(-public_note)

  # Scoring: committee score and the objective (automatic) reviewer only ------
  sc <- read_excel(wb, "Scoring", col_names = FALSE, .name_repair = "minimal")
  row3 <- as.character(unlist(sc[3, ]))
  row4 <- as.character(unlist(sc[4, ]))
  committee_col <- which(str_detect(row4, "^Committee Score"))[1]
  auto_col <- which(str_detect(row3, "Auto-Reviewer"))[1]
  if (is.na(committee_col) || is.na(auto_col)) stop("Could not find score columns in Scoring")
  scores <- sc[-(1:4), c(1, auto_col + 0:3, committee_col)] %>%
    set_names(c("org", "auto_stewardship", "auto_collaboration", "auto_impact",
                "auto_weighted", "committee_score")) %>%
    filter(org %in% intake$org) %>%
    mutate(across(-org, ~ suppressWarnings(as.numeric(.x))))

  allocations <- intake %>%
    left_join(results, by = "org") %>%
    left_join(scores, by = "org") %>%
    mutate(
      pct_of_request = if_else(requested > 0, allocated / requested, NA_real_),
      pct_of_eligible = if_else(eligible_request > 0, allocated / eligible_request, NA_real_)
    )
  write_csv(allocations, file.path(out, "allocations.csv"), na = "")

  # Events: food policy, event by event --------------------------------------
  events <- read_block(wb, "Events", 3) %>% table_rows() %>%
    filter(!str_starts(HSO, fixed("("))) %>%
    transmute(
      org = HSO, event = Event, category = Category,
      event_budget = `Event budget requested ($)`,
      food = `Food ($)`,
      excluded = `Excluded amount ($)`,
      cohosting_hsos = `Co-hosting HSOs (#)`,
      expected_attendees = `Expected attendees`,
      club_requested = suppressWarnings(as.numeric(`Club requested for this event ($)`)),
      why_excluded = `Why this exclusion (auto)`,
      committee_note = `Reclassification rationale`
    )
  write_csv(events, file.path("data", "raw", paste0(quarter, " events.csv")), na = "")
  food_summary <- events %>%
    group_by(category) %>%
    summarise(events = n(),
              event_budget = sum(event_budget, na.rm = TRUE),
              food = sum(food, na.rm = TRUE),
              excluded = sum(excluded, na.rm = TRUE), .groups = "drop")
  write_csv(food_summary, file.path(out, "food_summary.csv"))

  message("Wrote ", nrow(allocations), " HSOs and ", nrow(events), " events to ", out)
  invisible(list(allocations = allocations, food_summary = food_summary, parameters = params))
}
