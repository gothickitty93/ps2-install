# PS2 Install Script

This script allows you to install PS2 games to your PS2 over the network using the `hdl_dump` command. It supports both disk images and physical discs.

## Prerequisites

- `hdl_dump` must be installed and accessible.
- The script is built for macOS, however most Linux should also work if you change some commands around (untested).

## Usage

```sh
sudo ./ps2-install.sh <PS2_IP> <image|disc> <path_to_image_or_device>
```

- `<PS2_IP>`: The IP address of your PS2.
- `<image|disc>`: Specify `image` if you are using a disk image (e.g., ISO file), or `disc` if you are using a physical disc.
- `<path_to_image_or_device>`: The path to the disk image or the device representing the physical disc.

### Examples

- To install a game from an ISO image:

  ```sh
  sudo ./ps2-install.sh 192.168.0.83 image /path/to/game.iso
  ```

- To install a game from a physical disc:

  ```sh
  sudo ./ps2-install.sh 192.168.0.83 disc /dev/rdisk4
  ```

## Installation

1. Download the script and save it as `ps2-install.sh`.

2. Make the script executable:

   ```sh
   chmod +x ps2-install.sh
   ```

3. Edit the script to specify the full paths to the necessary commands. Use the `which` command to find these paths. For example:

   ```sh
   which basename
   which sed
   which hdl_dump
   which diskutil
   which grep
   which awk
   ```
  (If you are using Linux, you will need to substitute some of the macOS-only commands with their equivalants)
  
   Update the script with the paths as needed:

   ```sh
   BASENAME_CMD="/path/to/basename"
   SED_CMD="/path/to/sed"
   HDL_DUMP_CMD="/path/to/hdl_dump"
   DISKUTIL_CMD="/path/to/diskutil"
   GREP_CMD="/path/to/grep"
   AWK_CMD="/path/to/awk"
   ```

4. Run the script with the appropriate arguments as shown in the usage examples.

## Notes

- The script must be run with `sudo` to have the necessary permissions.
- Ensure that the `hdl_dump` command is installed and properly configured on your system.
- The script determines the game name by extracting it from the file name (for images) or the volume name (for discs).
- The script will automatically determine if a physical disc is a CD or DVD and use the appropriate `hdl_dump` command.

## Troubleshooting

- If you encounter a "command not found" error, ensure that the full paths to the commands are correctly specified in the script.
- If the script fails to determine the disc type, verify that the disc is properly inserted and recognized by the system.
