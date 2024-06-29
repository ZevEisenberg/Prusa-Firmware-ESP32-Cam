#!/bin/bash

# This is a script to build the firmware for the ESP32 PrusaConnectCam project.
# Thi script is created by Miroslav Pivovarsky (miroslav.pivovarsky@gmail.com)
# The script is provided as-is without any warranty.
# The script is free to use and modify.
# Version: 1.0
#
# The script builds the firmware for the following boards:
# 1. Ai Thinker ESP32-CAM
# 2. ESP32 Wrover Dev
# 3. ESP32-S3-EYE 2.2
#
# The script compiles the firmware for each board and creates a zip file with the compiled firmware.
# The zip file contains the firmware binary and other files generated during the compilation.
#
# The script uses the arduino-cli tool to compile the firmware.
# The arduino-cli tool must be installed before running this script.
#
# The script assumes the following directory structure:
# ESP32_PrusaConnectCam/
# ├── arduino-cli
# ├── ESP32_PrusaConnectCam.ino
# ├── mcu_cfg.h
# ├── ...
# ├── libraries/
# │   ├── zip/
# │   │   ├── AsyncTCP-3.1.4.zip
# │   │   └── ESPAsyncWebServer-2.10.8.zip
# ├── build/
# │   ├── output/
# │   ├── esp32-cam/
# │   ├── esp32-wrover-dev/
# │   └── esp32-s3-eye-22/
#
# The script creates the following files:
# build/
# ├── output/
# │   ├── ESP32_PrusaConnectCam.ino.bin
# │   ├── ESP32_WROVERDEV_PrusaConnectCam.ino.bin
# │   ├── ESP32S3_EYE22_PrusaConnectCam.ino.bin
# |   ├── esp32-cam.zip
# |   ├── esp32-wrover-dev.zip
# |   ├── esp32-s3-eye-22.zip
#
# The script assumes the following libraries are installed:
# 1. ArduinoJson
# 2. ArduinoUniqueID
# 3. AsyncTCP-3.1.4
# 4. ESPAsyncWebServer-2.10.8
#
# The script assumes the ESP32 core is installed:
# 1. esp32:esp32

# ---------------------------------------------
# Setup Instructions:
# Before running this script, ensure the following steps have been completed:
# 1. Download arduino-cli:
#    wget https://github.com/arduino/arduino-cli/releases/download/v1.0.1/arduino-cli_1.0.1_Linux_64bit.tar.gz
# 2. Extract the downloaded archive:
#    tar -zxvf arduino-cli_1.0.1_Linux_64bit.tar.gz
# 3. Install pip3:
#    sudo apt-get install pip3
# 4. Install pyserial using pip3:
#    pip3 install pyserial
#
# 5. Initialize arduino-cli configuration:
#    ./arduino-cli config init
# 6. Edit the arduino-cli.yaml configuration file (e.g., using nano):
#    nano /home/miro/.arduino15/arduino-cli.yaml
#    Add the following lines:
#    board_manager:
#      additional_urls:
#        - https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json
#    library:
#      enable_unsafe_install: true
#
# 7. Check installed libraries:
#    ./arduino-cli lib list
# 8. Install necessary libraries:
#    ./arduino-cli lib install ArduinoJson
#    ./arduino-cli lib install ArduinoUniqueID
#    ./arduino-cli lib install --zip-path ../libraries/zip/AsyncTCP-3.1.4.zip
#    ./arduino-cli lib install --zip-path ../libraries/zip/ESPAsyncWebServer-2.10.8.zip
#    Check installed libraries again:
#    ./arduino-cli lib list
#
# 9. Install the ESP32 core:
#    ./arduino-cli core install esp32:esp32

# ---------------------------------------------
cd ESP32_PrusaConnectCam
mkdir -p ../build/output
build_start=`date`

# ----------------- ESP32-CAM -----------------
# enable and build Ai Thinker board
echo "----------------------------------------------"
echo "Building Ai Thinker board"
mkdir -p ../build/esp32-cam
sed -i 's/#define \(AI_THINKER_ESP32_CAM\|ESP32_WROVER_DEV\|CAMERA_MODEL_ESP32_S3_DEV_CAM\|CAMERA_MODEL_ESP32_S3_EYE_2_2\|CAMERA_MODEL_XIAO_ESP32_S3_CAM\|CAMERA_MODEL_ESP32_S3_CAM\) .*/#define \1 false/' mcu_cfg.h && sed -i 's/#define AI_THINKER_ESP32_CAM false/#define AI_THINKER_ESP32_CAM true/' mcu_cfg.h
./arduino-cli compile -v -b esp32:esp32:esp32cam:CPUFreq=240,FlashFreq=80,FlashMode=dio,PartitionScheme=min_spiffs,DebugLevel=none,EraseFlash=none  --output-dir ../build/esp32-cam

