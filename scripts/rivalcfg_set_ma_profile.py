# try:
#     import rivalcfg
# except ImportError:
#     print("connot import rivalcfg")
#     exit(1)
from pprint import pprint
import rivalcfg

my_prof = {
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


def main():
    rival_dev = rivalcfg.get_first_mouse()
    rival_dev.set_z1_color(my_prof["z1_color"])
    rival_dev.set_z2_color(my_prof["z2_color"])
    rival_dev.set_z3_color(my_prof["z3_color"])
    rival_dev.set_logo_color(my_prof["logo_color"])
    rival_dev.set_buttons_mapping(my_prof["buttons_mapping"])
    rival_dev.set_polling_rate(my_prof["polling_rate"])
    rival_dev.set_sensitivity(my_prof["sensitivity"])
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


if __name__ == "__main__":
    main()
