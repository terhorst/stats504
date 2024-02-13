library(readr)

read_goes_file <- function(fname) { 
    col_positions <- fwf_positions(
      start = c(1, 3, 6, 8, 10, 12, 14, 18, 19, 23, 24, 28, 29, 30, 32, 33, 35, 38, 60, 61, 62, 64, 68, 72, 73, 81, 86, 87, 89, 91, 95, 96, 103, 104),
      end = c(2, 5, 7, 9, 11, 13, 17, 17, 22, 22, 27, 27, 29, 31, 32, 34, 37, 59, 60, 60, 63, 67, 71, 71, 80, 85, 85, 88, 90, 94, 94, 102, 102, 110),
      col_names = c("DataCode", "StationCode", "Year", "Month", "Day", "Astrisks", "StartTime", "Space1", "EndTime", "Space2", "MaxTime", "Space3", "NS", "Latitude", "EW", "CMDistance", "SXI", "Space4", "XrayClass", "Space5", "XrayIntensity", "Space6", "StationName", "Space7", "IntegratedFlux", "NOAAUSAFNum", "Space8", "YearCMP", "MonthCMP", "DayCMP", "Space9", "TotalRegionArea", "Space10", "TotalIntensity")
	)
    col_types <- cols(
        DataCode = col_integer(),
        StationCode = col_integer(),
        Year = col_integer(),
        Month = col_integer(),
        Day = col_integer(),
        Astrisks = col_character(),
        StartTime = col_integer(),
        Space1 = col_skip(),
        EndTime = col_integer(),
        Space2 = col_skip(),
        MaxTime = col_integer(),
        Space3 = col_skip(),
        NS = col_character(),
        Latitude = col_integer(),
        EW = col_character(),
        CMDistance = col_integer(),
        SXI = col_character(),
        Space4 = col_skip(),
        XrayClass = col_character(),
        Space5 = col_skip(),
        XrayIntensity = col_integer(),
        Space6 = col_skip(),
        StationName = col_character(),
        Space7 = col_skip(),
        IntegratedFlux = col_double(),
        NOAAUSAFNum = col_integer(),
        Space8 = col_skip(),
        YearCMP = col_integer(),
        MonthCMP = col_integer(),
        DayCMP = col_double(),
        Space9 = col_skip(),
        TotalRegionArea = col_double(),
        Space10 = col_skip(),
        TotalIntensity = col_double()
      )
    read_fwf(fname, col_positions, col_types)
}
