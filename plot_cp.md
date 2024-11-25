# Plot mCPR data and estimates

## Description

Plot mCPR data and estimates

## Usage

```r
plot_cp(dat, est, iso_code, CI = 95)
```

## Arguments

* `dat`: tibble which contains mCPR observations. Columns: iso, year, cp
* `est`: tibble which contains mCPR estimates. Columns: “Country or area”, iso, Year, Median, U95,L95
* `iso_code`: Numeric. The ISO code of the country for which to generate the plot.
* `CI`: confidence intervals to be plotted. Options can be: 80, 95, or NA (no CI plotted)

## Value

A ggplot object showing modern contraceptive use over time.

## Examples

```r
Load data and generate plot for Afghanistan (ISO code 4) with 95% CI

plot_cp(dat, est, iso_code = 4, CI = 95)

# Generate plot for Kenya (ISO code 404) with 80% CI
plot_cp(dat, est, iso_code = 404, CI = 80)
```

