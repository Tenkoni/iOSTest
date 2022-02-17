//
//  PictureCell.swift
//  iOSTest
//
//  Created by Lui on 16/02/22.
//

import UIKit

class PictureCell: UITableViewCell {

    let cellType = CellType.Photo
    
    //very similr as in CameraCell, but this time there's no need to adjust the zpos
    private let imageBox: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .white
        image.layer.cornerRadius = 20
        image.layer.masksToBounds = true
        image.layer.borderWidth = 1
        image.contentMode = UIView.ContentMode.scaleAspectFill
        image.layer.borderColor = UIColor.systemGray.cgColor
        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(imageBox)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageBox.frame = CGRect(x: 20, y: 0, width: contentView.frame.width - 40, height: contentView.frame.height)
    }
    
    func setImage(_ image: UIImage) {
        imageBox.image = image
    }
    
}
