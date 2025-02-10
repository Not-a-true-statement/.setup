import Gdk from "gi://Gdk";
import { getGDKMonitor, getMonitorName } from "./src/utils.js";
import { Bar } from "./src/bar/bar.js";
import { MonitorIndicator } from "./src/monitorIndicator/monitorIndicator.js";
// import { forMonitors } from './src/utils.js';

// Options
const verticalEnabled = true;

const hyprland = await Service.import("hyprland");
const display = Gdk.Display.get_default();

let currentBars = [];

// Location paths
const wallustColorsPath = `${Utils.CACHE_DIR}/../wallust-output`;

// CSS LOCATIONS
const wallustColors = `${wallustColorsPath}/ags-colors.scss`;
const stylesheetPath = `${App.configDir}/src/stylesheets`;
const compiledStylesheet = `${Utils.CACHE_DIR}/stylesheet.css`;

// Compile and update on color change
const compileSass = () => {
    const commandLog = Utils.exec(`sassc ${stylesheetPath}/stylesheet.scss ${compiledStylesheet}`);
    if (commandLog !== "") {
        console.log(commandLog);
        return;
    }
    App.resetCss()
    App.applyCss(compiledStylesheet)
    console.log("Updated css");
}
compileSass();
Utils.monitorFile(wallustColorsPath,() => { console.log("Wallust update"); compileSass(); });
Utils.monitorFile(stylesheetPath, ()=> { console.log("Ags update"); compileSass(); });

// CONFIGURATION
App.config({
    // style: "./src/stylesheets/stylesheet.css",
    style: compiledStylesheet,

    windows: () => {
        let windows = [];
        let hyprlandMonitors = hyprland.monitors;

        for (let monitorIndex = 0; monitorIndex < hyprlandMonitors.length; monitorIndex++) {
            const hyprlandMonitor = hyprlandMonitors[monitorIndex];
            let { id: hyprlandMonitorId, name: hyprlandMonitorName } = hyprlandMonitor;

            // Find correct GTK monitor for hyperland monitor
            const monitorCount = display?.get_n_monitors();
            for (let index = 0; index < (monitorCount ?? 1); index++) {
                let gdkMonitor = display?.get_monitor(index);
                if(getMonitorName(gdkMonitor) === hyprlandMonitorName){
                    const actualHeight = hyprlandMonitor.transform%2 === 1? hyprlandMonitor.height :hyprlandMonitor.width;
                    const actualWidth = hyprlandMonitor.transform%2 === 0? hyprlandMonitor.height :hyprlandMonitor.width;
                    windows.push(Bar(gdkMonitor, hyprlandMonitorId, { vertical: verticalEnabled? actualHeight>actualWidth:false }))    
                    windows.push(MonitorIndicator(gdkMonitor, hyprlandMonitorId));
                }
            }
        }

        return windows;
    }
})