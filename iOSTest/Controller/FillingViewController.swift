//
//  FillingViewController.swift
//  iOSTest
//
//  Created by Lui on 16/02/22.
//

import UIKit

class FillingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var optionsList: [CellType]!
    var curretCellIndex: IndexPath!
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CameraCell.self, forCellReuseIdentifier: CellType.Camera.rawValue)
        tableView.register(PictureCell.self, forCellReuseIdentifier: CellType.Photo.rawValue)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add your information"
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch optionsList[indexPath.row] {
        case CellType.Camera:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellType.Camera.rawValue) as? CameraCell else { fatalError("Unable to dequeue cell.") }
            return cell
        case CellType.Photo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellType.Photo.rawValue) as? PictureCell else { fatalError("Unable to dequeue cell.") }
            fetchImageFrom(url: "https://http2.mlstatic.com/vegeta-tamano-real-para-armar-en-papercraft-D_NQNP_892880-MLA26232224460_102017-F.jpg", for: cell)
            return cell
        default:
            return UITableViewCell()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if optionsList[indexPath.row] == CellType.Camera {
            //in case the camera cell is selected, we are going to open an imagepicker to
            //allow the camera and gallery usage
            curretCellIndex = indexPath
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.allowsEditing = true
            vc.delegate = self
            present(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if optionsList[indexPath.row] == CellType.Camera {
            return 200
        } else if optionsList[indexPath.row] == CellType.Photo {
            return 400
        }
        return tableView.rowHeight
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        //checking if we actually got a picture
        guard let image = info[.editedImage] as? UIImage else { return }
        guard let cell = tableView.cellForRow(at: curretCellIndex) as? CameraCell else { return }
        cell.setImage(image)
    }
    
    func fetchImageFrom(url: String, for cell: PictureCell){
        guard let url = URL(string: url) else { return }
        DispatchQueue.global(qos: .userInitiated).async { [weak cell] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell?.setImage(image)
                    }
                }
            }
        }
    }
    
}
