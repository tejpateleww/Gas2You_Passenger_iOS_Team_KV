//
//  HomeVC.swift
//  Gas 2 You
//
//  Created by MacMini on 02/08/21.
//

import UIKit



class HomeVC: BaseVC {
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var imgSelctService: UIImageView!
    @IBOutlet weak var gasServiceView: UIView!
    @IBOutlet var octaneButtons: [themeButton]!
    @IBOutlet weak var priceTagLabel: themeLabel!
    @IBOutlet weak var imgParkingLocation: UIImageView!
    @IBOutlet weak var locationLabel: themeLabel!
    @IBOutlet weak var selectDateButton: UIButton!
    @IBOutlet var timeSlotButtons: [themeButton]!
    @IBOutlet weak var imgSelectVehicle: UIImageView!
    @IBOutlet weak var checkTirePressureButton: UIButton!
    @IBOutlet weak var windshieldRefillButton: UIButton!
    @IBOutlet weak var lblSelectService: themeLabel!
    @IBOutlet weak var lblSelectedService: themeLabel!
    @IBOutlet weak var lblSelectGrade: themeLabel!
    @IBOutlet weak var btnGradeVal1: themeButton!
    @IBOutlet weak var btnGradeVal2: themeButton!
    @IBOutlet weak var lblSelectedGrade: themeLabel!
    @IBOutlet weak var lblPerGallon: themeLabel!
    @IBOutlet weak var lblParkingLocation: themeLabel!
    @IBOutlet weak var lblSelectDateTime: themeLabel!
    @IBOutlet weak var selectedDate: themeLabel!
    @IBOutlet weak var lblSelectVehicle: themeLabel!
    @IBOutlet weak var lblSelectedVehicle: themeLabel!
    @IBOutlet weak var lblAddOns: themeLabel!
    @IBOutlet weak var lblTirePressure: themeLabel!
    @IBOutlet weak var lblTirePressurePriceTag: themeLabel!
    @IBOutlet weak var lblWindShield: themeLabel!
    @IBOutlet weak var lblWindShieldPriceTag: themeLabel!
    @IBOutlet weak var btnFillup: ThemeButton!
    @IBOutlet weak var btnSelectService: UIButton!
    @IBOutlet weak var btnSelectParkingLocation: UIButton!
    @IBOutlet weak var btnSelectVehicle: UIButton!
    @IBOutlet weak var btnDatePicker: UIButton!
    
    
    
    var toolBarForService = UIToolbar()
    var toolBarForVehicle = UIToolbar()
    var toolBar = UIToolbar()
    
    var vehiclePicker = UIPickerView()
    var servicePicker = UIPickerView()
    var listOfVehicle = ["Supra", "R8", "M5"]
    var serviceList = ["Gas", "Diesel"]
    
    var datePicker  = UIDatePicker()
    let dateFormatter = DateFormatter()
    
    //MARK:- GLOBAL PROPERTIES
    
    
    
    //MARK:- VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NavbarrightButton()
        NavBarTitle(isOnlyTitle: false, isMenuButton: true, title: "Schedule Service", controller: self)
        
        vehiclePicker.delegate = self
        vehiclePicker.dataSource = self
        
        servicePicker.delegate = self
        servicePicker.dataSource = self
        dateFormatter.dateStyle = .long
        dateFormatter.dateFormat = "MMM d, yyyy"
        deselectOtherTimeSlot(tag: 0)
        let today = Date()
        let nextDate = Calendar.current.date(byAdding: .day, value: 2, to: today)
        if let date = nextDate {
            selectedDate.text = dateFormatter.string(from: date)
        }
        
      
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    
    //MARK:- ACTIONS
    
    @IBAction func btnSelectServiceTap(_ sender: UIButton) {
        
        onDoneButtonTappedService()
        onDoneButtonTappedVehicle()
        onDoneButtonDate()
        
        setServicePicker()
    }
    
    @IBAction func octaneButtonPressed(_ sender: themeButton) {
        
        switch sender.tag {
        case 0:
            deselectOtherOctaneButtons(tag: sender.tag)
            break
        case 1:
            deselectOtherOctaneButtons(tag: sender.tag)
            break
        default:
            break
        }
    }
    
    @IBAction func btnParkingLocationTap(_ sender: UIButton) {
        let carParkingLocationVC = storyboard?.instantiateViewController(withIdentifier: "CarParkingLocationVC") as! CarParkingLocationVC
        navigationController?.pushViewController(carParkingLocationVC, animated: true)
    }
    
    @IBAction func timeSlotButtonPressed(_ sender: themeButton) {
        
        switch sender.tag {
        case 0:
            deselectOtherTimeSlot(tag: sender.tag)
            break
        case 1:
            deselectOtherTimeSlot(tag: sender.tag)
            break
        case 2:
            deselectOtherTimeSlot(tag: sender.tag)
            break
        case 3:
            deselectOtherTimeSlot(tag: sender.tag)
            break
        default:
            break
        }
        
    }
    
    @IBAction func btnSelectVehicleTap(_ sender: UIButton) {
        
        if listOfVehicle.count == 0 {
            // show button for adding new vehicle
        } else {
            
            onDoneButtonTappedService()
            onDoneButtonTappedVehicle()
            onDoneButtonDate()
            
            setVehiclePicker()
        }
    }
 
