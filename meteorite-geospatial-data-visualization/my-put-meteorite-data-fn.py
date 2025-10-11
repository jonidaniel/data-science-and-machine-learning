# https://dev.to/slotbite/installing-python-dependencies-on-aws-lambda-using-efs-1n25
# https://medium.com/picus-security-engineering/exploring-the-power-of-aws-efs-with-lambda-cc1e35f35c8a
# https://aws.amazon.com/blogs/aws/new-a-shared-file-system-for-your-lambda-functions/
# https://safezone.im/how-to-use-efs-to-store-cx_oracle-pandas-and-other-python-packages/

# https://docs.aws.amazon.com/efs/latest/ug/efs-mount-helper.html
# https://docs.aws.amazon.com/efs/latest/ug/installing-amazon-efs-utils.html#installing-efs-utils-amzn-linux

# https://repost.aws/knowledge-center/efs-access-point-configurations

# https://stackoverflow.com/questions/29857396/file-permission-meanings

# https://www.youtube.com/watch?v=FA153BGOV_A&t=174s

# https://docs.aws.amazon.com/lambda/latest/dg/configuration-vpc-internet.html

# https://www.youtube.com/watch?v=vANJzXzh6cU

# https://docs.aws.amazon.com/lambda/latest/dg/configuration-timeout.html#configuration-timeout-console

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

# import os
# import subprocess

# PACKAGE_DIR = "/mnt/data/lib/{}/site-packages/"

# # Generates a Python version tag like 'python3.11'
# def get_python_version_tag():
#     return f"python{os.sys.version_info.major}.{os.sys.version_info.minor}"

# # Installs a Python package into the EFS-mounted directory
# def install_package(package):
#     target_dir = PACKAGE_DIR.format(get_python_version_tag())
#     os.makedirs(target_dir, exist_ok=True)
#     try:
#         subprocess.run(
#             [
#                 "pip",
#                 "install",
#                 package,
#                 "--target",
#                 target_dir,
#                 "--upgrade",
#                 "--no-cache-dir",
#             ],
#             check=True,
#         )
#         print(f"Package {package} installed successfully!")
#     except subprocess.CalledProcessError as e:
#         print(f"Failed to install package {package}: {e}")

# # AWS Lambda Handler for installing packages
# def lambda_handler(event, context):
#     try:
#         # List of packages to install from the event input
#         packages = event.get("packages", [])
#         for package in packages:
#             install_package(package)
#         # Optional for see packages installed
#         # os.system(f"ls -la {PACKAGE_DIR.format(get_python_version_tag())}")
#         return {"statusCode": 200, "body": "Packages installed successfully!"}
#     except Exception as e:
#         print(f"Error: {e}")
#         return {"statusCode": 500, "body": f"An error occurred: {e}"}
