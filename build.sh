#!/bin/bash

docker build \
  --tag greedcrow/qbittorrentee-rclone:v1.8 \
  --force-rm \
    .
