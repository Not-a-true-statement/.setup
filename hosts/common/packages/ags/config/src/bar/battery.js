const battery = await Service.import('battery');
const powerProfiles = await Service.import("powerprofiles");

export const batteryProgress = (options = { vertical: false }) => Widget.Box({
    class_name: "batteryWidget",
    children: [
        Widget.Icon({
            size: 18,
            icon: battery.bind('icon_name')
        }),
        Widget.Box({
            // vertical: true,
            children: [
                Widget.Label({
                    // vpack:"end",
                    class_name: "label",
                    // label: battery.bind('percent').as(precentage => precentage>=99 ? `FULL` : `${precentage}%`),
                    label: battery.bind('percent').as(precentage => `${precentage}%`),
                }),
                // Widget.Label({
                //     css:"background-color: green;",
                //     vpack:"start",
                //     class_name: "label",
                //     label: powerProfiles.bind('active_profile'),
                // }),
            ],
        }),
    ],
    visible: battery.bind('available'),
})