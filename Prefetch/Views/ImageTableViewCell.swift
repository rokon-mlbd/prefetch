//
//  ImageTableViewCell.swift
//  Prefetch
//
//  Created by Mohammed Rokon Uddin on 7/12/18.
//  Copyright © 2018 Monstar Lab Bangladesh Ltd. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var thumbImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    func updateAppearanceFor(_ photo: UIImage?) {
        DispatchQueue.main.async {
            self.displayPhoto(photo)
        }
    }

    private func displayPhoto(_ image: UIImage?) {
        if let _image = image {
            thumbImageView.image = _image
            contentView.backgroundColor = .white
            self.loadingIndicator.stopAnimating()
        } else {
            self.loadingIndicator.startAnimating()
            thumbImageView.image = .none
        }
    }

}
