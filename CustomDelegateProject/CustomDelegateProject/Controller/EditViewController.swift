//
//  EditViewController.swift
//  CustomDelegateProject
//
//  Created by 이유리 on 2023/07/04.
//

import UIKit
import PhotosUI

final class EditViewController: UIViewController {
    
    private let profileView = ProfileView()
    private lazy var button = profileView.saveButton
    
    var member: Member? {
        didSet {
            profileView.member = member
        }
    }
    
    weak var delegate: MemberDelegate?
    
    override func loadView() {
        view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func setupUI(){
        
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchUpImageView))
        profileView.mainImageView.addGestureRecognizer(tapGesture)
        profileView.mainImageView.isUserInteractionEnabled = true
    }
    
    @objc func touchUpImageView() {
        setupImagePicker()
    }
    
    func setupImagePicker() {
        // 기본설정 셋팅
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0
        configuration.filter = .any(of: [.images, .videos])
        
        // 기본설정을 가지고, 피커뷰컨트롤러 생성
        let picker = PHPickerViewController(configuration: configuration)
        // 피커뷰 컨트롤러의 대리자 설정
        picker.delegate = self
        // 피커뷰 띄우기
        self.present(picker, animated: true, completion: nil)
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
            
            delegate?.addNewMember(newMember)
            
            
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
            delegate?.update(index: memberId, member!)
        }
        
        // (일처리를 다한 후에) 전화면으로 돌아가기
        self.navigationController?.popViewController(animated: true)
    }
}

extension EditViewController: PHPickerViewControllerDelegate {
    
    // 사진이 선택이 된 후에 호출되는 메서드
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // 피커뷰 dismiss
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    // 이미지뷰에 표시
                    self.profileView.mainImageView.image = image as? UIImage
                }
            }
        } else {
            print("이미지를 불러오지 못함")
        }
    }
}
