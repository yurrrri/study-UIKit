//
//  EditViewController.swift
//  CustomDelegateProject
//
//  Created by 이유리 on 2023/07/04.
//

import UIKit

final class EditViewController: UIViewController {
    
    private let profileView = ProfileView()
    private lazy var button: UIButton = {
        let button = profileView.saveButton
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }()
    
    var member: Member? {
        didSet {
            profileView.member = member
        }
    }
    
    override func loadView() {
        view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @objc func saveButtonTapped() {
        
        // [1] 멤버가 없다면 (새로운 멤버를 추가하는 화면)
        if member == nil {
            // 입력이 안되어 있다면.. (일반적으로) 빈문자열로 저장
            let name = profileView.nameTextField.text ?? ""
            let age = Int(profileView.ageTextField.text ?? "")
            let phoneNumber = profileView.phoneNumberTextField.text ?? ""
            let address = profileView.addressTextField.text ?? ""
            
            // 새로운 멤버 (구조체) 생성
            var newMember =
            Member(name: name, age: age, phone: phoneNumber, address: address)
            newMember.memberImage = profileView.mainImageView.image
            
            //delegate?.addNewMember(newMember)
            
            
        // [2] 멤버가 있다면 (멤버의 내용을 업데이트 하기 위한 설정)
        } else {
            // 이미지뷰에 있는 것을 그대로 다시 멤버에 저장
            member!.memberImage = profileView.mainImageView.image
            
            let memberId = Int(profileView.memberIdTextField.text!) ?? 0
            member!.name = profileView.nameTextField.text ?? ""
            member!.age = Int(profileView.ageTextField.text ?? "") ?? 0
            member!.phone = profileView.phoneNumberTextField.text ?? ""
            member!.address = profileView.addressTextField.text ?? ""
            
            // 뷰에도 바뀐 멤버를 전달 (뷰컨트롤러 ==> 뷰)
            profileView.member = member
            
            // 델리게이트 방식으로 구현⭐️
            //delegate?.update(index: memberId, member!)
        }
        
        // (일처리를 다한 후에) 전화면으로 돌아가기
        self.navigationController?.popViewController(animated: true)
    }
}
