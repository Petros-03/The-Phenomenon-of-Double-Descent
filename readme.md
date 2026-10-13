# The Double Descent Phenomenon

This repository contains the code, dataset, and full report for a project completed as part of the **Methodological Tools of Machine Learning** course at the Department of Statistics, Athens University of Economics and Business (AUEB).

The objective of this project is to practically demonstrate and visualize the **Double Descent** phenomenon. This phenomenon challenges the classical bias-variance tradeoff by showing that as model complexity increases beyond the interpolation threshold (into the over-parameterized regime), the generalization error can actually decrease.

## Repository Contents

* **`Κωδικας Μηχανικής Μάθησης.R`**: The main R script containing the complete methodology, simulations, and code for generating the plots.
* **`Heart_Disease_Prediction.csv`**: The real-world dataset (sourced from Kaggle) used to empirically verify the phenomenon.
* **`Μηχανική_Μάθηση_Απαλλακτική.pdf`**: The full theoretical report and comprehensive analysis of the results (written in Greek).

## Data

To confirm the universality of the double descent phenomenon, two types of data were analyzed:

1. **Simulated Data**: One-dimensional linearly dependent data with added random Gaussian noise ($y = x + \epsilon$). The training sample size was set to $n = 200$.
2. **Real Data (Heart Disease Prediction)**: A dataset consisting of 270 observations and 14 variables, aimed at predicting the presence of heart disease. The training sample size for this experiment was set to $n_1 = 150$.

## Methodology

The experiment utilizes a single hidden layer neural network with random weights (**Random Fourier Features**). Through the `neuron_creator` function, the initial input data is transformed using sinusoidal activation functions.

As the number of parameters (neurons, denoted as $d$) increases and matches the sample size, the model hits the *Interpolation Threshold*. At this point, the test error spikes. As $d$ increases further into the over-parameterized regime, the system is solved using the **Moore-Penrose pseudo-inverse** matrix (via the `ginv()` function). This approach selects the solution with the minimum $L_2$ norm of weights, which implicitly acts as a regularization method and leads to the second descent in the test error.

## Prerequisites

To run the code, you will need **R** installed on your system along with the following packages:

* `MASS` (for calculating the generalized inverse matrix)
* `ggplot2` (for data visualization)

You can install these packages by running the following command in your R console:

```R
install.packages(c("MASS", "ggplot2"))
```

## Running the Code

1. Download the `Κωδικας Μηχανικής Μάθησης.R` script and the `Heart_Disease_Prediction.csv` dataset into the same directory.
2. Set this directory as your Working Directory in R or RStudio (e.g., using `setwd("path/to/folder")`).
3. Run the script. It will sequentially train the models for both datasets and generate two plots illustrating the Training Error and Test Error. These plots visually confirm the peak at the interpolation threshold and the subsequent "double descent".