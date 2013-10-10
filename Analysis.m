classdef Analysis < handle
    % ANALYSIS: This class takes in an object of STOCK class and
    % intializes the plot of stock price and volume as the default visuals.
    % The methods are then addition forms of analysis that are applied to
    % the historical data which are activated when checkboxes are selected
    % on the gui.
    
    properties
        Current_date
        Last_date
        Dates
        Open
        High
        Low
        Close
        Volume
        Adj_close
        
        Price_axes
        Volume_axes
        info_Panel
        tools_Panel
        xaxis_popup
        SMA_checkbox
        SMA_days_edit
        EMA_checkbox
        EMA_days_edit
        SMA_offset_checkbox
        SMA_offset_edit
        EMA_offset_checkbox
        EMA_offset_edit
        Trend_up_checkbox
        Trend_down_checkbox
        volumemax_checkbox
        volumemin_checkbox
        %legend_checkbox
        Stock_label
        
        SMA_plot
        SMA_offset_plot
        EMA_plot
        EMA_offset_plot
        Upper_plot
        Lower_plot
        Max_vol_plots
        Min_vol_plots
        
    end
    
    methods
        function obj = Analysis(ticker,cell_handles)
            % Constructor initializes the download of historical data via
            % Yahoo and plots the stock price and volume under the default
            % time scaling
            ticker = upper(ticker);
            
            % Construct dates spanning historial data of interest
            obj.Current_date = datevec(date) - [0 1 0 0 0 0];
            obj.Last_date = datevec(date) - [4 1 0 0 0 0];

            % Import data from Yahoo
            data_url = ['http://ichart.finance.yahoo.com/table.csv?',...
                        's=', ticker,...
                        '&d=', num2str(obj.Current_date(3)),...
                        '&e=', num2str(obj.Current_date(2)),...
                        '&f=', num2str(obj.Current_date(1)), '&g=d',...
                        '&a=', num2str(obj.Last_date(3)),...
                        '&b=', num2str(obj.Last_date(2)),...
                        '&c=', num2str(obj.Last_date(1)),...
                        '&ignore=.csv'];
            urlwrite(data_url,[ticker '_historical.csv']);
            fid = fopen([ticker '_historical.csv']);
            titles = textscan(fid,'%s %s %s %s %s %s %s',1, 'delimiter',',');
            historical_data = textscan(fid,'%s %f %f %f %f %f %f','delimiter',',');
            fclose(fid);
            
            % Assign property values with data
            obj.Dates = historical_data{1};
            obj.Open = historical_data{2};
            obj.High = historical_data{3};
            obj.Low = historical_data{4};
            obj.Close = historical_data{5};
            obj.Volume = historical_data{6};
            obj.Adj_close = historical_data{7};
            
            obj.Price_axes = cell_handles{1};
            obj.Volume_axes = cell_handles{2};
            obj.info_Panel = cell_handles{3};
            obj.tools_Panel = cell_handles{4};
            
            obj.xaxis_popup = cell_handles{5};
            obj.SMA_checkbox = cell_handles{6};
            obj.SMA_days_edit = cell_handles{7};
            obj.EMA_checkbox = cell_handles{27};
            obj.EMA_days_edit = cell_handles{28};
            obj.SMA_offset_checkbox = cell_handles{8};
            obj.SMA_offset_edit = cell_handles{9};
            obj.EMA_offset_checkbox = cell_handles{10};
            obj.EMA_offset_edit = cell_handles{11};
            obj.Trend_up_checkbox = cell_handles{12};
            obj.Trend_down_checkbox = cell_handles{13};
            obj.volumemax_checkbox = cell_handles{14};
            obj.volumemin_checkbox = cell_handles{15};
            %obj.legend_checkbox = cell_handles{16};
            
            obj.Stock_label = cell_handles{26};
            
            % Rounding the massive Volume numbers
            obj.Volume = round(obj.Volume*100)/100;
            
            % Plot historical closes onto Price_axes to default 3 months
            axes(obj.Price_axes)
            set(obj.Price_axes,'XLim',[0 66])
            plot(1:22*3,flipud(obj.Close(1:22*3)),'k')
            set(gca,'XTick',[1:(22*3)/7:22*3 22*3])
            set(gca,'XTickLabel',flipud(obj.Dates([1:ceil((22*3)/7):22*3 22*3])))
            
            % Plot historical volume onto Volume_axes to deafult 3 months
            axes(obj.Volume_axes)
            set(obj.Volume_axes,'XLim',[0 66])
            bar(1:22*3,flipud(obj.Volume(1:22*3)))
            set(gca,'xtick',[1:(22*3)/7:22*3 22*3])
            set(gca,'xticklabel',flipud(obj.Dates([1:ceil((22*3)/7):22*3 22*3])))
            
            % Header to the right panel for name and ticker of company
            temp_company = Stock.getStockInfo(ticker);
            temp_string = [ticker ' - ' temp_company{1}{1}];
            set(obj.Stock_label,'String',temp_string);
        end
        
        function scale_xaxis(obj)
            % Retrieve state of popup menu 
            switch get(obj.xaxis_popup,'Value')
                case 1
                    del = .25;
                case 2
                    del = .5;
                case 3
                    del = 1;
                case 4
                    del = 3;
                case 5
                    del = 6;
                case 6
                    del = 12;
                case 7
                    del = 24;
            end
            
            % Ensure that when scaling takes place that it resets the other
            % plotting tools to keep states matched up
            if get(obj.SMA_checkbox,'Value') == 1
                set(obj.SMA_checkbox,'Value',0);
            elseif get(obj.EMA_checkbox,'Value') == 1
                set(obj.EMA_checkbox,'Value',0);
            elseif get(obj.SMA_offset_checkbox,'Value') == 1
                set(obj.SMA_offset_checkbox,'Value',0);
            elseif get(obj.EMA_offset_checkbox,'Value') == 1
                set(obj.EMA_offset_checkbox,'Value',0);
            elseif get(obj.Trend_up_checkbox,'Value') == 1
                set(obj.Trend_up_checkbox,'Value',0);
            elseif get(obj.Trend_down_checkbox,'Value') == 1
                set(obj.Trend_down_checkbox,'Value',0);
            elseif get(obj.volumemax_checkbox,'Value') == 1
                set(obj.volumemax_checkbox,'Value',0);
            elseif get(obj.volumemin_checkbox,'Value') == 1
                set(obj.volumemin_checkbox,'Value',0);
            end
                
            % Replot the price chart
            cla(obj.Price_axes)
            axes(obj.Price_axes)
            set(obj.Price_axes,'XLim',[0 ceil(22*del)])
            plot(1:22*del,flipud(obj.Close(1:ceil(22*del))),'k')
            set(gca,'XTick',[1:22*del/6:22*del 22*del])
            set(gca,'XTickLabel',flipud(obj.Dates([1:ceil(22*del/6):floor(22*del) floor(22*del)])))
            
            % Replot the volume chart
            cla(obj.Volume_axes)
            axes(obj.Volume_axes)
            set(obj.Volume_axes,'XLim',[0 ceil(22*del)])
            bar(1:22*del,flipud(obj.Volume(1:ceil(22*del))))
            set(gca,'xtick',[1:22*del/6:22*del 22*del])
            set(gca,'xticklabel',flipud(obj.Dates([1:ceil(22*del/6):floor(22*del) floor(22*del)])))
            
        end
        
        function SMA(obj) % Simple Moving Average
            % Check if box is checked or not
            if get(obj.SMA_checkbox,'Value') == 1 % checked
                % Get current/desired x-axis scaling
                switch get(obj.xaxis_popup,'Value')
                    case 1
                        time_selection = 22*.25;
                    case 2
                        time_selection = 22*.5;
                    case 3
                        time_selection = 22*1;
                    case 4
                        time_selection = 22*3;
                    case 5
                        time_selection = 22*6;
                    case 6
                        time_selection = 22*12;
                    case 7
                        time_selection = 22*24;
                end
                
                % Get desired moving number and check if number was input
                % properly and/or will work with code
                moving_number = get(obj.SMA_days_edit,'String');
                [moving_number, status] = str2num(moving_number);
                
                if status == 0
                    disp('ERROR: Not a valid value for SMA');
                else
                    moving_number = ceil(moving_number);
                    if moving_number > 264
                        disp('ERROR: Selected SMA number of days is too large, value lowered to 264')
                        moving_number = 264;
                    elseif moving_number < 1
                        disp('ERROR: Selected SMA number of days is negative, value lifted to 10')
                        moving_number = 10;
                    end
                end
                
                % Calculate the simple moving average
                mov_data = zeros(1,time_selection);
                for i = 1:time_selection
                    if time_selection + moving_number > length(obj.Close)
                        disp('Error: Data requested is outside of 2 year bounding')
                    else
                        mov_data(i) = sum(obj.Close(time_selection-i+1:moving_number+time_selection-i+1))/moving_number;
                    end
                end
                
                % Plot SMA onto price axes
                axes(obj.Price_axes)
                hold on
                if isempty(obj.SMA_plot) == 1
                    obj.SMA_plot = plot(1:time_selection,mov_data,'g');
                elseif isempty(obj.SMA_plot) == 0
                    set(obj.SMA_plot,'Visible','off');
                    obj.SMA_plot = plot(1:time_selection,mov_data,'g');
                else
                    disp('ERROR: Something went wrong with SMA plotting')
                end
                hold off
                
            elseif get(obj.SMA_checkbox,'Value') == 0 % unchecked
                set(obj.SMA_plot,'Visible','off');
            else
                disp('ERROR: Something went horribly wrong');
            end
        end
        
        function SMA_offset(obj)
            % Check if box is checked or not
            if get(obj.SMA_offset_checkbox,'Value') == 1 % checked
                % Get current/desired x-axis scaling
                switch get(obj.xaxis_popup,'Value')
                    case 1
                        time_selection = 22*.25;
                    case 2
                        time_selection = 22*.5;
                    case 3
                        time_selection = 22*1;
                    case 4
                        time_selection = 22*3;
                    case 5
                        time_selection = 22*6;
                    case 6
                        time_selection = 22*12;
                    case 7
                        time_selection = 22*24;
                end
                
                % Get desired moving number and check if number was input
                % properly and/or will work with code
                moving_number = get(obj.SMA_days_edit,'String');
                [moving_number, status] = str2num(moving_number);
                
                if status == 0
                    disp('ERROR: Not a valid value for SMA');
                else
                    moving_number = ceil(moving_number);
                    if moving_number > 264
                        disp('ERROR: Selected SMA number of days is too large, value lowered to 264')
                        moving_number = 264;
                    elseif moving_number < 1
                        disp('ERROR: Selected SMA number of days is negative, value lifted to 10')
                        moving_number = 10;
                    end
                end
                
                % Calculate the simple moving average
                mov_data = zeros(1,time_selection);
                for i = 1:time_selection
                    if time_selection + moving_number > length(obj.Close)
                        disp('Error: Data requested is outside of 2 year bounding')
                    else
                        mov_data(i) = sum(obj.Close(time_selection-i+1:moving_number+time_selection-i+1))/moving_number;
                    end
                end
                                
                % Get desired offset percentage and check if number was
                % input properly and/or will work with code
                offset_percentage = get(obj.SMA_offset_edit,'String');
                [offset_percentage, status] = str2num(offset_percentage);
                
                if status == 0
                    disp('ERROR: Not a valid value for SMA offset');
                else
                    if offset_percentage > 100
                        disp('ERROR: Selected Offset percentage is too large, value lowered to 100')
                        offset_percentage = 100;
                    elseif offset_percentage < 0
                        disp('ERROR: Selected SMA number of days is negative, value lifted to 1')
                        offset_percentage = 1;
                    end
                end
                
                % Calculate the offset values
                offset_up = (1+offset_percentage/100)*mov_data;
                offset_down = (1-offset_percentage/100)*mov_data;
                
                % Plot offsets onto price axes
                axes(obj.Price_axes)
                hold on
                if isempty(obj.SMA_offset_plot) == 1
                    obj.SMA_offset_plot{1} = plot(1:time_selection,offset_up,'r--');
                    obj.SMA_offset_plot{2} = plot(1:time_selection,offset_down,'r--');
                elseif isempty(obj.SMA_offset_plot) == 0
                    set(obj.SMA_offset_plot{1},'Visible','off');
                    set(obj.SMA_offset_plot{2},'Visible','off');
                    obj.SMA_offset_plot{1} = plot(1:time_selection,offset_up,'r--');
                    obj.SMA_offset_plot{2} = plot(1:time_selection,offset_down,'r--');
                else
                    disp('ERROR: Something went wrong with SMA offset plotting')
                end
                hold off
                
            elseif get(obj.SMA_offset_checkbox,'Value') == 0 % unchecked
                set(obj.SMA_offset_plot{1},'Visible','off');
                set(obj.SMA_offset_plot{2},'Visible','off');
            else
                disp('ERROR: Something went horribly wrong');
            end
        end
                
        function EMA(obj)
            % Check if box is checked or not
            if get(obj.EMA_checkbox,'Value') == 1 % checked
                % Get current/desired x-axis scaling
                switch get(obj.xaxis_popup,'Value')
                    case 1
                        time_selection = 22*.25;
                    case 2
                        time_selection = 22*.5;
                    case 3
                        time_selection = 22*1;
                    case 4
                        time_selection = 22*3;
                    case 5
                        time_selection = 22*6;
                    case 6
                        time_selection = 22*12;
                    case 7
                        time_selection = 22*24;
                end
                
                % Get desired moving number and check if number was input
                % properly and/or will work with code
                moving_number = get(obj.EMA_days_edit,'String');
                [moving_number, status] = str2num(moving_number);
                
                if status == 0
                    disp('ERROR: Not a valid value for SMA');
                else
                    moving_number = ceil(moving_number);
                    if moving_number > 264
                        disp('ERROR: Selected SMA number of days is too large, value lowered to 264')
                        moving_number = 264;
                    elseif moving_number < 1
                        disp('ERROR: Selected SMA number of days is negative, value lifted to 10')
                        moving_number = 10;
                    end
                end
                
                % Calculate the exponential moving average
                mov_data = zeros(1,time_selection);
                k = 2/(moving_number+1);
                mov_data(1) = obj.Close(time_selection)*k + (1-k)*sum(obj.Close(time_selection+1:moving_number+time_selection+1))/moving_number;
                temp = mov_data(1);
                for i = 2:time_selection
                    if time_selection + moving_number > length(obj.Close)
                        disp('Error: Data requested is outside of 2 year bounding')
                    else
                        mov_data(i) = obj.Close(time_selection-i+1)*k + (1-k)*temp;
                        temp = mov_data(i);
                    end
                end
              
                % Plot EMA onto price axes
                axes(obj.Price_axes)
                hold on
                if isempty(obj.EMA_plot) == 1
                    obj.EMA_plot = plot(1:time_selection,mov_data,'y');
                elseif isempty(obj.SMA_plot) == 0
                    set(obj.EMA_plot,'Visible','off');
                    obj.EMA_plot = plot(1:time_selection,mov_data,'y');
                else
                    disp('ERROR: Something went wrong with EMA plotting')
                end
                hold off
                
            elseif get(obj.SMA_checkbox,'Value') == 0 % unchecked
                set(obj.EMA_plot,'Visible','off');
            else
                disp('ERROR: Something went horribly wrong');
            end
        end % Exponential Moving Average
        
        function EMA_offset(obj)
            % Check if box is checked or not
            if get(obj.EMA_offset_checkbox,'Value') == 1 % checked
                % Get current/desired x-axis scaling
                switch get(obj.xaxis_popup,'Value')
                    case 1
                        time_selection = 22*.25;
                    case 2
                        time_selection = 22*.5;
                    case 3
                        time_selection = 22*1;
                    case 4
                        time_selection = 22*3;
                    case 5
                        time_selection = 22*6;
                    case 6
                        time_selection = 22*12;
                    case 7
                        time_selection = 22*24;
                end
                
                % Get desired moving number and check if number was input
                % properly and/or will work with code
                moving_number = get(obj.EMA_days_edit,'String');
                [moving_number, status] = str2num(moving_number);
                
                if status == 0
                    disp('ERROR: Not a valid value for SMA');
                else
                    moving_number = ceil(moving_number);
                    if moving_number > 264
                        disp('ERROR: Selected SMA number of days is too large, value lowered to 264')
                        moving_number = 264;
                    elseif moving_number < 1
                        disp('ERROR: Selected SMA number of days is negative, value lifted to 10')
                        moving_number = 10;
                    end
                end
                
                % Calculate the exponential moving average
                mov_data = zeros(1,time_selection);
                k = 2./(moving_number+1);
                mov_data(1) = obj.Close(time_selection)*k + (1-k)*sum(obj.Close(time_selection+1:moving_number+time_selection+1))/moving_number;
                temp = mov_data(1);
                for i = 2:time_selection
                    if time_selection + moving_number > length(obj.Close)
                        disp('Error: Data requested is outside of 2 year bounding')
                    else
                        mov_data(i) = obj.Close(time_selection-i+1)*k + (1-k)*temp;
                        temp = mov_data(i);
                    end
                end
                                
                % Get desired offset percentage and check if number was
                % input properly and/or will work with code
                offset_percentage = get(obj.EMA_offset_edit,'String');
                [offset_percentage, status] = str2num(offset_percentage);
                
                if status == 0
                    disp('ERROR: Not a valid value for SMA offset');
                else
                    if offset_percentage > 100
                        disp('ERROR: Selected Offset percentage is too large, value lowered to 100')
                        offset_percentage = 100;
                    elseif offset_percentage < 0
                        disp('ERROR: Selected SMA number of days is negative, value lifted to 1')
                        offset_percentage = 1;
                    end
                end
                
                % Calculate the offset values
                offset_up = (1+offset_percentage/100)*mov_data;
                offset_down = (1-offset_percentage/100)*mov_data;
                
                % Plot offsets onto price axes
                axes(obj.Price_axes)
                hold on
                if isempty(obj.EMA_offset_plot) == 1
                    obj.EMA_offset_plot{1} = plot(1:time_selection,offset_up,'m--');
                    obj.EMA_offset_plot{2} = plot(1:time_selection,offset_down,'m--');
                elseif isempty(obj.SMA_offset_plot) == 0
                    set(obj.EMA_offset_plot{1},'Visible','off');
                    set(obj.EMA_offset_plot{2},'Visible','off');
                    obj.EMA_offset_plot{1} = plot(1:time_selection,offset_up,'m--');
                    obj.EMA_offset_plot{2} = plot(1:time_selection,offset_down,'m--');
                else
                    disp('ERROR: Something went wrong with SMA offset plotting')
                end
                hold off
                
            elseif get(obj.EMA_offset_checkbox,'Value') == 0 % unchecked
                set(obj.EMA_offset_plot{1},'Visible','off');
                set(obj.EMA_offset_plot{2},'Visible','off');
            else
                disp('ERROR: Something went horribly wrong');
            end
        end
        
        function Upper_trendline(obj)
            % Check if box is checked or not
            if get(obj.Trend_up_checkbox,'Value') == 1 % checked
                % Get current/desired x-axis scaling
                switch get(obj.xaxis_popup,'Value')
                    case 1
                        time_selection = 22*.25;
                    case 2
                        time_selection = 22*.5;
                    case 3
                        time_selection = 22*1;
                    case 4
                        time_selection = 22*3;
                    case 5
                        time_selection = 22*6;
                    case 6
                        time_selection = 22*12;
                    case 7
                        time_selection = 22*24;
                end
                
                axes(obj.Price_axes);
                hold on
                % Prompt user with directions:
                upper_dlg = helpdlg('Select local maximum points of interest and press enter when all selections have been made.','Upper Trendline Instructions');
                waitfor(upper_dlg);
                [x_high,y_high] = ginput;
                
                % Fit a linear polynomial to the selected inputs
                c = polyfit(x_high,y_high,1);
                up_trend = @(t) c(1)*t + c(2);
                
                %Plot Lower Trendline onto Chart
                time_section = floor(min(x_high)):time_selection + 10;
                obj.Upper_plot = plot(time_section,up_trend(time_section),'b');
                hold off
                
            elseif get(obj.Trend_up_checkbox,'Value') == 0 % unchecked
                set(obj.Upper_plot,'Visible','off')
            else
                disp('Something has gone terribly wrong')
            end
        end
        
        function Lower_trendline(obj)
            % Check if box is checked or not
            if get(obj.Trend_down_checkbox,'Value') == 1 % checked
                % Get current/desired x-axis scaling
                switch get(obj.xaxis_popup,'Value')
                    case 1
                        time_selection = 22*.25;
                    case 2
                        time_selection = 22*.5;
                    case 3
                        time_selection = 22*1;
                    case 4
                        time_selection = 22*3;
                    case 5
                        time_selection = 22*6;
                    case 6
                        time_selection = 22*12;
                    case 7
                        time_selection = 22*24;
                end
                
                axes(obj.Price_axes);
                hold on
                
                % Prompt user with directions:
                lower_dlg = helpdlg('Select local minimum points of interest and press enter when all selections have been made.','Lower Trendline Instructions');
                waitfor(lower_dlg);
                [x_low,y_low] = ginput;
                
                % Fit a linear polynomial to the selected inputs
                c = polyfit(x_low,y_low,1);
                down_trend = @(t) c(1)*t + c(2);
                
                %Plot Lower Trendline onto Chart
                time_section = floor(min(x_low)):time_selection + 10;
                obj.Lower_plot = plot(time_section,down_trend(time_section),'b');
                hold off
                
            elseif get(obj.Trend_down_checkbox,'Value') == 0 % unchecked
                set(obj.Lower_plot,'Visible','off')
            else
                disp('Something has gone terribly wrong')
            end
        end
        
        function Max_volume(obj)
            % Check if box is checked or not
            if get(obj.volumemax_checkbox,'Value') == 1 % checked
                 switch get(obj.xaxis_popup,'Value')
                    case 1
                        time_selection = 22*.25;
                    case 2
                        time_selection = 22*.5;
                    case 3
                        time_selection = 22*1;
                    case 4
                        time_selection = 22*3;
                    case 5
                        time_selection = 22*6;
                    case 6
                        time_selection = 22*12;
                    case 7
                        time_selection = 22*24;
                end
                
                temp = obj.Volume(1:time_selection);
                maxs_index = zeros(5,1);
                for i = 1:5
                    [~,index] = max(temp);
                    maxs_index(i) = index;
                    temp(index) = min(temp) - 1;
                end
                dots = linspace(min(obj.Close(1:time_selection)),...
                                max(obj.Close(1:time_selection)),100);
                x_vals = cell(1,5);
                for j = 1:5
                x_vals{j} = time_selection*ones(1,length(dots)) - ...
                            maxs_index(j)*ones(1,length(dots));
                end
                axes(obj.Price_axes);
                hold on
                obj.Max_vol_plots{1} = plot(x_vals{1},dots,'c--');
                obj.Max_vol_plots{2} = plot(x_vals{2},dots,'c--');
                obj.Max_vol_plots{3} = plot(x_vals{3},dots,'c--');
                obj.Max_vol_plots{4} = plot(x_vals{4},dots,'c--');
                obj.Max_vol_plots{5} = plot(x_vals{5},dots,'c--');
                hold off
            elseif get(obj.volumemax_checkbox,'Value') == 0 % unchecked
                set(obj.Max_vol_plots{1},'Visible','off')
                set(obj.Max_vol_plots{2},'Visible','off')
                set(obj.Max_vol_plots{3},'Visible','off')
                set(obj.Max_vol_plots{4},'Visible','off')
                set(obj.Max_vol_plots{5},'Visible','off')
            else
                disp('Something has gone terribly wrong')
            end
        end
        
        function Min_volume(obj)
            % Check if box is checked or not
            if get(obj.volumemin_checkbox,'Value') == 1 % checked
                switch get(obj.xaxis_popup,'Value')
                    case 1
                        time_selection = 22*.25;
                    case 2
                        time_selection = 22*.5;
                    case 3
                        time_selection = 22*1;
                    case 4
                        time_selection = 22*3;
                    case 5
                        time_selection = 22*6;
                    case 6
                        time_selection = 22*12;
                    case 7
                        time_selection = 22*24;
                end
                
                temp = obj.Volume(1:time_selection);
                mins_index = zeros(5,1);
                for i = 1:5
                    [~,index] = min(temp);
                    mins_index(i) = index;
                    temp(index) = max(temp) + 1;
                end
                dots = linspace(min(obj.Close(1:time_selection)),max(obj.Close(1:time_selection)),100);
                x_vals = cell(1,5);
                for j = 1:5
                x_vals{j} = time_selection*ones(1,length(dots)) - ...
                            mins_index(j)*ones(1,length(dots));
                end
                axes(obj.Price_axes);
                hold on
                obj.Min_vol_plots{1} = plot(x_vals{1},dots,'c--');
                obj.Min_vol_plots{2} = plot(x_vals{2},dots,'c--');
                obj.Min_vol_plots{3} = plot(x_vals{3},dots,'c--');
                obj.Min_vol_plots{4} = plot(x_vals{4},dots,'c--');
                obj.Min_vol_plots{5} = plot(x_vals{5},dots,'c--');
                hold off
            elseif get(obj.volumemin_checkbox,'Value') == 0 % unchecked
                set(obj.Min_vol_plots{1},'Visible','off')
                set(obj.Min_vol_plots{2},'Visible','off')
                set(obj.Min_vol_plots{3},'Visible','off')
                set(obj.Min_vol_plots{4},'Visible','off')
                set(obj.Min_vol_plots{5},'Visible','off')
            else
                disp('Something has gone terribly wrong')
            end
        end
           
    end
end


% cell_handles
% 1 - Price_axes
% 2 - Volume_axes
% 3 - info_Panel
% 4 - tools_Panel
% 5 - xaxis_popup
% 6 - SMA_checkbox
% 7 - SMA_days_edit
% 8 - SMA_offset_checkbox
% 9 - SMA_offset_edit
% 10 - EMA_offset_checkbox
% 11 - EMA_offset_edit
% 12 - Trend_up_checkbox
% 13 - Trend_down_checkbox
% 14 - volumemax_checkbox
% 15 - volumemin_checkbox
% 16 - legend_checkbox
% ...
% 26 - Stock_label
% 27 - EMA_checkbox
% 28 - EMA_days_edit

