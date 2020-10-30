//
//  ViewController.swift
//  berber
//
//  Created by Cem Sezeroglu on 16.10.2020.
//

import UIKit
import SwiftPhotoGallery
import Firebase

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var musaitlik = "Dolu"
    private let database = Database.database().reference()
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        berberNames.count
    }
   
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        berberNames[row]
        selectBerber.text = berberNames[row]
        
        return berberNames[row]
    }
    
    let imageNames = ["resim1", "resim2", "resim3","resim4","resim5"]
    let berberNames = ["Yavuz Kucur","Yılmaz Saatçi"]
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var selectBerber: UITextField!
    @IBOutlet weak var rezerveEtButton: UIButton!
    @IBOutlet weak var galeriButton: UIButton!
    
    @IBOutlet weak var konumButton: UIButton!
    @IBOutlet weak var iletisimButton: UIButton!
    
    @IBOutlet weak var aboutButton: UIButton!
    let dateFormatter = DateFormatter()
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createDatepicker()
        initializeHideKeyboard()
    }
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        
        if date.text == "" || name.text == "" {
            
            makeAllert(titleInput: "Hata", messageInput: "Girilen bilgiler eksik.")
            
        }else{
            makeAllerWithAction()
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureReserveButton()
        configureButtons(button: galeriButton)
        configureButtons(button: aboutButton)
        configureButtons(button: konumButton)
        configureButtons(button: iletisimButton)
        
        configureTextfield(textview: name)
        configureTextfield(textview: date)
        configureTextfield(textview: selectBerber)
        configurePlaceHolderColor()
        
    }
    @IBAction func galeriButtonClicked(_ sender: UIButton) {
        
        
       configureGalleryMedia()
    }
    
    @IBAction func konumButtonClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "konumVC", sender: self)
    }
    @IBAction func iletisimcClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "iletisimVC", sender: self)
    }
    
    @IBAction func hakkimizdaButton(_ sender: UIButton) {
        performSegue(withIdentifier: "hakkimizdaVC", sender: self)
    }
    
    func configureGalleryMedia(){
        
        let gallery = SwiftPhotoGallery(delegate: self, dataSource: self)

        gallery.backgroundColor = UIColor.black
        gallery.pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.5)
        gallery.currentPageIndicatorTintColor = UIColor.white
        gallery.hidePageControl = false
        gallery.modalPresentationStyle = .custom
        
        
        navigationController?.pushViewController(gallery, animated: true)
        
        
    }
    
    func configurePlaceHolderColor(){
        
        name.attributedPlaceholder = NSAttributedString(string: "İsim ve soyad girin", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        date.attributedPlaceholder = NSAttributedString(string: "Gün Tarih Seç", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        selectBerber.attributedPlaceholder = NSAttributedString(string: "Berberini Yaz", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }
   
    func makeAllerWithAction(){
        // Create the alert controller
        let alertController = UIAlertController(title: "Rezervasyon", message: "Rezervasyon Bilgilerin :\(name.text!) \n \(date.text!) \n \(selectBerber.text!) ", preferredStyle: .alert)

            // Create the actions
        let okAction = UIAlertAction(title: "Eminim", style: UIAlertAction.Style.default) {
                UIAlertAction in
            self.checkAvalibility(name: self.name, berber: self.selectBerber, date: self.date)
           
            
            self.areYouSure()
            
            
            }
        let cancelAction = UIAlertAction(title: "İptal", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
              
            }

            // Add the actions
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)

            // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
    }
    func createToolBar() -> UIToolbar{
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        
        toolBar.setItems([spaceButton,doneButton], animated: true)
        return toolBar
        
    }
    func createBerberList()-> UIToolbar{
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneBerberListPressed))
        
        
        toolBar.setItems([spaceButton,doneButton], animated: true)
        return toolBar
    }
    func configureTextfield(textview:UITextField){
        //Mark:TextField'ın altına çizgi
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textview.frame.height-2, width: textview.frame.width, height: 1)
        bottomLine.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        textview.layer.cornerRadius = 10
        
        textview.borderStyle = .none
        textview.layer.addSublayer(bottomLine)
        
    }
    
    func saveToDatabase(name:UITextField,berber:UITextField,date:UITextField){
        

       
        
    }

    func checkAvalibility(name:UITextField,berber:UITextField,date:UITextField){
        let object : [String:Any] = ["name":name.text ?? "nil","berber":berber.text ?? "nil","date":date.text ?? "nil","musait":musaitlik]
        
        database.child(date.text!).observeSingleEvent(of: .value) { (DataSnapshot) in
            guard let value = DataSnapshot.value  as? [String:Any] else {
              return
            }
            print("Seçilen Tarih :\(value["musait"] ?? "Date Nil")")
            if value["musait"] as! String == "Bos" {
                
                self.musaitlik = "Bos"
                self.database.child(date.text!).setValue(object)
                self.performSegue(withIdentifier: "detailsPage", sender: self)
            }else{
                self.musaitlik = "Dolu"
                self.makeAllert(titleInput: "Uyarı", messageInput: "Seçtiğin gün dolu")
                
            }
            
        }
    }
    
    func areYouSure(){
        selectBerber.text = ""
        date.text = ""
        name.text = ""
    }
    
    func createDatepicker(){
        
        datePicker.preferredDatePickerStyle = .wheels
        date.inputView = datePicker
        let loc = Locale(identifier: "tr")
        self.datePicker.locale = loc

        date.inputAccessoryView = createToolBar()
        
        let namePicker = UIPickerView()
        namePicker.dataSource = self
        namePicker.delegate = self
        
        selectBerber.inputAccessoryView = createBerberList()
        selectBerber.inputView = namePicker
        datePicker.preferredDatePickerStyle = .wheels
        
    }
    
    @objc func donePressed(){
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        self.date.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
        
    }
    
    @objc func doneBerberListPressed(){
        
        view.endEditing(true)
    }
    
    
    func configureReserveButton(){
        rezerveEtButton.layer.cornerRadius = 10
        rezerveEtButton.layer.masksToBounds = true
        rezerveEtButton.layer.borderWidth = 1
        rezerveEtButton.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
    }
    
    func configureButtons(button:UIButton){
        
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
       
        
        
    }
    
    func initializeHideKeyboard(){
     //Declare a Tap Gesture Recognizer which will trigger our dismissMyKeyboard() function
     let tap: UITapGestureRecognizer = UITapGestureRecognizer(
     target: self,
     action: #selector(dismissMyKeyboard))
     //Add this tap gesture recognizer to the parent view
     view.addGestureRecognizer(tap)
     }
    @objc func dismissMyKeyboard(){
    //endEditing causes the view (or one of its embedded text fields) to resign the first responder status.
    //In short- Dismiss the active keyboard.
    view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? detailViewController{
            destination.name = self.name.text ?? "nil"
            destination.date = selectBerber.text ?? "nil"
            destination.berber = date.text ?? "nil"
            
        }
    }
    
    func makeAllert(titleInput :String,messageInput:String){
            let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
    }
                
}

// MARK: SwiftPhotoGalleryDataSource Methods
extension ViewController:SwiftPhotoGalleryDataSource, SwiftPhotoGalleryDelegate{
    func numberOfImagesInGallery(gallery: SwiftPhotoGallery) -> Int {
        imageNames.count
    }

    func imageInGallery(gallery: SwiftPhotoGallery, forIndex: Int) -> UIImage? {
        return UIImage(named: imageNames[forIndex])
    }

    func galleryDidTapToClose(gallery: SwiftPhotoGallery) {
        dismiss(animated: true, completion: nil)
    }


}

