//
//  ViewController.swift
//  ByteCoin
//
//  Created by Daniela Lima on 2022-07-18.
//

import UIKit

class ViewController: UIViewController {

    var coinManager = CoinManager()

    @IBOutlet weak var bitCoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set coinManager's delegate at this current class so that we can receive notifications when the delegate methods are called
        coinManager.delegate = self
        
        //set ViewController.swift as the datasouce for the picker
        currencyPicker.dataSource = self
        
        //set ViewController.swift as the delegate of the currencyPicker
        currencyPicker.delegate = self
    }
}

//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
    
    //implementation for the delegate methods
    //when coinManager gets the price it will call this method and pass over the price and currency
    func didUpdatePrice(price: String, currency: String) {
        
        //to get hold of the main thread to update UI
        //App will crash if we try to update UI from a background thread (URLAession works in the background)
        DispatchQueue.main.async {
            self.bitCoinLabel.text = price
            self.currencyLabel.text = currency
        }
    }
    
    func didFAilWithError(error: Error) {
        print(error)
    }
}


//MARK: - UIPickerView DataSource & Delegate

//UIPickerViewdataSource is for the ViewController class provide data for any UIPickerViews
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //number of columns for the picker
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    //This method expects a String as an output, which is the title for a given row
    //When pickerView loads up, it will ask its delegate for a row title and call this method once for every row
    //For the first row, it will pass in a row value of 0 and a component value of 0
    //Inside this method, we can use the row Int to pick the title from currencyArray
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    //this will get called every time when the user scrolls the picker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //to get currency value selected by the user
        let selectedCurrency = coinManager.currencyArray[row]
        //to pass selected currency to CoinManager via getCoinPrice method
        coinManager.getCoinPrice(for: selectedCurrency)
    }
}
