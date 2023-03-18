#!/bin/bash

docker build \
  --tag greedcrow/qbittorrentee-rclone:v1.9 \
  --force-rm \
    .
