#!/bin/bash

docker build \
  --tag greedcrow/qbittorrentee-rclone:v2.0 \
  --force-rm \
    .
