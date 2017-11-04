//
//  GIFCollectionViewCell.swift
//  GiphyAppDemo
//
//  Created by msm72 on 02.11.2017.
//  Copyright © 2017 RemoteJob. All rights reserved.
//

import UIKit
import Kingfisher

class GIFCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    @IBOutlet weak var imageView: AnimatedImageView!
    @IBOutlet weak var importDateTimeLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
}
