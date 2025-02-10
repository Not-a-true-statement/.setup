import { batteryProgress } from "./battery.js"
import { bluetoothWidget } from "./bluetooth.js"
import { ClientTitle } from "./clientTitle.js"
import { sysTray } from "./systemTray.js"
import { Workspaces } from "./workspaces.js"
import Gdk from "gi://Gdk"
import GLib from "gi://GLib"
import { timeWidget } from "./time.js"

const clock = Variable(GLib.DateTime.new_now_local(), {
    poll: [1000, () => GLib.DateTime.new_now_local()],
})

const hyprland = await Service.import("hyprland");
const powerProfiles = await Service.import('powerprofiles')


export const Bar = (gdkMonitor, hyprlandMonitorID, options = { vertical: false }) => Widget.Window({
    gdkmonitor: gdkMonitor,
    name: `ags-bar-${hyprlandMonitorID}`,
    class_name: "bar-window",
    anchor: options.vertical ? ['top', 'left', 'bottom'] : ['top', 'left', 'right'],
    vexpand: true,
    hexpand: true,
    exclusivity: 'exclusive',
    type_hint: Gdk.WindowTypeHint.DOCK,
    layer: "top",

    child: Widget.CenterBox({
        vertical: options.vertical,
        hpack: !options.vertical ? "fill" : "baseline",
        vpack: options.vertical ? "fill" : "baseline",

        class_names: hyprland.active.monitor.bind("id").as((activeMonitorID) => {
            const bar = options.vertical? "bar-vertical" : "bar-horizontal";
            const focused = "bar-focused";

            return activeMonitorID !== hyprlandMonitorID ?
                ["bar", bar] : // Default.
                ["bar", bar, focused]; // Focused.
        }),

        start_widget: Widget.Box({
            vertical: options.vertical,
            children: [
                Widget.Icon({
                    icon:`${App.configDir}/src/assets/nixos.svg`,
                    size: 28,
                    class_name: options.vertical ? "logoWidget-vertical" : "logoWidget-horizontal",
                }),
                Workspaces(hyprlandMonitorID, { vertical: options.vertical }),
            ],
        }),

        center_widget: Widget.Box({
            vertical: options.vertical,
            children: [
                // Workspaces(hyprlandMonitorID, { vertical: options.vertical }),
                // ClientTitle({vertical: options.vertical, maxLetters: 30}),
            ],
        }),

        end_widget: Widget.Box({
            vertical: options.vertical,
            hpack: !options.vertical ? "end" : "baseline",
            vpack: options.vertical ? "end" : "baseline",
            spacing: 4,
            children: [
                sysTray({ vertical: options.vertical }),
                bluetoothWidget({ vertical: options.vertical }),
                batteryProgress({ vertical: options.vertical }),
                timeWidget({ vertical: options.vertical }),
            ]
        }),
    })
})