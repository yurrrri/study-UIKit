//
//  ViewController.swift
//  CustomDelegateProject
//
//  Created by 이유리 on 2023/07/04.
//

import UIKit

final class ViewController: UIViewController {
    
    lazy var memberDataManager = MemberDataManager()
    
    @IBOutlet weak var tableViewCell: UITableViewCell!
    @IBOutlet weak var tableView: UITableView!
    lazy var plusButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memberDataManager.setMemberList()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        // 네비게이션바 오른쪽 상단 버튼 설정
        self.navigationItem.rightBarButtonItem = self.plusButton
    }
    
    @objc func plusButtonTapped() {
        // 다음화면으로 이동 (멤버는 전달하지 않음)
        let editVC = EditViewController()
        
        editVC.delegate = self
        
        // 화면이동
        navigationController?.pushViewController(editVC, animated: true)
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberDataManager.getMemberList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! MemberTableViewCell
        
        cell.member = memberDataManager[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 다음화면으로 이동
        let editVC = EditViewController()
        
        // 다음 화면의 대리자 설정 (다음 화면의 대리자는 지금 현재의 뷰컨트롤러)
        editVC.delegate = self
        
        // 다음 화면에 멤버를 전달
        let currentMember = memberDataManager.getMemberList()[indexPath.row]
        editVC.member = currentMember
        
        // 화면이동
        navigationController?.pushViewController(editVC, animated: true)
    }
}

extension ViewController: MemberDelegate {
    func addNewMember(_ member: Member) {
        memberDataManager.insertNewMember(member)
        tableView.reloadData()
    }
    
    func update(index: Int, _ member: Member) {
        memberDataManager.updateMember(index, member)
        tableView.reloadData()
    }
    
    
}
