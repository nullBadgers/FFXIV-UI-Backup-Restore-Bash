# FFXIV Backup and Restore

A bash script for KDE Plasma on CachyOS. The script backs up and restores the FFXIV XIVLauncher config folder (`ffxivConfig`).

## What the script does

- Backup: creates a timestamped archive of `~/.xlcore/ffxivConfig` in `~/Documents/BACKUP_TO_ONLINE`. The archive name follows the format `ffxivConfig_YYYYMMDD_HHMMSS.tar.gz`.
- Restore: extracts the newest archive back into `~/.xlcore`. Before extracting, the script renames your current `ffxivConfig` folder to `ffxivConfig_pre_restore_YYYYMMDD_HHMMSS`, so no files get overwritten.

Both actions send a desktop notification with the result.

## Requirements

- bash
- tar
- kdialog (included with KDE Plasma)
- notify-send (from libnotify)

Install kdialog if your system lacks the package:

```
sudo pacman -S kdialog
```

## Installation

```
git clone <your-repo-url>
cd <your-repo-folder>
chmod +x ffxiv_backup_restore.sh
```

## Configuration

Open the script and edit these two variables at the top to match your system:

```
BACKUP_DIR="/home/mojo/Documents/BACKUP_TO_ONLINE"
CONFIG_DIR="/home/mojo/.xlcore"
```

## Usage

### Menu mode

Run the script with no argument. A KDE dialog asks you to select Backup or Restore.

```
./ffxiv_backup_restore.sh
```

### Command line mode

Pass the action as an argument to skip the menu.

```
./ffxiv_backup_restore.sh backup
./ffxiv_backup_restore.sh restore
```

Restore asks for confirmation in a KDE dialog before the script changes any files.

## Launch without a terminal

Create the file `~/.local/share/applications/ffxiv-backup-restore.desktop` with this content:

```
[Desktop Entry]
Type=Application
Name=FFXIV Backup and Restore
Exec=/home/mojo/ffxiv_backup_restore.sh
Icon=document-save
Terminal=false
Categories=Utility;
```

Search for "FFXIV Backup and Restore" in the application launcher. Right-click the entry to add the launcher to your panel or desktop.

## Notes

- Close FFXIV before you restore.
- The script picks the newest backup by the timestamp in the file name.
- Old `ffxivConfig_pre_restore_*` folders stay in `~/.xlcore` until you delete them.