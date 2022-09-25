classdef HilbertAppRaw < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                matlab.ui.Figure
        Image                   matlab.ui.control.Image
        HilbertInstantaneousFrequencySolverLabel  matlab.ui.control.Label
        COSC591594T22022Label   matlab.ui.control.Label
        BaseFrequencyHzLabel    matlab.ui.control.Label
        FrequencyChangesLabel   matlab.ui.control.Label
        DurationsLabel          matlab.ui.control.Label
        SamplingRateHzLabel     matlab.ui.control.Label
        TextBaseFrequency       matlab.ui.control.NumericEditField
        TextFrequencyChanges    matlab.ui.control.NumericEditField
        TextDuration            matlab.ui.control.NumericEditField
        TextSamplingRate        matlab.ui.control.NumericEditField
        BaseFrequencyHzSlider   matlab.ui.control.Slider
        FrequencyChangesSlider  matlab.ui.control.Slider
        DurationsSlider         matlab.ui.control.Slider
        SamplingRateHzSlider    matlab.ui.control.Slider
        Transformation          matlab.ui.control.UIAxes
        PhaseAngle              matlab.ui.control.UIAxes
        InputSignal             matlab.ui.control.UIAxes
        ActualFreq              matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        FreqTSHold % Parameter to be passed amongst event functions to hold
                   % existing input signal
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            clc
            % Set initial values on launch.
            % Set variables to take values from slider inputs
            fs = app.SamplingRateHzSlider.Value;
            StopTime = app.DurationsSlider.Value;
            FreqChg = app.FrequencyChangesSlider.Value;
            BaseFreq = app.BaseFrequencyHzSlider.Value;

            % Set text boxes to the values of the sliders
            app.TextSamplingRate.Value = round(fs);
            app.TextDuration.Value = round(StopTime);
            app.TextFrequencyChanges.Value = round(FreqChg);
            app.TextBaseFrequency.Value = round(BaseFreq);

            % Call Hilbert transform function
            [t,tout,freqTS,data,z,instfrq,magField,TSHeld] = HilbertFunction(round(fs),round(StopTime),round(FreqChg),round(BaseFreq),0);
            
            %Generate all plots

            %Plot Actual Frequency
            app.FreqTSHold = TSHeld;
            plot(app.ActualFreq,t,freqTS)
            title(app.ActualFreq,'Actual Frequency of Generated Signal')
            xlabel(app.ActualFreq,'Time Elapsed (s)');
            ylabel(app.ActualFreq,'Frequency (Hz)')
            
            %Plot Input Signal
            plot(app.InputSignal,t,data)
            title(app.InputSignal,'Input Signal')
            xlabel(app.InputSignal,'Time Elapsed (s)');
            
            %Plot Phase angle
            plot(app.PhaseAngle,t,angle(z))
            title(app.PhaseAngle,'Phase')
            ylabel(app.PhaseAngle,'Phase (rad.)')
            
            %Plot Final output transformation
            yyaxis(app.Transformation,"left")
            plot(app.Transformation,tout(1:numel(t)-1),instfrq)
            hold (app.Transformation,"on")
            plot(app.Transformation,tout,freqTS)
            title(app.Transformation,'Hilbert Transformed Frequency and Magnetic Field')
            xlabel(app.Transformation,'Time Elapsed (s)')
            ylabel(app.Transformation,'Frequency (Hz)')
            ylim(app.Transformation,[min(freqTS) max(freqTS)])
            hold (app.Transformation,"off")
            yyaxis(app.Transformation,"right")
            plot(app.Transformation,tout(1:numel(t)-1),magField,":")
            ylabel(app.Transformation,'Magnetic Field (nT)')
            ylim(app.Transformation,[(min(freqTS/3.5)) (max(freqTS/3.5))])
            legend(app.Transformation,'Transformed','Actual','Magnetic Field (RHS)','location','southeast')
        end

        % Value changed function: SamplingRateHzSlider
        function SamplingRateHzSliderValueChanged(app, event)
              
            % Set variables to take values from slider inputs
            fs = app.SamplingRateHzSlider.Value;
            StopTime = app.DurationsSlider.Value;
            FreqChg = app.FrequencyChangesSlider.Value;
            BaseFreq = app.BaseFrequencyHzSlider.Value;
            app.TextSamplingRate.Value = round(fs);

            % Call Hilbert transform function
            [t,tout,freqTS,data,z,instfrq,magField] = HilbertFunction(round(fs),round(StopTime),round(FreqChg),round(BaseFreq),app.FreqTSHold);
          
            %Generate all plots

            %Plot Actual Frequency
            plot(app.ActualFreq,t,freqTS)
            title(app.ActualFreq,'Actual Frequency of Generated Signal')
            xlabel(app.ActualFreq,'Time Elapsed (s)');
            ylabel(app.ActualFreq,'Frequency (Hz)')
            
            %Plot input signal
            plot(app.InputSignal,t,data)
            title(app.InputSignal,'Input Signal')
            xlabel(app.InputSignal,'Time Elapsed (s)');
            
            %Phase angle
            plot(app.PhaseAngle,t,angle(z))
            title(app.PhaseAngle,'Phase')
            ylabel(app.PhaseAngle,'Phase (rad.)')
            
            %Transformation
            yyaxis(app.Transformation,"left")
            plot(app.Transformation,tout(1:numel(t)-1),instfrq)
            hold (app.Transformation,"on")
            plot(app.Transformation,tout,freqTS)
            title(app.Transformation,'Hilbert Transformed Frequency and Magnetic Field')
            xlabel(app.Transformation,'Time Elapsed (s)')
            ylabel(app.Transformation,'Frequency (Hz)')
            ylim(app.Transformation,[min(freqTS) max(freqTS)])
             hold (app.Transformation,"off")
            yyaxis(app.Transformation,"right")
             plot(app.Transformation,tout(1:numel(t)-1),magField,":")
            ylabel(app.Transformation,'Magnetic Field (nT)')
            ylim(app.Transformation,[(min(freqTS/3.5)) (max(freqTS/3.5))])
           
            legend(app.Transformation,'Transformed','Actual','Magnetic Field (RHS)','location','southeast')
            
        end

        % Value changed function: DurationsSlider
        function DurationsSliderValueChanged(app, event)
            % Set variables to take values from slider inputs
            fs = app.SamplingRateHzSlider.Value;
            StopTime = app.DurationsSlider.Value;
            FreqChg = app.FrequencyChangesSlider.Value;
            BaseFreq = app.BaseFrequencyHzSlider.Value;
            app.TextDuration.Value = round(StopTime);
            
            % Call Hilbert transform function
            [t,tout,freqTS,data,z,instfrq,magField,TSHeld] = HilbertFunction(round(fs),round(StopTime),round(FreqChg),round(BaseFreq),0);
            
            %Generate all plots

            %Plot Actual Frequency
            app.FreqTSHold = TSHeld;
            plot(app.ActualFreq,t,freqTS)
            title(app.ActualFreq,'Actual Frequency of Generated Signal')
            xlabel(app.ActualFreq,'Time Elapsed (s)');
            ylabel(app.ActualFreq,'Frequency (Hz)')
            
            %input signal
            plot(app.InputSignal,t,data)
            title(app.InputSignal,'Input Signal')
            xlabel(app.InputSignal,'Time Elapsed (s)');
            
            %Phase angle
            plot(app.PhaseAngle,t,angle(z))
            title(app.PhaseAngle,'Phase')
            ylabel(app.PhaseAngle,'Phase (rad.)')
            
            %Transformation
            yyaxis(app.Transformation,"left")
            plot(app.Transformation,tout(1:numel(t)-1),instfrq)
            hold (app.Transformation,"on")
            plot(app.Transformation,tout,freqTS)
            title(app.Transformation,'Hilbert Transformed Frequency and Magnetic Field')
            xlabel(app.Transformation,'Time Elapsed (s)')
            ylabel(app.Transformation,'Frequency (Hz)')
            ylim(app.Transformation,[min(freqTS) max(freqTS)])
            hold (app.Transformation,"off")
            yyaxis(app.Transformation,"right")
            plot(app.Transformation,tout(1:numel(t)-1),magField,":")
            ylabel(app.Transformation,'Magnetic Field (nT)')
            ylim(app.Transformation,[(min(freqTS/3.5)) (max(freqTS/3.5))])
            legend(app.Transformation,'Transformed','Actual','Magnetic Field (RHS)','location','southeast')
            
        end

        % Value changed function: FrequencyChangesSlider
        function FrequencyChangesSliderValueChanged(app, event)
            % Set variables to take values from slider inputs  
            fs = app.SamplingRateHzSlider.Value;
            StopTime = app.DurationsSlider.Value;
            FreqChg = app.FrequencyChangesSlider.Value;
            BaseFreq = app.BaseFrequencyHzSlider.Value;
            app.TextFrequencyChanges.Value = round(FreqChg);
             
            % Call Hilbert transform function
            [t,tout,freqTS,data,z,instfrq,magField,TSHeld] = HilbertFunction(round(fs),round(StopTime),round(FreqChg),round(BaseFreq),0);
            
            %Generate all plots

            %Plot Actual Frequency
            app.FreqTSHold = TSHeld;
            plot(app.ActualFreq,t,freqTS)
            title(app.ActualFreq,'Actual Frequency of Generated Signal')
            xlabel(app.ActualFreq,'Time Elapsed (s)');
            ylabel(app.ActualFreq,'Frequency (Hz)')
            
            %input signal
            plot(app.InputSignal,t,data)
            title(app.InputSignal,'Input Signal')
            xlabel(app.InputSignal,'Time Elapsed (s)');
            
            %Phase angle
            plot(app.PhaseAngle,t,angle(z))
            title(app.PhaseAngle,'Phase')
            ylabel(app.PhaseAngle,'Phase (rad.)')
            
            %transformation
            yyaxis(app.Transformation,"left")
            plot(app.Transformation,tout(1:numel(t)-1),instfrq)
            hold (app.Transformation,"on")
            plot(app.Transformation,tout,freqTS)
            title(app.Transformation,'Hilbert Transformed Frequency and Magnetic Field')
            xlabel(app.Transformation,'Time Elapsed (s)')
            ylabel(app.Transformation,'Frequency (Hz)')
            ylim(app.Transformation,[min(freqTS) max(freqTS)])
            hold (app.Transformation,"off")
            yyaxis(app.Transformation,"right")
            plot(app.Transformation,tout(1:numel(t)-1),magField,":")
            ylabel(app.Transformation,'Magnetic Field (nT)')
            ylim(app.Transformation,[(min(freqTS/3.5)) (max(freqTS/3.5))])
            legend(app.Transformation,'Transformed','Actual','Magnetic Field (RHS)','location','southeast')
            
        end

        % Value changed function: BaseFrequencyHzSlider
        function BaseFrequencyHzSliderValueChanged(app, event)
            % Set variables to take values from slider inputs 
            fs = app.SamplingRateHzSlider.Value;
            StopTime = app.DurationsSlider.Value;
            FreqChg = app.FrequencyChangesSlider.Value;
            BaseFreq = app.BaseFrequencyHzSlider.Value;
            app.TextBaseFrequency.Value = round(BaseFreq);
            
            % Call Hilbert transform function
            [t,tout,freqTS,data,z,instfrq,magField,TSHeld] = HilbertFunction(round(fs),round(StopTime),round(FreqChg),round(BaseFreq),0);
            %Generate all plots

            %Plot Actual Frequency
            app.FreqTSHold = TSHeld;
            plot(app.ActualFreq,t,freqTS)
            title(app.ActualFreq,'Actual Frequency of Generated Signal')
            xlabel(app.ActualFreq,'Time Elapsed (s)');
            ylabel(app.ActualFreq,'Frequency (Hz)')
            
            %input signal
            plot(app.InputSignal,t,data)
            title(app.InputSignal,'Input Signal')
            xlabel(app.InputSignal,'Time Elapsed (s)');
            
            %Phase angle
            plot(app.PhaseAngle,t,angle(z))
            title(app.PhaseAngle,'Phase')
            ylabel(app.PhaseAngle,'Phase (rad.)')
            
            %transformation
            yyaxis(app.Transformation,"left")
            plot(app.Transformation,tout(1:numel(t)-1),instfrq)
            hold (app.Transformation,"on")
            plot(app.Transformation,tout,freqTS)
            title(app.Transformation,'Hilbert Transformed Frequency and Magnetic Field')
            xlabel(app.Transformation,'Time Elapsed (s)')
            ylabel(app.Transformation,'Frequency (Hz)')
            ylim(app.Transformation,[min(freqTS) max(freqTS)])
            hold (app.Transformation,"off")
            yyaxis(app.Transformation,"right")
            plot(app.Transformation,tout(1:numel(t)-1),magField,":")
            ylabel(app.Transformation,'Magnetic Field (nT)')
            ylim(app.Transformation,[(min(freqTS/3.5)) (max(freqTS/3.5))])
            legend(app.Transformation,'Transformed','Actual','Magnetic Field (RHS)','location','southeast')
            
        end

        % Value changed function: TextSamplingRate
        function TextSamplingRateValueChanged(app, event)
            % Set variables to take values from slider inputs  
            fs = app.TextSamplingRate.Value;
            app.SamplingRateHzSlider.Value = app.TextSamplingRate.Value;  
            StopTime = app.DurationsSlider.Value;
            FreqChg = app.FrequencyChangesSlider.Value;
            BaseFreq = app.BaseFrequencyHzSlider.Value;
            app.TextSamplingRate.Value = round(fs);
         
            % Call Hilbert transform function
            [t,tout,freqTS,data,z,instfrq,magField] = HilbertFunction(round(fs),round(StopTime),round(FreqChg),round(BaseFreq),app.FreqTSHold);
            
            %Generate all plots

            %Plot Actual Frequency
            plot(app.ActualFreq,t,freqTS)
            title(app.ActualFreq,'Actual Frequency of Generated Signal')
            xlabel(app.ActualFreq,'Time Elapsed (s)');
            ylabel(app.ActualFreq,'Frequency (Hz)')
            
            %input signal
            plot(app.InputSignal,t,data)
            title(app.InputSignal,'Input Signal')
            xlabel(app.InputSignal,'Time Elapsed (s)');
            
            %Phase angle
            plot(app.PhaseAngle,t,angle(z))
            title(app.PhaseAngle,'Phase')
            ylabel(app.PhaseAngle,'Phase (rad.)')
            
            %transformation
            yyaxis(app.Transformation,"left")
            plot(app.Transformation,tout(1:numel(t)-1),instfrq)
            hold (app.Transformation,"on")
            plot(app.Transformation,tout,freqTS)
            title(app.Transformation,'Hilbert Transformed Frequency and Magnetic Field')
            xlabel(app.Transformation,'Time Elapsed (s)')
            ylabel(app.Transformation,'Frequency (Hz)')
            ylim(app.Transformation,[min(freqTS) max(freqTS)])
            hold (app.Transformation,"off")
            yyaxis(app.Transformation,"right")
            plot(app.Transformation,tout(1:numel(t)-1),magField,":")
            ylabel(app.Transformation,'Magnetic Field (nT)')
            ylim(app.Transformation,[(min(freqTS/3.5)) (max(freqTS/3.5))])
            legend(app.Transformation,'Transformed','Actual','Magnetic Field (RHS)','location','southeast')
        end

        % Value changed function: TextDuration
        function TextDurationValueChanged(app, event)
            % Set variables to take values from slider inputs
            fs = app.SamplingRateHzSlider.Value;
            StopTime = app.TextDuration.Value;
            app.DurationsSlider.Value = app.TextDuration.Value;
            FreqChg = app.FrequencyChangesSlider.Value;
            BaseFreq = app.BaseFrequencyHzSlider.Value;
            app.TextDuration.Value = round(StopTime);

             % Call Hilbert transform function
            [t,tout,freqTS,data,z,instfrq,magField,TSHeld] = HilbertFunction(round(fs),round(StopTime),round(FreqChg),round(BaseFreq),0);
           
            %Generate all plots

            %Plot Actual Frequency
            app.FreqTSHold = TSHeld;
            plot(app.ActualFreq,t,freqTS)
            title(app.ActualFreq,'Actual Frequency of Generated Signal')
            xlabel(app.ActualFreq,'Time Elapsed (s)');
            ylabel(app.ActualFreq,'Frequency (Hz)')
            
            %input signal
            plot(app.InputSignal,t,data)
            title(app.InputSignal,'Input Signal')
            xlabel(app.InputSignal,'Time Elapsed (s)');
            
            %Phase angle
            plot(app.PhaseAngle,t,angle(z))
            title(app.PhaseAngle,'Phase')
            ylabel(app.PhaseAngle,'Phase (rad.)')
            
            %transformation
            yyaxis(app.Transformation,"left")
            plot(app.Transformation,tout(1:numel(t)-1),instfrq)
            hold (app.Transformation,"on")
            plot(app.Transformation,tout,freqTS)
            title(app.Transformation,'Hilbert Transformed Frequency and Magnetic Field')
            xlabel(app.Transformation,'Time Elapsed (s)')
            ylabel(app.Transformation,'Frequency (Hz)')
            ylim(app.Transformation,[min(freqTS) max(freqTS)])
            hold (app.Transformation,"off")
            yyaxis(app.Transformation,"right")
            plot(app.Transformation,tout(1:numel(t)-1),magField,":")
            ylabel(app.Transformation,'Magnetic Field (nT)')
            ylim(app.Transformation,[(min(freqTS/3.5)) (max(freqTS/3.5))])
            legend(app.Transformation,'Transformed','Actual','Magnetic Field (RHS)','location','southeast')
            
        end

        % Value changed function: TextBaseFrequency
        function TextBaseFrequencyValueChanged(app, event)
            % Set variables to take values from slider inputs
            fs = app.SamplingRateHzSlider.Value;
            StopTime = app.TextDuration.Value;
            app.BaseFrequencyHzSlider.Value = app.TextBaseFrequency.Value;
            FreqChg = app.FrequencyChangesSlider.Value;
            BaseFreq = app.BaseFrequencyHzSlider.Value;
            app.TextDuration.Value = round(StopTime);

             % Call Hilbert transform function
            [t,tout,freqTS,data,z,instfrq,magField,TSHeld] = HilbertFunction(round(fs),round(StopTime),round(FreqChg),round(BaseFreq),0);
            
            %Generate all plots

            %Plot Actual Frequency
            app.FreqTSHold = TSHeld;
            plot(app.ActualFreq,t,freqTS)
            title(app.ActualFreq,'Actual Frequency of Generated Signal')
            xlabel(app.ActualFreq,'Time Elapsed (s)');
            ylabel(app.ActualFreq,'Frequency (Hz)')
            
            %input signal
            plot(app.InputSignal,t,data)
            title(app.InputSignal,'Input Signal')
            xlabel(app.InputSignal,'Time Elapsed (s)');
            
            %Phase angle
            plot(app.PhaseAngle,t,angle(z))
            title(app.PhaseAngle,'Phase')
            ylabel(app.PhaseAngle,'Phase (rad.)')
            
            %transformation
            yyaxis(app.Transformation,"left")
            plot(app.Transformation,tout(1:numel(t)-1),instfrq)
            hold (app.Transformation,"on")
            plot(app.Transformation,tout,freqTS)
            title(app.Transformation,'Hilbert Transformed Frequency and Magnetic Field')
            xlabel(app.Transformation,'Time Elapsed (s)')
            ylabel(app.Transformation,'Frequency (Hz)')
            ylim(app.Transformation,[min(freqTS) max(freqTS)])
            hold (app.Transformation,"off")
            yyaxis(app.Transformation,"right")
            plot(app.Transformation,tout(1:numel(t)-1),magField,":")
            ylabel(app.Transformation,'Magnetic Field (nT)')
            ylim(app.Transformation,[(min(freqTS/3.5)) (max(freqTS/3.5))])
            legend(app.Transformation,'Transformed','Actual','Magnetic Field (RHS)','location','southeast')
            
            
        end

        % Value changed function: TextFrequencyChanges
        function TextFrequencyChangesValueChanged(app, event)
            % Set variables to take values from slider inputs
            fs = app.SamplingRateHzSlider.Value;
            StopTime = app.TextDuration.Value;
            app.FrequencyChangesSlider.Value = app.TextFrequencyChanges.Value;
            FreqChg = app.FrequencyChangesSlider.Value;
            BaseFreq = app.BaseFrequencyHzSlider.Value;
            app.TextDuration.Value = round(StopTime);

             % Call Hilbert transform function
            [t,tout,freqTS,data,z,instfrq,magField,TSHeld] = HilbertFunction(round(fs),round(StopTime),round(FreqChg),round(BaseFreq),0);
            
            %Generate all plots

            %Plot Actual Frequency
            app.FreqTSHold = TSHeld;
            plot(app.ActualFreq,t,freqTS)
            title(app.ActualFreq,'Actual Frequency of Generated Signal')
            xlabel(app.ActualFreq,'Time Elapsed (s)');
            ylabel(app.ActualFreq,'Frequency (Hz)')
            
            %input signal
            plot(app.InputSignal,t,data)
            title(app.InputSignal,'Input Signal')
            xlabel(app.InputSignal,'Time Elapsed (s)');
            
            %Phase angle
            plot(app.PhaseAngle,t,angle(z))
            title(app.PhaseAngle,'Phase')
            ylabel(app.PhaseAngle,'Phase (rad.)')
            
            %transformation
            yyaxis(app.Transformation,"left")
            plot(app.Transformation,tout(1:numel(t)-1),instfrq)
            hold (app.Transformation,"on")
            plot(app.Transformation,tout,freqTS)
            title(app.Transformation,'Hilbert Transformed Frequency and Magnetic Field')
            xlabel(app.Transformation,'Time Elapsed (s)')
            ylabel(app.Transformation,'Frequency (Hz)')
            ylim(app.Transformation,[min(freqTS) max(freqTS)])
            hold (app.Transformation,"off")
            yyaxis(app.Transformation,"right")
            plot(app.Transformation,tout(1:numel(t)-1),magField,":")
            ylabel(app.Transformation,'Magnetic Field (nT)')
            ylim(app.Transformation,[(min(freqTS/3.5)) (max(freqTS/3.5))])
            legend(app.Transformation,'Transformed','Actual','Magnetic Field (RHS)','location','southeast')
            
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 814 743];
            app.UIFigure.Name = 'MATLAB App';

            % Create ActualFreq
            app.ActualFreq = uiaxes(app.UIFigure);
            title(app.ActualFreq, 'Title')
            xlabel(app.ActualFreq, 'X')
            ylabel(app.ActualFreq, 'Y')
            zlabel(app.ActualFreq, 'Z')
            app.ActualFreq.Position = [471 523 329 108];

            % Create InputSignal
            app.InputSignal = uiaxes(app.UIFigure);
            title(app.InputSignal, 'Title')
            xlabel(app.InputSignal, 'X')
            ylabel(app.InputSignal, 'Y')
            zlabel(app.InputSignal, 'Z')
            app.InputSignal.Position = [471 409 329 108];

            % Create PhaseAngle
            app.PhaseAngle = uiaxes(app.UIFigure);
            title(app.PhaseAngle, 'Title')
            xlabel(app.PhaseAngle, 'X')
            ylabel(app.PhaseAngle, 'Y')
            zlabel(app.PhaseAngle, 'Z')
            app.PhaseAngle.Position = [471 295 329 108];

            % Create Transformation
            app.Transformation = uiaxes(app.UIFigure);
            title(app.Transformation, 'Title')
            xlabel(app.Transformation, 'X')
            ylabel(app.Transformation, 'Y')
            zlabel(app.Transformation, 'Z')
            app.Transformation.Position = [12 49 788 234];

            % Create SamplingRateHzSlider
            app.SamplingRateHzSlider = uislider(app.UIFigure);
            app.SamplingRateHzSlider.Limits = [10 5000000];
            app.SamplingRateHzSlider.MajorTicks = [10 2500 5000 7500 10000];
            app.SamplingRateHzSlider.MajorTickLabels = {'10', '2500', '5000', '7500', '10,000'};
            app.SamplingRateHzSlider.ValueChangedFcn = createCallbackFcn(app, @SamplingRateHzSliderValueChanged, true);
            app.SamplingRateHzSlider.Position = [35 589 310 3];
            app.SamplingRateHzSlider.Value = 1000;

            % Create DurationsSlider
            app.DurationsSlider = uislider(app.UIFigure);
            app.DurationsSlider.Limits = [1 5];
            app.DurationsSlider.MajorTicks = [1 2 3 4 5];
            app.DurationsSlider.ValueChangedFcn = createCallbackFcn(app, @DurationsSliderValueChanged, true);
            app.DurationsSlider.MinorTicks = [];
            app.DurationsSlider.Position = [37 348 310 3];
            app.DurationsSlider.Value = 1;

            % Create FrequencyChangesSlider
            app.FrequencyChangesSlider = uislider(app.UIFigure);
            app.FrequencyChangesSlider.Limits = [10 1000];
            app.FrequencyChangesSlider.ValueChangedFcn = createCallbackFcn(app, @FrequencyChangesSliderValueChanged, true);
            app.FrequencyChangesSlider.Position = [38 426 310 3];
            app.FrequencyChangesSlider.Value = 100;

            % Create BaseFrequencyHzSlider
            app.BaseFrequencyHzSlider = uislider(app.UIFigure);
            app.BaseFrequencyHzSlider.Limits = [10 270000];
            app.BaseFrequencyHzSlider.ValueChangedFcn = createCallbackFcn(app, @BaseFrequencyHzSliderValueChanged, true);
            app.BaseFrequencyHzSlider.Position = [36 510 310 3];
            app.BaseFrequencyHzSlider.Value = 100;

            % Create TextSamplingRate
            app.TextSamplingRate = uieditfield(app.UIFigure, 'numeric');
            app.TextSamplingRate.ValueChangedFcn = createCallbackFcn(app, @TextSamplingRateValueChanged, true);
            app.TextSamplingRate.Tooltip = {'Selected Sampling Rate in Hertz.'};
            app.TextSamplingRate.Position = [373 580 57 22];

            % Create TextDuration
            app.TextDuration = uieditfield(app.UIFigure, 'numeric');
            app.TextDuration.ValueChangedFcn = createCallbackFcn(app, @TextDurationValueChanged, true);
            app.TextDuration.Tooltip = {'Signal duration in seconds.'};
            app.TextDuration.Position = [373 338 57 22];

            % Create TextFrequencyChanges
            app.TextFrequencyChanges = uieditfield(app.UIFigure, 'numeric');
            app.TextFrequencyChanges.ValueChangedFcn = createCallbackFcn(app, @TextFrequencyChangesValueChanged, true);
            app.TextFrequencyChanges.Tooltip = {'Number of times the frqeuency of the input signal will change.'};
            app.TextFrequencyChanges.Position = [373 417 57 22];

            % Create TextBaseFrequency
            app.TextBaseFrequency = uieditfield(app.UIFigure, 'numeric');
            app.TextBaseFrequency.ValueChangedFcn = createCallbackFcn(app, @TextBaseFrequencyValueChanged, true);
            app.TextBaseFrequency.Tooltip = {'Base, or average, signal frequency.'};
            app.TextBaseFrequency.Position = [373 500 57 22];

            % Create SamplingRateHzLabel
            app.SamplingRateHzLabel = uilabel(app.UIFigure);
            app.SamplingRateHzLabel.Position = [35 603 131 22];
            app.SamplingRateHzLabel.Text = 'Sampling Rate (Hz)';

            % Create DurationsLabel
            app.DurationsLabel = uilabel(app.UIFigure);
            app.DurationsLabel.Position = [37 358 68 22];
            app.DurationsLabel.Text = 'Duration (s)';

            % Create FrequencyChangesLabel
            app.FrequencyChangesLabel = uilabel(app.UIFigure);
            app.FrequencyChangesLabel.Position = [38 437 114 22];
            app.FrequencyChangesLabel.Text = 'Frequency Changes';

            % Create BaseFrequencyHzLabel
            app.BaseFrequencyHzLabel = uilabel(app.UIFigure);
            app.BaseFrequencyHzLabel.Position = [36 523 119 22];
            app.BaseFrequencyHzLabel.Text = 'Base Frequency (Hz)';

            % Create COSC591594T22022Label
            app.COSC591594T22022Label = uilabel(app.UIFigure);
            app.COSC591594T22022Label.HorizontalAlignment = 'right';
            app.COSC591594T22022Label.Position = [567 12 233 35];
            app.COSC591594T22022Label.Text = 'COSC591/594 T2 2022';

            % Create HilbertInstantaneousFrequencySolverLabel
            app.HilbertInstantaneousFrequencySolverLabel = uilabel(app.UIFigure);
            app.HilbertInstantaneousFrequencySolverLabel.FontSize = 25;
            app.HilbertInstantaneousFrequencySolverLabel.FontWeight = 'bold';
            app.HilbertInstantaneousFrequencySolverLabel.Position = [24 694 487 31];
            app.HilbertInstantaneousFrequencySolverLabel.Text = 'Hilbert Instantaneous Frequency Solver';

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.Position = [688 635 100 100];
            app.Image.ImageSource = 'unelogo.png';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = HilbertAppRaw

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end