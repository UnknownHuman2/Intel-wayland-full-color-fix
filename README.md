# Intel-wayland-full-color-fix

**By default some monitors might not be recognized properly by the Intel GPU and have washed out colors because it's not in full-range RGB mode.**

This script is adapted from the [Arch Wiki - Intel Graphics](https://wiki.archlinux.org/title/Intel_graphics#Fix_colors_for_Wayland). Credit to those Guys or Gals.

---
## ⚠️ Disclaimer

This script is a workaround, not an official or guaranteed fix. It modifies low-level GPU connector properties via `proptest` to force full-range RGB output on Intel GPUs under Wayland — specifically to resolve the washed-out color issue that affects some displays.

❗ This approach may bypass compositor-level logic and is considered fragile by design. It’s intended for setups where:
- The compositor does not offer a full RGB toggle.
- Your monitor is misidentified (e.g. as a TV or limited-range device)
- You’ve confirmed that native options (like KDE Plasma 6 settings) do not resolve the issue.

🛠️ Although generally safe, this script does modify live GPU connector settings. Be aware of the following:
- Display flickering or temporary black screens may occur when applying changes.
- Forcing full RGB on displays that expect limited RGB (such as TVs) can cause crushed blacks or incorrect colors.
- This workaround may conflict with future compositor updates that add proper RGB handling.

---

## ✅ Best Practices (Recommended)
Try native compositor settings first
 - KDE Plasma 5.24+ (Kwin): Use the Display Configration in System settings to toggle RGB range.
 - GNOME: Add `<rgbrange>full</rgbrange>` to `~/.config/monitors.xml` ([Arch Wiki](https://wiki.archlinux.org/title/Intel_graphics#Fix_colors_for_Wayland))
 - Hyprland (wlroots-based Wayland compositor): Currently does not offer a built-in full-range RGB toggle.
 - Other compositor: Cheak the Official Doucmention or Wiki.
 
Use `edid-decode` or `libdisplay-info` to confirm your display advertises full RGB.

Avoid using on setups where the display expects limited RGB (e.g. TVs, Old Moniters).  

---

## 💡 What It Actually Does

- Writes a script to `/usr/local/bin/intel-wayland-fix-full-color`
- Adds a `udev` rule to `/etc/udev/rules.d/80-i915.rules`
- Uses `proptest` to enable **full RGB range** on Intel iGPUs
- Activates automatically on boot or when the `i915` module loads

---

## ⚙️ Installation Guide
Apply this script only if you’ve ruled out all standard methods.  
```bash
git clone "https://github.com/UnknownHuman2/Intel-wayland-full-color-fix.git"
cd Intel-wayland-full-color-fix
chmod +x install_intel_color_fix.sh
./install_intel_color_fix.sh
```

- Prompts before writing any file
- Shows you the scripts before installing
- Makes everything executable
- Reloads udev rules if needed

🔁 **REBOOT after installing**. If you don’t see any color change, uninstall it:

```bash
./uninstall_intel_color_fix.sh
```

---

## ❌ Uninstalling

Simple and clean. Reverts the changes.

```bash
chmod +x uninstall_intel_color_fix.sh
./uninstall_intel_color_fix.sh
```

---

## 📸 CLI Screenshot

This is how the script politely asks for your permission before touching your system (unlike some install.sh monsters out there):

![CLI Screenshot](images/cli_script_preview.png)

---
## 👥 Credit & Support

**📝 Arch Wiki - Guys and Gals**
-  For documenting the `proptest` workaround in the first place.

**👤 Reddit**
- User from `r/Hyprland` who helped identify bugs and edge cases, and highlighted important behavior on wlroots-based setups.
- Another helpful user from `r/archlinux` who provided critical feedback on potential risks and encouraged safer practices.

---

## 📝 License

[MIT](LICENSE) – standard "use at your own risk" license.