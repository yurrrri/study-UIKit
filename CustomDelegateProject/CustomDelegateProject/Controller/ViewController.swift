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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memberDataManager.setMemberList()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func toUpdate(_ sender: Any) {
        self.performSegue(withIdentifier: "toUpdate", sender: self)
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
        //detailVC.delegate = self
        
        // 다음 화면에 멤버를 전달
        let currentMember = memberDataManager.getMemberList()[indexPath.row]
        editVC.member = currentMember
        
        // 화면이동
        navigationController?.pushViewController(editVC, animated: true)
    }
}
