#!/bin/bash

# This is a crude script with few safety checks, use at your own risk and have a backup first.
# Ideally you're on ZFS and can just make a snapshot that you can rollback to if needed.

# Your Nextcloud container name or ID
CONTAINER_NAME="nextcloud"

# Define the list of apps you want to install.  Add/remove as needed. (Names can be found in the URL of the nextcloud app store)
APPS=(
  "memories"
  "facerecognition"
  "recognize"
  "previewgenerator"
  "camerarawpreviews"
  "bruteforcesettings"
  "calendar"
  "contacts"
  "mail"
  "maps"
  "files_archive"
  "drawio"
  "metadata"
  "files_snapshots"
  )

# Loop through each app and install
for app in "${APPS[@]}"; do
    echo "Installing $app..."
    docker exec $CONTAINER_NAME php occ app:install $app
done

# Config Nextcloud
docker exec $CONTAINER_NAME php occ background:cron
docker exec $CONTAINER_NAME php occ config:system:set default_phone_region --value='US'
docker exec $CONTAINER_NAME php occ config:app:set theming name --value='Cloud'
docker exec $CONTAINER_NAME php occ config:app:set theming slogan --value='Fluffy'
docker exec $CONTAINER_NAME php occ config:app:set theming url --value='https://subdomain.domain.com'
docker exec $CONTAINER_NAME php occ config:system:set preview_ffmpeg_path --value='/usr/bin/ffmpeg'


# Recognize: Install Face Recognition settigns and models.  Memory can be reduced if you are short, minimum is 4GB.
docker exec $CONTAINER_NAME php occ face:setup -M 16GB
docker exec $CONTAINER_NAME php occ face:setup -m 1
docker exec $CONTAINER_NAME php occ face:setup -m 2
docker exec $CONTAINER_NAME php occ face:setup -m 3
docker exec $CONTAINER_NAME php occ face:setup -m 4
docker exec $CONTAINER_NAME php occ config:app:set facerecognition analysis_image_area --value='8294400'

# Face Recognition: Install Model for Recognize app & configure
docker exec $CONTAINER_NAME php occ recognize:download-models
docker exec $CONTAINER_NAME php occ config:app:set recognize faces.enabled --value=true
docker exec $CONTAINER_NAME php occ config:app:set recognize imagenet.enabled --value=true
docker exec $CONTAINER_NAME php occ config:app:set recognize landmarks.enabled --value=true
docker exec $CONTAINER_NAME php occ config:app:set recognize musicnn.enabled --value=true
docker exec $CONTAINER_NAME php occ config:app:set recognize movinet.enabled --value=true

# Memories: Configure
# Downloads Geo Data.  takes a long time, fails sometimes.  May need to put a retry check or run manually
# docker exec $CONTAINER_NAME php occ memories:places-setup
docker exec $CONTAINER_NAME php occ config:system:set enable_previews --value=true
docker exec $CONTAINER_NAME php occ config:system:set preview_max_memory --value='4096'
docker exec $CONTAINER_NAME php occ config:system:set preview_max_x --value='2048'
docker exec $CONTAINER_NAME php occ config:system:set preview_max_y --value='2048'
docker exec $CONTAINER_NAME php occ config:system:set jpeg_quality --value='75'
docker exec $CONTAINER_NAME php occ config:system:set preview_max_filesize_image --value='256'
docker exec $CONTAINER_NAME php occ config:system:set enabledPreviewProviders 0 --value='OC\Preview\PNG'
docker exec $CONTAINER_NAME php occ config:system:set enabledPreviewProviders 1 --value='OC\Preview\JPEG'
docker exec $CONTAINER_NAME php occ config:system:set enabledPreviewProviders 2 --value='OC\Preview\GIF'
docker exec $CONTAINER_NAME php occ config:system:set enabledPreviewProviders 3 --value='OC\Preview\BMP'
docker exec $CONTAINER_NAME php occ config:system:set enabledPreviewProviders 4 --value='OC\Preview\XBitmap'
docker exec $CONTAINER_NAME php occ config:system:set enabledPreviewProviders 5 --value='OC\Preview\MP3'
docker exec $CONTAINER_NAME php occ config:system:set enabledPreviewProviders 6 --value='OC\Preview\HEIC'
docker exec $CONTAINER_NAME php occ config:system:set enabledPreviewProviders 7 --value='OC\Preview\Movie'
docker exec $CONTAINER_NAME php occ config:system:set enabledPreviewProviders 8 --value='OC\Preview\TIFF'
docker exec $CONTAINER_NAME php occ config:system:set enabledPreviewProviders 9 --value='OC\Preview\MKV'
docker exec $CONTAINER_NAME php occ config:system:set enabledPreviewProviders 10 --value='OC\Preview\MP4'
docker exec $CONTAINER_NAME php occ config:system:set enabledPreviewProviders 11 --value='OC\Preview\AVI'
docker exec $CONTAINER_NAME php occ config:system:set enabledPreviewProviders 12 --value='OC\Preview\MOV'
docker exec $CONTAINER_NAME php occ config:system:set enabledPreviewProviders 13 --value='OC\Preview\webp'

# files_snapshots: Install configure
docker exec $CONTAINER_NAME php occ config:app:set files_snapshots snap_format --value='/var/www/html/data/.zfs/snapshot/%snapshot%/'
docker exec $CONTAINER_NAME php occ config:app:set files_snapshots date_format --value='Y-m-d-His'

# files_archive: Install configure
docker exec $CONTAINER_NAME php occ config:app:set files_archive archiveSizeLimit --value='214748364800'

# drawio: Install configure
docker exec $CONTAINER_NAME php occ config:app:set drawio DrawioOffline --value='yes'
docker exec $CONTAINER_NAME php occ config:app:set drawio DrawioLibraries --value='yes'
