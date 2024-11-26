# Use a base image with Python and R pre-installed
FROM rocker/verse:4.3.1

# Install Python3 and essential build tools
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    build-essential \
    libssl-dev \
    libcurl4-gnutls-dev \
    unzip \
    && apt-get clean

# Set up Python environment
RUN pip3 install --upgrade pip

# Install Python machine learning libraries
RUN pip3 install \
    numpy \
    pandas \
    jax \
    scipy \
    scikit-learn \
    matplotlib \
    seaborn \
    xgboost \
    lightgbm \
    tensorflow \
    keras \
    torch torchvision \
    statsmodels \
    joblib \
    catboost \
    jupyter

# Install R machine learning libraries
RUN Rscript -e "options(Ncpus = 12); install.packages(c('data.table', 'caret', 'xgboost', 'lightgbm', 'randomForest', 'e1071', 'glmnet', 'ranger', 'gbm', 'nnet', 'tensorflow', 'keras', 'torch', 'catboost', 'h2o'), repos = 'https://cloud.r-project.org')"

# Set working directory
WORKDIR /app

# Command to unzip and execute the predict script
# Copy a script to handle the subcommands
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Default entrypoint
ENTRYPOINT ["entrypoint.sh"]
