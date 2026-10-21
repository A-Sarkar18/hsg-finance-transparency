# Chart and table helpers for the transparency report.

library(tidyverse)
library(scales)

MAROON <- "#800000"
GOLD <- "#C99700"
GRAY <- "#BDBAB3"
INK <- "#2B2B2B"

theme_hsg <- function(base_size = 13) {
  theme_minimal(base_size = base_size) +
    theme(
      text = element_text(color = INK),
      plot.title = element_text(face = "bold", size = rel(1.2)),
      plot.title.position = "plot",
      plot.caption = element_text(color = "#6B6B6B", hjust = 0),
      panel.grid.minor = element_blank(),
      panel.grid.major.y = element_blank(),
      legend.position = "top",
      legend.title = element_blank()
    )
}

load_quarter <- function(quarter) {
  dir <- file.path("data", quarter)
  list(
    allocations = read_csv(file.path(dir, "allocations.csv"), show_col_types = FALSE),
    food = read_csv(file.path(dir, "food_summary.csv"), show_col_types = FALSE),
    parameters = read_csv(file.path(dir, "parameters.csv"), show_col_types = FALSE),
    attendance = if (file.exists(file.path(dir, "attendance_summary.csv")))
      read_csv(file.path(dir, "attendance_summary.csv"), show_col_types = FALSE) else NULL
  )
}

param <- function(p, pattern) p$value[str_detect(p$parameter, fixed(pattern))][1]

dollars <- function(x) dollar(x, accuracy = 1)

funded <- function(a) filter(a, allocated > 0)

# Requested vs eligible vs allocated, one row per HSO -------------------------
plot_allocations <- function(a) {
  d <- funded(a) %>%
    mutate(org = fct_reorder(org, allocated)) %>%
    select(org, Requested = requested, `Eligible request` = eligible_request, Allocated = allocated) %>%
    pivot_longer(-org) %>%
    mutate(name = factor(name, c("Requested", "Eligible request", "Allocated")))
  ggplot(d, aes(value, org, fill = name)) +
    geom_col(data = filter(d, name == "Requested"), width = 0.8) +
    geom_col(data = filter(d, name == "Eligible request"), width = 0.55) +
    geom_col(data = filter(d, name == "Allocated"), width = 0.3) +
    geom_text(data = funded(a) %>% filter(requested > 0) %>% mutate(org = factor(org, levels(d$org))),
              aes(requested, org, label = percent(allocated / requested, accuracy = 1)),
              inherit.aes = FALSE, hjust = -0.2, size = 3.4, color = INK) +
    scale_fill_manual(values = c(Requested = GRAY, `Eligible request` = GOLD, Allocated = MAROON)) +
    scale_x_continuous(labels = dollar, expand = expansion(mult = c(0, 0.09))) +
    labs(x = NULL, y = NULL,
         caption = paste("Eligible request = requested amount minus food spending above the policy limits.",
                         "Percentages = share of the request funded.")) +
    theme_hsg()
}

# How many HSOs asked for how much, and their share of all requested dollars --
plot_request_sizes <- function(a) {
  d <- a %>% filter(status == "Applied", requested > 0) %>%
    mutate(band = cut(requested, c(0, 999.99, 1999.99, 2999.99, 4999.99, Inf),
                      labels = c("Under $1,000", "$1,000-$1,999", "$2,000-$2,999", "$3,000-$4,999", "$5,000+"))) %>%
    group_by(band, .drop = FALSE) %>%
    summarise(hsos = n(), dollars_requested = sum(requested), .groups = "drop") %>%
    mutate(share = dollars_requested / sum(dollars_requested))
  ggplot(d, aes(band, hsos)) +
    geom_col(fill = MAROON, width = 0.7) +
    geom_text(aes(label = paste0(hsos, " HSOs\n", percent(share, accuracy = 1), " of all requested $")),
              vjust = -0.3, size = 3.4, lineheight = 0.9) +
    scale_y_continuous(expand = expansion(mult = c(0, 0.35)), breaks = pretty_breaks()) +
    labs(x = "Amount requested", y = "Number of HSOs") +
    theme_hsg() + theme(panel.grid.major.x = element_blank())
}

# Expected attendance per event, by band ---------------------------------------
plot_attendance <- function(at) {
  d <- at %>% filter(events > 0 | band != "Not given") %>%
    mutate(band = factor(band, c("1-24", "25-49", "50-99", "100-199", "200+", "Not given")))
  ggplot(d, aes(band, events)) +
    geom_col(fill = GOLD, width = 0.7) +
    geom_text(aes(label = events), vjust = -0.4, size = 3.6) +
    scale_y_continuous(expand = expansion(mult = c(0, 0.15)), breaks = pretty_breaks()) +
    labs(x = "Expected attendees per event", y = "Number of events",
         caption = "Attendance figures are the HSOs' own estimates from their applications.") +
    theme_hsg() + theme(panel.grid.major.x = element_blank())
}

# Committee score vs share of eligible request funded -------------------------
plot_score_share <- function(a) {
  d <- funded(a) %>% filter(!is.na(committee_score), eligible_request > 0)
  ggplot(d, aes(committee_score, pct_of_eligible)) +
    geom_smooth(method = "lm", se = FALSE, color = GRAY, linewidth = 1) +
    geom_point(color = MAROON, size = 3) +
    geom_text(aes(label = org), size = 3.2, vjust = -0.9, check_overlap = TRUE) +
    scale_y_continuous(labels = percent, limits = c(0, NA)) +
    labs(x = "Committee score (1-5)", y = "Share of eligible request funded",
         caption = "Each dot is one HSO. The line is a simple linear fit.") +
    theme_hsg() + theme(panel.grid.major.y = element_line())
}

