# zmk-barrack

![schematic](img/xiao-nrf--zmk-barrack1.png)

My personal minimal (and *naughty*) zmk-config that can be used as a skeleton.

I often use this repo to write/check my zmk-modules rather than creating keyboards.

To tailor your new keyboards, I'd recommend to base the [unified-zmk-config-template](https://github.com/zmkfirmware/unified-zmk-config-template) of course.

# Setup
```
cd ~/Downloads
git clone git@github.com:hidsh/zmk-barrack.git
cd zmk-barrack
./_rename.sh     # rename directories and files and replace strings in some files
                 # to use as your *new* zmk-config according to your naming.

cd /PATH/TO/zmk/app
ln -sf /PATH/TO/zmk-NEW_NAME/NEW_NAME.mk .
```

# Build/Flash a new firmware
```
cd /PATH/TO/zmk/app
make -f NEW_NAME.mk
```
