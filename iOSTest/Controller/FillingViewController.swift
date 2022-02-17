//
//  FillingViewController.swift
//  iOSTest
//
//  Created by Lui on 16/02/22.
//

import UIKit

class FillingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, GenderCellDelegate {
    
    var optionsList: [CellType]!
    //keeping track of the currently selected cell
    var curretCellIndex: IndexPath!
    var genderTracker: [CellType:IndexPath]!
    //color we want
    var colorCell = [CellColors.Green, CellColors.Yellow, CellColors.Orange, CellColors.Red, CellColors.Purple, CellColors.Blue]
    //sections number
    var sections: Int!
    //tracking the sections
    var rowsForSection: [SectionStruct]!
    
    let tableView: UITableView = {
        let tableView = UITableView()
        //defining the cells our table is going to have
        tableView.register(CameraCell.self, forCellReuseIdentifier: CellType.Camera.rawValue)
        tableView.register(PictureCell.self, forCellReuseIdentifier: CellType.Photo.rawValue)
        tableView.register(NameCell.self, forCellReuseIdentifier: CellType.Name.rawValue)
        tableView.register(NumberCell.self, forCellReuseIdentifier: CellType.Phone.rawValue)
        tableView.register(DateCell.self, forCellReuseIdentifier: CellType.Birth.rawValue)
        tableView.register(GenderCell.self, forCellReuseIdentifier: CellType.Gender.rawValue)
        tableView.register(ColorCell.self, forCellReuseIdentifier: CellType.Color.rawValue)

        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Agrega tu información"
        view.backgroundColor = .systemBackground
        //we will know how many sections do we have given the number of selections on the first table
        sections = optionsList.count
        //sorting array to always have the same element order
        optionsList.sort{$0<$1}
        rowsForSection = [SectionStruct]()
        //calculating the number of elements for each section
        for element in optionsList {
            if element == .Gender {
                rowsForSection.append(SectionStruct(section: 2, cellType: .Gender))
            } else if element == .Color {
                rowsForSection.append(SectionStruct(section: colorCell.count, cellType: .Color))
            } else {
                rowsForSection.append(SectionStruct(section: 1, cellType: element))
            }
        }
        genderTracker = [CellType:IndexPath]()
        //preparing the datacells, here we change the gender option for specific male and female options
        if let index = optionsList.firstIndex(of: CellType.Gender) {
            optionsList.replaceSubrange(index..<index+1, with: [CellType.Female, CellType.Male])
        }
        //preparing the datacells for colors
        var colorSubarray = [CellType]()
        for _ in colorCell {
            colorSubarray.append(CellType.Color)
        }
        if let index = optionsList.firstIndex(of: CellType.Color) {
            optionsList.replaceSubrange(index..<index+1, with: colorSubarray)
        }

        //start listening to the notification center to detect the keyboard poping on screen, so we can adapt the content being displayed
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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //generating an index relative to the whole table, not only sections
        var row = indexPath.row
        for i in 0..<indexPath.section{
            row += self.tableView.numberOfRows(inSection: i)
        }
        
        //we display an specific cell class according to the parameters supplied
        //on the first view's table. Using the enumerator to identify them
        switch optionsList[row] {
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
            
        case CellType.Female:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellType.Gender.rawValue) as? GenderCell else { fatalError("Unable to dequeue cell.") }
            cell.delegate = self
            cell.configureCell(gender: CellType.Female)
            genderTracker[CellType.Female] = indexPath
            return cell
        case CellType.Male:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellType.Gender.rawValue) as? GenderCell else { fatalError("Unable to dequeue cell.") }
            cell.delegate = self
            cell.configureCell(gender: CellType.Male)
            genderTracker[CellType.Male] = indexPath
            return cell
        
        case CellType.Color:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellType.Color.rawValue) as? ColorCell else { fatalError("Unable to dequeue cell.") }
            cell.configureCell(color: colorCell[indexPath.row])
            return cell
            
        default:
            return UITableViewCell()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //as the number of rows for section are different we need a way to get the needed rows for each section
        return rowsForSection[section].section
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if optionsList[indexPath.section] == CellType.Camera {
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
        if optionsList[indexPath.section] == CellType.Camera {
            return 200
        } else if optionsList[indexPath.section] == CellType.Photo {
            return 400
        }
        return tableView.rowHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionHeader: String
        let sectionInfo = rowsForSection[section]
        //giving a name to all the sections
        switch sectionInfo.cellType {
            case .Name:
                sectionHeader = "Nombre completo"
            case .Camera:
                sectionHeader = "Cámara"
            case .Photo:
                sectionHeader = "Foto"
            case .Phone:
                sectionHeader = "Número telefónico"
            case .Gender:
                sectionHeader = "Sexo"
            case .Color:
                sectionHeader = "Color favorito"
            case .Birth:
                sectionHeader = "Fecha de nacimiento"
            default:
                sectionHeader = ""
        }
        return sectionHeader
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        //checking if we actually got a picture
        guard let image = info[.editedImage] as? UIImage else { return }
        guard let cell = tableView.cellForRow(at: curretCellIndex) as? CameraCell else { return }
        cell.setImage(image)
    }
    
    //async fetching of an image given a string representing the url
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
    
    //this method is called when the notification of the keyboard changing state is detected, it will allow us to always keep the cell being edited above the keyboard.
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
    
    func switchGenderActive(to gender: CellType) {
        //manages the switching between gender picks, deactivating the other when receiving a click notification throught the delegate
        if gender == CellType.Male {
            guard let cell = tableView.cellForRow(at: genderTracker[CellType.Female]!) as? GenderCell else { return }
            cell.turnOffButton()
        } else if gender == CellType.Female {
            guard let cell = tableView.cellForRow(at: genderTracker[CellType.Male]!) as? GenderCell else { return }
            cell.turnOffButton()
        }
    }
    
}