rm -f ../build/esp32-cam/ESP32_PrusaConnectCam.ino.elf
rm -f ../build/esp32-cam/ESP32_PrusaConnectCam.ino.map
rm -f ../build/esp32-cam/ESP32_PrusaConnectCam.ino.merged.bin
cp ../build/esp32-cam/ESP32_PrusaConnectCam.ino.bin ../build/output/ESP32_PrusaConnectCam.ino.bin

cd ../build/esp32-cam && zip -r ../esp32-cam.zip . && cd -
mv ../build/esp32-cam.zip ../build/output/

# ----------------- ESP32-WROVER-DEV -----------------
# enable and build ESP32 Wrover Dev board
echo "----------------------------------------------"
echo "Building ESP32 Wrover Dev board"
mkdir ../build/esp32-wrover-dev
sed -i 's/#define \(AI_THINKER_ESP32_CAM\|ESP32_WROVER_DEV\|CAMERA_MODEL_ESP32_S3_DEV_CAM\|CAMERA_MODEL_ESP32_S3_EYE_2_2\|CAMERA_MODEL_XIAO_ESP32_S3_CAM\|CAMERA_MODEL_ESP32_S3_CAM\) .*/#define \1 false/' mcu_cfg.h && sed -i 's/#define ESP32_WROVER_DEV false/#define ESP32_WROVER_DEV true/' mcu_cfg.h
./arduino-cli compile -v -b esp32:esp32:esp32wrover:FlashFreq=80,FlashMode=dio,PartitionScheme=min_spiffs,DebugLevel=none,EraseFlash=none --output-dir ../build/esp32-wrover-dev

rm -f ../build/esp32-wrover-dev/ESP32_PrusaConnectCam.ino.elf
rm -f ../build/esp32-wrover-dev/ESP32_PrusaConnectCam.ino.map
rm -f ../build/esp32-wrover-dev/ESP32_PrusaConnectCam.ino.merged.bin
cp ../build/esp32-wrover-dev/ESP32_PrusaConnectCam.ino.bin ../build/output/ESP32_WROVERDEV.bin

cd ../build/esp32-wrover-dev && zip -r ../esp32-wrover-dev.zip . && cd -
mv ../build/esp32-wrover-dev.zip ../build/output/

# ----------------- ESP32-S3-CAM EYE 2.2 -----------------
# build ESP32-S3-EYE 2.2 board
echo "----------------------------------------------"
echo "Building ESP32-S3-EYE 2.2 board"
mkdir ../build/esp32-s3-eye-22
sed -i 's/#define \(AI_THINKER_ESP32_CAM\|ESP32_WROVER_DEV\|CAMERA_MODEL_ESP32_S3_DEV_CAM\|CAMERA_MODEL_ESP32_S3_EYE_2_2\|CAMERA_MODEL_XIAO_ESP32_S3_CAM\|CAMERA_MODEL_ESP32_S3_CAM\) .*/#define \1 false/' mcu_cfg.h && sed -i 's/#define CAMERA_MODEL_ESP32_S3_EYE_2_2 false/#define CAMERA_MODEL_ESP32_S3_EYE_2_2 true/' mcu_cfg.h

./arduino-cli compile -v -b esp32:esp32:esp32s3:USBMode=hwcdc,CDCOnBoot=cdc,MSCOnBoot=default,DFUOnBoot=default,UploadMode=cdc,CPUFreq=240,FlashMode=dio,FlashSize=8M,PartitionScheme=min_spiffs,DebugLevel=none,PSRAM=opi,LoopCore=0,EventsCore=0,EraseFlash=none,JTAGAdapter=default,ZigbeeMode=default --output-dir ../build/esp32-s3-eye-22

rm -f ../build/esp32-s3-eye-22/ESP32_PrusaConnectCam.ino.elf
rm -f ../build/esp32-s3-eye-22/ESP32_PrusaConnectCam.ino.map
rm -f ../build/esp32-s3-eye-22/ESP32_PrusaConnectCam.ino.merged.bin
cp ../build/esp32-s3-eye-22/ESP32_PrusaConnectCam.ino.bin ../build/output/ESP32S3_EYE22.bin

cd ../build/esp32-s3-eye-22 && zip -r ../esp32-s3-eye-22.zip . && cd -
mv ../build/esp32-s3-eye-22.zip ../build/output/

# --------------------------------------------------------
echo "----------------------------------------------"
echo "Build completed. Output files are in the output folder."
echo "Start build: $build_start"
echo "End build: `date`"

exit 0

# EOF