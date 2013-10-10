classdef SAW < handle
    %This is the main function that initilizes the GUI for our stock class
    %and stores the variables.
    
    properties
        StockLists;
        portfolio;
        watchlist;
        fig;
        analysis;
        pagewatch;
        pageport;
        current_ticker;
    end
    
    methods
        function obj=SAW()
            urlwrite('http://www.nasdaq.com/screening/companies-by-name.aspx?letter=0&exchange=nasdaq&render=download','nasdaq.csv');
            urlwrite('http://www.nasdaq.com/screening/companies-by-name.aspx?letter=0&exchange=nyse&render=download','nyse.csv');
            fidNys = fopen('nyse.csv');
            nyse= textscan(fidNys,'%s %20s %*[^\n]','HeaderLines',2,'delimiter',',');
            fclose(fidNys);
            fidNas = fopen('nasdaq.csv');
            
            nasdaq= textscan(fidNas,'%s %20s %*[^\n]','HeaderLines',2,'delimiter',',');
            fclose(fidNas);
            obj.StockLists{1}=[strrep(nasdaq{1},'"','');strrep(nyse{1},'"','')];
            obj.StockLists{2}=[strrep(nasdaq{2},'"','');strrep(nyse{2},'"','')];
            [obj.StockLists{2},ind]=sortrows(obj.StockLists{2});
            obj.StockLists{1}=obj.StockLists{1}(ind);
            obj.StockLists{3}=cell.empty(length(obj.StockLists{1}),0);
            for i=1:length(obj.StockLists{1})
                obj.StockLists{3}{i}=sprintf('%-8s %-20s',obj.StockLists{1}{i},obj.StockLists{2}{i});
            end
            for i=1:length(obj.StockLists{1})
                obj.StockLists{3}{i+length(obj.StockLists{1})}=sprintf('%-16s %-20s',obj.StockLists{2}{i},obj.StockLists{1}{i});
            end
            if exist('portfolio.mat')
                load('portfolio.mat')
                obj.portfolio=portfolio;
            else
                obj.portfolio=Portfolio(100000);
            end
            if exist('WatchList.mat')
                load('WatchList.mat');
                obj.watchlist=Watchlist(WL);
                
            else
                obj.watchlist=Watchlist();
            end
            
            obj.fig=figure;
            
        end
        function display(obj)
            Gui(obj)
        end
    end
    
end

