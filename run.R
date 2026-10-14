# Builds the transparency report for one quarter.
# 1. Put the allocation workbook at data/raw/<quarter>.xlsx
# 2. Set the quarter below (quarter_order continues the sequence in data/history_allocations.csv)
# 3. Run this script. The report is written to docs/index.html (the live site)
#    and archived as docs/<quarter>.html.

quarter <- "Fall 2026"
quarter_order <- 5

# RStudio and Positron ship pandoc; point rmarkdown at it when running Rscript outside them.
if (!rmarkdown::pandoc_available()) {
  for (dir in c("/Applications/RStudio.app/Contents/Resources/app/quarto/bin/tools/aarch64",
                "/Applications/RStudio.app/Contents/Resources/app/quarto/bin/tools/x86_64",
                "/Applications/RStudio.app/Contents/Resources/app/quarto/bin/tools")) {
    if (file.exists(file.path(dir, "pandoc"))) {
      Sys.setenv(RSTUDIO_PANDOC = dir)
      break
    }
  }
}

source("extract_data.R")
if (file.exists(file.path("data", "raw", paste0(quarter, ".xlsx")))) {
  extract_quarter(quarter)
} else {
  message("No workbook in data/raw; using the CSVs already in data/", quarter)
}

dir.create("docs", showWarnings = FALSE)
rmarkdown::render(
  "report.Rmd",
  params = list(quarter = quarter, quarter_order = quarter_order),
  output_file = paste0(quarter, ".html"),
  output_dir = "docs"
)
file.copy(file.path("docs", paste0(quarter, ".html")), file.path("docs", "index.html"), overwrite = TRUE)
