classdef Watchlist <handle
    %This class stores the watchlist and adds or removes stocks from teh
    %watchlist
    
    properties
        list=struct('Ticker',{});
    end
    
    methods
        function obj=Watchlist(varargin)
            if nargin==1
                obj=varargin{1};
            end
        end
        
        function addStock(WL,ticker)
            found=false;
            
            for i=1:length(WL.list)
                if strcmp(ticker,WL.list(i).Ticker)
                    found=true;
                end
            end
            if found==false
                entry=length(WL.list)+1;
                WL.list(entry).Ticker=ticker{1};
            end
            save('WatchList.mat','WL');
        end
        
        function removeStock(WL,stock)
            
            for i=1:length(WL.list)
                if strcmp(stock,WL.list(i).Ticker)
                    WL.list(i)=[];
                end
            end
            save('WatchList.mat','WL');
            
        end
        
    end
    
end

