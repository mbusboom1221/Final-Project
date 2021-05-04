%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% ALERT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% CONSULT YOUR PHYSICIAN BEFORE BEGINNING ANY DIET %%%%%%%%%%%%%%%%%%
%%%% THIS PROGRAM IS BUILT FOR EDUCATIONAL PURPOSES ONLY %%%%%%%%%%%%%%%
%%%% This educational program will open a GUI panel that will allow %%%%
%%%% a user to track their weight loss progress and provide calorie %%%%
%%%% intake suggestions based on their goal rate of weight loss.%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [] = bodyWeightTracker()
    close all;
    global gui;
    %This will set the position of the GUI popup to the lefthand side of
    %the screen and also changes the size
    gui.fig = figure('position',[500 500 1000 500]);
    gui.p = plot(0,0);
    %changes the overall size and position of the graph inside the figure
    gui.p.Parent.Position = [.32 .25 .61 .6];
    %limits and labels to ensure the graph stays the same size with the
    %same levels when certain callbacks are executed
    xlim(gui.p.Parent,[1,30]);
    xlim(gui.p.Parent,'manual');
    xlabel(gui.p.Parent,'Day');
    ylabel(gui.p.Parent,'Weight (lbs.)');
    legend('Legend','location','northeast');
    hold on;
    %Creates or reads from existing file to enable long term use of the
    %function
    fopen('recordedBodyWeights.txt','a');
    %Creates a global variable containing a matrix filled with all the core
    %data needed for functionality
    global fitnessMatrix;
    fitnessMatrix=[];
    fitnessMatrix=readmatrix('recordedBodyWeights.txt');
    %Need to use global variables in order for all the functions to be able
    %to operate on the same data and so that the function will retain the
    %data throughout runtime as the function cannot write to or call from a
    %file (Updated with FileIO support).
    global days;
    global weights;
    global caloriesIn;
    global caloriesOut;
    global weeklyLossRate;
    global avgDef;
    avgDef=[];
    days=[];
    weights=[];
    caloriesIn=[];
    caloriesOut=[];
    %Update-Had to add an if block to prevent an error when attempting
    %index an matrix with a size of 0
    if size(fitnessMatrix)>0
        days=fitnessMatrix(:,1);
        weights=fitnessMatrix(:,2);
        caloriesIn=fitnessMatrix(:,3);
        caloriesOut=fitnessMatrix(:,4);
    end
    weeklyLossRate=[];
    plot(days,weights,'r*');
    %The gui structures set the layout and function of the GUI
    gui.labelWeight = uicontrol('style','text','string','Weight','units','normalized','position',[.05 .93 .2 .05]);
    gui.inputWeight = uicontrol('style','edit','units','normalized','position',[.05 .9 .2 .05]);
    gui.clearFieldsButton = uicontrol('style','pushbutton','string','Clear Fields','units','normalized','position',[.26 .9 .2 .05],'callback',@clearFields);
    gui.labelCaloriesIn = uicontrol('style','text','string','Calories In','units','normalized','position',[.05 .85 .2 .05]);
    gui.inputCaloriesIn = uicontrol('style','edit','units','normalized','position',[.05 .81 .2 .05]);
    gui.labelCaloriesOut = uicontrol('style','text','string','Calories Out (TDEE)','units','normalized','position',[.05 .76 .2 .05]);
    gui.inputCaloriesOut = uicontrol('style','edit','units','normalized','position',[.05 .72 .2 .05]);
    gui.labelDayNumber = uicontrol('style','text','string','Day Number','units','normalized','position',[.05 .67 .2 .05]);
    gui.inputDayNumber = uicontrol('style','edit','units','normalized','position',[.05 .63 .2 .05]);
    gui.weighInButton = uicontrol('style','pushbutton','string','Weigh In!','units','normalized','position',[.05 .56 .2 .05],'callback',@bodyWeightPlot);
    gui.weightLossRateSlider = uicontrol('style','slider','units','normalized','position',[.125 .07 .05 .435],'value',.01,'min',.005,'max',.015,'callback',@goalWeightTrendline);
    gui.labelSliderHigh = uicontrol('style','text','string','Aggressive (-1.5%BW/week)','units','normalized','position',[.05 .5 .2 .05]);
    gui.labelSliderLow = uicontrol('style','text','string','Conservative (-.5%BW/week)','units','normalized','position',[.05 .0001 .2 .05]);
    gui.resetButton = uicontrol('style','pushbutton','string','Reset','units','normalized','position',[.75 .9 .2 .05],'callback',@resetGUI);
    gui.avgDeficit= uicontrol('style','pushbutton','string','Calculate Average Caloric Deficit','units','normalized','position',[.32 .1 .2 .05],'callback',@averageCalories);
    gui.avgDeficitDisplay= uicontrol('style','text','units','normalized','position',[.32 .025 .2 .05]);
    gui.avgRateLoss= uicontrol('style','pushbutton','string','Calculate Avg Loss/Week','units','normalized','position',[.525 .1 .2 .05],'callback',@bodyWeightTrendline);
    gui.avgRateLossDisplay= uicontrol('style','text','units','normalized','position',[.525 .025 .2 .05]);
    gui.dailyIntakeSuggestion= uicontrol('style','pushbutton','string','Calculate Daily Calories Goal','units','normalized','position',[.73 .1 .2 .05],'callback',@nutritionSuggestion);
    gui.intakeSuggestionDisplay= uicontrol('style','text','units','normalized','position',[.73 .025 .2 .05]);
    
