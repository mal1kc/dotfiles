#!/usr/bin/env python3
import json
import pathlib
import sys

try:
    import rivalcfg
except ImportError:
    print("connot import rivalcfg")
    sys.exit(1)


my_prof_rival3 = {
    # " rivalcfg --z1 0c0215 --z2 18052c --z3 063042 --z4 001102 -s "5600","8600""
    "sensitivity": "5600,8500",
    "polling_rate": 1000,
    "z1_color": "0c0215",
    "z2_color": "18052c",
    "z3_color": "063042",
    "logo_color": "001102",
    "light_effect": "steady",
    "buttons_mapping": "buttons(button1=button1; button2=button2; button3=button3; button4=button4; button5=button5; button6=dpi; scrollup=scrollup; scrolldown=scrolldown; layout=qwerty)",
}

my_prof_aerox3 = {
    "sensitivity": "1600, 3500, 8500",
    "polling_rate": 1000,
    # "z1_color": "red",
    # "z2_color": "lime",
    # "z3_color": "blue",
    "z1_color": "0c0215",
    "z2_color": "18052c",
    "z3_color": "063042",
    # "reactive_color": "off",
    "reactive_color": "001102",
    "led_brightness": 30,
    "rainbow_effect": "bottom",
    "buttons_mapping": "buttons(button1=button1; button2=button2; button3=button3; button4=button4; button5=button5; button6=dpi; scrollup=scrollup; scrolldown=scrolldown; layout=qwerty)",
    "default_lighting": "reactive",
}


def dump_mouse_settings(m: rivalcfg.mouse.Mouse) -> dict:
    s = {}
    s["sensitivity"] = m.mouse_settings.get("sensitivity")
    s["polling_rate"] = m.mouse_settings.get("polling_rate")
    s["z1_color"] = m.mouse_settings.get("z1_color")
    s["z2_color"] = m.mouse_settings.get("z2_color")
    s["z3_color"] = m.mouse_settings.get("z3_color")
    s["reactive_color"] = m.mouse_settings.get("reactive_color")
    s["led_brightness"] = m.mouse_settings.get("led_brightness")
    s["rainbow_effect"] = m.mouse_settings.get("rainbow_effect")
    s["buttons_mapping"] = m.mouse_settings.get("buttons_mapping")
    s["default_lighting"] = m.mouse_settings.get("default_lighting")
    return s


def rival3(rival_dev: rivalcfg.mouse.Mouse):
    rival_dev.set_z1_color(my_prof_rival3["z1_color"])
    rival_dev.set_z2_color(my_prof_rival3["z2_color"])
    rival_dev.set_z3_color(my_prof_rival3["z3_color"])
    rival_dev.set_logo_color(my_prof_rival3["logo_color"])
    rival_dev.set_buttons_mapping(my_prof_rival3["buttons_mapping"])
    rival_dev.set_polling_rate(my_prof_rival3["polling_rate"])
    rival_dev.set_sensitivity(my_prof_rival3["sensitivity"])
    rival_dev.save()
    # m_profile = rivalcfg.devices.get_profile(
    #     rival_dev.vendor_id,
    #     rival_dev.product_id,
    # )
    # pprint(m_profile)

    # rival_dev = rivalcfg.get_first_mouse()
    # for setting_key, setting_val in my_prof.items():
    #     rival_dev.mouse_settings.set(setting_key, setting_val)
    # assert rival_dev.mouse_settings._settings["default"] == my_prof
    # rival_dev.save()


def aerox3(rival_dev: rivalcfg.mouse.Mouse):
    rival_dev.set_sensitivity(my_prof_aerox3["sensitivity"])
    rival_dev.set_polling_rate(my_prof_aerox3["polling_rate"])

    rival_dev.set_z1_color(my_prof_aerox3["z1_color"])
    rival_dev.set_z2_color(my_prof_aerox3["z2_color"])
    rival_dev.set_z3_color(my_prof_aerox3["z3_color"])

    rival_dev.set_reactive_color(my_prof_aerox3["reactive_color"])
    rival_dev.set_led_brightness(my_prof_aerox3["led_brightness"])

    rival_dev.set_rainbow_effect(my_prof_aerox3["rainbow_effect"])

    rival_dev.set_buttons_mapping(my_prof_aerox3["buttons_mapping"])
    rival_dev.set_default_lighting(my_prof_aerox3["default_lighting"])
    rival_dev.save()
    # m_profile = rivalcfg.devices.get_profile(
    #     rival_dev.vendor_id,
    #     rival_dev.product_id,
    # )
    # pprint(m_profile)

    # rival_dev = rivalcfg.get_first_mouse()
    # for setting_key, setting_val in my_prof.items():
    #     rival_dev.mouse_settings.set(setting_key, setting_val)
    # assert rival_dev.mouse_settings._settings["default"] == my_prof
    # rival_dev.save()


def main():
    mouse = rivalcfg.get_first_mouse()
    home_dir = pathlib.Path.home()
    if mouse.name == "SteelSeries Aerox 3":
        mouse_settings = dump_mouse_settings(mouse)
        with open(
            home_dir.joinpath(".cache/rivalcfg_ar3_before_change.json"), mode="w"
        ) as fp:
            json.dump(mouse_settings, fp)
        aerox3(mouse)
    elif mouse.name == "SteelSeries Rival 3":
        mouse_settings = dump_mouse_settings(mouse)
        with open(
            home_dir.joinpath(".cache/rivalcfg_r3_before_change.json"), mode="w"
        ) as fp:
            json.dump(mouse_settings, fp)
        rival3(mouse)
    else:
        raise FileNotFoundError("SteelSeries device not found or does not have config")


if __name__ == "__main__":
    main()
