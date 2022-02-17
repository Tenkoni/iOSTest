//
//  ViewController.swift
//  iOSTest
//
//  Created by Lui on 15/02/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, CustomCellDelegate {
    
    var tableValues = [CellType.Camera, CellType.Photo, CellType.Name, CellType.Phone, CellType.Birth, CellType.Gender, CellType.Color]
    var selectedCells = [CellType]()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CustomCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Siguiente", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        title = "Datos personales"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(tableView)
        view.addSubview(nextButton)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //configuring the layout, this way we will have a table and botton on the same view, allowing compression between table bottom and button
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        let tableBottomConst = tableView.bottomAnchor.constraint(equalTo: nextButton.topAnchor)
        tableBottomConst.priority = UILayoutPriority(999)
        tableBottomConst.isActive = true
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomCell else {return UITableViewCell()}
        cell.configureCell(cellType: tableValues[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableValues.count
    }
    
    func switchTrackingOf(cellType: CellType) {
        if selectedCells.isEmpty {
            selectedCells.append(cellType)
            return
        }
        if selectedCells.contains(cellType) {
            guard let index = selectedCells.firstIndex(of: cellType) else { return }
            selectedCells.remove(at: index)
        } else {
            selectedCells.append(cellType)
        }
    }
    
    @objc func nextPage(_ sender: UIButton) {
        //Alert in case the user didn't select anything
        if selectedCells.isEmpty {
            let ac = UIAlertController(title: "No selected options!", message: "Please, select at least one option before continuing.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Okay", style: .default))
            present(ac, animated: true)
        } else {
        //logic for moving to the next View, needs a basic implementation first at least before including this logic
        //the basic implementation should pass the selected cells to the new view, so the new view can format a table
        //according to the options of the user.
            print(selectedCells)
            let nextView = FillingViewController()
            nextView.optionsList = selectedCells
            self.navigationController?.pushViewController(nextView, animated: true)
        }
        
    }
    

}


