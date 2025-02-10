import GLib from "gi://GLib"

const clock = Variable(GLib.DateTime.new_now_local(), {
    poll: [1000, () => GLib.DateTime.new_now_local()],
})

// export const timeWidget = (options = { vertical: false }) => Widget.Box({
//     vertical: true,
//     vpack: "center",
//     child: clock.bind().as(
//         (t) => Widget.Box({
//             class_name: "timeWidget",
//             vertical: true,
//             children: [
//                 Widget.Label({
//                     vpack: "end",
//                     justification: "center",
//                     // css:"background:green;",
//                     class_name: "labelTop",
//                     label: t.format("%H:%M %a")?.toUpperCase() ?? "",
//                 }),
//                 Widget.Label({
//                     vpack: "start",
//                     justification: "center",
//                     class_name: "labelBottom",
//                     label: t.format("%F") ?? "",
//                 }),
//             ],
//         })
//     ),
// })

export const timeWidget = (options = { vertical: false }) => options.vertical ? vertical() : horizontal()

const horizontal = () => Widget.Box({
    hpack: "center",
    child: clock.bind().as(
        (t) => Widget.Box({
            class_names: [
                "timeWidget",
                "timeWidget-horizontal",
            ],
            vertical: true,
            children: [
                Widget.Label({
                    vpack: "end",
                    justification: "center",
                    // css:"background:green;",
                    class_name: "labelTop",
                    label: t.format("%H:%M %a")?.toUpperCase() ?? "",
                }),
                Widget.Label({
                    vpack: "start",
                    justification: "center",
                    class_name: "labelBottom",
                    label: t.format("%F") ?? "",
                }),
            ],
        })
    ),
})

const vertical = () => Widget.Box({
    class_names: [
        "timeWidget",
        "timeWidget-vertical",
    ],
    vertical: true,
    hpack: "center",
    children: clock.bind().as((time) => [
        Widget.Label({
            hpack: "center",
            justification: "center",
            class_name: "labelDate",
            label: time.format("%a")?.toUpperCase() ?? "",
        }),
        Widget.Label({
            hpack: "center",
            justification: "center",
            class_name: "labelDate",
            label: time.format("%m/%d") ?? "",
        }),
        Widget.Label({
            hpack: "center",
            justification: "center",
            class_name: "labelDate",
            label: time.format("%Y") ?? "",
        }),

        Widget.Separator({
            vertical: true,
            class_name: "spacer",
        }),

        Widget.Label({
            hpack: "center",
            justification: "center",
            class_name: "labelTime",
            label: time.format("%H") ?? "",
        }),
        Widget.Label({
            hpack: "center",
            justification: "center",
            class_name: "labelTime",
            label: time.format("%M") ?? "",
        }),
        // Widget.Label({
            //     label: time.format("%A") ?? "",
        // }),
    ]
    ),
    // child: clock.bind().as(
    //     (t) => Widget.Box({
    //         class_name: "timeWidget",
    //         css:"background:black;",
    //         hpack:"center",
    //         vertical: true,
    //         children: [
    //             // Widget.Label({
    //             //     class_name: "labelTop",
    //             //     label: t.format("%H:%M %a")?.toUpperCase() ?? "",
    //             // }),
    //             Widget.Label({
    //                 hpack:"center",
    //                 justification:"center",
    //                 class_name: "labelTop",
    //                 css:"background:yellow;",
    //                 label: t.format("%H") ?? "",
    //             }),
    //             Widget.Label({
    //                 hpack:"center",
    //                 justification:"center",
    //                 class_name: "labelTop",
    //                 label: t.format("%M") ?? "",
    //             }),
    //             // Widget.Label({
    //             //     vpack: "start",
    //             //     justification: "center",
    //             //     class_name: "labelBottom",
    //             //     label: t.format("%m-%d") ?? "",
    //             // }),
    //             // Widget.Label({
    //             //     vpack: "start",
    //             //     justification: "center",
    //             //     class_name: "labelBottom",
    //             //     label: t.format("%a") ?? "",
    //             // }),
    //         ],
    //     })
    // ),
})