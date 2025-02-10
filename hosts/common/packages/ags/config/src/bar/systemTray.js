const systemtray = await Service.import('systemtray')

/** @param {import('types/service/systemtray').TrayItem} item */
const SysTrayItem = item => Widget.Button({
    child: Widget.Icon({ size: 18 }).bind('icon', item, 'icon'),
    tooltipMarkup: item.bind('tooltip_markup'),
    onPrimaryClick: (_, event) => item.activate(event),
    onSecondaryClick: (systrayIcon, event) => {
        item.openMenu(event)
    },
});

export const sysTray = (options = { vertical: false }) => Widget.Box({
    class_name: "systrayWidget",
    
    hpack: !options.vertical ? "center" : "baseline",
    vpack: options.vertical ? "center" : "baseline",
    vertical:options.vertical,

    spacing: 3,
    children: systemtray.bind('items').as(i => i.map(SysTrayItem))
})