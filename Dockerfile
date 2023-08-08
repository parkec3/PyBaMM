FROM python:3.11-slim

# Set the working directory
WORKDIR /

# Install the necessary dependencies
RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y libopenblas-dev gcc gfortran graphviz git make g++ build-essential

ENV CMAKE_C_COMPILER=/usr/bin/gcc
ENV CMAKE_CXX_COMPILER=/usr/bin/g++
ENV CMAKE_MAKE_PROGRAM=/usr/bin/make

# Copy project files into the container
RUN git clone https://github.com/pybamm-team/PyBaMM.git

WORKDIR /PyBaMM/

# Install PyBaMM
RUN python -m pip install --upgrade pip
# RUN pip install -e ".[all]"

ARG ODES
ARG JAX
ARG IDAKLU


RUN if [ "$ODES" = "true" ]; then \
    apt-get install -y cmake && \
    pip install wget \
    pip install -e ".[all]" \
    pybamm_install_odes; \
    fi

RUN if [ "$JAX" = "true" ]; then \
    pip install -e ".[jax,all]";\
    fi

RUN if [ "$IDAKLU" = "true" ]; then \
    pip install wget \
    python scripts/install_KLU_Sundials.py \
    git clone https://github.com/pybind/pybind11.git pybind11/; \
    pip install -e ".[all]"; \
    fi

CMD ["/bin/bash"]
