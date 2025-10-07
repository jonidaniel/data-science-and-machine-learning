#!/usr/bin/env python3

import os
import pandas as pd
import urllib.request

# Meteorite Landings 1900–2013 (NASA): Power BI Dashboard
# https://app.powerbi.com/links/LFsOgcf-i8?ctid=f0b9e9d7-8d66-4b16-9c1c-6b07c4796280&pbi_source=linkShare
def createMeteoritesByYear():
    # Wrangle the landings data
    meteoritesByYear = meteorites[(meteorites["year"] >= 1900) & (meteorites["fall"] == "Fell")]["year"].value_counts()

    # Save the data into an Excel file
    if not os.path.isdir("./spreadsheets"):
        os.mkdir("./spreadsheets")
    meteoritesByYear.to_excel("./spreadsheets/meteorites-by-year.xlsx", index = True)

# Meteorite Landings (NASA): Power BI Dashboard
# ???
def createMeteoriteLocations():
    # Wrangle the landings data
    meteoriteLocations = meteorites.loc[0:, ["name", "year", "reclat", "reclong"]].sort_values(["name", "year", "reclat", "reclong"])

    # Save the data into an Excel file
    if not os.path.isdir("./spreadsheets"):
        os.mkdir("./spreadsheets")
    meteoriteLocations.to_excel("./spreadsheets/meteorite-locations.xlsx", index = False)

# Meteorite Quality Probability Based on Mass: Interactive Power BI Dashboard
# ???
def createMeteoriteQualityProbabilityBasedOnMass():
    # Wrangle the landings data
    # !!!!!

    # Save it into an Excel file
    if not os.path.isdir("./spreadsheets"):
        os.mkdir("./spreadsheets")
    meteorites.to_excel("./spreadsheets/meteorite-quality-probability-based-on-mass.xlsx", index = False)

# Download meteorite landings data and save it into a CSV file
# urllib.request.urlretrieve("https://data.nasa.gov/docs/legacy/meteorite_landings/Meteorite_Landings.csv", "./meteorite-landings-nasa.csv")

# Read landings data file
meteorites = pd.read_csv("./meteorite-landings-nasa.csv")

# Create Excel files for Power BI dashboards
createMeteoritesByYear()
createMeteoriteLocations()
createMeteoriteQualityProbabilityBasedOnMass()
