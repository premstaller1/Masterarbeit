# Master Thesis Repository

## Overview

This repository contains the data and code used for the analysis presented in the master's thesis titled **"Geographical Distribution and Clustering of the Hydrogen Economy in Europe: An Analysis of Hydrogen Valleys and Value Chain"**. The study explores the hydrogen ecosystem within Hydrogen Valleys through industrial cluster analysis, leveraging firm-level spatial data from diverse sources.

## Author

- **Name:** Andrè Premstaller
- **Student ID:** h11811428

## Institution

- **Department:** Department of Information Systems and Operations Management
- **Institute:** Institute for Data, Energy, and Sustainability

## Advisor

- **Advisor:** Univ.Prof. Dr. Kavita Surana

## Repository Structure

### Final Datasets:
The final Datasets can be found in "gahteredData".

- **Hydrogen Industry**
  - The hydrogen industry dataset created in this thesis is named: "locations_hydro_V14"
  - It contains Lat, Lon, Name, Full Adress, Address, ZIP, City, Country and the Source.
    - Not for every actor the individual parts of the address was available (e.g. City, ZIP).

- **Benchmark Industry**
  - The hydrogen industry dataset created in this thesis is named: "locations_benchmark_V4"
  - It contains Lat, Lon, Name, Full Adress, Address, ZIP, City, Country

### Directories

- **.vscode**
  - Contains configuration files for Visual Studio Code.

- **Archive**
  - Contains archived data and descriptions of notebooks.

- **Centrality**
  - Includes scripts and data related to centrality analysis.

- **CorrelationAnalysis**
  - Contains data and notebooks for correlation analysis. Here RQ2 was mostly answered using visualisations and data praparation.

- **gatheredData**
  - Holds gathered data used across various analyses. 

- **gis**
  - Contains GIS data and related resources.

- **webcrawler**
  - Includes scripts and data from web crawling activities. Here it is visible how the data was gathered using crawlers and the API.

### Files

- **Mitarbeiter_SHP.gpkg**
  - Geopackage file related to employee data.

- **cluster_areas.gpkg**
  - Geopackage file for cluster area data.

- **cluster_locations.gpkg**
  - Geopackage file for cluster location data.

- **hydrogen_landscape.qgz**
  - QGIS project file for hydrogen landscape analysis.

- **prod_skala.gpkg**
  - Geopackage file for production scale visuals.

- **reporjection.gpkg**
  - Geopackage file with reprojected data.

## Abstract

The European Union (EU) has identified green and low carbon Hydrogen as a pivotal component in transitioning its economy from fossil fuel dependency to a sustainable, circular, and carbon-neutral model. However, as of 2022, a staggering 96% of hydrogen production relied on natural gas, with hydrogen accounting for a mere 2% of Europe's energy consumption. To meet the strategic objective of achieving 40GW electrolyser capacity by 2030, comprehensive development of hydrogen production across the entire value chain, from production to consumption and transportation, is imperative. The EU has introduced the concept of "Hydrogen Valleys" to stimulate local production and demand, fostering regional hydrogen economies that engage citizens.

This master's thesis aims to explore the hydrogen ecosystem within Hydrogen Valleys through industrial cluster analysis, leveraging firm-level spatial data from diverse sources. By conducting an initial screening of available data sources and synthesizing relevant information, this study will employ Geographic Information Systems (GIS) to visualize the landscape of existing valleys, identify potential emerging regions, and outline key characteristics of the hydrogen economy.

## Research Questions

1. **Geographical Distribution and Clustering**
   - Where and how are the hydrogen clusters geographically distributed across Europe, and what does this distribution reveal about the spatial concentration and development of the hydrogen economy?
   - Sub-questions:
     - Does the hydrogen economy in Europe exhibit clustering behaviour, and if so, which regions in Europe exhibit the highest levels of clustering as indicated by a firm-level cluster index?
     - Where could potential hydrogen valleys emerge in selected European countries, and where are existing hydrogen valleys developing?

