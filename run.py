#     python3 -m venv venv
#   * source ./venv/bin/activate  *
#
#     pip install pyautogui
#   * python3 app.py  *

import pyautogui as auto

def farm(min, max):
    while True:
      key = min
      for i in range(1,max+1):
        auto.press(str(key))
        auto.click()
        key = key + 1
      key = min

farm(1,5)
