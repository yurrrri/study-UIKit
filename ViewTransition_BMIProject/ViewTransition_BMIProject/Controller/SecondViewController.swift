//
//  SecondViewController.swift
//  ViewTransition_BMIProject
//
//  Created by 이유리 on 2023/07/01.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var resultNumberLabel: UILabel!
    @IBOutlet weak var bmiNumberLabel: UILabel!
    
    // 얘를 묶어서 struct로
//    var bmiNumber: Double?
//    var adviceString: String?
//    var bmiColor: UIColor?
    var bmi: BMI?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bmiNumberLabel.text = "\(bmi?.advice)"
        bmiNumberLabel.backgroundColor = bmi?.color
        resultNumberLabel.text = bmi?.advice
                
        setupUI()
    }
    
    func setupUI() {
        bmiNumberLabel.clipsToBounds = true
        bmiNumberLabel.layer.cornerRadius = 8
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
