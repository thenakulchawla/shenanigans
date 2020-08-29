//
//  FriendRequestViewCell.swift
//  reeal
//
//  Created by Nakul Chawla on 4/12/20.
//  Copyright © 2020 Nakul Chawla. All rights reserved.
//

import UIKit

protocol FriendRequestCellDelegate : class {
    func didPressAcceptButton(_ tag: Int)
    func didPressDenyButton(_ tag: Int)
}

class FriendRequestViewCell: UITableViewCell {
    
    var friendRequestCellDelegate: FriendRequestCellDelegate?

    @IBOutlet weak var acceptRequest: UIButton!
    @IBOutlet weak var denyRequest: UIButton!
    
    @IBAction func acceptRequestAction(_ acceptRequest: UIButton) {
        friendRequestCellDelegate?.didPressAcceptButton(acceptRequest.tag)

    }
    
    
    @IBAction func denyRequestAction(_ denyRequest: UIButton) {
        
        friendRequestCellDelegate?.didPressDenyButton(denyRequest.tag)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
