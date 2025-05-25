# 🌍 GPU-Accelerated COVID-19 Geospatial Analysis using RAPIDS

This repository contains a Jupyter notebook that demonstrates **GPU-native geospatial data processing** and **clustering analysis** using NVIDIA RAPIDS libraries like `cuDF`, `cuSpatial`, and `cuML`. The goal is to analyze global COVID-19 case data and uncover geospatial patterns efficiently on the GPU.

---

## 📁 Project Structure

```bash
.
├── test.ipynb                  # Main Jupyter notebook
├── data/
│   ├── WHO-COVID-19-global-data-2.csv
│   └── world_country_and_usa_states_latitude_and_longitude_values.csv
└── README.md                   # Project documentation
```

---

## 🔧 Technologies Used

- [cuDF](https://docs.rapids.ai/api/cudf/stable/) – GPU-accelerated DataFrame (Pandas-like)
- [cuSpatial](https://docs.rapids.ai/api/cuspatial/stable/) – Geospatial operations (e.g., Haversine distance)
- [cuML](https://docs.rapids.ai/api/cuml/stable/) – GPU-based machine learning (DBSCAN clustering)
- [Matplotlib](https://matplotlib.org/) – Visualizations
- [Pandas](https://pandas.pydata.org/) – Date parsing (intermediate step)

---

## 📊 What This Notebook Does

1. **Load Data**  
   - COVID-19 case data from WHO  
   - Country latitude/longitude mappings

2. **Clean & Preprocess**  
   - Fix column names  
   - Parse dates correctly  
   - Merge case data with geolocation data  
   - Filter data to a target date range (post-2021)

3. **Geospatial Computation**  
   - Calculate Haversine distance between points  
   - Prepare latitude and longitude for clustering

4. **Clustering with DBSCAN**  
   - Use `cuML`'s GPU-accelerated DBSCAN  
   - Identify spatial clusters of COVID-19 activity

5. **Visualization**  
   - Plot results using Matplotlib  
   - Highlight discovered clusters on maps

---

## 🗂️ Dataset Sources

- WHO COVID-19 Global Data:  
  https://covid19.who.int/info/

- Country & State Coordinates:  
  Derived from various open data sources (lat/lon mapping)

---

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/gpu-covid-analysis.git
cd gpu-covid-analysis
```

### 2. Set Up Your Environment

Install RAPIDS (compatible with your CUDA version). Visit: https://rapids.ai/start.html  
Or use Docker with RAPIDS pre-installed.

### 3. Install Required Python Packages

```bash
pip install matplotlib pandas
# RAPIDS packages should be installed via conda or Docker
```

### 4. Run the Notebook

Launch Jupyter Lab or Jupyter Notebook:

```bash
jupyter lab
```

Open `test.ipynb` and run the cells sequentially.

---

## ✅ Requirements

- NVIDIA GPU with CUDA support (11.x or higher recommended)
- RAPIDS installed (cuDF, cuSpatial, cuML)
- Python 3.8 or newer

---

## 📌 Notes

- For better performance, ensure data is on the GPU memory as much as possible.
- When working with large datasets, avoid converting back to Pandas unless needed (e.g., for datetime parsing).
- Use `.shift()` carefully when computing distances between points over time.

---

## 📄 License

This project is open-sourced under the [MIT License](LICENSE).

---

## 🙌 Acknowledgements

Thanks to [NVIDIA RAPIDS](https://rapids.ai) for enabling high-performance GPU analytics!

---

## 📬 Contact

For questions or feedback, feel free to open an issue or reach out on GitHub.
