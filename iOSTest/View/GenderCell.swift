//
//  GenderCell.swift
//  iOSTest
//
//  Created by Lui on 17/02/22.
//

import UIKit

//this class is very similar to the CustomCell used for the first table but considering the Open-Closed principle is not a good practice to go back and modify the old CustomCell code, as its modification could affect the working of other components. The right call would be extend it, in this case I will again work with a new class. A good refactor option would be making a customcell protocol, so this new class could implement it and not inherit.
class GenderCell: UITableViewCell {

    var delegate: FillingViewController?
    let cellType = CellType.Gender
    var gender: CellType!
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
        contentView.addSubview(labelText)
        contentView.addSubview(selectedBox)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //the layout for the cell internal components, using the cell as reference to keep it working properly after resizing or such.
        let boxWidth = contentView.frame.height
        labelText.frame = CGRect(x: 20, y: 0, width: contentView.frame.width - 50 - boxWidth + 15, height: contentView.frame.height)
        selectedBox.frame = CGRect(x: 10 + labelText.frame.width , y: contentView.frame.midY - boxWidth/2, width: boxWidth, height: boxWidth)
        
    }
    
    @objc func buttonTapped(_ sender: UIButton){
        
        //callind the delegate to switch the tracking state of the cellTypes
        delegate?.switchGenderActive(to: gender)
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

    }
    
    func turnOffButton() {
        
        UIView.animate(withDuration: 0.2, delay: 0, options: []) { [weak self] in
            //disappears
            self?.selectedBox.alpha = 0
        } completion: { finished in
            UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: { [weak self] in
                //reappers after the first animation is done.
                //strange syntax, but is forcing unwraping the result of a not operation  (!(not)(true/false))!(unwrap)
                self?.selectedBox.isSelected = false
                self?.selectedBox.alpha = 1
            }, completion: nil)

        }
    }
    
    //function to simplify configuration and keep our properties encapsulated (private)
    public func configureCell(gender: CellType) {
        self.gender = gender
        self.labelText.text = gender.rawValue
    }
    
}
