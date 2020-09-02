//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by Ufuk Canlı on 2.09.2020.
//  Copyright © 2020 Ufuk Canlı. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
