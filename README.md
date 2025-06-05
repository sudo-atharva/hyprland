<p align="center">
  <img src="https://raw.githubusercontent.com/hyprwm/Hyprland/main/.github/assets/logo.svg" alt="Hyprland Logo" width="120"/>
</p>

<h1 align="center">🧩 Fixing Flatpak Apps on Hyprland (Ubuntu 24.04)</h1>

<p align="center"><b>Make Flatpak Electron apps work smoothly on Hyprland with this step-by-step guide and universal fix script.</b></p>

---

> ⚠️ <b>Disclaimer from sudo-atharva:</b> <br>
> I, <b>sudo-atharva</b>, do <b>not</b> take responsibility for your computer. Use this guide and the automatic script at your own risk. <br>
> The script is provided as-is and is <b>not guaranteed to work</b> on every system or configuration. <br>
> Please review the script and understand what it does before running it.

---

## 🚀 Overview

This guide helps you fix Flatpak apps that don’t launch or behave weirdly under <b>Hyprland</b> (Wayland compositor) on <b>Ubuntu 24.04</b>.

- Focus: <b>Arduino IDE 2 (Flatpak)</b>, but works for other Electron-based apps too.
- If you have a better fix, PRs and suggestions are welcome!

---

## 🖥️ My Setup

| Component                | Value                                                                 |
|--------------------------|-----------------------------------------------------------------------|
| <b>OS</b>                | Ubuntu 24.04                                                          |
| <b>Hyprland install</b>  | [JaKooLit’s Ubuntu-Hyprland](https://github.com/JaKooLit/Ubuntu-Hyprland) |
| <b>Flatpak App</b>       | <code>cc.arduino.IDE2</code>                                          |
| <b>Wayland compositor</b>| Hyprland (X11 fallback used when necessary)                            |

---

## 🛠️ Step-by-Step Fix (Arduino IDE 2)

Try these in order until one works:

1. **Run Normally**
   ```bash
   flatpak run cc.arduino.IDE2
   ```
2. **Disable GPU Acceleration**
   ```bash
   flatpak run cc.arduino.IDE2 --disable-gpu
   ```
3. **Add Debug + Disable GPU**
   ```bash
   flatpak run --env=ELECTRON_ENABLE_LOGGING=true --env=ELECTRON_DISABLE_GPU=true cc.arduino.IDE2
   ```
4. **Disable Wayland Socket (Force X11 Fallback)**
   ```bash
   flatpak override --user --filesystem=home cc.arduino.IDE2
   flatpak run --nosocket=wayland cc.arduino.IDE2
   ```
   💡 <b>This worked best for me — fast, stable, and responsive.</b>

---

## 🧷 Make the Fix Permanent with a Custom <code>.desktop</code> Launcher

Create a desktop entry so it shows up in your application launcher:

```bash
mkdir -p ~/.local/share/applications
nano ~/.local/share/applications/arduino-ide.desktop
```

Paste the following content:

```ini
[Desktop Entry]
Name=Arduino IDE (Fixed for Hyprland)
Comment=Official Arduino IDE with X11 fallback
Exec=flatpak run --env=MOZ_ENABLE_WAYLAND=0 --env=ELECTRON_OZONE_PLATFORM_HINT=x11 cc.arduino.IDE2
Terminal=false
Type=Application
Icon=cc.arduino.IDE2
Categories=Development;IDE;
StartupNotify=true
```

Save and close the file. The new launcher should now appear in your system menu.

---

## 🧠 Why This Works

- Electron apps can misbehave on native Wayland.
- By <b>disabling the Wayland socket</b>, we force <b>XWayland fallback</b>, improving compatibility.
- Disabling GPU acceleration avoids rendering bugs on some drivers or hybrid graphics setups.

---

## 📦 Bonus Tips

- Use <a href="https://flathub.org/apps/com.github.tchx84.Flatseal">Flatseal</a> to manage Flatpak permissions visually.
- You can adapt this method to other Electron apps like VS Code, Discord, Obsidian, etc.

---

## 🛠️ Universal Hyprland Flatpak Fix Script

Here’s your universal script: <b>✅ fix_flatpak_hyprland.sh</b>

**What it does:**
- Applies all the Flatpak environment overrides for Hyprland compatibility.
- Forces the app to use X11 fallback (<code>--nosocket=wayland</code>).
- Optionally creates a <code>.desktop</code> launcher for your app.

**You can download it from this repository:**

📂 by running the following command in your terminal:
```bash git clone https://github.com/sudo-atharva/hyprland.git

### 🔧 How to Use

1. <b>Make it executable:</b>
   ```bash
   chmod +x fix_hyprland_flatpak.sh
   ```
2. <b>Run it:</b>
   ```bash
   ./fix_hyprland_flatpak.sh
   ```
3. <b>Follow the prompts:</b>
   - Enter the Flatpak app ID when prompted (e.g. <code>cc.arduino.IDE2</code>).
   - Optionally, create a custom launcher for your app.

> ⚠️ <b>Disclaimer from sudo-atharva:</b> <br>
> I, <b>sudo-atharva</b>, do <b>not</b> take responsibility for your computer. Use this guide and the automatic script at your own risk. <br>
> The script is provided as-is and is <b>not guaranteed to work</b> on every system or configuration. <br>
> Please review the script and understand what it does before running it.

> Want a version that also supports non-Electron apps like Qt or GTK? Let me know!

---

## 🧵 Related Projects

- [Hyprland](https://github.com/hyprwm/Hyprland)
- [Ubuntu-Hyprland by JaKooLit](https://github.com/JaKooLit/Ubuntu-Hyprland)
- [Flatpak Documentation](https://docs.flatpak.org/)
- [Electron Wayland Issues](https://github.com/electron/electron/issues?q=wayland)

---

## 🙌 Contribute

Found a better fix? PRs and suggestions welcome!

---

## 🔐 License

This guide is open-sourced under the [MIT License](LICENSE).

---

