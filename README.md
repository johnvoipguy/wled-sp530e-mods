# 🎯 WLED for SP530E Controllers (ESP32-C3 Modified Hardware)

[![Build SP530E Binaries](https://github.com/johnvoipguy/wled-sp530e-mods/actions/workflows/build-sp530e.yml/badge.svg)](https://github.com/johnvoipguy/wled-sp530e-mods/actions/workflows/build-sp530e.yml)

## 🚨 **WLED for SP530E Controllers** 🚨

**This repository contains WLED modifications specifically optimized for SP530E LED controllers with ESP32-C3 chips.** 

⚠️ **CAUTION: Requires modification by soldering connections to use UART for flashing this firmware** ⚠️

---

## 📥 **Quick Download**

**Need firmware for your modified SP530E?** 

👉 **[📁 Easy Download - builds/latest/](./builds/latest/)** 👈

**Ready-to-flash firmware** (no hunting through artifacts!):
- **[WLED_SP530E_Full_Latest.bin](./builds/latest/WLED_SP530E_Full_Latest.bin)** - Complete firmware (UART flash)  
- **[WLED_SP530E_App_Latest.bin](./builds/latest/WLED_SP530E_App_Latest.bin)** - OTA updates only

📦 **[All builds and versions →](./builds/)**

## ⚠️ Important Notice

Here are some brief instructions for soldering the connections required to connect to a USB UART. I will add the pictures later.

## 🔧 Hardware Requirements

- **Stock SP530E LED Controller** (ESP32-C3 based)
- **UART access via soldering** for initial firmware flashing
- **Required modifications**:
  - Solder connections to UART pins (TX, RX, GND, 3.3V)
  - Access to GPIO9 for booting into boot mode for initial flashing.
  - No chip replacement needed - uses stock ESP32-C3

## 📋 Features

### Custom User Modules
- **Boot Status LED**: Visual indication of boot process and system status
- **WiFi Status LED**: Real-time WiFi connection status indicator
- **Audio Reactive**: Enhanced audio processing for ESP32-C3

### ESP32-C3 Optimizations
- **4MB Flash Support**: Optimized memory layout for ESP32-C3
- **GPIO Mapping**: Correct pin assignments for SP530E hardware
  - **On Board Button**: GPIO 8
  - **On Board Mic**: GPIO 3
  - **On Board Blue LED**: GPIO 0 (Inverted)
  - **On Board Green LED**: GPIO 1 (Inverted)
  - **LED Data Output**: GPIO 19
  - **Analog Pins**:
    - R: GPIO 10
    - G: GPIO 7
    - B: GPIO 6
    - WW: GPIO 5
    - CW: GPIO 4
- **Performance Tuning**: ESP32-C3 specific optimizations

## 🚀 Quick Start

### Option 1: Download Pre-built Binaries

1. Go to the [Releases](https://github.com/johnvoipguy/wled-sp530e-mods/releases) page
2. Download the latest `WLED_SP530E_Full_Latest.bin`
3. Flash using your preferred method (see [Flashing Instructions](#-flashing-instructions))

### Option 2: Download from Actions (Latest Builds)

1. Go to [Actions](https://github.com/johnvoipguy/wled-sp530e-mods/actions)
2. Click on the latest successful build
3. Download the appropriate artifact for your configuration

## 💾 Flashing Instructions

### UART Wiring for SP530E
You need to solder wires to these points on the SP530E board:
- **TX** → UART RX
- **RX** → UART TX  
- **GND** → UART GND
- **3.3V** → UART VCC (or use external 3.3V supply)
- $\color{blue}{GPIO9 → GND }$ **During power up!** (to enable access to bootloader for flashing)

<img src="https://github.com/johnvoipguy/wled-sp530e-mods/blob/sp530e-mods/images/back_no_wiring.jpg" width="324" height="324"> <img src="https://github.com/johnvoipguy/wled-sp530e-mods/blob/sp530e-mods/images/Front_lights.jpg" width="324" height="324">

<img src="https://github.com/johnvoipguy/wled-sp530e-mods/blob/sp530e-mods/images/back_wiring.jpg" width="250" height="250"> <img src="https://github.com/johnvoipguy/wled-sp530e-mods/blob/sp530e-mods/images/Back_wiring_2.jpg" width="250" height="250">
 
  **You'll know you did correctly, if after connecting power, and removing GPIO9 from GRND if there are no lights on the front**
  
<img src="https://github.com/johnvoipguy/wled-sp530e-mods/blob/sp530e-mods/images/HA_wled_dash_1.png" width="324" height="324">

### Prerequisites
- **ESPTool** or **ESP Flash Download Tool**
- **USB UART adapter** connected to SP530E as shown above

### Using ESPTool (Command Line)
```bash
# Install esptool if not already installed
pip install esptool

# Put SP530E in download mode (connect GPIO0 to GND during power-on)
# Flash the firmware via UART (replace COM_PORT with your UART adapter port)
esptool.py --chip esp32c3 --port COM_PORT write_flash 0x0000 WLED_SP530E_*.bin
```

### Using ESP Flash Download Tool (GUI)
1. Download [ESP Flash Download Tool](https://www.espressif.com/en/support/download/other-tools)
2. Select ESP32-C3
3. Load the `.bin` file at address `0x0000`
4. Connect and flash

### Over-The-Air (OTA) Updates
Once initially flashed via UART, **OTA updates are the preferred method** for firmware updates:

1. **Connect to your SP530E** via web interface
2. **Go to Settings** → Update  
3. **Upload new firmware** (.bin file from releases)
4. **Automatic reboot** with new firmware

**Note**: OTA updates only include the APP partition (not bootloader or partition table), making them faster and safer for routine updates.

## 🛠️ Configuration

### First Boot
1. After flashing, the SP530E will create a WiFi access point named `WLED-AP`
2. Connect to this network (password: `wled1234`)
3. Navigate to `http://4.3.2.1` in your browser
4. Complete the WiFi setup

### LED Configuration
- **Default GPIO**: Configured for modified SP530E pinout
- **LED Count**: Set according to your strip length
- **Color Order**: Typically GRB for most WS2812B strips

### Audio Reactive Setup
1. Go to Settings → Sound Reactive
2. Configure microphone input (GPIO settings pre-configured)
3. Adjust sensitivity and gain as needed

## 📁 Available Builds

### `sp530e` (Recommended)
- **Audio Reactive**: Full audio processing with microphone support
- **4MB Flash**: Extended features and effects  
- **SP530E Optimized**: Hardware-specific GPIO configuration
- **Performance Tuned**: Optimized for ESP32-C3 architecture

## 🔧 Development

### Building from Source
```bash
# Clone the repository
git clone https://github.com/johnvoipguy/wled-sp530e-mods.git
cd wled-sp530e-mods

# Install dependencies
npm install
pip install -r requirements.txt

# Build the firmware  
platformio run -e sp530e
```

### Custom Modifications
If you need to modify the configuration:
1. Edit `platformio.ini` for build settings
2. Modify user modules in `usermods/` directory
3. Update pin assignments in `wled00/const.h`

## 📚 Documentation

- [WLED Official Documentation](https://kno.wled.ge/)
- [ESP32-C3 Datasheet](https://www.espressif.com/sites/default/files/documentation/esp32-c3_datasheet_en.pdf)
- [SP530E Hardware Modification Guide](SP530E_UPGRADE_CHECKLIST.md)

## 🤝 Support

### Hardware Issues
- Ensure all hardware modifications are completed correctly
- Verify ESP32-C3 chip installation and connections
- Check power supply specifications

### Software Issues  
- Check [Issues](https://github.com/johnvoipguy/wled-sp530e-mods/issues) for known problems
- Create a new issue with detailed description and logs
- Include hardware modification details

### Community
- Join the [WLED Discord](https://discord.gg/KuqP7NE) for community support
- Visit [WLED Community](https://github.com/Aircoookie/WLED/discussions)

## 📄 License

This project maintains the same license as WLED. See the original [WLED LICENSE](LICENSE) for details.

## 🙏 Acknowledgments

- **Aircoookie** and the WLED team for the amazing base firmware
- **ESP32-C3 community** for development resources and support  
- **SP530E modders** who made the hardware modifications possible

## ⚡ Changelog

See [CHANGELOG.md](CHANGELOG.md) for detailed version history and updates.

---
