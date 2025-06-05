from pathlib import Path

# Create a universal shell script to fix Electron-based Flatpak apps for Hyprland
script_content = """#!/bin/bash

# Universal Fix Script for Electron-based Flatpak Apps on Hyprland

echo "🔧 Universal Hyprland Flatpak Fixer for Electron Apps"
echo "⚠️  This will override Flatpak settings for better compatibility with Hyprland."

read -p "Enter the Flatpak App ID (e.g., cc.arduino.IDE2): " app_id

if [[ -z "$app_id" ]]; then
    echo "❌ No app ID provided. Exiting."
    exit 1
fi

# Apply Flatpak overrides
echo "📦 Applying Flatpak environment overrides..."
flatpak override --user --env=ELECTRON_ENABLE_LOGGING=true "$app_id"
flatpak override --user --env=ELECTRON_DISABLE_GPU=true "$app_id"
flatpak override --user --env=MOZ_ENABLE_WAYLAND=0 "$app_id"
flatpak override --user --env=ELECTRON_OZONE_PLATFORM_HINT=x11 "$app_id"
flatpak override --user --filesystem=home "$app_id"

# Run app with Wayland socket disabled to force XWayland fallback
echo "🚀 Running the app with Wayland socket disabled (forcing X11)..."
flatpak run --nosocket=wayland "$app_id" &

# Optional: Create .desktop entry
read -p "Do you want to create a new launcher for this app? (y/n): " create_launcher
if [[ "$create_launcher" == "y" || "$create_launcher" == "Y" ]]; then
    desktop_file="$HOME/.local/share/applications/${app_id//./_}-hyprfix.desktop"
    echo "📝 Creating .desktop launcher at $desktop_file"
    mkdir -p ~/.local/share/applications
    cat > "$desktop_file" <<EOF
[Desktop Entry]
Name=${app_id} (Hyprland Fixed)
Comment=Flatpak app fixed for Hyprland
Exec=flatpak run --env=MOZ_ENABLE_WAYLAND=0 --env=ELECTRON_OZONE_PLATFORM_HINT=x11 $app_id
Terminal=false
Type=Application
Icon=$app_id
Categories=Utility;Development;
StartupNotify=true
EOF
    echo "✅ Launcher created: $desktop_file"
else
    echo "🛑 Skipping launcher creation."
fi

echo "✅ Done! Try launching your app now."
"""

# Save the script to a file
script_path = Path("/mnt/data/fix_flatpak_hyprland.sh")
script_path.write_text(script_content)
script_path.chmod(0o755)  # Make the script executable

script_path.name
