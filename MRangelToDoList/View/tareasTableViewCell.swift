//
//  tareasTableViewCell.swift
//  MRangelToDoList
//
//  Created by MacBookMBA5 on 15/03/23.
//

import UIKit

class tareasTableViewCell: UITableViewCell {

    
    @IBOutlet weak var NombreLbl: UILabel!
    @IBOutlet weak var ImageCategoria: UIImageView!
    @IBOutlet weak var checkImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
