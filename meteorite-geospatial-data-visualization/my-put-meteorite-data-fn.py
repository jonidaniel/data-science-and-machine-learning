import sys
# Look for Python packages from EFS mount path
sys.path.append("/mnt/data/my-venv/lib64/python3.9/site-packages/")
import boto3
import numpy as np
import pandas as pd
import geopandas as gpd
import shapely

from zipfile import ZipFile

# Puts ready ZIP files into an S3 bucket
def put_object_to_s3(file, key):
    client = boto3.client('s3')
    response = client.upload_file(file, "meteorite-landings", key)
    return response

# Constructs geo data frames from data frames
def constructGeoDataFrame(df, points, key):
    # Turn latitude and longitude coordinates into Geometry Points
    geometry = shapely.points(points[0], points[1])
    # Create a geo data frame with the Points
    gdf = gpd.GeoDataFrame(df, geometry=geometry)
    # Set its Coordinate Reference System
    gdf = gdf.set_crs("EPSG:4326")

    # Create a Shapefile from the geo data frame and save it to EFS
    gdf.to_file("/mnt/data/" + key + ".shp", driver="ESRI Shapefile")

    # Compress the Shapefile into a ZIP file
    with ZipFile("/mnt/data/" + key + ".zip", "w") as zipf:
        zipf.write("/mnt/data/" + key + ".cpg")
        zipf.write("/mnt/data/" + key + ".dbf")
        zipf.write("/mnt/data/" + key + ".prj")
        zipf.write("/mnt/data/" + key + ".shp")
        zipf.write("/mnt/data/" + key + ".shx")

    put_object_to_s3("/mnt/data/" + key + ".zip", key + ".zip")

# Lambda handler function
def lambda_handler(event, context):
    try:
        # Download NASA meteorite data and turn it into a DataFrame
        df = pd.read_csv("https://data.nasa.gov/docs/legacy/meteorite_landings/Meteorite_Landings.csv")

        # Narrow meteorites down to only those that where witnessed (and not found afterwards)
        df = df[df["fall"] == "Fell"]

        # Get rid of unnecessary columns
        keep_cols = [
            "name",
            "mass (g)",
            "year",
            "reclat",
            "reclong"
        ]
        df = df[keep_cols]

        # Keep only rows where all of the columns are existing
        df = df[(df["name"].notna() & df["mass (g)"].notna() & df["year"].notna() & df["reclat"].notna() & df["reclong"].notna())]

        # Calculate latitude and longitude means
        lat_mean = np.mean(df["reclat"])
        long_mean = np.mean(df["reclong"])

        # Calculate weighted latitude and longitude means
        lat_mean_weighted = np.average(df["reclat"], weights=df["mass (g)"])
        long_mean_weighted = np.average(df["reclong"], weights=df["mass (g)"])

        # Calculate total mass of meteorites
        total_mass = np.sum(df["mass (g)"])

        # Form mean and weighted mean data frames
        df_mean = pd.DataFrame([[lat_mean, long_mean]], columns = ["lat", "long"])
        df_mean_weighted = pd.DataFrame([[lat_mean_weighted, long_mean_weighted, total_mass]], columns = ["lat_weighted", "long_weighted", "mass_total"])

        constructGeoDataFrame(df, [df.pop("reclong"), df.pop("reclat")], "meteorites")
        constructGeoDataFrame(df_mean, [df_mean["long"], df_mean["lat"]], "meteorites_mean")
        constructGeoDataFrame(df_mean_weighted, [df_mean_weighted["long_weighted"], df_mean_weighted["lat_weighted"]], "meteorites_mean_weighted")

        return {
            "statusCode": 200,
            "body": "Data uploaded to S3 successfully!"
        }

    except Exception as e:
        print(f"Error: {e}")
        return {
            "statusCode": 500,
            "body": f"An error occurred: {e}"
        }
