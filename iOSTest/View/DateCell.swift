//
//  DateCell.swift
//  iOSTest
//
//  Created by Lui on 17/02/22.
//

import UIKit

class DateCell: UITableViewCell {

    let cellType = CellType.Birth
    
    private let textBox: UITextField = {
        let textBox = UITextField()
        textBox.placeholder = "Fecha de Nacimiento"
        return textBox
    }()
    
    //a datepicker allows us to use a picker specifically made for dates
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(doneEditing), for: .valueChanged)
        return picker
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .blue
        textBox.inputView = datePicker
        contentView.addSubview(textBox)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textBox.frame =  CGRect(x: 20, y: 0, width: contentView.frame.width - 40, height: contentView.frame.height)
    }
    
    @objc func doneEditing(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        textBox.text = dateFormatter.string(from: sender.date)
    }
    
}
