//
//  ViewController.swift
//  DelegateProject
//
//  Created by 이유리 on 2023/06/30.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textField.delegate = self
        
        setupUI()
    }
    
    func setupUI() {  // 함수 이름은 회사 코드컨벤션 따라갈것
        view.backgroundColor = .gray
        textField.placeholder = "이메일 입력"
        textField.keyboardType = .emailAddress
        textField.clearButtonMode = .always
        textField.returnKeyType = .search
        
        textField.becomeFirstResponder() // 화면에서 먼저 반응하게 해줌 -> 텍스트필드가 먼저 반응
    }

    // 관습적으로 ibaction을 아래에 배치하여 변수 선언단과 분리함
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        textField.resignFirstResponder()
        
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 10
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString

        return newString.length <= maxLength
    }
}

