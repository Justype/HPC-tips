# Useful Linux Apps

1. [barrier](https://github.com/debauchee/barrier) share keyboard and mouse across win, unix, and linux
2. [input-remapper](https://github.com/sezanzeb/input-remapper) remap keys nad mouse buttons


## Barrier Troubleshooting

`ERROR: ssl certificate doesn't exist: $HOME/.local/share/barrier/SSL/Barrier.pem`

fix: https://stackoverflow.com/questions/67343804/error-ssl-certificate-doesnt-exist-home-rsvay-snap-barrier-kvm-2-local-shar

```bash
cd $HOME/.local/share/barrier/SSL/
openssl req -x509 -nodes -days 365 -subj /CN=barrier -newkey rsa:4096 -keyout Barrier.pem -out Barrier.pem
```

## Input remapper

- Mouse
  - `Extra` => `repeat(2, key(BTN_LEFT).w(100))`
- Keyboard
  - `CapsLock` => `if_tap(key(Escape), key(Caps_Lock))`

## Touchpad Scroll too sensitve

1. `xinput --list` check the touchpad ID
2. `xinput --set-prop "YOUR TOUCHPAD" "libinput Scrolling Pixel Distance" YOUR_SPEED` (larger => less sensitive) I used 40.