2. **Hydrogen Value Chain**
   - How is the hydrogen value chain distributed across different European countries?
   - Sub-questions:
     - How do different European countries perform across various segments of the hydrogen value chain, and what patterns emerge from their relative distribution of activities?
     - Which countries have the most advanced hydrogen value chains, and which are still emerging?
     - Is there a significant difference in the development of hydrogen value chains among countries with varying numbers of Hydrogen Valleys?

## Methodology

### Data Gathering

- **Sources:** Various data sources were aggregated and cleaned to create a comprehensive dataset. The sources included international associations, national hydrogen associations, specific databases, public/federal project participants, and publicly available or provided data.
- **Data Types:**
  - **Actor-based data:** Includes the name of the company and its exact location (street, house number, and postcode).
  - **Aggregated data:** Includes information aggregated on a country level, such as hydrogen production costs, FCEV fleet data, demand, and production data.

### Data Cleaning

- **Process:**
  - Duplicate entries (both in address and name) were removed.
  - Subsidiaries located at the same address were checked and either the headquarter or the specific hydrogen subsidiary was retained.
  - Missing locations were manually searched and added.
  - Entries outside continental Europe were deleted.
- **Result:** The cleaned dataset consisted of 4,242 actors involved in various aspects of the hydrogen economy across Europe.

### Benchmark Data

- **Source:** The benchmark data was obtained using the Amadeus database for the Energy Sector in the EU.
- **Process:** The initial dataset of 180,000 entries was randomly reduced to 30,000 while maintaining the original distribution of companies per country. After geocoding, the dataset was further reduced to 25,000 entries by removing unrealistic or non-European values.

### Analysis

- **Cluster Analysis:**
  - **Firm-Level Cluster Index:** Developed by Scholl & Brenner (2016), this index assesses the degree of spatial concentration of hydrogen firms.
    - **Key Properties:**
      - **Cluster Index:** Measures the concentration or dispersion of an industry within a particular area compared to the overall industrial agglomeration.
      - **Spatial Insight:** Identifies the spatial location of highly clustered firms.
      - **Interval-scaled Variable:** Computes a unique concentration level for each firm.
    - **Algorithm:**
      - Firm-specific spatial concentration values (Di-Values) are calculated by summing the inverted distances between a firm and all other firms in the same industry.
      - The index is normalized to make it comparable across industries.
      - The Di values are compared with a benchmark distribution using a kernel density estimator.
      - Statistical tests (Kolmogorov-Smirnov and Wilcoxon Rank Sum) are used to validate the clustering results.
  - **DBSCAN (Density-Based Spatial Clustering of Applications with Noise):**
    - Identifies clusters based on data point density.
    - Noise tolerance allows for the identification of outlier data points.
    - Does not require the number of clusters to be predefined.
    - Parameters used: minimum cluster size (min) = 10, maximum distance between cluster points (eps) = 15,000 meters.

- **GIS Visualization:**
  - **Tools:** Geographic Information Systems (GIS) were used to visualize the hydrogen landscape.
  - **Data Visualized:** Includes production sites, consumption centers, employment data, business areas, and other attributes.
  - **Methods:**
    - **Kernel Density Estimation (KDE):** Identifies areas with high density of hydrogen actors.
    - **DBSCAN Clustering:** Provides insights into the concentration and potential growth areas for the hydrogen industry.

### Results Analysis

- **Global Values and Concentration:** The firm-level index provided insights into the spatial concentration of hydrogen firms relative to benchmark locations.
- **Spatial Concentration Analysis:** Identified regions with the highest levels of clustering and potential areas for hydrogen valley development.
- **Descriptive Analysis:** Compared the hydrogen economy across different European countries and analyzed the performance across the hydrogen value chain.
- **QGIS Visualization:** Visualized the distribution of hydrogen-related actors and the hydrogen value chain to provide a comprehensive understanding of the hydrogen economy in Europe.
- **Value Chain Analysis:** Visualized the hydrogen value chain along different European countries to identify differences in maturity and development.

"""

## Contact

For any questions or contributions, please contact the repository maintainer.

---

This README file provides an overview of the repository structure and the research conducted for the master's thesis. For more detailed information, please refer to the individual directories and files.
"""