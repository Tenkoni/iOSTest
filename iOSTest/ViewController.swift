//
//  ViewController.swift
//  iOSTest
//
//  Created by Lui on 15/02/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    var tableValues = [CellType.Camera, CellType.Photo, CellType.Name, CellType.Phone, CellType.Birth, CellType.Gender, CellType.Color]
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CustomCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        title = "Data form"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.frame
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomCell else {return UITableViewCell()}
        cell.configureCell(cellType: tableValues[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableValues.count
    }

}


