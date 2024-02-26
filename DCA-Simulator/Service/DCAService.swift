import Foundation

struct DCAService {
    func calculate(asset: AssetModel,
                   initialInvestmentAmount: Double,
                   monthlyDollarCostAveragingAmount: Double,
                   intialDateOfInvestmentIndex: Int) -> DCAResult {
        
        //1. DCA (Total Investment)
        let investmentAmount = getInvestmentAmount(initialInvestmentAmount: initialInvestmentAmount,
                                                   monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount,
                                                   intialDateOfInvestmentIndex: intialDateOfInvestmentIndex)
        
        //2. Latest Share Price
        let latestSharePrice = getLatestSharePrice(asset: asset)
        
        //3. Get Number of Shares
        let numberOfShares = getNumberOfShares(asset: asset,
                                               initialInvestmentAmount: initialInvestmentAmount,
                                               monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount,
                                               intialDateOfInvestmentIndex: intialDateOfInvestmentIndex)
        
        //4. Get Current Value
        let currentValue = getCurrentValue(numberOfShares: numberOfShares, latestSharePrice: latestSharePrice)
        
        //5. Get to Know if The Investment is Profitable
        let isProfitable = currentValue > investmentAmount
        
        return .init(currentValue: currentValue,
                     investmentAmount: investmentAmount,
                     gain: 0,
                     yield: 0,
                     annualizedReturn: 0, 
                     isProfitable: isProfitable)
    }
    
    //Computed Function below is to Simulates DCA
    
    ///Computed Function for Dollar Cost Averaging Service (Total Investment)
    ///1. Simulation of Total Investing:
    ///December (investing $1000)
    ///November (investing $1000)
    ///October (investing $1000)
    ///September (investing $5000)
    ///Total Investing is $8000
    private func getInvestmentAmount(initialInvestmentAmount: Double,
                                     monthlyDollarCostAveragingAmount: Double,
                                     intialDateOfInvestmentIndex: Int) -> Double {
        
        var totalAmount = Double()
        totalAmount += initialInvestmentAmount
        let dollarCostAveragingAmounts = intialDateOfInvestmentIndex.doubleValue * monthlyDollarCostAveragingAmount
        totalAmount += dollarCostAveragingAmounts
        
        return totalAmount
    }
    
    ///Computed Function to Get Current Value
    ///2. Get Current Value:
    ///CurrentValue = number of shares (initial investment + DCA) x latest share price
    private func getCurrentValue(numberOfShares: Double, latestSharePrice: Double) -> Double {
        return numberOfShares * latestSharePrice
    }
    
    ///Computed Function to Get Latest Share Price
    ///3. Get Latest Share Price
    private func getLatestSharePrice(asset: AssetModel) -> Double {
        return asset.timeSeriesMonthlyAdjusted.getMonthInfos().first?.adjustedClose ?? 0
    }
    
    ///Computed Function to Get Number of Shares
    ///4. Get Number of Shares
    private func getNumberOfShares(asset: AssetModel,
                                   initialInvestmentAmount: Double,
                                   monthlyDollarCostAveragingAmount: Double,
                                   intialDateOfInvestmentIndex: Int) -> Double {
        
        var totalShares = Double()
        
        let initialInvestmentOpenPrice = asset.timeSeriesMonthlyAdjusted.getMonthInfos()[intialDateOfInvestmentIndex].adjustedOpen
        
        let initialInvestmentShares = initialInvestmentAmount / initialInvestmentOpenPrice
        totalShares += initialInvestmentShares
        asset.timeSeriesMonthlyAdjusted.getMonthInfos().prefix(intialDateOfInvestmentIndex).forEach { (monthInfo) in
            let dcaInvestmentShares = monthlyDollarCostAveragingAmount / monthInfo.adjustedOpen
            totalShares += dcaInvestmentShares
        }
        
        return totalShares
    }
}

struct DCAResult {
    let currentValue: Double
    let investmentAmount: Double
    let gain: Double
    let yield: Double
    let annualizedReturn: Double
    let isProfitable: Bool
}


