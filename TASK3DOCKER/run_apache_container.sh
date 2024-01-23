#!/bin/bash

# Build Docker Image
docker build -t thomas-image4 .

# Run Docker Container
docker run -d -p 5555:5555 --name thomas-container4 thomas-image4