end
function [] = bodyWeightPlot(~,~)
    global gui;
    global days;
    global fitnessMatrix;
    hold on;
    %This if block checks to make sure there are numeric values entered
    %into all input edit boxes and positive numeric values only
    if isempty(gui.inputDayNumber.String)==1 || str2double(gui.inputDayNumber.String)<=0 || isempty(str2num(gui.inputDayNumber.String))== 1 ||...
            isempty(gui.inputCaloriesIn.String)==1 || str2double(gui.inputCaloriesIn.String)<=0 || isempty(str2num(gui.inputCaloriesIn.String))== 1 ||...
            isempty(gui.inputCaloriesOut.String)==1 || str2double(gui.inputCaloriesOut.String)<=0 || isempty(str2num(gui.inputCaloriesOut.String))== 1 ||...
            isempty(gui.inputWeight.String)==1 || str2double(gui.inputWeight.String)<=0 || isempty(str2num(gui.inputWeight.String))== 1
        gui.inputDayNumber.String='Please Enter Positive Number';
        gui.inputWeight.String='Please Enter Positive Number';
        gui.inputCaloriesIn.String='Please Enter Positive Number';
        gui.inputCaloriesOut.String='Please Enter Positive Number';
        return
    end
    %This if block checks to make sure there aren't any accidentally
    %duplicated day numbers
    if any(days(:) == str2double(gui.inputDayNumber.String)) == 1
        gui.inputDayNumber.String = 'Oops! Day Already Recorded!';
        return;
    end
    fitnessMatrix=[fitnessMatrix;str2double(gui.inputDayNumber.String),str2double(gui.inputWeight.String)...
        ,str2double(gui.inputCaloriesIn.String),str2double(gui.inputCaloriesOut.String)];
    dlmwrite('recordedBodyWeights.txt',fitnessMatrix);
    plot(fitnessMatrix(:,1),fitnessMatrix(:,2),'r*');
    %Clears all the user input boxes upon successful input of data
    gui.inputWeight.String=[];
    gui.inputDayNumber.String=[];
    gui.inputCaloriesIn.String=[];
    gui.inputCaloriesOut.String=[];

end
function [] = averageCalories(~,~)
global gui;
global caloriesIn;
global caloriesOut;
global avgDef;
global weights;
%Prevents an error when not enough points are entered
if length(weights)<3
    gui.avgDeficitDisplay.String='Insufficient Data';
    return;
end
%Calculates an average of calories consumed per day
avgCalsIn=sum(caloriesIn)/length(caloriesIn);
%Calculates an average of calories burned per day
avgCalsOut=sum(caloriesOut)/length(caloriesOut);
%Calculates the average deficit per day
avgDef=avgCalsIn-avgCalsOut;
%Displays the average deficit per day for the user below the button
%labeled "Calculate Average Caloric Deficit"
gui.avgDeficitDisplay.String=avgDef;

