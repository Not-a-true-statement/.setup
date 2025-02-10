import Gdk from "gi://Gdk";
import { getMonitorName } from "../utils.js";
import GLib20 from "gi://GLib";
import Cairo10 from "gi://cairo";


const hyprland = await Service.import("hyprland");

export const MonitorIndicator = (gdkMonitor, hyprlandMonitorID, options = {}) => {
    
    const alwaysShow = false;

    let visibilityTimer;
    let opacityInterval, currentOpacity;
    let i = 0;
    const hyprlandMonitor = hyprland.getMonitor(hyprlandMonitorID);

    const window = Widget.Window({
        // monitor: (monitor),
        gdkmonitor: gdkMonitor,
        name: `ags-bar-monitorIndicator${hyprlandMonitorID}`,
        class_name: "monitor-indicator-window",
        anchor: ["bottom","right"],
        vexpand: true,
        hexpand: true,
        exclusivity: 'ignore',
        // type_hint: Gdk.WindowTypeHint.NOTIFICATION,
        layer: "overlay",
        click_through: true,
        

        // Hide after delay (Update on monitor beacuse it updates only when moving between monitors altough its called twice)
        opacity: alwaysShow ? 1 : hyprland.bind("monitors").as((v)=>{
            if (hyprland.active.monitor.id === hyprlandMonitorID) {
                clearTimeout(visibilityTimer);
                visibilityTimer = setTimeout(()=>{
                    console.log(`MonitorID ${hyprlandMonitorID}: MonitorIndicator invisible`);
                    window.opacity = 0;
                }, 2000);
                console.log(`MonitorID ${hyprlandMonitorID}: MonitorIndicator visible`);
                return 1
            }
            return 0;
        }),

        child: Widget.Box({
            hexpand:true,
            vexpand:true,
            class_name: "monitor-indicator",
            children: [
                Widget.Label({
                    class_name : "monitor-id",
                    hexpand: true,
                    vexpand: true,
                    vpack: "center",
                    label: `${hyprlandMonitorID}`,
                }),
                Widget.Box({
                    class_name : "monitor-properties",
                    hexpand: true,
                    vexpand: true,
                    vpack: "center",
                    vertical: true,
                    children: [
                        Widget.Label({
                            label: `${getMonitorName(gdkMonitor)}`,
                            hpack:"start",
                        }),
                        Widget.Label({
                            label: `Resolution: ${hyprlandMonitor?.width} x ${hyprlandMonitor?.height}`,
                            hpack:"start",
                        }),
                        Widget.Label({
                            label: `Rotation: ${hyprlandMonitor?.transform}`,
                            hpack:"start",
                        }),
                        Widget.Label({
                            label: `Model: ${hyprlandMonitor?.model}`,
                            hpack:"start",
                        }),
                    ],
                }),
            ],
        }),
    });

    return window;
}