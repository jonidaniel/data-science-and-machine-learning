# Meteorite Geospatial Data Visualization

Various scripts supporting my [Data Science Project: Meteorite Geospatial Data Visualization.](https://www.jonimakinen.com/mywork/meteorites-en.html) Uses `/assets/meteorite-data-nasa.csv` as the main input to form, e.g., Shapefiles and visualizations.

## Setup and Testing

**On macOS:**

1. First, make sure that you have `git`, `python3` and `pip3` installed.

2. Then, download the repository to your local machine by commanding `git clone https://github.com/jonidaniel/data-science-and-machine-learning` in your command line tools.

3. Navigate to the project directory with `cd data-science-and-machine-learning/meteorite-geospatial-data-visualization`

4. Create a [Python virtual environment (venv)](https://docs.python.org/3/library/venv.html) for the project's Python dependencies with `python3 -m venv <your_venv_name>`

5. Activate the newly created venv with `source <your_venv_name>/bin/activate`

6. Install all needed Python dependencies with `pip3 install -r requirements.txt` This will install `folium`, `geopandas`, `ipykernel`, `ipywidgets`, `leafmap`, `matplotlib`, `mapclassify`, `openpyxl`, and `pandas` packages to the project.

7. Run `code .` to open the whole project in [Visual Studio Code](https://code.visualstudio.com/) (recommended; different commands apply for different IDEs).

8. Finally, run the cells on whichever notebook(s) you like. You must have a [Jupyter Notebook](https://jupyter.org/) extension installed and your venv selected as the Python kernel.

   - `create-meteorite-spreadsheets.ipynb`

     For creating spreadsheets from the meteorite data. Creates 3 different spreadsheets (`meteorite-locations.xlsx`, `meteorite-quality-probability-based-on-mass.xlsx`, `meteorites-by-year.xlsx`) into `/spreadsheets`, which can then be used to, e.g., form Power BI dashboards.

   - `create-meteorite-shapefiles.py`

     For creating Shapefiles from the meteorite data. Creates 4 files `meteorites.cpg`, `meteorites.dbf`, `meteorites.shp`, `meteorites.shx` into `/shapefiles`, then compresses them into an archive, which, in this case, is considered the final Shapefile. The Shapefile can then be uploaded used in, e.g., forming geospatial data visualizations.

   - `leafmap-meteorite-locations-demonstration.ipynb`

     A Leafmap geospatial data visualization demonstration. Takes the spreadsheet from `/spreadsheets/meteorite-locations.xlsx` and uses the meteorite locations when drawing a Leafmap.

   - `my-put-meteorite-data-fn.py`

     This script is originally situated in [my AWS environment](https://github.com/jonidaniel/my-aws-environment) as a Lambda function, so it doesn't work here as a standalone executable. Over at AWS it acts as the first phase of the backend process of my [Data Science Project: Geospatial Meteorite Data Visualization.](https://www.jonimakinen.com/mywork/meteorites-fi.html)

## Author

Fall 2025, [@jonidaniel](https://github.com/jonidaniel)
