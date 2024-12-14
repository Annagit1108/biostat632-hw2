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
  if (!("iso" %in% names(dat)) || !("iso" %in% names(est))) {
    stop("Input data file dat and estimates file est must contain variable iso.")
  }

  if (!("year" %in% names(dat)) || !("cp" %in% names(dat))) {
    stop("Input data file dat must contain variable year and cp.")
  }

  # Check that 'contraceptive_use_modern' is numeric
  if (!is.numeric(dat$cp)) {
    stop("Input cp in data file dat must be numeric.")
  }

  # Check that CI is one of 80, 95, or NA
  if (!CI %in% c(80, 95, NA)) {
    stop("CI must be 80, 95, or NA.")
  }

  est_filtered <- est %>% filter(iso == iso_code)

  # Remove rows with missing values (NA) or invalid data
  observed_filtered <- dat %>%
    filter(iso == iso_code)

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
        aes(x = year, y = cp)
      )
  }

  return(p)
}
