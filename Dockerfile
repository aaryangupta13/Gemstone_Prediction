FROM continuumio/miniconda3:latest

WORKDIR /app

# Install system dependencies (AWS CLI)
RUN apt-get update -y && \
    apt-get install -y awscli && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy environment file (environment.yml) first (for caching)
COPY environment.yml .

# Create the conda environment inside Docker
RUN conda env create -f environment.yml

# --- Set shell to always use conda environment ---
SHELL ["conda", "run", "-n", "gemstone_price_prediction_venv", "/bin/bash", "-c"]

# --- Copy rest of the project code ---
COPY . .

# Add conda environment to PATH
ENV PATH /opt/conda/envs/gemstone_env/bin:$PATH

# Expose Flask port
EXPOSE 5001

# Run the app inside conda environment
CMD ["conda", "run", "--no-capture-output", "-n", "gemstone_price_prediction_venv", "python", "app.py"]