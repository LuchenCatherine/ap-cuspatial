# Advanced Project : GPU-Accelerated Spatial Analysis with cuSpatial on NTAD Dataset

This project demonstrates how to use NVIDIA's [cuSpatial](https://docs.rapids.ai/api/cuspatial/stable/) library with the **North American Transportation Atlas Dataset (NTAD)** to accelerate spatial queries like filtering road segments within bounding boxes and distance calculations from a fixed point (e.g., New York City).

## Repository Contents

- `cuspatial-test.ipynb`: Initial notebook with basic point processing using cuSpatial functions.
- `ntad-cusp.ipynb`: Early attempts to use NTAD shapefile with cuSpatial.
- `ntad-cuspatial-analysis.ipynb`: Final optimized implementation with benchmarking, filtering, and visualization.
- `db2_queries.sql`: Contains SQL scripts used for creating and managing the data in DB2 SE spatial database.

Note: The dataset can be downloaded from https://geodata.bts.gov/datasets/usdot::north-american-roads/about and select shape file (.shp format)

---

## Project Objectives

- Load and preprocess a large shapefile (`.shp`) using GeoPandas.
- Convert coordinates to `cudf.Series` and use cuSpatial GPU APIs for filtering and distance computation.
- Compare performance between traditional DB2 Spatial queries and GPU-accelerated cuSpatial workflows.
- Visualize spatial filters (bounding box and circular radius).

---

## Environment Setup

### Required Libraries

- Python 3.9
- cuSpatial `23.12`
- cuDF, cuPy, GeoPandas, Shapely, Pandas, NumPy, Matplotlib

### Conda Environment Setup

```bash
conda create -n cuspatial_env -c rapidsai -c nvidia -c conda-forge -c defaults cuspatial=23.12 python=3.9 cudatoolkit=11.8 -y
conda activate cuspatial_env
conda install notebook ipykernel
python -m ipykernel install --user --name=cuspatial --display-name "Python (cuspatial)"
```

## Results Summary

### Dataset Overview
* Source: North American Roads Dataset (NTAD)
* Format: Shapefile (.shp) converted to .csv with Well-Known Text (WKT) geometry column
* Size: ~720,000 road segments
* Region Focus: New York City and New York State area

### Experiments Conducted
1. **Naïve Point Count**
  - Loaded all road coordinate points without any filtering.
  - Measured full dataset traversal time on GPU using cuSpatial.
2. **Bounding Box Filtering**
  - Applied a spatial filter using bounding box coordinates around New York State.
  - Performed on both cuSpatial and DB2 Spatial Extender for time comparison.
3. **Distance-Based Filtering**
  - Measured Haversine distance from a fixed reference point (NYC).
  - Queried all road points within a 100 km radius using GPU.
  - Compared results with DB2 spatial distance function.
4. **Spatial DB Querying (IBM Db2 + Spatial Extender)**
  - Used ST_Intersects() and ST_Distance() functions to perform CPU-based spatial queries.
  - Evaluated feasibility and runtime vs. cuSpatial GPU processing.

### Performance Comparison

| Task                         | cuSpatial (GPU) | DB2 Spatial Extender (CPU)   | Speedup        |
|------------------------------|-----------------|------------------------------|----------------|
| Bounding Box Filter          | 0.0080 sec      | 4.9 sec                      | ~612× faster   |
| 100 km Distance Filter (NYC) | Instant         | Slow on large set            | ~100× faster   |
| Basic Join (cuDF vs pandas)  | 43 sec          | 1364 sec                     | ~31× faster    |

* GPU-based spatial filtering drastically outperforms traditional CPU/DB methods, especially on large-scale datasets.

### Key Takeaways
* cuSpatial provides efficient GPU-accelerated spatial operations such as point filtering, distance measurement, and bounding box intersection.

* cuDF + cuSpatial can scale to large datasets while maintaining real-time responsiveness.

* Combining bounding boxes with haversine distance reduces unnecessary computation.

* While DB2 Spatial Extender offers SQL-based spatial support, GPU acceleration is essential for high-performance querying.

