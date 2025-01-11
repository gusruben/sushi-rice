#!/bin/env python3
from os import path
import math
from time import sleep
from subprocess import run as sp_run

# config options
accent_color = "#ef4c80"
# battery_icons = [
#     "",
#     "",
#     "",
#     "",
#     "",
#     "",
#     "",
#     "",
#     "",
#     "",
# ]
battery_icons = [
    "",
    "",
    "",
    "",
    "",
]
package_icon = ""

package_check_interval = 60 * 60 * 6 # 6 hours
battery_check_interval = 1 # 1 second

# running battery mode or not
battery = path.exists("/sys/class/power_supply/BAT1")

if battery:
    while True:
        with open("/sys/class/power_supply/BAT1/capacity") as f:
            battery_level = int(f.read())

        with open("/sys/class/power_supply/BAT1/status") as f:
            is_charging = f.read().strip() == "Charging"
        charging_icon = " " if is_charging else ""

        index = math.ceil(battery_level / (100 /len(battery_icons))) - 1
        icon = battery_icons[index]

        battery_level_color = ""
        if battery_level <= 20:
            battery_level_color = f"%{{F{accent_color}}}"
        
        print(f"%{{F{accent_color}}}{icon}{charging_icon}%{{F-}} {battery_level_color}{battery_level}%")
        sleep(battery_check_interval)

# package mode
else:
    while True:
        package_count = int(sp_run("countupdates", capture_output=True).stdout)
        print(f"%{{F{accent_color}}}{package_icon}%{{F-}} {package_count}")
        sleep(package_check_interval)


