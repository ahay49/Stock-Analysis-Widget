classdef Stock < handle
    %STOCK: This class is created when a new ticker is purchased or added
    %to the watchlist. The class queries the web for certain non-real-time
    %information about the stock as well as provides up to date pricing
    %when attempting to trade the stock. Inputs are just the ticker itself.
    
    properties
        Ticker
        Name
        Year_low
        Year_high
        Open
        Price_book
        PE_ratio
        Market_cap
        Avg_day_vol
        Dividend_share
        Dividend_date
        Change_value
        Change_percent
        
        open_text
        year_high_text
        year_low_text
        market_cap_text
        pe_ratio_text
        price_book_text
        avg_vol_text
        dividend_text
        div_date_text
    end
    
    methods
        function obj = Stock(ticker,cell_handles)
            % Set up and run import of data from Yahoo by writing
            % concatenating the url together when given a ticker, writing
            % the url to a .csv file, importing it into Matlab, and then
            % reorganizing it for easy readability.
            ticker = upper(ticker);
            url = ['http://finance.yahoo.com/d/quotes.csv?s=',...
                ticker,...
                '&f=',...
                'n','j','k','m4','p6','r','j1','a2','d','r1','c6','p2'];
            urlwrite(url,[ticker '.csv'])
            data = importdata([ticker '.csv'],' ',1);
            newdata = textscan(data{1:end},'%q %f %f %f %f %f %s %f %f %q %q %q','delimiter', ',');
            
            % Assign properties to values given by import
            obj.Ticker = ticker;
            obj.Name = newdata{1};
            
            obj.Year_low = newdata{2};
            obj.Year_high = newdata{3};
            obj.Open = newdata{4}; %
            obj.Price_book = newdata{5};
            obj.PE_ratio = newdata{6};
            obj.Market_cap = newdata{7};
            obj.Avg_day_vol = newdata{8};
            obj.Dividend_share = newdata{9};
            obj.Dividend_date = newdata{10};
            
            obj.Change_value = newdata{11};
            obj.Change_percent = newdata{12};
            
            % Assign properties to displayed information handles
            obj.open_text = cell_handles{17};
            obj.year_high_text = cell_handles{18};
            obj.year_low_text = cell_handles{19};
            obj.market_cap_text = cell_handles{20};
            obj.pe_ratio_text = cell_handles{21};
            obj.price_book_text = cell_handles{22};
            obj.avg_vol_text = cell_handles{23};
            obj.dividend_text = cell_handles{24};
            obj.div_date_text = cell_handles{25};
            
            % Place Static data onto info_Panel
            set(obj.open_text,'String','N/A')
            set(obj.year_high_text,'String',obj.Year_high)
            set(obj.year_low_text,'String',obj.Year_low)
            set(obj.market_cap_text,'String',obj.Market_cap)
            set(obj.pe_ratio_text,'String',obj.PE_ratio)
            set(obj.price_book_text,'String',obj.Price_book)
            set(obj.avg_vol_text,'String',obj.Avg_day_vol)
            set(obj.dividend_text,'String',obj.Dividend_share)
            set(obj.div_date_text,'String',obj.Dividend_date)
        end
        
        function extra_info(obj)
            set(obj.open_text,'String','N/A')
            set(obj.year_high_text,'String',obj.Year_high)
            set(obj.year_low_text,'String',obj.Year_low)
            set(obj.market_cap_text,'String',obj.Market_cap)
            set(obj.pe_ratio_text,'String',obj.PE_ratio)
            set(obj.price_book_text,'String',obj.Price_book)
            set(obj.avg_vol_text,'String',obj.Avg_day_vol)
            set(obj.dividend_text,'String',obj.Dividend_share)
            set(obj.div_date_text,'String',obj.Dividend_date)
        end
    end
    methods (Static)
        function Data = getStockInfo(ticker)
            url_data = ['http://finance.yahoo.com/d/quotes.csv?s=',...
                ticker,...
                '&f=',...
                'nl1c'];
            urlwrite(url_data,[ticker '_current.csv']);
            webData = importdata([ticker '_current.csv'],' ',1);
            info=strrep(webData{1},'",',':');
            info=strrep(info,',"',':');
            Data = textscan(info,'%s %.2f %s','delimiter',':');
            
        end
    end
end

% cell_handles
% ...
% 17 - open_text
% 18 - year_high_text
% 19 - year_low_text
% 20 - market_cap_text
% 21 - pe_ratio_text
% 22 - price_book_text
% 23 - avg_vol_text
% 24 - dividend_text
% 25 - div_date_text