#!/bin/bash

# Build Docker Image
docker build -t thomas-image5 .

# Run Docker Container
docker run -d -p 6666:6666 --name thomas-container5 thomas-image5

