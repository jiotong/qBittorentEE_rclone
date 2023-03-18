#!/bin/bash

docker build \
  --tag greedcrow/qbittorrentee-rclone:lastest \
  --force-rm \
    .
