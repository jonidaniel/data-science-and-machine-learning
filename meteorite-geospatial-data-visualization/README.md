# Meteorite Geospatial Data Visualization

Various scripts for my [Data Science Project: Meteorite Geospatial Data Visualization](https://www.jonimakinen.com/mywork/meteorites-en.html)

`create-meteorite-spreadsheets.py` is a file for creating various spreadsheets from NASA meteorite data.

`leafmap-meteorite-locations-demonstration.ipynb` is a demo on visualizing geospatial data with Leafmap.

`my-put-meteorite-data-fn.py` is a Python script that lives in AWS Lambda. It fetches meteorite data from NASA website.

## Setup and testing

**On Mac:**

1. First, make sure that you have `python3` and `pip3` installed.

2. Then, download the repository to your local machine by commanding `git clone https://github.com/jonidaniel/data-science-and-machine-learning` in your command line tools.

3. Navigate to the project directory with `cd data-science-and-machine-learning/meteorite-geospatial-data-visualization`

4. Create a [Python virtual environment (venv)](https://docs.python.org/3/library/venv.html) for the project's Python dependencies with `python3 -m venv <your_venv_name>`

5. Activate the newly created venv with `source <your_venv_name>/bin/activate`

6. Install all needed Python dependencies with `pip3 install -r requirements.txt`. This will install `folium`, `geopandas`, `ipykernel`, `ipywidgets`, `leafmap`, `matplotlib`, `mapclassify`, `openpyxl`, and `pandas` packages to the project.

7. Run `code .` to open the whole project in [Visual Studio Code](https://code.visualstudio.com/) (recommended; different commands apply for different IDEs).

8. Run the cells on `create-meteorite-shapefiles.ipynb`, `create-meteorite-spreadsheets.py`, `leafmap-meteorite-locations-demonstration.ipynb`, or `my-put-meteorite-data-fn.py`. You must have a [Jupyter Notebook](https://jupyter.org/) extension installed and your venv selected as the Python kernel.

## Author

Fall 2025, [@jonidaniel](https://github.com/jonidaniel)
