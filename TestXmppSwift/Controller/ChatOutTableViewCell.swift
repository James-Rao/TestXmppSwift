//
//  ChatFromTableViewCell.swift
//  TestXmppSwift
//
//  Created by James Rao on 15/02/2016.
//  Copyright © 2016 James Studio. All rights reserved.
//

import UIKit

class ChatOutTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var chatMessageLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
