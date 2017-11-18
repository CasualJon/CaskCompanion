//
//  RateScotchVC.swift
//  CaskCompanion1
//
//  Created by Jonathan Cyrus on 8/5/17.
//  Copyright © 2017 Jon Cyrus. All rights reserved.
//

import UIKit

class RateScotchVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Fields
    /////////////////////////////////////////////////////////////////////////////////////
    public var scotchName: String!
    public var scotchAgeAbv: String!
    public var scotchImage: UIImage!
    private var scoreArray: [Int]!
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Outlets
    /////////////////////////////////////////////////////////////////////////////////////
    @IBOutlet weak var scotchNameOutlet: UILabel!
    @IBOutlet weak var scotchAgeABVOutlet: UILabel!
    @IBOutlet weak var scotchImageOutlet: UIImageView!
    @IBOutlet weak var selectedScoreOutlet: UILabel!
    @IBOutlet weak var scorePickerOutlet: UIPickerView!
    
    @IBAction func zeroButton(_ sender: UIButton) {
        scorePickerOutlet.selectRow(0, inComponent: 0, animated: true)
        selectedScoreOutlet.text = "0"
    }
    
    @IBAction func tenButton(_ sender: UIButton) {
        scorePickerOutlet.selectRow(10, inComponent: 0, animated: true)
        selectedScoreOutlet.text = "10"
    }
    
    @IBAction func twentyButton(_ sender: UIButton) {
        scorePickerOutlet.selectRow(20, inComponent: 0, animated: true)
        selectedScoreOutlet.text = "20"
    }
    
    @IBAction func thirtyButton(_ sender: UIButton) {
        scorePickerOutlet.selectRow(30, inComponent: 0, animated: true)
        selectedScoreOutlet.text = "30"
    }
    
    @IBAction func fourtyButton(_ sender: UIButton) {
        scorePickerOutlet.selectRow(40, inComponent: 0, animated: true)
        selectedScoreOutlet.text = "40"
    }
    
    @IBAction func fiftyButton(_ sender: UIButton) {
        scorePickerOutlet.selectRow(50, inComponent: 0, animated: true)
        selectedScoreOutlet.text = "50"
    }
    
    @IBAction func sixtyButton(_ sender: UIButton) {
        scorePickerOutlet.selectRow(60, inComponent: 0, animated: true)
        selectedScoreOutlet.text = "60"
    }
    
    @IBAction func seventyButton(_ sender: UIButton) {
        scorePickerOutlet.selectRow(70, inComponent: 0, animated: true)
        selectedScoreOutlet.text = "90"
    }
    
    @IBAction func eightyButton(_ sender: UIButton) {
        scorePickerOutlet.selectRow(80, inComponent: 0, animated: true)
        selectedScoreOutlet.text = "80"
    }
    
    @IBAction func ninetyButton(_ sender: UIButton) {
        scorePickerOutlet.selectRow(90, inComponent: 0, animated: true)
        selectedScoreOutlet.text = "90"
    }
    
    @IBAction func oneHundredButton(_ sender: UIButton) {
        scorePickerOutlet.selectRow(100, inComponent: 0, animated: true)
        selectedScoreOutlet.text = "100"
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        if  DBManager.shared.saveUserRating(scotchName: scotchName!, userScore: selectedScoreOutlet.text!) {
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Methods
    /////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if scotchName != nil {
            scotchNameOutlet.text = scotchName
        }
        if scotchAgeAbv != nil {
            scotchAgeABVOutlet.text = scotchAgeAbv
        }
        if scotchImage != nil {
            scotchImageOutlet.image = scotchImage
        }
        
        scoreArray = [Int]()
        for i in 0 ..< 101 {
            scoreArray.append(i)
        }
        scorePickerOutlet.selectRow(100, inComponent: 0, animated: false)
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return scoreArray.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(scoreArray[row])
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedScoreOutlet.text = String(scoreArray[row])
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
