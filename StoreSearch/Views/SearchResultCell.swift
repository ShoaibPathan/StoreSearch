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
    
    var downloadTask: URLSessionDownloadTask?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        downloadTask = nil
    }

    func configure(for result: SearchResult) {
        nameLabel.text = result.name
        if result.artist.isEmpty {
            artistNameLabel.text = "Unknown"
        } else {
            artistNameLabel.text = String(format: "%@ (%@)", result.artist, result.type)
        }
        if let smallURL = URL(string: result.imageSmall) {
            downloadTask = artworkImageView.loadImage(url: smallURL)
        } else {
            artworkImageView.image = UIImage(named: "Placeholder")
        }
    }

}
