//
//  addReservationViewController.swift
//  berber
//
//  Created by Cem Sezeroglu on 30.11.2020.
//

import UIKit
import Firebase

class addReservationViewController: UIViewController, UITextFieldDelegate {
    let language = LanguageCheck()
    //MARK: İnitialize database - ref
    private let database = Database.database().reference()
    
    
    @IBOutlet weak var isim: UITextField!
    @IBOutlet weak var telefon: UITextField!
    @IBOutlet weak var rezerveEt: UIButton!
    @IBOutlet weak var tarihSaat: UITextField!
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet var buttons: [UIButton]!
    var berberName = ""
    var dateLabelWithoutTime = ""
    
    //MARK: Objects
    let dateFormatter = DateFormatter()
    let datePicker = UIDatePicker()
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        telefon.delegate = self
        createDatepicker()
        initializeHideKeyboard()
        telefon.keyboardType = .numberPad
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        rezerveEt.isEnabled = true
        rezerveEt.alpha = 1
        infoView.isHidden = true
        infoView.layer.cornerRadius = 10
        infoView.layer.masksToBounds = true
        configureReserveButton()
        
        buttonCornerRadious(buttons: buttons)
        configureActivity()
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let textFieldText = telefon.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 11
        }
    
    //MARK: Create datePicker for toolBar
    func createDatepicker() {
        
        datePicker.preferredDatePickerStyle = .wheels
        tarihSaat.inputView = datePicker
        let loc = Locale(identifier: "tr")
        self.datePicker.minuteInterval = 30
     
        self.datePicker.locale = loc
        
        tarihSaat.inputAccessoryView = createToolBar()
        
    }
    func languageCheking()-> String{
            
            if language.preferredLanguage() == "en"{
                
                return  "en"
                
                }else if language.preferredLanguage() == "tr"{
                
                    return  "tr"
                
                    }else if language.preferredLanguage() == "it"{
                        return  "it"
                
                        }else{
                            return  "zh"
            }
        }
    //MARK:Toolbar For Date and time
    func createToolBar() -> UIToolbar{
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let tamamButton = UIBarButtonItem(title: "Tamam", style: UIBarButtonItem.Style.plain, target: nil, action: #selector(donePressed))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
       
        toolBar.setItems([spaceButton,tamamButton], animated: true)
        return toolBar
        
    }
    //MARK: what happens When user press done in toolbar
    @objc func donePressed(){
        
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        
        if languageCheking() == "tr"{
            dateFormatter.locale = NSLocale.init(localeIdentifier: "tr") as Locale
        }else{
            dateFormatter.locale = NSLocale.init(localeIdentifier: "tr") as Locale
        }
       
        
        self.tarihSaat.text = dateFormatter.string(from: datePicker.date)
        
        
        let split =  tarihSaat.text!.split(separator: " ")
        print(split)
        dateLabelWithoutTime = split[0]+" "+split[1]+" "+split[2]
        
        
        doneButtonEmptyCheck()
        
        view.endEditing(true)
        
    }
    //MARK:Rezerve et butonuna tıklama eylemi
    @IBAction func rezerveEtButtonClicked(_ sender: UIButton) {
        
        if NetworkMonitor.shared.isConnected {
        //Belirtilen tarih ve berber boş mu dolu mu kontrol et - > checkAvalibility()
        activityIndicator.startAnimating()
        if  isim.text == "" || berberName == "" {
            
            makeAllert(titleInput: "Uyarı", messageInput: "Eksik bilgi girdiniz")
            activityIndicator.stopAnimating()
            
        }else{
            
            checkAvalibility(name: isim.text ?? "nil", berber: berberName, date: tarihSaat.text ?? "nil", phoneNumber: telefon.text ?? "nil")
            
        }
            
        }else{
            makeAllert(titleInput: "Uyarı", messageInput: "İnternet bağlantınızı kontrol edin ve uygulamayı yeniden başlatın")
        }
        
        
    }
    ///seçilen tarih boş mu değil mi kontrolü
    func checkAvalibility(name:String,berber:String,date:String,phoneNumber:String){
        let tamRandevu = date+" "+berber
        //database.child("byMakas") ulaşmak istediğimiz child'ı temsil ediyor eğer bu isim değişicekse erişilmek istenen ref ismi doğru yazılmalı.
        database.child("byMakas").child(tamRandevu).observeSingleEvent(of: .value, with: { (snapshot) in
          // Get user value
          let value = snapshot.value as? NSDictionary
          let randevu = value?["tamRandevu"] as? String ?? ""
            
            if randevu == tamRandevu{
                
                print("Bu randevu Dolu")
                self.makeAllert(titleInput: "Randevu saati dolu", messageInput: "Randevu saati dolu. Berberinizi ya da saati yeniden seçiniz.")
                self.activityIndicator.stopAnimating()
            }else{
                //Eğer boşsa database'e kaydet.
                self.saveToDatabase(name: name, berber: berber, date: date,dateWithoutTime: self.dateLabelWithoutTime, phoneNumber: phoneNumber)
                self.infoView.isHidden = false
                self.rezerveEt.isEnabled = false
                self.rezerveEt.alpha = 0.5
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                    self.navigationController?.popViewController(animated: true)
                }
            }

          // ...
          }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    //Database'e kayıt
    func saveToDatabase(name:String,berber:String,date:String,dateWithoutTime:String,phoneNumber:String){
        
        let tamRandevu = date+" "+berber
        let object : [String:Any] = ["name":name ,"berberAd":berber ,"tarih":dateWithoutTime ,"tamRandevu":tamRandevu,"phoneNumber":phoneNumber]
  
        
        let stationsRef = database.child("byMakas") //Eğer yeni bir ref'e eklenicekse. örn xberber "byMakas" ismi değişicek
        stationsRef.child(tamRandevu).setValue(object)
     
        activityIndicator.stopAnimating()
        
        
    }
    ///Gerekli bilgiler eksik mi değil mi kontrolü
    func doneButtonEmptyCheck(){
        if  isim.text == "" || berberName == "" {
            makeAllert(titleInput: "Uyarı", messageInput: "Eksik bilgi girdiniz")
        }else{
         
        }
    }
    @objc func doneBerberListPressed(){
        
        view.endEditing(true)
    }
    func configureReserveButton(){
        rezerveEt.layer.cornerRadius = 5
        rezerveEt.layer.masksToBounds = true
    }
    @IBAction func buttonPressToggle(_ sender: UIButton) {
        guard buttons != nil else { return }//collectionOfButtons -> your outlet collection
        
        for btn in buttons {
            
            if btn == sender {
                btn.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1098039216, alpha: 1)
                btn.setTitleColor(.white, for: .normal)
                addShadowToButton(btn: btn)
                self.berberName = btn.titleLabel?.text ?? "Nil"
//                #colorLiteral(red: 0.6128053617, green: 0.6128053617, blue: 0.6128053617, alpha: 1)
            } else {
                btn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                btn.setTitleColor(.black, for: .normal)
                btn.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
                btn.layer.shadowColor = UIColor.white.cgColor
            }
        }
    }
    func makeAllert(titleInput :String,messageInput:String){
            let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
    }

    
    func buttonCornerRadious(buttons:[UIButton]){
        for btn in buttons{
            btn.layer.cornerRadius = 5
            btn.layer.masksToBounds = true
            btn.layer.borderWidth = 1
            btn.layer.borderColor = #colorLiteral(red: 0.1450980392, green: 0.1450980392, blue: 0.1450980392, alpha: 1)
        }
    }
    func addShadowToButton(btn:UIButton){
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: 5.0, height: 6.0)
        btn.layer.shadowRadius = 8
        btn.layer.shadowOpacity = 0.5
        btn.layer.masksToBounds = false
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
    func configureActivity(){
          activityIndicator.center = self.view.center
          activityIndicator.hidesWhenStopped = true
          activityIndicator.style = UIActivityIndicatorView.Style.large
          activityIndicator.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
          activityIndicator.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
          activityIndicator.autoresizingMask = [
              .flexibleLeftMargin,
              .flexibleRightMargin,
              .flexibleTopMargin,
              .flexibleBottomMargin
          ]
          self.view.addSubview(activityIndicator)
          
      }
  

}


