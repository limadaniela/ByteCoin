//
//  CoinData.swift
//  ByteCoin
//
//  Created by Daniela Lima on 2022-07-18.
//

import Foundation

//make struct conform to the Decodable protocol to use it to decode JSON
struct CoinData: Decodable {
    
    //there's only one property we're interested in the JSON data, which is the last price of bitcoin
    //because it's a decimal number, we'll give it a Double data type
    let rate: Double
}
