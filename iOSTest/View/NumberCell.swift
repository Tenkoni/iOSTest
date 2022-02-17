//
//  NumberCell.swift
//  iOSTest
//
//  Created by Lui on 17/02/22.
//

import UIKit

//this class is very similar to NameCell, inheritance might be a solution with method override, but to keep an easy to scale and easy to understand design, it will be implemented as a different class.
class NumberCell: UITableViewCell, UITextFieldDelegate {

    let cellType = CellType.Phone
    
    private let textBox: UITextField = {
        let textBox = UITextField()
        textBox.placeholder = "Inserta tu número"
        return textBox
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .blue
        textBox.keyboardType = .numberPad
        textBox.delegate = self
        contentView.addSubview(textBox)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textBox.frame =  CGRect(x: 20, y: 0, width: contentView.frame.width - 40, height: contentView.frame.height)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //first off the character filter
        //get the character set of the characters in the new text
        let characterSet = CharacterSet(charactersIn: string)
        //next we declare the character space of unicode that would include only numbers
        let unicodeNumbers = CharacterSet.decimalDigits
        
        //now the lenght filter
        let currentText = textField.text ?? ""
        //reading the range of characters that are going to be changed
        guard let stringRange = Range(range, in: currentText) else { return false }
        //now we replace the caracters in the range to be edited
        let newText = currentText.replacingCharacters(in: stringRange, with: string)
        
        //here we verify if the new characters are in the unicode space sets, if its in and the length of the updated text is under 10 characters, we allow the editing
        return unicodeNumbers.isSuperset(of: characterSet) && newText.count <= 10
    }

}
