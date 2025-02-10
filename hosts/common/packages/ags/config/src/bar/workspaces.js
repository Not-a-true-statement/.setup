import Gdk from 'gi://Gdk';
import GLib from "gi://GLib";
import Gio from "gi://Gio";
import Gtk from "gi://Gtk?version=3.0"
import GdkPixbuf from "gi://GdkPixbuf"
import { exec } from "resource:///com/github/Aylur/ags/utils/exec.js";
import { getMonitorName } from '../utils.js';

const hyprland = await Service.import("hyprland");
const { query } = await Service.import("applications")


// Properties
// const iconSize = 24;
const iconSize = 30;
// const iconSize = 70;
const showAllWorkspaces = true;
const dontShowAllIcons = true;
const highlightDifferentWorkspace = false;

const generateIconWidget = (classname, size) => {
    const matchingApplications = query(classname);
    // Default icon
    // if (!matchingApplications[0] || !matchingApplications[0].icon_name) {
    //     return Widget.Icon({icon:"emblem-system", size: size,});
    // }
    // return Widget.Icon({icon:matchingApplications[0].icon_name, size: size,});


    // const grayScale = 0
    const grayScale = 0.70
    // const grayScale = 1

    const iconTheme = Gtk.IconTheme.get_default();
    const iconName = () => {
        if (!matchingApplications[0] || !matchingApplications[0].icon_name) {
            return "emblem-system";
        };
        return matchingApplications[0].icon_name;
    }
    const iconInfo = iconTheme.lookup_icon(iconName(), 64, 0); // Replace with your actual icon name
    const loadedIcon = iconInfo?.load_icon().scale_simple(iconSize, iconSize, GdkPixbuf.InterpType.BILINEAR);
    loadedIcon?.saturate_and_pixelate(loadedIcon, grayScale, false);

    // Default icon

    return new Gtk.Image({
        pixbuf: loadedIcon,
    });
}

export const Workspaces = (/** @type {number} */ monitorID, options = { vertical: false }) => {

    // Consturct workspaces tree
    const workspaces = Utils.merge([hyprland.bind("workspaces"), hyprland.bind("monitors")], (workspaces, monitors) => {

        let filteredWorkspaces = workspaces;

        // Remove workspaces not assigned to monitor
        if (!showAllWorkspaces)
            filteredWorkspaces = filteredWorkspaces.filter((a) => (a.monitorID === monitorID));

        // Sort
        var workspacesSorted = new Map([...filteredWorkspaces.entries()].sort((a, b) => { return a[1].id - b[1].id }));

        const workspaceGroup = [];

        for (let [key, value] of workspacesSorted) {
            const workspace = value;
            const appIcons = [];



            if (dontShowAllIcons && showAllWorkspaces && workspace.monitorID != monitorID) {
                // Workspace label.
                // appIcons.push(Widget.Label({
                //     label: `${workspace.id}`,
                //     class_name: "workspace-label-monitor-highlighted"
                // }))
                appIcons.push(Widget.Box({
                    hpack:"center",
                    children: [
                        Widget.Label({
                            label: `${workspace.id}`,
                            class_name: "workspace-label-monitor-highlighted"
                        }),
                        Widget.Label({
                            hpack:"start",
                            vpack: "start",
                            label: `${workspace.monitorID}`,
                            class_names: ["workspace-label-monitor-highlighted", "workspace-label-monitor-highlighted-monitor"]
                        })
                    ]
                }))
            }
            else {
                // Workspace label.
                appIcons.push(Widget.Label({
                    label: `${workspace.id}`,
                }))

                // Generate icons for each workspace.
                for (let clientIndex = 0; clientIndex < hyprland.clients.length; clientIndex++) {
                    const client = hyprland.clients[clientIndex];
                    if (client.workspace.id !== workspace.id) { continue; }
                    appIcons.push(generateIconWidget(client.initialClass, iconSize))
                }
            }

            // Check the current focused workspace per monitor.
            let workspaceClass = "workspace";
            const currentMonitor = monitors.find((monitor) => monitor.id === monitorID)
            if (currentMonitor) {
                if (currentMonitor.activeWorkspace.id === workspace.id) {
                    workspaceClass = "workspace-focused";
                }
            }

            // Construct the workspace group.
            const workspaceContainer = Widget.Button({
                // class_name: "workspaces-workspace",
                // class_name: activeWorkspaceID === workspace.id ? "workspaces-workspace-focused" : "workspaces-workspace", 
                class_name: workspaceClass,

                child: Widget.Box({
                    vertical: options.vertical,
                    children: appIcons,
                }),
                on_clicked: () => {
                    exec(`hyprctl dispatch focusworkspaceoncurrentmonitor ${workspace.id}`);
                    // console.log(`hyprctl dispatch focusworkspaceoncurrentmonitor ${workspace.id}`);
                },
            });
            workspaceGroup.push(workspaceContainer);
        }
        return workspaceGroup;
    });




    // Return root widget
    return Widget.Box({
        vertical: options.vertical,
        class_name: "workspaces",
        children: workspaces,
    });
}