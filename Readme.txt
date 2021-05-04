Instructions for bodyWeightTracker.m

ALERT - CONSULT YOUR PHYSICIAN BEFORE BEGINNING ANY WEIGHT LOSS DIET
THIS PROGRAM IS FOR EDUCATIONAL PURPOSES ONLY.  DO NOT ATTEMPT FOR PERSONAL
OR PROFESSIONAL USE.

UPDATED NOTES-
Included is a txt file containing values for the first 20 days of my weight
loss phase at the beginning of the semester in order to showcase the
functionality of the GUI.  If you wish to play around with the data, you'll
need to begin the logging with your first entry beginning at day 21.  If
you want to start with fresh data, open 'recordedBodyWeights.txt'
manually and delete all data.  If you want to delete a point entered,
open 'recordedBodyWeights.txt' and delete the entire row/line corresponding
to the point you wish to delete.  To view the trend lines, simply click
on the slider or drag to desired rate of weight loss.

1)  Make sure Matlab directory contains bodyWeightTracker.m
2)  Open the .m file or type bodyWeightTracker in the command window.

The GUI is setup to be used on a daily basis.  

1)  Weigh yourself in the morning after going to the bathroom and beforming
    consuming anything.
2)  Use a calorie tracking system such as myfitnesspal to track daily calories
    consumed.
3)  Calculate your estimated total daily energy expenditure or TDEE
    by using prebuilt estimation calculators which can be found online
    using a google search for "TDEE Calculator".
4)  Start from the top right of the GUI panel and enter the corresponding values,
    filling each field before clicking on the button labeled "Weigh In!".
    a)  All values must be numbers.
    b)  All numbers must be positive.
    c)  There must be no duplicate values recorded in the "Day" field.
    d)  If an incorrect input results in an error message in the edit boxes,
        you must fully delete the error messages by clicking on the
        "Clear Fields" button to the right of the "Weight" input box.
5)  Then, select your desired rate of weight loss using the slider below
    the input boxes.
    a)  The upper threshold corresponds to an aggressive rate of -1.5% of
        body weight loss per week.
    b)  The lower threshold corresponds to a conservative rate of -0.5% of 
        body weight loss per week.
    c)  If this is your first time dieting, it's highly recommended to use
        a conservative to moderate rate of weight loss between -0.5% and
        -1.0% body weight loss per week.
6)  Your recorded body weights, the trendline estimating your actual rate of
    weight loss, and your desired rate of weight loss will be displayed in
    the graph.  The legend to the top right of the graph labels the data
    being visualized.
7)  Next, click the buttom on the bottom left labeled "Calculate Average
    Caloric Deficit" and your average caloric deficit will be displayed below
    the button.
8)  Likewise, you may click the buttons to the right labeled "Calculate Avg
    Loss/Week" and "Calculate Daily Calories Needed" and the values
    will be displayed below the buttons.
9)  Remember, weight fluctuations are completely normal and the graph will
    help you visualize your overall trends and keep you on track!
10) Keep working hard and have fun!