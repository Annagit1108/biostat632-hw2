#'Plot mCPR data and estimates
#' @param dat tibble which contains mCPR observations. Columns: iso, year, cp
#' @param est tibble which contains mCPR estimates. Columns: “Country or area”, iso, Year, Median, U95,L95
#' @param iso_code Numeric. The ISO code of the country for which to generate the plot.
#' @param CI confidence intervals to be plotted. Options can be: 80, 95, or NA (no CI plotted)
#'
#' @return A ggplot object showing modern contraceptive use over time.
#' @export
#'
#' @examples Load data and generate plot for Afghanistan (ISO code 4) with 95% CI
#'
#' plot_cp(dat, est, iso_code = 4, CI = 95)
#'
#' # Generate plot for Kenya (ISO code 404) with 80% CI
#' plot_cp(dat, est, iso_code = 404, CI = 80)
#'
plot_cp <- function(dat, est, iso_code, CI = 95) {
  dat_path <- system.file("data", "contraceptive_use.csv", package = "hw2plot")
  dat <- read_csv(dat_path)

  # Load 'estimated_use.csv' from the data/ folder
  est_path <- system.file("data", "est.csv", package = "hw2plot")
  est <- read_csv(est_path)

  # Merge datasets: Prepare observed data
  dat <- dat %>%
    filter(is_in_union == "Y") %>%
    mutate(
      ref_time = (start_date + end_date) / 2,
      cp = contraceptive_use_modern * 100
    ) %>%
    select(division_numeric_code, ref_time, cp)

  est_filtered <- est %>% filter(iso == iso_code)
  # Remove rows with missing values (NA) or invalid data
  observed_filtered <- dat %>%
    filter(division_numeric_code == iso_code) %>%
    filter(!is.na(ref_time) & !is.na(cp))

  # Base plot
  p <- ggplot(est_filtered, aes(x = Year, y = Median)) +
    geom_line(color = "blue", linewidth = 1) +
    labs(
      x = "Time",
      y = "Modern use (%)",
      title = unique(est_filtered$`Country or area`)
    )

  # Add uncertainty intervals if CI is specified
  if (!is.na(CI)) {
    if (CI == 95) {
      p <- p + geom_ribbon(aes(ymin = L95, ymax = U95), alpha = 0.2)
    } else if (CI == 80) {
      p <- p + geom_ribbon(aes(ymin = L80, ymax = U80), alpha = 0.2)
    }
  }

  # Add observed data points
  if (nrow(observed_filtered) > 0) {
    p <- p +
      geom_point(
        data = observed_filtered,
        aes(x = ref_time, y = cp)
      )
  }

  return(p)
}
