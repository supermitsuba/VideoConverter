FROM ubuntu:18.04

WORKDIR /mnt
COPY convert.sh /mnt/convert.sh

# source="/mnt/source"
# destination="/mnt/destination"
RUN apt update && apt install -y ffmpeg
ENTRYPOINT /mnt/convert.sh