    @IBAction func tirePressureButtonPressed(_ sender: UIButton) {
        checkTirePressureButton.isSelected.toggle()
        if checkTirePressureButton.isSelected {
            checkTirePressureButton.setImage(#imageLiteral(resourceName: "IC_selectedBlue"), for: .normal)
        } else {
            checkTirePressureButton.setImage(#imageLiteral(resourceName: "IC_unselectedBlue"), for: .normal)
        }
    }
    
    @IBAction func windShieldRefillButtonPressed(_ sender: UIButton) {
        windshieldRefillButton.isSelected.toggle()
        if windshieldRefillButton.isSelected {
            windshieldRefillButton.setImage(#imageLiteral(resourceName: "IC_selectedBlue"), for: .normal)
        } else {
            windshieldRefillButton.setImage(#imageLiteral(resourceName: "IC_unselectedBlue"), for: .normal)
        }
    }
    
    @IBAction func fillItUpButtonPressed(_ sender: ThemeButton) {
        
        let slideToConfirmVC: SlideToConfirmVC = SlideToConfirmVC.instantiate(fromAppStoryboard: .Main)
        slideToConfirmVC.completion = {
            let myOrdersVC: MyOrdersVC = MyOrdersVC.instantiate(fromAppStoryboard: .Main)
            self.navigationController?.pushViewController(myOrdersVC, animated: true)
        }
        
        
        slideToConfirmVC.modalPresentationStyle = .overFullScreen
        present(slideToConfirmVC, animated: false, completion: nil)
        
    }
    
    @IBAction func btnDatePickerTap(_ sender: UIButton) {
        
        onDoneButtonTappedService()
        onDoneButtonTappedVehicle()
        onDoneButtonDate()
        
        setDatePicker()
        
    }
    
    //MARK:- OTHER METHODS
    
    func deselectOtherTimeSlot(tag: Int) {
        
        for i in 0..<timeSlotButtons.count {
            if tag == i {
//                timeSlotButtons[i].isSelected = true
                timeSlotButtons[i].backgroundColor = UIColor(hexString: ThemeColor.themeBlue.rawValue)
                timeSlotButtons[i].layer.cornerRadius = 5
                timeSlotButtons[i].layer.masksToBounds = true
                timeSlotButtons[i].setTitleColor(.white, for: .normal)
            } else {
//                timeSlotButtons[i].isSelected = false
                timeSlotButtons[i].backgroundColor = .white
                timeSlotButtons[i].setTitleColor(.black, for: .normal)

            }
        }
    }
    
    func deselectOtherOctaneButtons(tag: Int) {
        
        for i in 0..<octaneButtons.count {
            if tag == i {
                octaneButtons[i].setImage(#imageLiteral(resourceName: "IC_selectedCheckGray"), for: .normal)
            } else {
                octaneButtons[i].setImage(#imageLiteral(resourceName: "IC_unselectedGray"), for: .normal)
            }
        }
    }
    
    func setServicePicker() {
        
        servicePicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 250, width: UIScreen.main.bounds.width, height: 250)
        servicePicker.backgroundColor = .white
        self.view.addSubview(servicePicker)
        
        toolBarForService = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 250, width: UIScreen.main.bounds.size.width, height: 50))
        toolBarForService.barStyle = .default
        toolBarForService.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTappedService))]
        self.view.addSubview(toolBarForService)
        
    }
    
    @objc func onDoneButtonTappedService() {
        toolBarForService.removeFromSuperview()
        servicePicker.removeFromSuperview()
    }
    
    func setVehiclePicker() {
        
        vehiclePicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 250, width: UIScreen.main.bounds.width, height: 250)
        vehiclePicker.backgroundColor = .white
        self.view.addSubview(vehiclePicker)
        
        toolBarForVehicle = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 250, width: UIScreen.main.bounds.size.width, height: 50))
        toolBarForVehicle.barStyle = .default
        toolBarForVehicle.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTappedVehicle))]
        self.view.addSubview(toolBarForVehicle)
        
    }
    
    @objc func onDoneButtonTappedVehicle() {
        toolBarForVehicle.removeFromSuperview()
        vehiclePicker.removeFromSuperview()
    }
    
    func setDatePicker() {
        
        datePicker = UIDatePicker.init()
        
        datePicker.autoresizingMask = .flexibleWidth
        datePicker.datePickerMode = .date
        
        let today = Date()
        let nextDate = Calendar.current.date(byAdding: .day, value: 2, to: today)
        datePicker.minimumDate = nextDate

        let nextMonth = Calendar.current.date(byAdding: .day, value: 33, to: today)
        datePicker.maximumDate = nextMonth
        
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
            // Fallback on earlier versions
        }
        
        datePicker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)
        datePicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 250, width: UIScreen.main.bounds.size.width, height: 250)
        datePicker.backgroundColor = .white
        self.view.addSubview(datePicker)
        
        toolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 250, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
        toolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onDoneButtonDate))]
        toolBar.sizeToFit()
        self.view.addSubview(toolBar)
    }
    
    @objc func onDoneButtonDate() {
        toolBar.removeFromSuperview()
        datePicker.removeFromSuperview()
    }
    
    @objc func dateChanged(_ sender: UIDatePicker?) {
        
        if let date = sender?.date {
            print("Picked the date \(dateFormatter.string(from: date))")
            selectedDate.text = dateFormatter.string(from: date)
        }
    }
    
}

//MARK:- EXTENSIONS

extension HomeVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == servicePicker {
            return serviceList.count
        } else {
            return listOfVehicle.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == servicePicker {
            return serviceList[row]
        } else {
            return listOfVehicle[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == servicePicker {
            lblSelectedService.text = serviceList[row]
        } else {
            lblSelectedVehicle.text = listOfVehicle[row]
        }
    }
    
}
