# Fourier
Program to estimate curves with harmonics

## Building
1. Download *Processing 3+* version from https://www.processing.org/download/
2. Download *.pde* files and open them, using *Processing*.
3. Run the code and enjoy!

## Controls
Press **LMB** and drag your mouse on the screen. Program will store the path you drew as grey dots. That will become the input curve.
After releasing, program will start to draw its curve as white dots. Note that program curve is smoother than the input curve. It is because program curve is a sum of multiple harmonics (aka arrows, rotating with integer speeds). You can press **h** to show all the arrows, contributing to the result. You can press **left and right arrows** to change the number of arrows. Press **c** to center the camera on the end of the last arrow. Don't get dizzy! To change framerate (speed of the program), press **up and down arrows**. If you want to get a closer look, you can zoom in and out using **z** and **x**.
If ypu want to draw another curve, press **r** to reset. To exit just press **ESC**.

## How does it work?
Essentially it uses complex numbers to calculate center of mass of the input curve. Programm does that multiple times, simultaneously rotating it, thus creating *weights* - positions of those centers of mass. Those *weights* are the initial positions of the arrows - phases.
For better explanation use video by *3Blue1Brown*: https://www.youtube.com/watch?v=r6sGWTCMz2k. This program is heavily inspired by it.
