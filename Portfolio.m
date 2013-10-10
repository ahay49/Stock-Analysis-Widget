classdef Portfolio <handle
    %This class stores the values of the portfolio and adds or removes
    %stocks from the portfolio list
    
    properties
        PortfolioList=struct('Ticker',{},'Shares',{});
        Bank;
    end
    
    
    methods
        function obj=Portfolio(bank)
            obj.Bank=bank;
            
        end
        function buyStock(portfolio,ticker,amount)
            price=Stock.getStockInfo(ticker);
            if amount*price{2}<portfolio.Bank
                found=false;
                portfolio.Bank=portfolio.Bank-amount*price{2};
                for i=1:length(portfolio.PortfolioList)
                    if strcmp(ticker,portfolio.PortfolioList(i).Ticker)
                        portfolio.PortfolioList(i).Shares=portfolio.PortfolioList(i).Shares+amount;
                        found=true;
                    end
                end
                if found==false
                    entry=length(portfolio.PortfolioList)+1;
                    portfolio.PortfolioList(entry).Ticker=ticker;
                    portfolio.PortfolioList(entry).Shares=amount;
                end
            end
            
            save('portfolio.mat','portfolio');
            
        end
        
        function sellStock(portfolio,stock,amount)
            price=Stock.getStockInfo(stock);
            index=[];
            for i=1:length(portfolio.PortfolioList)
                if strcmp(stock,portfolio.PortfolioList(i).Ticker)
                    if portfolio.PortfolioList(i).Shares>amount
                        portfolio.PortfolioList(i).Shares=portfolio.PortfolioList(i).Shares-amount;
                        portfolio.Bank=portfolio.Bank+amount*price{2};
                    elseif portfolio.PortfolioList(i).Shares==amount
                        portfolio.Bank=portfolio.Bank+amount*price{2};
                        index=i;
                    end
                end
            end
            if ~isempty(index)
                portfolio.PortfolioList(index)=[];
            end
            save('portfolio.mat','portfolio');
        end
        
    end
    
end

