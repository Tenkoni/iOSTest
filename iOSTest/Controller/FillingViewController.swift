//
//  FillingViewController.swift
//  iOSTest
//
//  Created by Lui on 16/02/22.
//

import UIKit

class FillingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var optionsList: [CellType]!
    //keeping track of the currently selected cell
    var curretCellIndex: IndexPath!
    
    let tableView: UITableView = {
        let tableView = UITableView()
        //defining the cells our table is going to have
        tableView.register(CameraCell.self, forCellReuseIdentifier: CellType.Camera.rawValue)
        tableView.register(PictureCell.self, forCellReuseIdentifier: CellType.Photo.rawValue)
        tableView.register(NameCell.self, forCellReuseIdentifier: CellType.Name.rawValue)
        tableView.register(NumberCell.self, forCellReuseIdentifier: CellType.Phone.rawValue)
        tableView.register(DateCell.self, forCellReuseIdentifier: CellType.Birth.rawValue)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add your information"
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        view.addSubview(tableView)

    }
    
    override func viewWillLayoutSubviews() {
        //currently the tableview takes all the view area, will change
        //later to only use the safe guide layout
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //we display an specific cell class according to the parameters supplied
        //on the first view's table. Using the enumerator to identify them
        switch optionsList[indexPath.row] {
        case CellType.Camera:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellType.Camera.rawValue) as? CameraCell else { fatalError("Unable to dequeue cell.") }
            return cell
            
        case CellType.Photo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellType.Photo.rawValue) as? PictureCell else { fatalError("Unable to dequeue cell.") }
            //fetching an image (async), as required
            fetchImageFrom(url: "https://http2.mlstatic.com/vegeta-tamano-real-para-armar-en-papercraft-D_NQNP_892880-MLA26232224460_102017-F.jpg", for: cell)
            return cell
            
        case CellType.Name:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellType.Name.rawValue) as? NameCell else { fatalError("Unable to dequeue cell.") }
            return cell
            
        case CellType.Phone:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellType.Phone.rawValue) as? NumberCell else { fatalError("Unable to dequeue cell.") }
            return cell
            
        case CellType.Birth:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellType.Birth.rawValue) as? DateCell else { fatalError("Unable to dequeue cell.") }
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
    
    @objc func adjustKeyboard(notification: Notification) {
        //getting the keyboard object, included in the notification
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey]  as? NSValue else { return }
        //getting the frame of the keyboard to locate it on screen
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)
        //depending the notification type we will adjust the table accordingly
        if notification.name == UIResponder.keyboardWillHideNotification {
            tableView.contentInset = .zero
        } else {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        tableView.scrollIndicatorInsets = tableView.contentInset
        
    }
    
}
