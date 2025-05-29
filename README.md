# install-zig
> Blazingly fast and easy Zig installation script for Linux systems.

## Features
- Automatically detects existing Zig installations
- Downloads official Zig binaries
- Installs system-wide with proper PATH setup
- Works on Debian-based distributions

## Quick Start

Make sure your system have `sudo`, `git` and `wget` to begin. Next, run the following code below to install.

```bash
git clone https://github.com/MingFei2001/install-zig.git
cd install-zig
bash ./install-zig.sh
```

Now run `zig version` to verify the installation.

## What it installs

- Latest Zig version to `/usr/local/zig/`
- Symlink in `/usr/local/bin/zig`

The script skips installation if the required version is already present. Edit the `ZIG_REQUIRED_VERSION` variable in the script to change the target version.

## Credits
*Script adapted from [JustAGuyLinux](https://github.com/drewgrif/myghostty)*

## License
This project is released under the [MIT License](./LICENSE). Feel free to use, modify, and distribute as needed.
