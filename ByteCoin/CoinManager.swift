//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Daniela Lima on 2022-07-18.
//

import Foundation

//protocol to pass the last price of bitcoin that we got from the API request to the ViewController class and display in the UI
//by convention, Swift protocols are usually written in the file that has the class/struct which call the delegate methods
protocol CoinManagerDelegate {
    
    //create the method stubs without implementation in the protocol
    func didUpdatePrice(price: String, currency: String)
    func didFAilWithError(error:Error)
}

struct CoinManager {
    
    //optional delegate that will have to implement the delegate methods which we can notify when we have updated the price
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    //to get API key: https://www.coinapi.io/Pricing
    let apiKey = "KEY"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        
        //use String concatenation to add the selected currency at the end of the baseURL along with the API key
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        //use optional binding to unwrap the URL that's created from the urlString
        if let url = URL(string: urlString) {
            
            //create a new URLSession object with default configuration
            let session = URLSession(configuration: .default)
            
            //create a new data task for the URLSession
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFAilWithError(error: error!)
                    return
                }
                
                //format the data we got back as a String to be able to print it
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        
                        //call the delegate method in the delegate (ViewController) and pass along the necessary data
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
            }
            
            //start the task to fetch data from bitcoin average's servers
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        
        //JSON decoder
        let decoder = JSONDecoder()
        do {
            //try to decode the data using the CoinData struct
            let decodedData = try decoder.decode(CoinData.self, from: data)
            
            //get the last property from the decoded data
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice
        } catch {
            //catch and print any errors
            print(error)
            return nil
        }
    }
}

