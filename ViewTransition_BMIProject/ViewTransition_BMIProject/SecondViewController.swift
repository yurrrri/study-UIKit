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
    
    var bmiNumber: Double?
    var adviceString: String?
    var bmiColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bmiNumberLabel.text = "\(bmiNumber!)"
        bmiNumberLabel.backgroundColor = bmiColor
        resultNumberLabel.text = adviceString
        
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
