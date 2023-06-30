//
//  ViewController.swift
//  CodeBasedUILoginProject
//
//  Created by 이유리 on 2023/06/30.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - UI
    private let textFieldViewHeight: CGFloat = 48
    private lazy var emailInfoLabelCenterYConstraint = emailInfoLabel.centerYAnchor.constraint(equalTo:emailTextFieldView.centerYAnchor)
    // 나중에 constraint 변경하기 위해서 변수 선언
    private lazy var passwordInfoLabelCenterYConstraint = passwordInfoLabel.centerYAnchor.constraint(equalTo:passwordTextFieldView.centerYAnchor)

    private let emailTextFieldView: UIView = {   // 각 UI에 관한 속성을 분리하는게 아니라 같이 쓸 수 있어서 깔끔함
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    // vs Then 라이브러리
    
    private var emailInfoLabel: UILabel = {
        let lb = UILabel()
        lb.text = "이메일주소 또는 전화번호"
        lb.font = .systemFont(ofSize: 18)
        lb.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.frame.size.height = 48
        tf.backgroundColor = .clear
        tf.textColor = .white
        tf.keyboardType = .emailAddress
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.addTarget(self, action: #selector(setEnableLoginButtonWhenTextFilled), for: .editingChanged)
        return tf
    }()
    
    private let passwordTextFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private let passwordInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.frame.size.height = 48
        tf.backgroundColor = .clear
        tf.textColor = .white
        tf.isSecureTextEntry = true
        tf.clearsOnBeginEditing = false
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.addTarget(self, action: #selector(setEnableLoginButtonWhenTextFilled), for: .editingChanged)
        return tf
    }()
    
    private let passwordSecureButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("표시", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        button.addTarget(self, action: #selector(passwordSecureModeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.isEnabled = false
        return button
    }()
    
    // 이메일텍스트필드, 패스워드, 로그인버튼 스택뷰에 배치
    // 얘가 lazy인 이유는? 다른 속성을 사용하므로 이 속성들이 먼저 초기화되고 난 다음에, stackView가 만들어질 때 subView로 추가하기 위함
    private lazy var stackView: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [emailTextFieldView, passwordTextFieldView, loginButton])
        stview.spacing = 18
        stview.axis = .vertical
        stview.distribution = .fillEqually
        stview.alignment = .fill
        stview.translatesAutoresizingMaskIntoConstraints = false
        return stview
    }()
    
    // 비밀번호 재설정 버튼
    private let passwordResetButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("비밀번호 재설정", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpUI()
        setUpLayout()
        
        emailTextField.delegate = self   // 명시해줌으로써 대리자 지정
        passwordTextField.delegate = self
    }
    
    func setUpUI(){
        view.backgroundColor = .black
        
        view.addSubview(stackView)
        emailTextFieldView.addSubview(emailInfoLabel)
        emailTextFieldView.addSubview(emailTextField)
        passwordTextFieldView.addSubview(passwordInfoLabel)
        passwordTextFieldView.addSubview(passwordTextField)
        passwordTextFieldView.addSubview(passwordSecureButton)
        
        view.addSubview(passwordResetButton)
    }
    
    func setUpLayout(){
        // 코드로 UI를 짤 때 자동으로 오토레이아웃을 잡아주는 것을 방지
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: textFieldViewHeight*3 + 36).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        // 너무 불편
//        emailInfoLabel.centerYAnchor.constraint(equalTo: emailTextFieldView.centerYAnchor).isActive = true
//        emailInfoLabel.leadingAnchor.constraint(equalTo: emailTextFieldView.leadingAnchor, constant: 8).isActive = true
//        emailInfoLabel.trailingAnchor.constraint(equalTo: emailTextFieldView.trailingAnchor, constant: -8).isActive = true
        
        // 개선
        NSLayoutConstraint.activate([
//            emailInfoLabel.centerYAnchor.constraint(equalTo: emailTextFieldView.centerYAnchor),
            emailInfoLabelCenterYConstraint,
            emailInfoLabel.leadingAnchor.constraint(equalTo: emailTextFieldView.leadingAnchor, constant: 8),
            emailInfoLabel.trailingAnchor.constraint(equalTo: emailTextFieldView.trailingAnchor, constant: -8)
        ])

        emailTextField.topAnchor.constraint(equalTo: emailTextFieldView.topAnchor, constant: 15).isActive = true
        emailTextField.bottomAnchor.constraint(equalTo: emailTextFieldView.bottomAnchor, constant: -2).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: emailTextFieldView.leadingAnchor, constant: 8).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: emailTextFieldView.trailingAnchor, constant: -8).isActive = true
        
        passwordInfoLabel.leadingAnchor.constraint(equalTo: passwordTextFieldView.leadingAnchor, constant: 8).isActive = true
        passwordInfoLabel.trailingAnchor.constraint(equalTo: passwordTextFieldView.trailingAnchor, constant: -8).isActive = true
        passwordInfoLabelCenterYConstraint.isActive = true
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.topAnchor.constraint(equalTo: passwordTextFieldView.topAnchor, constant: 15).isActive = true
        passwordTextField.bottomAnchor.constraint(equalTo: passwordTextFieldView.bottomAnchor, constant: -2).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: passwordTextFieldView.leadingAnchor, constant: 8).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: passwordTextFieldView.trailingAnchor, constant: -8).isActive = true
        
        passwordSecureButton.translatesAutoresizingMaskIntoConstraints = false
        passwordSecureButton.topAnchor.constraint(equalTo: passwordTextFieldView.topAnchor, constant: 15).isActive = true
        passwordSecureButton.bottomAnchor.constraint(equalTo: passwordTextFieldView.bottomAnchor, constant: -15).isActive = true
        passwordSecureButton.trailingAnchor.constraint(equalTo: passwordTextFieldView.trailingAnchor, constant: -8).isActive = true
        
        passwordResetButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10).isActive = true
        passwordResetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        passwordResetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        passwordResetButton.heightAnchor.constraint(equalToConstant: textFieldViewHeight).isActive = true
        // vs SnapKit 라이브러리

    }
    
    @objc func resetButtonTapped() {
        let alert = UIAlertController(title: "비밀번호 바꾸기", message: "비밀번호를 바꾸시겠습니까?", preferredStyle: .alert)
        
        let success = UIAlertAction(title: "확인", style: .default) { action in
            
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel) { cancel in
            
        }
        
        alert.addAction(success)   //알럿창에다가 액션할 버튼을 2개 더 추가해줘ㅏ야함
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    @objc func passwordSecureModeButtonTapped() {
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) //키보드 내리기
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            emailInfoLabel.font = .systemFont(ofSize: 11)
            // 레이아웃 업데이트
            emailInfoLabelCenterYConstraint.constant = -13
        } else if textField == passwordTextField {
            passwordInfoLabel.font = .systemFont(ofSize: 11)
            passwordInfoLabelCenterYConstraint.constant = -13
        }
        
        UIView.animate(withDuration: 0.3) { //0.3초동안 애니메이션으로 동작하게 해줘
            self.stackView.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            if emailTextField.text == "" {
                emailInfoLabel.font = .systemFont(ofSize: 18)
                emailInfoLabelCenterYConstraint.constant = 0
            }
        } else if textField == passwordTextField {
            if passwordTextField.text == "" {
                passwordInfoLabel.font = .systemFont(ofSize: 18)
                passwordInfoLabelCenterYConstraint.constant = 0
            }
        }
    }
    
    @objc func setEnableLoginButtonWhenTextFilled(_ textField: UITextField) {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            loginButton.backgroundColor = .clear
            loginButton.isEnabled = false
            return
        }
        
        loginButton.backgroundColor = .red
        loginButton.isEnabled = true
    }
}
