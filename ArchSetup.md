# Arch Setup

## 1. Initial setup
###  Set up your keyboard

Display keymap options for the keyboard:

    localectl list-keymaps 

Example keyboard languages:

| Command | Language |
| - | - |
| us | US English |
| uk | UK English |
| se-lat6 | Swedish |
| de-latin1 | German |

Set the desired keyboard layout:

    loadkeys se-lat6


### 1.2. Increase font-size if needed.


    setfont ter-132b

### 1.3. Verify Boot mode.

    cat /sys/firmware/efi/fw_platform_size

| Output         | Mode        |
|----------------|-------------|
| 64             | 64 bit UEFI |
| 32             | 32 bit UEFI |
| File not found | BIOS        |
If you have BIOS this guide can not help you. Refer to [this](https://wiki.archlinux.org/title/Partitioning#BIOS/MBR_layout_example) instead.

### 1.4. Connect to the internet
Check if your [network interface](https://wiki.archlinux.org/title/Network_configuration#Network_interfaces) is listed and enabled.


    ip link

Plug in your ethernet cable or set up your wifi using [iwctl](https://wiki.archlinux.org/title/Iwd#iwctl).

Test your connection.

    ping 8.8.8.8        

 Press `CTRL+C` to stop the ping. 

### 1.5. Update system clock
    timedatectl                  # Check current
    timedatectl list-timezone    # List available 
    timedatectl set-timezone     # Select your desired timezone

Example:

    timedatectl set-timezone Europe/Amsterdam

## 2. Partitioning
### 2.1. List your disks
Choose one that is empty or one that can be wiped.  
The name will usually be sdX or nvmeXnX where X can vary. 

    lsblk

This is my 2TB SSD which I partitioned into 4 parts. The name of my disk is **nvme0n1**:

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
512MB is usually enough unless you plan to have a complex bootloader setup or multiple kernels. 
If you prefer to separate them, the recommended size for EFI is 100MB-512MB,
and for boot, 500MB-2GB. 

**swap**  
Swap acts as extra RAM when your memory is full. 
It can also store all content from your RAM during hibernation.
The recommended size is 2x your RAM size, but I settled for the same size as my RAM. 

**root**  
Root is where you will store your essential Linux system files. 
Recommended size is 25GB-50GB.
Mine has reached 33GB in the past, but after cleaning unnecessary files, it stays around 20GB.
I like having 50GB to be on the safe side, although 40GB is probably more than enough. 

**home**  
Lastly I chose to have a separate Home directory where all my user data and files are stored. 
This takes up my remaining storage. 

### 2.2. Partition the disk
You can choose to use the partitioning tool `fdisk` or the interactive partitioning tool `cgdisk`.

Replace nvme0n1 with your disk name. 

#### Option 1: `fdisk`

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


### 2.3. Format partitions

    mkfs.fat -F32 /dev/nvme0n1p1  # Format EFI partition as FAT32 (required for UEFI boot)
    mkswap /dev/nvme0n1p2         # Initialize swap partition
    mkfs.ext4 /dev/nvme0n1p3      # Format root partition as ext4
    mkfs.ext4 /dev/nvme0n1p4      # Format home partition as ext4

### 2.4. Mount partitions

    mount /dev/nvme0n1p3 /mnt               # First mount root to /mnt 
    mount --mkdir /dev/nvme0n1p4 /mnt/home  # Make and mount Home to /mnt/home
    mount --mkdir /dev/nvme0n1p1 /mnt/boot  # Make and mount EFI boot to /mnt/boot
    swapon /dev/sdX2                        # Enable SWAP

## 3. Installation
### 3.1. Select mirrors
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

### 3.2. Install the system and essential packages (pre-configuration)
**Check what CPU you have using `lscpu`.**
   
      lscpu | grep -i "model name"

Depending on your CPU, install `intel-ucode` for Intel CPU or `amd-ucode` for AMD.

Depending on your preferred [text editor](https://itsfoss.com/command-line-text-editors-linux/), 
install `nano`, `vim` or `neovim` for example. 

    pacstrap -K /mnt base base-devel linux linux-firmware intel-ucode nano

### 3.3. fstab
After installing the base system, generate the filesystem table `/etc/fstab`, 
which tells the system how to mount the partitions at boot. 
        
    genfstab -U -p /mnt >> /mnt/etc/fstab
        nano /mnt/etc/fstab                     # to view, ctrl+x to exit

## 4. Configure the system
### 4.1. Chroot
Now that Arch is installed, enter your new system to configure it. This changes /mnt to be the new root /.

    arch-chroot /mnt
 
### 4.2. Time
#### 4.2.1. Set your timezone:
You have two options, I find the older way easier using `ln -sf`.  
You can press `tab` to show a list of your options after /zoneinfo/ and /region/

    ln -sf /usr/share/zoneinfo/region/city /etc/localtime

Here is my example: 

    ln -sf /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime

You can also choose to use `timedatectl` as previously.

    timedatectl list-timezones
    timedatectl set-timezone Europe/Amsterdam

#### 4.2.2. Synchronize your system clock 
Running this command will to generate /etc/adjtime and store your adjustments. 

    hwclock --systohc

### 4.3. Edit localization
Set your preferred languages and keyboard layout. 
I prefer to keep the language as English and the Keyboard as Swedish. 

        nano /etc/locale.gen        # Uncomment en_US.UTF-8 UTF-8 and other desired UTF-8 locales.
        locale-gen                  # Generate the selected locales.
        nano /etc/locale.conf       # Create locale.conf, add LANG=en_US.UTF-8 or your preferred language.
        nano /etc/vconsole.conf     # Add KEYMAP=se-lat6 for Swedish or KEYMAP= your preferred Keyboard layout. 

### 4.4. Hostname and users
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

Edit permissions, use this command if you prefer to use nano instead of its default editor: 

    EDITOR=nano visudo /etc/sudoers     # Untag wheel members to give them sudo permission

## 4.5. Check video card
### 4.5.1. Identify your GPU

You can use `lspci` and search for VGA or just directly type in: 

    lspci | grep -i vga

Look for if you have Intel, NVIDIA or AMD. 

Example:  
My output tells me I have NVIDIA. 

    01:00.0 VGA compatible controller: NVIDIA Corporation GA104 [GeForce RTX 3070] (rev a1)


### 4.5.2. Install packages 
Depending on what driver you have you will need different packages. 
If you have a hybrid you might want to consider a mix of packages.
There are also packages not listed here that can be used to swap between them. 
---
### Intel:  
**Normal setup**  
Suitable for gaming or heavy GPU usage.

    sudo pacman -S mesa intel-media-driver vulkan-intel lib32-vulkan-intel
**Minimalist setup**

    sudo pacman -S mesa intel-media-driver 
**x11 additional package**  
Only necessary if you're using Xorg (X11). Wayland already includes this through the modesetting driver.

    sudo pacman -S xf86-video-intel  
---
### NVIDIA:
**Normal setup**  
Suitable for gaming or heavy GPU usage.

    sudo pacman -S nvidia nvidia-utils nvidia-settings vulkan-driver lib32-nvidia-utils

**Minimalist setup**

    sudo pacman -S nvidia nvidia-utils nvidia-settings
---
### AMD:
**Normal setup**  
Suitable for gaming or heavy GPU usage.

    sudo pacman -S mesa vulkan-radeon lib32-vulkan-radeon

**Minimalist setup**

    sudo pacman -S mesa

**x11 additional package**  
Only necessary if you're using Xorg (X11). Wayland already includes this through the modesetting driver.

    sudo pacman -S xf86-video-amdgpu

---
## 6. Install additional packages
Previously installed: `base base-devel linux linux-firmware intel-ucode nano`

Examples of packages I installed:

        sudo pacman -S nvidia nvidia-utils vulkan-driver nvidia-settings lib32-nvidia-utils
        sudo pacman -S grub efibootmgr dosftools os-prober networkmanager git sudo openssh
        sudo pacman -S hyprland wayland xorg-xwayland wlroots ly
        sudo pacman -S pipewire pipewire-pulse wireplumber
        sudo pacman -S hyprpaper hyprlock swaync waybar wofi grim slurp kitty thunar ranger
        sudo pacman -S noto-fonts noto-fonts-emoji ttf-jetbrains-mono ttf-font-awesome

Initialize grub or your preferred boot loader:

        grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
        grub-mkconfig -o /boot/grub/grub.cfg

Enable some essentials: 

        systemctl enable sshd
        systemctl enable ly               # Or your chosen login screen, such as lightdm 
        systemctl enable NetworkManager
        systemctl enable pipewire
        systemctl enable wireplumber

---
Additionally, you can enable multilib for 32 bit gaming, go to:

    sudo nano /etc/pacman.conf

Uncomment the following:

    # [multilib]
    # Include = /etc/pacman.d/mirrorlist
---
## Here is a list of all packages I use:
You can also install these at a later stage, as long as you have the essentials before you reboot.

### System and Base Packages
    base                      # Essential Arch Linux system components
    base-devel                # Development tools like gcc, make, etc.
    linux                     # The Linux kernel (Arch version)
    linux-firmware            # Firmware files for various devices
    efibootmgr                # Manage UEFI boot entries
    ntfs-3g                   # NTFS read/write driver
    grub                      # Bootloader
    grub-customizer           # GUI tool to configure GRUB
    intel-ucode               # Intel CPU microcode updates
    os-prober                 # Detect other OSes for bootloader config
    pacman-contrib            # Extra utilities for pacman (e.g., checkupdates)
    reflector                 # Update mirrorlist using fastest mirrors
    networkmanager            # Tool for managing network connections
    openssh                   # SSH client/server tools
    ly                        # TUI login manager
    git                       # Version control system
    stow                      # Symlink farm manager (great for dotfiles)
    yay                       # AUR helper written in Go
    yay-debug                 # Debug version of yay
    wget                      # CLI tool for downloading files over HTTP/FTP
    zsh                       # Z shell (alternative shell to bash)
    kitty                     # Fast, GPU-accelerated terminal emulator

### Text Editors and IDEs
    nano                      # Simple terminal text editor
    vim                       # Vi IMproved (text editor)
    neovim                    # Neovim (modern Vim alternative)
    xpad                      # Sticky notes app
    notion-app-electron       # Notion note-taking app (Electron version)
    libreoffice-fresh         # Full office suite (latest version)
    pycharm-community-edition # Free IDE for Python development

### File Manager
    pcmanfm-gtk3              # Lightweight file manager
    thunar                    # Lightweight file manager (XFCE)Artt
    ranger                    # Terminal-based file manager with vim-like bindings

### Analyzing Tools
    baobab                    # Disk usage analyzer (GUI)
    neofetch                  # System info tool (ASCII + stats)
    bashtop                   # Resource monitor in terminal

### Fonts
    noto-fonts                # Noto fonts collection for better language support
    noto-fonts-cjk            # Noto fonts for CJK (Chinese, Japanese, Korean)
    ttf-font-awesome          # Font Awesome (icon font)
    ttf-jetbrains-mono        # JetBrains Mono font (designed for coding)
    ttf-jetbrains-mono-nerd   # JetBrains Mono with Nerd Font patches
    wqy-zenhei                # WenQuanYi Zen Hei (Chinese font)
    fcitx5-configtool         # GUI config tool for Fcitx5 input method
    fcitx5-gtk                # GTK support module for Fcitx5
    fcitx5-mozc               # Japanese input method engine (Mozc) for Fcitx5
    font-manager              # View your fonts

### Audio
    pipewire                  # Audio/video server (Pulse/Jack replacement)
    pipewire-pulse            # PulseAudio compatibility layer for PipeWire
    wireplumber               # Session manager for PipeWire
    helvum                    # GTK patchbay for PipeWire
    pavucontrol-gtk3          # GTK3 PulseAudio volume control GUI
    mpd                       # Music Player Daemon
    mpc                       # Command-line client for MPD

### Hyprland and wayland ecosystem
    xorg-xhost                # Utility to manage X server access control
    xorg-xwayland             # Run X apps in Wayland session
    hyprland                  # Dynamic tiling Wayland compositor
    hypridle                  # Idle management tool for Hyprland
    hyprlock                  # Screen locker for Hyprland
    hyprpaper                 # Wallpaper daemon for Hyprland
    hyprpicker                # Color picker for Wayland
    hyprshot                  # Screenshot tool for Hyprland
    wlroots                   # Wayland compositor library (used by Hyprland etc.)
    waybar                    # Status bar for Wayland compositors
    rofi                      # Window switcher and launcher (X/Wayland)
    wofi                      # Application launcher for Wayland (rofi-like)
    grim                      # Screenshot utility for Wayland
    slurp                     # Region selector for Wayland (used with grim)
    swaync                    # Notification center for Wayland
    swaync-widgets-git        # Widgets for swaync (development version)
    wev                       # Event viewer for Wayland input
    nwg-look                  # GTK theme preview/config tool for Wayland

### Other useful packages
    obs-studio                # Streaming and recording software
    megacmd                   # CLI for MEGA cloud storage
    thunderbird               # Email client by Mozilla
    microsoft-edge-stable-bin # Microsoft Edge browser (binary version)
    zen-browser-bin           # Lightweight minimal browser (binary release)
    steam                     # Gaming platform from Valve
    minecraft-launcher        # Launcher for Minecraft game
    spotify                   # Spotify music client
    spotube                   # Lightweight Spotify frontend (uses YouTube)
    discord                   # VoIP/chat app for gamers and communities
    python-numpy              # Numerical operations library for Python
    python-pip                # Python package installer

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
