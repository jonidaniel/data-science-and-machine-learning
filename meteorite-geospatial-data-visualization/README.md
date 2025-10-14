# Meteorite Geospatial Data Visualization

Various scripts for my [Data Science Project: Meteorite Geospatial Data Visualization](https://www.jonimakinen.com/mywork/meteorites-en.html)

`/create-meteorite-spreadsheets.py` is a file for creating various spreadsheets from NASA meteorite data.

`/leafmap-meteorite-locations-demonstration.ipynb` is a demo on visualizing geospatial data with Leafmap.

`/my-put-meteorite-data-fn.py` is a Python script that lives in AWS Lambda. It fetches meteorite data from NASA website.

## Setup and testing

1. First, make sure that you have `python3` and `pip3` installed.

2. Then, download this project to your local machine by giving this command via your command line tools: `git clone https://github.com/jonidaniel/machine-learning/tree/main/meteorite-geospatial-data-visualization`

3. Navigate to the project directory `meteorite-geospatial-data-visualization` and create a Python virtual environment (venv) for the project's Python dependencies with `python3 -m venv <your_venv_name>`

4. Activate the newly created venv with `source <your_venv_name>/bin/activate`

5. Install all needed Python dependencies with `pip3 install -r requirements.txt`

6. Open `/` in your IDE and run it.

## Author

Fall 2025, [@jonidaniel](https://github.com/jonidaniel)
