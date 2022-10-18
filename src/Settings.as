[Setting category="General" name="address"]
string OBS_Display_Address = "localhost";

[Setting category="General" name="port"]
int OBS_Display_Port = 7775;

[Setting category="General" name="Close Settings to Save and Reload OBS Display Plugin"]
bool obs_blah = false;

[SettingsTab name="Reset"]
void RenderResetSettings() {
    UI::Text("This will reset all customizations you might have made to the presets!");
    if (UI::Button("Reset Presets")) {
        CopyPresets();
        UI::ShowNotification("OBS Display", "Presets were reset to their defaults!");
    }
}