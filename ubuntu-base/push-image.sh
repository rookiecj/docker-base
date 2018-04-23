#!/bin/bash

# login
docker login

# tag
docker tag rookiecj/docker-ubuntu-base:16.04 rookiecj/ubuntu-base:16.04

# publish
docker push rookiecj/ubuntu-base:16.04
