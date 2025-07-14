#!/bin/bash

# === Paths ===
SCRIPT_PATH="/usr/local/bin/intel-wayland-fix-full-color"
UDEV_RULE_PATH="/etc/udev/rules.d/80-i915.rules"

# === LICENSE ===
echo -e "📜 \033[1;35mMIT License\033[0m"
echo -e "👤 \033[1;36mCopyright (c) 2025 Amandeep Singh\033[0m"
echo ""

echo "🧹 Intel Wayland Full-Color Fix Uninstaller"
echo "------------------------------------------"

# === Check existing files ===
REMOVE_LIST=()

if [[ -f "$SCRIPT_PATH" ]]; then
    REMOVE_LIST+=("$SCRIPT_PATH")
fi

if [[ -f "$UDEV_RULE_PATH" ]]; then
    REMOVE_LIST+=("$UDEV_RULE_PATH")
fi

# === If nothing to remove ===
if [[ ${#REMOVE_LIST[@]} -eq 0 ]]; then
    echo "✅ Nothing to remove. Script and udev rule not found."
    exit 0
fi

# === Show what will be removed ===
echo "📂 The following files will be removed:"
for file in "${REMOVE_LIST[@]}"; do
    echo "  - $file"
done

# === Ask for confirmation ===
read -p "❓ Are you sure you want to delete these files? (yes/no): " confirm
confirm=${confirm,,}

if [[ "$confirm" != "yes" && "$confirm" != "y" ]]; then
    echo "❌ Uninstallation cancelled."
    exit 0
fi

# === Perform removal ===
for file in "${REMOVE_LIST[@]}"; do
    echo "🗑️ Removing: $file"
    sudo rm -f "$file"
done

# === Reload udev ===
echo "🔄 Reloading udev rules..."
sudo udevadm control --reload
sudo udevadm trigger

echo "✅ Uninstallation complete!"
