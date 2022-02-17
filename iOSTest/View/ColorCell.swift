//
//  ColorCell.swift
//  iOSTest
//
//  Created by Lui on 17/02/22.
//

import UIKit

class ColorCell: UITableViewCell {

    let cellType = CellType.Color
    var color: UIColor!

    //the button used for the cell uses the system checkmark and circle provided by Apple
    private let selectedBox: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.checkmark, for: .selected)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    //The label that will contain our custom text, the goal is for it to resemble the system label
    private let labelText: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .systemBackground
        contentView.addSubview(labelText)
        contentView.addSubview(selectedBox)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //the layout for the cell internal components, using the cell as reference to keep it working properly after resizing or such.
        let boxWidth = contentView.frame.height - 22
        labelText.frame = CGRect(x: 20, y: 0, width: contentView.frame.width - 50 - boxWidth, height: contentView.frame.height)
        selectedBox.frame = CGRect(x: 10 + labelText.frame.width , y: contentView.frame.midY - boxWidth/2, width: boxWidth, height: boxWidth)
        
    }
    
    @objc func buttonTapped(_ sender: UIButton){
        
        //Animating the button switching to make it more pleasant to see for the user
        UIView.animate(withDuration: 0.2, delay: 0, options: []) {
            //disappears
            sender.alpha = 0
        } completion: { finished in
            UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                //reappers after the first animation is done.
                sender.isSelected = !sender.isSelected
                sender.alpha = 1
            }, completion: nil)

        }
        
        UIView.animate(withDuration: 1, delay: 0, options: [.transitionCrossDissolve], animations: { [weak self] in
            if self?.backgroundColor != .systemBackground {
                self?.backgroundColor = .systemBackground
                self?.selectedBox.backgroundColor = .systemBackground
            } else {
                self?.backgroundColor = self?.color
                self?.selectedBox.backgroundColor = self?.color
            }
        }, completion: nil)
        
        

    }
    
    //function to simplify configuration and keep our properties encapsulated (private)
    public func configureCell(color: CellColors) {
        
        self.labelText.text = color.rawValue
        switch color {
        case .Green:
            self.color = UIColor(red: 94/255, green: 189/255, blue: 62/255, alpha: 1)
        case .Yellow:
            self.color = UIColor(red: 255/255, green: 185/255, blue: 0, alpha: 1)
        case .Orange:
            self.color = UIColor(red: 247/255, green: 130/255, blue: 0, alpha: 1)
        case .Red:
            self.color = UIColor(red: 226/255, green: 56/255, blue: 56/255, alpha: 1)
        case .Purple:
            self.color = UIColor(red: 151/255, green: 57/255, blue: 153/255, alpha: 1)
        case .Blue:
            self.color = UIColor(red: 0, green: 156/255, blue: 223/255, alpha: 1)
        }
    }
    
}
