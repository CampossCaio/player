#!/usr/bin/env bash

set -e

# Usage create-vod-hls.sh SOURCE_FILE [OUTPUT_NAME]
[[ ! "${1}" ]] && echo "Usage: create-vod-hls.sh SOURCE_FILE [OUTPUT_NAME]" && exit 1

source="${1}"
folderName=${source/.mp4/''}

cd src/upload

resolutions=("1080" "720" "480" "360")

for resolution in ${resolutions[@]}; do
  mkdir -p ${folderName}/${resolution}
done

master_playlist+="#EXTM3U
#EXT-X-VERSION:3
#EXT-X-STREAM-INF:BANDWIDTH=800000,RESOLUTION=640x360
360/360.m3u8\n
#EXT-X-STREAM-INF:BANDWIDTH=1400000,RESOLUTION=842x480
480/480.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=2800000,RESOLUTION=1280x720
720/720.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=5000000,RESOLUTION=1920x1080
1080/1080.m3u8"


#start conversion
echo -e "Executing command:\nffmpeg"
 docker run -v $(pwd):$(pwd) -w $(pwd)\
        jrottenberg/ffmpeg:4.4-scratch -stats \
 -i ${source} -vf scale=w=640:h=360:force_original_aspect_ratio=decrease -c:a aac -ar 48000 -c:v h264 -profile:v main -crf 20 -sc_threshold 0 -g 48 -keyint_min 48 -hls_time 6 -hls_playlist_type vod -b:v 800k -maxrate 856k -bufsize 1200k -b:a 96k -hls_segment_filename ${folderName}/360/seguiment-%03d.ts ${folderName}/360/360.m3u8 \
-vf scale=w=842:h=480:force_original_aspect_ratio=decrease -c:a aac -ar 48000 -c:v h264 -profile:v main -crf 20 -sc_threshold 0 -g 48 -keyint_min 48 -hls_time 6 -hls_playlist_type vod -b:v 1400k -maxrate 1498k -bufsize 2100k -b:a 128k -hls_segment_filename ${folderName}/480/seguiment-%03d.ts ${folderName}/480/480.m3u8 \
-vf scale=w=1280:h=720:force_original_aspect_ratio=decrease -c:a aac -ar 48000 -c:v h264 -profile:v main -crf 20 -sc_threshold 0 -g 48 -keyint_min 48 -hls_time 6 -hls_playlist_type vod -b:v 2800k -maxrate 2996k -bufsize 4200k -b:a 128k -hls_segment_filename ${folderName}/720/seguiment-%03d.ts ${folderName}/720/720.m3u8 \
-vf scale=w=1920:h=1080:force_original_aspect_ratio=decrease -c:a aac -ar 48000 -c:v h264 -profile:v main -crf 20 -sc_threshold 0 -g 48 -keyint_min 48 -hls_time 6 -hls_playlist_type vod -b:v 5000k -maxrate 5350k -bufsize 7500k -b:a 192k -hls_segment_filename ${folderName}/1080/seguiment-%03d.ts ${folderName}/1080/1080.m3u8

# create master playlist file
echo -e "${master_playlist}" > ${folderName}/master.m3u8

mv ${folderName} ../videos
rm ${source}

echo "Done"