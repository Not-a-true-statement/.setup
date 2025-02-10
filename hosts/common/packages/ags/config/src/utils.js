import Gdk from 'gi://Gdk';

export function range(length, start = 1) {
    return Array.from({ length }, (_, i) => i + start);
}

const display = Gdk.Display.get_default();

export function forMonitors(widget) {
    const n = display?.get_n_monitors() || 1;
    return range(n, 0).map(widget).flat(1);
}

export function getGDKMonitor(hyprlandMonitor) {
    return display?.get_monitor_at_point(hyprlandMonitor.x, hyprlandMonitor.y) || null;
}

/**
 * @param {Gdk.Monitor | null | undefined} gdkmonitor
 */
export function getMonitorName(gdkmonitor) {
    const screen = display?.get_default_screen();
    const screenCount = display?.get_n_monitors() ?? 1; 

    for(let i = 0; i < screenCount; ++i) {
        if(gdkmonitor === display?.get_monitor(i))
            return screen?.get_monitor_plug_name(i) ?? null;
    }
    return null;
}