end
function [] = bodyWeightTrendline(~,~)
global gui;
global weights;
global weeklyLossRate;
global fitnessMatrix;

%Prevents an error when not enough points are entered
if length(weights)<3
    gui.avgRateLossDisplay.String='Insufficient Data';
    return;
end
%Calculates the slope of the trendline for the user recorded weights
linearCoefficients = polyfit(fitnessMatrix(:,1),fitnessMatrix(:,2),1);
%Calculates the average rate of weight loss per day
weeklyLossRate=linearCoefficients(1)*7;
%Displays the average rate of weight loss per week for the user below
%button labeled "Calculate Avg Loss/Week"
gui.avgRateLossDisplay.String=weeklyLossRate;

end
function []= goalWeightTrendline(~,~)
global gui;
global weights;
global days;
global fitnessMatrix;
%Prevents an error when not enough points are entered
if length(days)<3
    return;
end
%Takes in the user's desired rate of weight loss with upper threshhold'
%being -1.5% of body weight per week and lower threshhold being -.5% of
%body weight per week and calculates the desired amount in pounds based on
%the user's inital weight when beginning the diet.  In future, this should
%calculate based on user's current weight for a program more conducive to
%longevity.  Lack of file writing and calling prevents long term use
%anyway in the function's current state. (Update) Added fileIO
%functionality so the function can now write to a file and read from an
%existing file.
goalWeightSlope=gui.weightLossRateSlider.Value*(-1)*weights(1)/7;
%Calculates the line equation for the user's weight trend line
f=fit(fitnessMatrix(:,1),fitnessMatrix(:,2),'poly1');
%Prevents the slider from plotting a line and keeping the line on the plot
%anytime the value of the slider is changed
hold off;
%plots the goal weight line based on the user's desired rate of loss as a
%black line
xlabel('Day');
ylabel('Weight (lbs.)');
plot(days,days*goalWeightSlope+weights(1),'k-');
xlim([1,30]);
xlabel('Day');
ylabel('Weight (lbs.)');
hold on;
%plots the user's recorded weight from each day as a red star
plot(days,weights,'r*');
%plots the user's actual weight loss trend line as a blue line
plot(f,'b-');
xlim([1,30]);
xlabel('Day');
ylabel('Weight (lbs.)');
legend('Goal Weight','Daily Weight (lbs)',...
        'Weight Loss Trend','location','northeast');
end
function [] = nutritionSuggestion(~,~)
global gui;
global weights;
global weeklyLossRate;
global avgDef;
global caloriesOut;
%Prevents an error when not enough points are entered
if length(weights)<3
    gui.intakeSuggestionDisplay.String='Insufficient Data';
    return;
end
if isempty(avgDef) == 1
    gui.intakeSuggestionDisplay.String='First, click on "Calculate Average Caloric Deficit".  Then, reclick.';
    return;
end
%calculates the desired weight loss rate
targetLoss=(-1)*weights(1)*gui.weightLossRateSlider.Value;
%calculates a ratio of the user's actual weight loss and desired rate loss
%to adjust their average deficit in order to match a deficit value that
%would result in the user's desired weight loss rate
deficitRatio=targetLoss/weeklyLossRate;
deficitNeeded=deficitRatio*avgDef;
averageCalsOut=sum(caloriesOut)/length(caloriesOut);
caloriesNeeded=averageCalsOut+deficitNeeded;
%displays the value of the calculation for the suggested caloric intake
%necessary to achieve the user's desired rate of weight loss
gui.intakeSuggestionDisplay.String=caloriesNeeded;


end
function []=clearFields(~,~)
    %Clears all the user input boxes
    global gui;
    gui.inputWeight.String=[];
    gui.inputDayNumber.String=[];
    gui.inputCaloriesIn.String=[];
    gui.inputCaloriesOut.String=[];

end
function []=resetGUI(~,~)
    global gui;
    clf(gui.fig);
    bodyWeightTracker;

end