get_width_ci <- function(est, iso_code, coverage = 95) {
  # Validate inputs
  if (!"Year" %in% names(est)) stop("The input data must contain a 'Year' column.")
  if (coverage == 95 && !all(c("L95", "U95") %in% names(est))) {
    stop("The input data must contain 'L95' and 'U95' columns for 95% CI calculations.")
  }
  if (coverage == 80 && !all(c("L80", "U80") %in% names(est))) {
    stop("The input data must contain 'L80' and 'U80' columns for 80% CI calculations.")
  }
  if (!iso_code %in% est$iso) stop("The specified ISO code is not present in the dataset.")
  if (!coverage %in% c(80, 95)) stop("Coverage must be either 80 or 95.")
  
  # Filter data for the specified ISO code
  est_filtered <- est %>% filter(iso == iso_code)
  
  # Calculate interval widths based on coverage
  if (coverage == 95) {
    est_filtered <- est_filtered %>%
      mutate(width = U95 - L95)
  } else if (coverage == 80) {
    est_filtered <- est_filtered %>%
      mutate(width = U80 - L80)
  }
  
  # Rename columns to match desired output format
  result <- est_filtered %>%
    select(year = Year, width)
  
  return(result)
}