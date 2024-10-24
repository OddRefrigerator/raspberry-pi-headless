# Raspberry Pi Headless Setup

This repository contains scripts and instructions for setting up a Raspberry Pi for headless operation, allowing you to manage it remotely without the need for a monitor, keyboard, or mouse.

## Features

- **Headless Configuration:** Quickly configure your Raspberry Pi to run without a display or input devices.
- **SSH Access:** Enables SSH access out of the box for remote management.
- **Wi-Fi Setup:** Allows configuration of Wi-Fi settings during the initial setup.
- **Customizable Settings:** Easily customize configurations for various use cases.

## Requirements

- A Raspberry Pi (any model that supports headless operation).
- A microSD card (with Raspberry Pi OS installed).
- A computer to prepare the microSD card and modify configuration files.
- Basic knowledge of the command line.

## Installation

### Step 1: Download Raspberry Pi OS

1. Download the latest version of Raspberry Pi OS from the [official Raspberry Pi website](https://www.raspberrypi.com/software/).
2. Use a tool like [balenaEtcher](https://www.balena.io/etcher/) to write the OS image to your microSD card.

### Step 2: Enable SSH

1. After writing the OS image, access the boot partition of the microSD card.
2. Create an empty file named `ssh` (with no file extension) in the root directory of the boot partition. This enables SSH on boot.

### Step 3: Configure Wi-Fi

1. Create a file named `wpa_supplicant.conf` in the boot partition with the following content:

   ```plaintext
   country=US
   ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
   update_config=1

   network={
       ssid="Your_WiFi_Network_Name"
       psk="Your_WiFi_Password"
       key_mgmt=WPA-PSK
   }
   ```

   Replace `Your_WiFi_Network_Name` and `Your_WiFi_Password` with your actual Wi-Fi credentials.

### Step 4: Boot Your Raspberry Pi

1. Insert the microSD card into the Raspberry Pi.
2. Power on the Raspberry Pi. It should connect to the Wi-Fi network automatically and enable SSH.

### Step 5: Connect via SSH

1. Use an SSH client to connect to your Raspberry Pi:

   ```bash
   ssh pi@<Your_Raspberry_Pi_IP_Address>
   ```

   The default password is `raspberry`.

## Usage

Once connected via SSH, you can begin using your Raspberry Pi for various projects. Update your system and install any necessary packages as needed:

```bash
sudo apt update
sudo apt upgrade
```

## Custom Scripts

This repository may include custom scripts for further configurations or setups. Review the scripts in the repository to see their functionalities.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! If you have improvements, suggestions, or bug fixes, feel free to submit an issue or open a pull request.

### Steps for Contribution

1. Fork the repository.
2. Create a new branch for your feature or fix:
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes:
   ```bash
   git commit -m "Description of your feature or fix"
   ```
4. Push your branch:
   ```bash
   git push origin feature-name
   ```
5. Open a pull request with a detailed explanation of your changes.

## Author

This project was created by [OddRefrigerator](https://github.com/OddRefrigerator).

## Contact

For any inquiries or issues, feel free to open an issue on GitHub or contact the repository owner.
