## code to prepare `participation` dataset goes here

# create dataset for app
library(odbc)
library(readxl)
library(DBI)
library(dplyr)
library(purrr)

# NSSE particpation
participation <- read_xlsx("C:/nsse/2025/nsse kiosk (2013-25).xlsx") |>
  # drop test schools and special cases, and Canadians/foreign institutions for now
  filter(unitid != 888888 & SPLOp == 0 & unitid < 900000) |>
  select(unitid, admin_year, BCSSE, FSSE, module1label, module2label, cons_full)


# for reference, omit
tbl(dbConnect(RSQLite::SQLite(),
              dbname = "C:/IPEDS/sqlite/IPEDS_202324.db"),
    "valueSets23") |>
  filter(varName %iN% c("SECTOR", "ICLEVEL", "C21SZSET", "C21ENRPRF")) |>
  select(varName, Codevalue, valueLabel) |>
  arrange(varName, Codevalue) |>
  print(n = Inf)


# IPEDS data, matched on available year.
# E.g. IPEDS 2022-23 is most recent "final" data available at the time for NSSE25 (Spring 2025)
# add Carnegie stuff for each year (contains("BASIC"), contains("SZSET")) once it's established the codes are semi-reliable. Might need to coerce labels, however.
ipeds <- map(
  unique(participation$admin_year),
  \(x)
  tbl(
    dbConnect(RSQLite::SQLite(),
              dbname = paste0("C:/IPEDS/sqlite/IPEDS_",
                              x - 3, substr(x - 2, 3, 4), ".db")),
    paste0("HD20", substr(x - 3, 3, 4))) |>
    # standard criteria: >=4-year, degree granting, UG degree or cert among IPEDS-reporting institutions
    filter(ICLEVEL == 1 & DEGGRANT == 1 & UGOFFER == 1) |>
    select(UNITID, INSTNM, CITY, STABBR, WEBADDR, LATITUDE, LONGITUD,
           # common filters
           CONTROL, OBEREG) |>
    collect()
) |>
  set_names(
    paste0("HD20", substr(unique(participation$admin_year) - 3, 3, 4))
  ) |>
  # for linking with NSSE
  map2(unique(participation$admin_year), mutate) |>
  map(rename, admin_year = last_col())

# check that the Carnegie Classifications remain more or less the same in codes, distributions
# then select the most current one for each table

# add labels
ipeds_labels <- map(
  unique(participation$admin_year),
  \(x)
  tbl(
    dbConnect(RSQLite::SQLite(),
              dbname = paste0("C:/IPEDS/sqlite/IPEDS_",
                              x - 3, substr(x - 2, 3, 4), ".db")),
    paste0("valueSets", substr(x - 3, 3, 4))) |>
    filter(varName %in% c("CONTROL", "OBEREG")) |>
    select(varName, Codevalue, valueLabel) |>
    collect() |>
    mutate(Codevalue = as.integer(Codevalue))
) |>
  set_names(
    paste0("HD20", substr(unique(participation$admin_year) - 3, 3, 4))
  )

# for replacing IPEDS codes with labels
apply_ipeds_labels <- function(x, y, var) {
  by_var <- setNames(c("Codevalue"), var)

  left_join(x, filter(y, varName == var),
            by = by_var) |>
    mutate(!!sym(var) := factor(valueLabel)) |>
    select(-valueLabel, -varName)
}

ipeds <- map2(ipeds, ipeds_labels, apply_ipeds_labels, var = "OBEREG") |>
  map2(ipeds_labels, apply_ipeds_labels, var = "CONTROL")


# match NSSE participation, minor adjustments
participation <- left_join(participation, bind_rows(ipeds), by = c("unitid" = "UNITID", "admin_year"))

# quality check: a very small handful are missing some data, possibly from having UNITID reassigned...
#count(participation, is.na(CONTROL) | is.na(OBEREG) | is.na(INSTNM))
# can't map w/o coordinates
participation <- filter(participation, !is.na(LATITUDE) & !is.na(LONGITUD))

# any particular adjustments for display or download

# save to /data (VERY small)
usethis::use_data(participation, overwrite = TRUE)
