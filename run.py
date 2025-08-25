import ctypes
import time

# Constantes Windows
PUL = ctypes.POINTER(ctypes.c_ulong)

# Structures INPUT pour SendInput
class KEYBDINPUT(ctypes.Structure):
    _fields_ = [("wVk", ctypes.c_ushort),
                ("wScan", ctypes.c_ushort),
                ("dwFlags", ctypes.c_ulong),
                ("time", ctypes.c_ulong),
                ("dwExtraInfo", PUL)]

class MOUSEINPUT(ctypes.Structure):
    _fields_ = [("dx", ctypes.c_long),
                ("dy", ctypes.c_long),
                ("mouseData", ctypes.c_ulong),
                ("dwFlags", ctypes.c_ulong),
                ("time", ctypes.c_ulong),
                ("dwExtraInfo", PUL)]

class INPUT(ctypes.Structure):
    class _I(ctypes.Union):
        _fields_ = [("ki", KEYBDINPUT),
                    ("mi", MOUSEINPUT)]
    _anonymous_ = ("i",)
    _fields_ = [("type", ctypes.c_ulong),
                ("i", _I)]

# Constantes event
INPUT_KEYBOARD = 1
INPUT_MOUSE = 0

KEYEVENTF_KEYUP = 0x0002
MOUSEEVENTF_LEFTDOWN = 0x0002
MOUSEEVENTF_LEFTUP = 0x0004

SendInput = ctypes.windll.user32.SendInput

def press_key(vk):
    """Appuie sur une touche virtuelle Windows"""
    x = INPUT(type=INPUT_KEYBOARD,
              ki=KEYBDINPUT(wVk=vk, wScan=0, dwFlags=0,
                            time=0, dwExtraInfo=None))
    SendInput(1, ctypes.byref(x), ctypes.sizeof(x))
    x = INPUT(type=INPUT_KEYBOARD,
              ki=KEYBDINPUT(wVk=vk, wScan=0, dwFlags=KEYEVENTF_KEYUP,
                            time=0, dwExtraInfo=None))
    SendInput(1, ctypes.byref(x), ctypes.sizeof(x))

def click_mouse():
    """Clique gauche souris"""
    x = INPUT(type=INPUT_MOUSE,
              mi=MOUSEINPUT(0, 0, 0, MOUSEEVENTF_LEFTDOWN, 0, None))
    SendInput(1, ctypes.byref(x), ctypes.sizeof(x))
    x = INPUT(type=INPUT_MOUSE,
              mi=MOUSEINPUT(0, 0, 0, MOUSEEVENTF_LEFTUP, 0, None))
    SendInput(1, ctypes.byref(x), ctypes.sizeof(x))

def farm(min_key, max_key):
    """Spam touches min → max et clic"""
    while True:
        for key in range(min_key, max_key+1):
            vk_code = 0x30 + key if 0 <= key <= 9 else None
            if vk_code:
                press_key(vk_code)
                time.sleep(0.05)  # évite trop de vitesse
                click_mouse()
                time.sleep(0.05)

farm(1, 5)
