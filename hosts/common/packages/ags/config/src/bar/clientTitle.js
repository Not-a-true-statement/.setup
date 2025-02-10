const hyprland = await Service.import("hyprland");

export const ClientTitle = (options = { vertical: false, maxLetters: 30}) => {
    return Widget.Label({
        class_name: options.vertical ? "clientTitle-horizontal" : "clientTitle-vertical",
        // maxWidthChars: options.vertical ? 1 : -1,
        // vexpand:true,
        // wrap: true,
        label: hyprland.active.client.bind("title").as((title)=>{
            if (title.length > options.maxLetters) {
                return title.substring(0, options.maxLetters) + "...";
            }
            return title;
        }),
    });
}