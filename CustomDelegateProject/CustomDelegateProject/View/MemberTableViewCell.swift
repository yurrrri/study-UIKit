//
//  MemberTableViewCell.swift
//  CustomDelegateProject
//
//  Created by 이유리 on 2023/07/05.
//

import UIKit

final class MemberTableViewCell: UITableViewCell {

    //스토리보드 시 Cell 생성 및 outlet 설정
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var memberImageView: UIImageView!
    
    var member: Member? {
        didSet {
            guard var member = member else { return }
            name.text = member.name
            phone.text = member.phone
            memberImageView.image = member.memberImage
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.memberImageView.layer.cornerRadius = self.memberImageView.frame.width / 2
    }

}
