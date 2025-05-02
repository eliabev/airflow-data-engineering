FROM quay.io/astronomer/astro-runtime:12.7.1

# Install system dependencies required for building pandas and other C extensions
USER root
RUN apt-get update && apt-get install -y gcc build-essential

# Create virtual env, install dependencies, then remove build deps if desired
RUN python -m venv soda_venv && \
    . soda_venv/bin/activate && \
    pip install --no-cache-dir soda-core-bigquery==3.0.45 && \
    pip install --no-cache-dir soda-core-scientific==3.0.45 && \
    deactivate

# Optionally, if you want to remove build dependencies after installation to reduce image size:
# RUN apt-get remove -y gcc build-essential && apt-get autoremove -y && apt-get clean

USER astro

RUN python -m venv dbt_venv && source dbt_venv/bin/activate && \
    pip install --no-cache-dir dbt-bigquery==1.5.3 && deactivate