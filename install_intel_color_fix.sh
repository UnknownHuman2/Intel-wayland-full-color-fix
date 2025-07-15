#!/bin/bash

# === Paths ===
SCRIPT_PATH="/usr/local/bin/intel-wayland-fix-full-color"
UDEV_RULE_PATH="/etc/udev/rules.d/80-i915.rules"

# === Script content ===
SCRIPT_CONTENT='#!/bin/bash

readarray -t proptest_result <<<"$(/usr/bin/proptest -M i915 -D /dev/dri/card0 | grep -E '\''Broadcast|Connector'\'')"

for ((i = 0; i < ${#proptest_result[*]}; i += 2)); do
    connector=$(echo ${proptest_result[i]} | awk '\''{print $2}'\'')
    connector_id=$(echo ${proptest_result[i + 1]} | awk '\''{print $1}'\'')

    /usr/bin/proptest -M i915 $connector connector $connector_id 1
done
'

# === udev rule content ===
UDEV_RULE='ACTION=="add", SUBSYSTEM=="module", KERNEL=="i915", RUN+="/usr/local/bin/intel-wayland-fix-full-color"'

# === LICENSE ===
echo -e "📜 \033[1;35mMIT License\033[0m"
echo -e "👤 \033[1;36mCopyright (c) 2025 Amandeep Singh\033[0m"
echo -e "⚠️  \033[1;33mUse at your own risk. See LICENSE file for full terms.\033[0m"
echo ""

# === WARNING & DISCLAIMER ===
echo -e "🔺 \033[1;31mWARNING!\033[0m"
echo "This script will:"
echo "📁 Create: $SCRIPT_PATH"
echo "📄 Add udev rule: $UDEV_RULE_PATH"
echo ""
echo "🖥️ This script applies a workaround for Intel GPUs under Wayland to fix limited RGB range (washed-out colors)."
echo "⚠️ By running this, you agree that:"
echo "   - You've already tried native/compositor methods (e.g. KDE, GNOME)."
echo "   - You've read the README and understand the potential side effects."
echo "   - You know this is a workaround — not an official or permanent fix."
echo ""
echo "🧾 This script is adapted from the Arch Wiki: https://wiki.archlinux.org/title/Intel_graphics#Fix_colors_for_Wayland . Credit to those Guy or Gals."
echo ""
read -p "❓ Do you wish to continue? (yes/no): " proceed
proceed=${proceed,,}
if [[ "$proceed" != "yes" && "$proceed" != "y" ]]; then
    echo "❌ Installation aborted."
    exit 0
fi

echo -e "\n📄 Script that will be created at: \033[1m$SCRIPT_PATH\033[0m"
echo "----------------------------------------------------------"
echo "$SCRIPT_CONTENT"
echo "----------------------------------------------------------"
read -p "🤔 Do you want to create this script file? (yes/no): " confirm_script
confirm_script=${confirm_script,,}

if [[ "$confirm_script" == "yes" || "$confirm_script" == "y" ]]; then
    echo "✍️  Writing script to $SCRIPT_PATH..."
    echo "$SCRIPT_CONTENT" | sudo tee "$SCRIPT_PATH" > /dev/null
    echo "✅ Script created!"

    read -p "🔐 Do you want to make the script executable? (yes/no): " confirm_exec
    confirm_exec=${confirm_exec,,}
    if [[ "$confirm_exec" == "yes" || "$confirm_exec" == "y" ]]; then
        sudo chmod +x "$SCRIPT_PATH"
        echo "🚀 Script is now executable! You can run it with: intel-wayland-fix-full-color"
    else
        echo "⚠️  Skipped making script executable."
    fi
else
    echo "❌ Script creation cancelled."
    exit 1
fi

echo -e "\n📎 Udev rule that will be created at: \033[1m$UDEV_RULE_PATH\033[0m"
echo "----------------------------------------------------------"
echo "$UDEV_RULE"
echo "----------------------------------------------------------"
read -p "🤔 Do you want to create this udev rule? (yes/no): " confirm_udev
confirm_udev=${confirm_udev,,}

if [[ "$confirm_udev" == "yes" || "$confirm_udev" == "y" ]]; then
    echo "✍️  Writing udev rule to $UDEV_RULE_PATH..."
    echo "$UDEV_RULE" | sudo tee "$UDEV_RULE_PATH" > /dev/null
    echo "🔄 Reloading udev rules..."
    sudo udevadm control --reload
    sudo udevadm trigger
    echo "✅ udev rule installed! Your script will run automatically when Intel GPU module loads."
else
    echo "⚠️  Skipped udev rule creation."
fi

echo -e "\n🎉 Done! You may reboot to test the fix."

echo -e "\n🧹 If something doesn’t work or you want to undo this:"
echo "➡️  Run the uninstaller script:"
echo -e "   \033[1muninstall_intel_color_fix.sh\033[0m"