# Rollover relative to the request vs share funded ----------------------------
plot_rollover <- function(a) {
  d <- funded(a) %>% filter(requested > 0) %>%
    mutate(rollover_ratio = pmin(rollover_external / requested, 3))
  ggplot(d, aes(rollover_ratio, pct_of_eligible)) +
    geom_point(color = MAROON, size = 3) +
    geom_text(aes(label = org), size = 3.2, vjust = -0.9, check_overlap = TRUE) +
    scale_x_continuous(labels = percent) +
    scale_y_continuous(labels = percent, limits = c(0, NA)) +
    labs(x = "Rollover and outside funds as a share of the request (capped at 300%)",
         y = "Share of eligible request funded") +
    theme_hsg() + theme(panel.grid.major.y = element_line())
}

# Food: requested vs excluded, by event category ------------------------------
plot_food <- function(f) {
  d <- f %>%
    transmute(category, `Food requested` = food, `Excluded by policy` = excluded) %>%
    pivot_longer(-category) %>%
    mutate(name = factor(name, c("Food requested", "Excluded by policy")))
  ggplot(d, aes(value, fct_rev(category), fill = name)) +
    geom_col(position = position_dodge(width = 0.7), width = 0.6) +
    geom_text(aes(label = dollars(value)), position = position_dodge(width = 0.7),
              hjust = -0.1, size = 3.5) +
    scale_fill_manual(values = c(`Food requested` = GOLD, `Excluded by policy` = MAROON)) +
    scale_x_continuous(labels = dollar, expand = expansion(mult = c(0, 0.15))) +
    labs(x = NULL, y = NULL,
         caption = "Social events are limited by total event cost, so their exclusions can include non-food costs.") +
    theme_hsg()
}

# History ---------------------------------------------------------------------
history_with_current <- function(quarter, a, order) {
  h <- read_csv(file.path("data", "history_allocations.csv"), show_col_types = FALSE)
  current <- funded(a) %>%
    transmute(quarter = quarter, quarter_order = order, round = "Regular", org,
              requested = if_else(requested > 0, requested, NA_real_), allocated)
  bind_rows(select(h, quarter, quarter_order, round, org, requested, allocated), current) %>%
    mutate(quarter = fct_reorder(quarter, quarter_order))
}

plot_history_totals <- function(h) {
  d <- h %>%
    group_by(quarter = as.character(quarter), quarter_order) %>%
    summarise(Requested = sum(requested, na.rm = TRUE), Allocated = sum(allocated), .groups = "drop")
  # Quarters where only totals are available (no HSO-level records)
  totals_file <- file.path("data", "history_totals.csv")
  if (file.exists(totals_file)) {
    d <- bind_rows(d, read_csv(totals_file, show_col_types = FALSE) %>%
                     transmute(quarter, quarter_order, Requested = requested, Allocated = allocated))
  }
  d <- d %>%
    mutate(quarter = fct_reorder(quarter, quarter_order)) %>%
    pivot_longer(c(Requested, Allocated)) %>%
    mutate(name = factor(name, c("Requested", "Allocated")))
  ggplot(d, aes(quarter, value, fill = name)) +
    geom_col(position = position_dodge(width = 0.75), width = 0.7) +
    geom_text(aes(label = dollars(value)), position = position_dodge(width = 0.75),
              vjust = -0.4, size = 3.4) +
    scale_fill_manual(values = c(Requested = GRAY, Allocated = MAROON)) +
    scale_y_continuous(labels = dollar, expand = expansion(mult = c(0, 0.1))) +
    labs(x = NULL, y = NULL,
         caption = paste("Fall 2024 includes the special allocation round. Winter 2026 totals are from that quarter's",
                         "Finance Committee report;\nHSO-level detail is not available. Fall 2025 records are not in this repository.")) +
    theme_hsg() + theme(panel.grid.major.y = element_line(), panel.grid.major.x = element_blank())
}

plot_history_clubs <- function(h, orgs) {
  d <- h %>% filter(org %in% orgs) %>%
    group_by(quarter, org) %>% summarise(allocated = sum(allocated), .groups = "drop")
  ggplot(d, aes(quarter, allocated, group = org)) +
    geom_line(color = GRAY) +
    geom_point(color = MAROON, size = 2) +
    facet_wrap(~org, ncol = 5) +
    scale_y_continuous(labels = dollar) +
    labs(x = NULL, y = NULL,
         caption = "Agora was formerly Unum and RPD was formerly RAC. A missing point means the HSO did not apply that quarter.") +
    theme_hsg(11) +
    theme(axis.text.x = element_text(angle = 45, hjust = 1), panel.grid.major.y = element_line())
}

# Tables ------------------------------------------------------------------------
allocation_table <- function(a) {
  a %>%
    filter(status == "Applied" | allocated > 0) %>%
    arrange(desc(allocated)) %>%
    transmute(
      HSO = org,
      Requested = dollars(requested),
      `Rollover + outside` = dollars(rollover_external),
      `Eligible request` = dollars(eligible_request),
      `Committee score` = if_else(is.na(committee_score), "", number(committee_score, accuracy = 0.01)),
      Flat = dollars(flat),
      Flexible = dollars(flexible),
      Allocated = dollars(allocated),
      `% of eligible` = if_else(is.na(pct_of_eligible), "", percent(pct_of_eligible, accuracy = 1)),
      Note = coalesce(adjustment_note, if_else(status != "Applied", "No application on record", ""))
    )
}

