[SettingsTab name="Reset"]
void RenderResetSettings() {
    UI::Text("This will reset all customizations you might have made to the presets!");
    if (UI::Button("Reset Presets")) {
        CopyPresets(dirLocation);
        UI::ShowNotification("OBS Display", "Presets were reset to their defaults!");
    }
}