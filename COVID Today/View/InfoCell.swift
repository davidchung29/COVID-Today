//
//  InfoViewCell.swift
//  COVID Today
//
//  Created by David Jr on 1/15/21.
//

import UIKit

class InfoCell: UITableViewCell {
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoDescription: UILabel!
    @IBOutlet weak var infoView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
