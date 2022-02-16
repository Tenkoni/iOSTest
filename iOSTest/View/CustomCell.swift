//
//  CustomCell.swift
//  iOSTest
//
//  Created by Lui on 15/02/22.
//

import UIKit

class CustomCell: UITableViewCell {

    private var cellType: CellType?
    private let selectedBox: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.checkmark, for: .selected)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    private let labelText: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(labelText)
        contentView.addSubview(selectedBox)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let boxWidth = contentView.frame.height - 22
        labelText.frame = CGRect(x: 20, y: 0, width: contentView.frame.width - 50 - boxWidth, height: contentView.frame.height)
        selectedBox.frame = CGRect(x: 10 + labelText.frame.width , y: contentView.frame.midY - boxWidth/2, width: boxWidth, height: boxWidth)
        
    }
    
    @objc func buttonTapped(_ sender: UIButton){
        UIView.animate(withDuration: 0.2, delay: 0, options: []) {
            sender.alpha = 0
        } completion: { finished in
            UIView.animate(withDuration: 0.2, delay: 0, options: []) {
                sender.isSelected = !sender.isSelected
                sender.alpha = 1
            } completion: { finishes in
                //nothing
            }

        }

    }
    
    public func configureCell(cellType: CellType) {
        self.cellType = cellType
        self.labelText.text = cellType.rawValue
    }
    
}
