//
//  ViewController.swift
//  ViewTransition_BMIProject
//
//  Created by 이유리 on 2023/07/01.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var weightTextField: UITextField!
        
    lazy var calculateBMIManager = BMICalculatorManager()   // VC는 이 DataManager에게 로직을 요청하고 데이터를 받아옴
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    private func setupUI() {
        heightTextField.delegate = self
        weightTextField.delegate = self
    }

    @IBAction func calculateButtonTapped(_ sender: UIButton) {
//        calculateBMIManager.calculateBMI(height: heightTextField.text!, weight: weightTextField.text!)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // 화면 전환을 할지 안할지 반환
        if heightTextField.text == "" || weightTextField.text == "" {
            mainLabel.text = "키와 몸무게를 입력하지 않았습니다."
            return false
        }
        mainLabel.text = "키와 몸무게를 입력해주세요"
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goBMI" {
            let secondVC = segue.destination as! SecondViewController
            
            // 데이터 전달
//            secondVC.bmiNumber = calculateBMIManager.getBMIResult()
//            secondVC.bmiColor = calculateBMIManager.getBackgroundColor()
//            secondVC.adviceString = calculateBMIManager.getBMIAdviceString()
            secondVC.bmi = calculateBMIManager.getBMI(height: heightTextField.text!, weight: weightTextField.text!)
        }
        
        heightTextField.text = ""
        weightTextField.text = ""
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if Int(string) != nil || string == "" {
            return true     // 글자 입력 허용
        }
        return false
    }
    
    // 텍스트필드 이외의 영역을 눌렀을때 키보드 내려가도록
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        heightTextField.resignFirstResponder()
        weightTextField.resignFirstResponder()
    }
}

