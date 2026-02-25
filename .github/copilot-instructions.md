# Copilot Instructions — ShinyHood

R Shiny app that lets students browse Hood College bioinformatics program courses. Data is loaded from a CSV; UI is built with `bslib`; tables use `DT`.

## Running the App

```r
# From the project root in R:
shiny::runApp()
```

Required packages: `shiny`, `bslib`, `DT`. Install with:

```r
install.packages(c("shiny", "bslib", "DT"))
```

## Architecture

All code lives in a single `app.R`. The app uses a **Shiny module** pattern (`course_table_ui` / `course_table_server`) so each program tab (MS, Graduate Certificate) is an independent instance of the same UI + logic.

- **`data/courses.csv`** — sole data source; loaded once at startup with `read.csv()`
- **`page_navbar()`** — top-level layout with one `nav_panel` per program
- **Module** — `course_table_ui(id)` / `course_table_server(id, program_label)` render a filtered `DTOutput` and handle row-click modals
- **Filtering by program** — courses with `program == "Both"` appear in both tabs; the server module filters on `program %in% c(program_label, "Both")`

## CSV Schema (`data/courses.csv`)

| Column | Type | Notes |
|---|---|---|
| `course_number` | string | e.g. `BIFX 501` |
| `course_name` | string | Short title |
| `description` | string | Full description shown in modal |
| `program` | string | `MS`, `Certificate`, or `Both` |
| `type` | string | `Required` or `Elective` |
| `last_taught` | string | e.g. `Fall 2024` |
| `next_planned` | string | e.g. `Spring 2026` |
| `website` | string | URL or empty — rendered as `<a>` link in modal |

## Key Conventions

- **Module namespace**: always use `ns <- NS(id)` inside `course_table_ui`; server uses `moduleServer(id, ...)`.
- **Row-click modals**: `input$<outputId>_rows_selected` (DT convention) triggers `showModal()`. The modal is built inline — no separate UI function.
- **Website links**: rendered conditionally with `!is.na(course$website) && nzchar(course$website)` before building the `tags$a()` element.
- **Theme**: `bs_theme(bootswatch = "cosmo", primary = "#003087")` — Hood College navy as primary color.
- **Table display columns** are controlled by `TABLE_COLS` / `TABLE_HEADERS` constants at the top of `app.R`; the full row (including `description`) is retrieved from `filtered()` for the modal.
