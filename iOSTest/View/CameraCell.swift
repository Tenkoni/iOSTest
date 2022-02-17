//
//  CameraCell.swift
//  iOSTest
//
//  Created by Lui on 16/02/22.
//

import UIKit

class CameraCell: UITableViewCell {

    let cellType = CellType.Camera
    
    //view that will hold an image taken with the camera
    private let imageBox: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .white
        image.layer.zPosition = -1
        image.layer.cornerRadius = 20
        image.layer.masksToBounds = true
        image.layer.borderWidth = 1
        //keeping the aspect of the image
        image.contentMode = UIView.ContentMode.scaleAspectFill
        image.layer.borderColor = UIColor.systemGray.cgColor
        return image
    }()
    
    //The label that will contain a text warning there's no picture taken yet.
    private let noPictureLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 20
        label.backgroundColor = .lightGray
        label.text = "Tap to take a picture"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.systemGray.cgColor
        label.layer.masksToBounds = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(imageBox)
        contentView.addSubview(noPictureLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //preparing the internal cell layout
        //the label will be on top of the image at start.
        imageBox.frame = CGRect(x: 20, y: 0, width: contentView.frame.width - 40, height: contentView.frame.height)
        noPictureLabel.frame = imageBox.frame
    }
    
    func setImage(_ image: UIImage) {
        //set image sent by VC
        imageBox.image = image
        noPictureLabel.isHidden = true
    }
}
