#!/bin/bash
# backup_sp530e.sh
BACKUP_DIR="sp530e_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Copy custom files
cp platformio.ini "$BACKUP_DIR/"
cp wled00/usermods_list.cpp "$BACKUP_DIR/"
cp wled00/const.h "$BACKUP_DIR/"
cp -r usermods/wifi_status_led "$BACKUP_DIR/"
cp -r usermods/boot_status_led "$BACKUP_DIR/"
cp tools/WLED_ESP32C3_4MB_audioreactive.csv "$BACKUP_DIR/" 2>/dev/null || true

# Copy built firmware
cp build_output/release/WLED_*_SP530E-JW.bin "$BACKUP_DIR/" 2>/dev/null || true

echo "SP530E backup created in: $BACKUP_DIR"