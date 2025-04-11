# Arch Setup

## 1. Initial setup
### 1. Set up your keyboard

Display keymap options for the keyboard

    localectl list-keymaps 

Example keyboard languages:

| Command | Language |
| - | - |
| us | US English |
| uk | UK English |
| se-lat6 | Swedish |
| de-latin1 | German |

    loadkeys se-lat6


### 2. Increase font-size if needed.


    setfont ter-132b

### 3. Verify Boot mode.

    cat /sys/firmware/efi/fw_platform_size

| Output         | Mode        |
|----------------|-------------|
| 64             | 64 bit UEFI |
| 32             | 32 bit UEFI |
| File not found | BIOS        |
If you have BIOS this guide can not help you. 

### 4. Connect to the internet
Check if your [network interface]() is listed and enabled.


    ip link

Plug in your ethernet cable or set up your wifi using [iwctl](https://wiki.archlinux.org/title/Iwd#iwctl).

Test your connection.

    ping 8.8.8.8        

 Press `CTRL+C` to stop the ping. 

### 5. Update system clock
    timedatectl
    timedatectl list-timezone
    timedatectl set-timezone

Example:

    timedatectl set-timezone Europe/Amsterdam

## 2. Partitioning
### 1. List your disks
Choose one that is empty or one that can be wiped.  
The name will usually be sdX or nvmeXnX where X can vary. 

    lsblk

This is my 2TB SSD which I partitioned into 4 parts. 

The name of my disk is nvme0n1

| Disk name | Size  | Code | Type |
|-----------|-------|------|------|
| nvme0n1p1 | 512mb | EF00 | boot |
| nvme0n1p2 | 16GB  | 8200 | swap |
| nvme0n1p3 | 50GB  | 8300 | root |
| nvme0n1p4 | 1.8T  | 8300 | home |


    nvme0n1     259:6    0   1.8T  0 disk 
    ├─nvme0n1p1 259:7    0   512M  0 part /boot
    ├─nvme0n1p2 259:8    0    16G  0 part [SWAP]
    ├─nvme0n1p3 259:9    0    50G  0 part /
    └─nvme0n1p4 259:10   0   1.8T  0 part /home

**EFI boot**  
I use a combined partition for EFI and boot. Recommended size is 500MB-2GB.
512MB is usually enough unless you plan on having a complex bootloader setup or multiple kernels. 
If you prefer to separate them the recommended size for EFI is 100MB-512MB,
and the recommended for boot would be 500MB-2GB. 

**swap**  
swap works as extra RAM when your RAM is full or stores everything from your RAM during hibernation. 
Recommended size is 2x your RAM, but I settled for the same size as my RAM. 

**root**  
root is where you will store your important linux and system files. 
Recommended size is 25GB-50GB.
Mine has reached 33GB in the past but after cleaning unnecessary files stays around 20GB.
I enjoy having 50GB to be on the safer side but this is up to personal preference. 
40GB is probably more than enough. 

### 2. Partition the disk
You can choose to partition them manually using `fdisk` or using the interactive partitioning tool `cgdisk`.

Replace nvme0n1 with your disk name. 

#### Option 1: Manually `fdisk`

    fdisk /dev/nvme0n1      

    p                # Print current partition table (Check if empty)
    g                # Create a new GPT partition table (wipes your disk)
    p                # Print again to confirm it's empty now

1. EFI boot partition (nvme0n1p1)

        n                # Create new partition
        enter            # Partition number (default: 1)
        enter            # First sector (default)
        +512M            # Size of EFI partition
        t                # Change partition type
        1                # Select partition 1
        EF00             # EFI System Partition type

2. SWAP partition (nvme0n1p2)

        n                # New partition: Swap (sdX2)
        enter            # Partition number (default: 2)
        enter            # First sector (default)
        +16G             # Size of swap partition
        t                # Change partition type
        2                # Select partition 2
        8200             # Linux swap

3. Root partition (nvme0n1p3)

        n                # New partition: Root (sdX3)
        enter            # Partition number (default: 3)
        enter            # First sector (default)
        +50G             # Size of root partition

    You don't strictly need to select type for root since the default linux filesystem (8300) works just fine. 
    But if you would like you can change it to Linux root instead.

        t                # Change partition type
        3                # Select partition 3
        23               # Set type to "Linux root (x86-64)"

4. Home partition (nvme0n1p4)

        n                # New partition: Home (sdX4)
        enter            # Partition number (default: 4)
        enter            # First sector (default)
        enter            # Last sector (use rest of the disk)

    For Home the default type is recommended and is automatically set to linux filesystem (8300).


5. Confirm changes:
    
        p                # Print final partition table to verify if everything is correct.
        w                # Write changes to disk and exit, there is no return after this. 
    

#### Option 2: Interactive `cgdisk`

    gdisk /dev/nvme0n1
    x                       # Enter expert mode
    z                       # Zap (destroy) GPT and MBR data structures
    y                       # Confirm zap
    y                       # Confirm blank MBR

Launch the interactive GPT partitioning tool

    cgdisk /dev/nvme0n1

1. EFI boot partition (nvme0n1p1)

        New       # Create new partition
        Enter     # First sector (default)
        512MiB    # Size
        EF00      # EFI System (EF00)
        boot      # Name (optional)
2. SWAP partition (nvme0n1p2)

        New       # Create new partition
        Enter     # First sector (default)
        16GiB     # Size
        8200      # Linux swap (8200)
        swap      # Name (optional)
3. Root partition (nvme0n1p3)

        New       # Create new partition
        Enter     # First sector (default)
        50GiB     # Size
        Enter     # Default (8300) or 23 for Linux root (x86-64)
        root      # Name (optional)
4. Home partition (nvme0n1p4)

        New       # Create new partition
        Enter     # First sector (default)
        Enter     # Size (use remaining space)
        Enter     # Default (8300)
        home      # Name (optional)

5. Confirm changes

        Write     # Save the partition table, 
        yes       # Confirm write, no return after this.
        Quit      # Exit cgdisk


### 3. Format partitions

    mkfs.fat -F32 /dev/nvme0n1p1  # Format EFI partition as FAT32 (required for UEFI boot)
    mkswap /dev/nvme0n1p2         # Initialize swap partition
    mkfs.ext4 /dev/nvme0n1p3      # Format root partition as ext4
    mkfs.ext4 /dev/nvme0n1p4      # Format home partition as ext4

### 4. Mount partitions

    mount /dev/nvme0n1p3 /mnt               # First mount root to /mnt 
    mount --mkdir /dev/nvme0n1p4 /mnt/home  # Make and mount Home to /mnt/home
    mount --mkdir /dev/nvme0n1p1 /mnt/boot  # Make and mount EFI boot to /mnt/boot
    swapon /dev/sdX2                        # Enable SWAP

## 3. Installation
### 1. Select mirrors
1. Show mirror-list

        cat /etc/pacman.d/mirrorlist 

2. Install reflector

        sudo pacman -Sy pacman-contrib

3. Sort the 10 fastest mirrors and save it to your mirrorlist directly:

        sudo reflector --latest 10 --sort rate --save /etc/pacman.d/mirrorlist
    Note: You can also change the number to 5 or 6 depending on how many you want. 
    
    Optionally add your country or multiple countries to limit your mirror selection to those.  
    
    Use `reflector --list-countries` to see which countries are available. 
    
    Example:

        sudo reflector --latest 6 --sort rate --country 'Netherlands' --country 'Germany' --save /etc/pacman.d/mirrorlist
4. Print to see if they have been updated and look satisfactory.

        cat /etc/pacman.d/mirrorlist 

### 2. Install the system and essential packages (pre-configuration)
Depending on your CPU, install `intel-ucode` for Intel CPU or `amd-ucode` for AMD. 
Depending on your preferred text editor, install `nano`, `vim` or `vi` for example. 

    pacstrap -K /mnt base base-devel linux linux-firmware intel-ucode nano

### 3. fstab
After installing the base system, generate the filesystem table `/etc/fstab`, 
which tells the system how to mount the partitions at boot. 
        
    genfstab -U -p /mnt >> /mnt/etc/fstab
        nano /mnt/etc/fstab                     # to view, ctrl+x to exit

## 4. Configure the system
### 1. Chroot
Now that Arch is installed, enter your new system to configure it. This changes /mnt to be the new root /.

    arch-chroot /mnt
 
### 2. Time
#### 1. Set your timezone:
You have two options, I find the older way easier using `ln -sf`.  
You can press `tab` to show a list of your options after /zoneinfo/ and /region/

    ln -sf /usr/share/zoneinfo/region/city /etc/localtime

Here is my example: 

    ln -sf /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime

You can also choose to use `timedatectl` as previously.

    timedatectl list-timezones
    timedatectl set-timezone Europe/Amsterdam

#### 2. Synchronize your system clock 
Running this command will to generate /etc/adjtime and store your adjustments. 

    hwclock --systohc

### 3. Edit localization
Set your preferred languages and keyboard layout. 
I prefer to keep the language as English and the Keyboard as Swedish. 

        nano /etc/locale.gen        # Uncomment en_US.UTF-8 UTF-8 and other desired UTF-8 locales.
        locale-gen                  # Generate the selected locales.
        nano /etc/locale.conf       # Create locale.conf, add LANG=en_US.UTF-8 or your preferred language.
        nano /etc/vconsole.conf     # Add KEYMAP=se-lat6 for Swedish or KEYMAP= your preferred Keyboard layout. 

### 4. Hostname and users
Enter your desired hostname in the following: 

    nano /etc/hostname      

Set root password
        
    passwd

Create user:

    useradd -m -g users -G wheel user_name    # Create a user (replace "user_name").
    passwd user_name                          # Set a password for the new user.

Optionally you can also add more advanced details such as:

    useradd -m -g users -G wheel.storage.power -s /bin/bash user_name
    passwd user_name

`-m` creates a home directory for the user such as /home/user_name.  
`-g users` sets the primary group for this user as "users".  
`-G wheel.storage.power` adds secondary groups (`wheel`, `storage`, `power`) to the user.  
`-s /bin/bash` sets the default shell, you can also use `/bin/zsh`.  

Edit permissions: 

    EDITOR=nano visudo /etc/sudoers     # Untag wheel members to give them sudo permission

## 5. Check video card
### 1. Identify your GPU
You can use `lspci` and search for VGA or just directly type in: 

    lspci | grep -i vga

Depending on what driver you have you will need different packages. 

### Intel:  
**Normal setup**  
Suitable for gaming or heavy GPU usage.

    sudo pacman -S mesa intel-media-driver vulkan-intel lib32-vulkan-intel
**Minimalist setup**

    sudo pacman -S mesa intel-media-driver 
**x11 additional package**  
Only necessary if you're using Xorg (X11). Wayland already includes this through the modesetting driver.

    sudo pacman -S xf86-video-intel  

### NVIDIA:
**Normal setup**  
Suitable for gaming or heavy GPU usage.

    sudo pacman -S nvidia nvidia-utils nvidia-settings vulkan-driver lib32-nvidia-utils

**Minimalist setup**

    sudo pacman -S nvidia nvidia-utils nvidia-settings

### AMD:
**Normal setup**  
Suitable for gaming or heavy GPU usage.

    sudo pacman -S mesa vulkan-radeon lib32-vulkan-radeon

**Minimalist setup**

    sudo pacman -S mesa

**x11 additional package**  
Only necessary if you're using Xorg (X11). Wayland already includes this through the modesetting driver.

    sudo pacman -S xf86-video-amdgpu


## 6. Install additional packages
Previously installed: `base base-devel linux linux-firmware intel-ucode nano`

Examples of packages I installed:

        sudo pacman -S nvidia nvidia-utils vulkan-driver nvidia-settings lib32-nvidia-utils
        sudo pacman -S grub efibootmgr dosftools os-prober networkmanager git sudo openssh
        sudo pacman -S hyprland wayland xorg-xwayland wlroots
        sudo pacman -S lightdm lightdm-gtk-greeter
        sudo pacman -S pipewire pipewire-pulse wireplumber
        sudo pacman -S hyprpaper hyprlock swaync waybar rofi grim slurp kitty pcmanfm ranger
        sudo pacman -S ttf-dejavu ttf-liberation noto-fonts noto-fonts-emoji ttf-jetbrains-mono ttf-font-awesome

Initialize grub or your preferred boot loader:

        grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
        grub-mkconfig -o /boot/grub/grub.cfg

Enable some essentials: 

        systemctl enable sshd
        systemctl enable lightdm
        systemctl enable NetworkManager
        systemctl enable pipewire
        systemctl enable wireplumber


Additionally you can enable multilib for 32 bit gaming, go to:

    sudo nano /etc/pacman.conf

Uncomment the following:

    # [multilib]
    # Include = /etc/pacman.d/mirrorlist

## Here is a list of all packages I use:

### System and Base Packages

       base                     # Base package group for minimal installation
       base-devel               # Development tools for building packages
       linux                    # Linux kernel
       linux-firmware           # Firmware for supported hardware
       grub                     # GRUB bootloader
       efibootmgr               # EFI boot manager
       os-prober                # Detect other operating systems for dual-boot setups
       pacman-contrib           # Utilities for pacman
       nano                     # Simple text editor
       git                      # Version control system
       zsh                      # Z shell (alternative shell to bash)
       yay                      # AUR helper for managing Arch User Repository (AUR)
       yay-debug                # Debug version of yay AUR helper
    
### Fonts

       noto-fonts               # Noto fonts collection for better language support
       noto-fonts-cjk           # Noto fonts for CJK (Chinese, Japanese, Korean)
       ttf-font-awesome         # Font Awesome (icon font)
       ttf-jetbrains-mono       # JetBrains Mono font (designed for coding)
       ttf-jetbrains-mono-nerd  # JetBrains Mono with Nerd Font patches
       wqy-zenhei               # WenQuanYi Zen Hei (Chinese font)
    
### Desktop Environment and Window Manager

       hyprland                 # Hyprland Wayland compositor
       hyprpaper                # Wallpaper setter for Hyprland
       hyprlock                 # Screen lock for Hyprland
       hyprshot                 # Screenshot tool for Hyprland
       hyprpicker               # Color picker tool for Hyprland
       hypridle                 # Idle detection for Hyprland
       waybar                   # Wayland status bar (for Wayland compositors)
       wlroots                  # Low-level Wayland compositor library
       lightdm                  # Display manager (login screen)
       lightdm-gtk-greeter      # GTK-based greeter for LightDM
    
### System Utilities and Configuration

       pipewire                 # Multimedia framework for audio and video
       pipewire-pulse           # PulseAudio replacement with PipeWire
       wireplumber              # Session manager for PipeWire
       networkmanager           # Network manager for managing network connections
       openssh                  # SSH server for remote access
       stow                     # Manage dotfiles with symlinks
       reflector                # Mirror list generator for pacman
       systemd                  # System and service manager
    
### Text Editors and IDEs

       nano                     # Simple text editor
       pycharm-community-edition # JetBrains PyCharm (Python IDE)
       vim                      # Vi IMproved (text editor)
       neovim                   # Neovim (modern Vim alternative)
    
### Multimedia and Media Players

       discord                  # Discord (communication platform)
       spotify                  # Spotify (music streaming service)
       obs-studio               # Open Broadcaster Software (video recording/streaming)
       steam                    # Steam (gaming platform)
       megacmd                  # MEGA command-line interface
       spotube                  # YouTube client for Spotify
       microsoft-edge-stable-bin # Microsoft Edge browser (stable version)
       minecraft-launcher       # Minecraft game launcher
       lib32-steam
    
### Networking Tools

       neofetch                 # System information tool
       wget                     # Non-interactive network downloader
       pcmanfm-gtk3             # PCManFM (lightweight file manager)
       rofi                     # Window switcher and application launcher
       thunar                   # Thunar file manager (lightweight)
       xpad                     # Xbox gamepad driver
    
### Fonts and Text Rendering

       ttf-font-awesome         # Font Awesome (icon font)
       ttf-jetbrains-mono       # JetBrains Mono font
       ttf-jetbrains-mono-nerd  # JetBrains Mono with Nerd Font patches
    
### Miscellaneous Utilities and Tools

       bashtop                  # Resource monitor for terminal (bash)
       ranger                   # Terminal file manager
       kitty                    # Terminal emulator
       stow                     # Symlink manager for dotfiles
       wev                      # Wayland event viewer
       rofi                     # Window switcher and application launcher
       pcmanfm-gtk3             # PCManFM (GTK3 version)
       notion-app-electron      # Notion (note-taking and organization app)
       nvidia                   # NVIDIA drivers
       nvidia-utils             # NVIDIA utilities and libraries
    
### File System and Storage

       ntfs-3g                  # NTFS read/write support
       libmp4v2                 # Library for handling MP4 files
       os-prober                # Detect other operating systems for dual-boot setups
    
### Display and Graphics

       grub-customizer          # Customizer for GRUB bootloader
       grub                     # GRUB bootloader
       xorg-xwayland            # XWayland (X11 compatibility layer for Wayland)
       xorg-xhost               # X server host control
       intel-ucode              # Microcode updates for Intel CPUs


## 7. Final steps
### 1. Optionally update and clean some files.
`-Syu` → Sync and update all packages from official repositories.

`-Rns $(pacman -Qdtq)` → Remove orphaned packages.

`-Sc` → Clean the package cache. Keeps only the latest versions of installed packages.

    sudo pacman -Syu && sudo pacman -Rns $(pacman -Qdtq) && sudo pacman -Sc

If you installed yay in the previous step you can use this command instead:

     yay -Syu && yay -Yc && yay -Sc


### 2. Exit Chroot environment
Exit the chroot environment by typing exit or pressing Ctrl+D. 

    exit 
Lastly reboot and login. Done.

    reboot
