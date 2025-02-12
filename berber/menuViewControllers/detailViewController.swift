//
//  detailViewController.swift
//  berber
//
//  Created by Cem Sezeroglu on 22.10.2020.
//

import UIKit
import Firebase
import SwiftGifOrigin

class detailViewController: UIViewController, UITextFieldDelegate {
    let language = LanguageCheck()
    //MARK: İnitialize database - ref
    private let database = Database.database().reference()
    
    let userDate = UserDefaults.standard
    
    @IBOutlet weak var buttonsView: UIView!
    
    @IBOutlet weak var iptalView: UIView!
    
    //MARK: Properties
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var dateAndTimeText: UITextField!
    var dateLabelWithoutTime = ""
    
    @IBOutlet weak var phoneText: UITextField!
    
    @IBOutlet var buttons: [UIButton]!
    var berberName = ""
    
    @IBOutlet weak var iptalEtButton: UIButton!
    let attributedString = NSAttributedString(string: "Randevuyu İptal Et", attributes:[
        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16.0),
        NSAttributedString.Key.foregroundColor : UIColor.red,
        NSAttributedString.Key.underlineStyle:1.0
    ])
    //Summary view elements
    @IBOutlet weak var checkMark: UIImageView!
    @IBOutlet weak var reserveButton: UIButton!
    @IBOutlet weak var summaryText: UITextView!
    @IBOutlet weak var summaryLabel: UILabel!
    
    //MARK: Objects
    let dateFormatter = DateFormatter()
    let datePicker = UIDatePicker()
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneText.delegate = self
        createDatepicker()
        initializeHideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureReserveButton()
        
        buttonCornerRadious(buttons: buttons)
        summaryText.layer.cornerRadius = 10
        summaryText.layer.masksToBounds = true
        summaryText.addShadowToTextField()
        phoneText.keyboardType = .numberPad

        iptalEtButton.setAttributedTitle(attributedString, for: .normal)
       
        configureActivity()
        addShadowToNavBar()
        detectReservationNotNilOrNil()
        
      
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.clear.cgColor
    }
    
  
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let textFieldText = phoneText.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 11
        }
    
    func addShadowToNavBar(){
        
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.white.cgColor
            self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            self.navigationController?.navigationBar.layer.shadowRadius = 4.0
            self.navigationController?.navigationBar.layer.shadowOpacity = 1.0
            self.navigationController?.navigationBar.layer.masksToBounds = false
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
    
  
    
    func detectReservationNotNilOrNil(){
        
      
        
        if userDate.object(forKey: "Date") != nil { //Eğer date nil değilse demek ki bir randevusu var
            
            let reservationDate = userDate.object(forKey: "Date") as! Date //Randevu tarihi al
            let currentDate = Date() //Bugünün tarihini al
            
            if (currentDate >= reservationDate) { //Bugünün tarihi, rezervasyon yarihinden büyükse ya geçmişse
                //Demekki randevusu var ama tarihi geçmiş
                let userInfo = userDate.dictionary(forKey: "userInformation")
                if userInfo != nil {
                    let tamRandevu = userInfo!["tamRandevu"] as? String
                    
                    let stationsRef = database.child("byMakas") //Eğer yeni bir ref'e eklenicekse. örn xberber "byMakas" ismi değişicek
                    stationsRef.child(tamRandevu!).removeValue()
                    updateNoUI()
                    userDate.removeObject(forKey: "userInformation")
                    userDate.removeObject(forKey: "Date")
                }else{
                    updateNoUI()
                }
              
                
            }else if (currentDate <= reservationDate)  {
                //Randevusu var ve tarihi geçmemiş
                updateReservationUI()
                checkMark.image = UIImage(named: "checkMArk")
            }
            
        }else{
            
            updateNoUI()
        }
    }
    
    //MARK: Create datePicker for toolBar
    func createDatepicker() {
        
        datePicker.preferredDatePickerStyle = .wheels
        dateAndTimeText.inputView = datePicker
        let loc = Locale(identifier: "tr")
        self.datePicker.minuteInterval = 30
     
        self.datePicker.locale = loc
        
        dateAndTimeText.inputAccessoryView = createToolBar()
        
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
    
    @IBAction func iptalEtButton(_ sender: UIButton) {
        
        activityIndicator.startAnimating()
        
       
        let userInfo = userDate.dictionary(forKey: "userInformation")
        
        let tamRandevu = userInfo!["tamRandevu"] as? String
      
        userDate.removeObject(forKey: "userInformation")
        userDate.removeObject(forKey: "Date")
        
        updateNoUI()
        
        let stationsRef = database.child("byMakas") //Eğer yeni bir ref'e eklenicekse. örn xberber "byMakas" ismi değişicek
        stationsRef.child(tamRandevu!).setValue(nil)
        
        
        
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
    
    func updateNoUI(){
        
        nameText.text = ""
        phoneText.text = ""
        dateAndTimeText.text = ""
        
        nameText.isUserInteractionEnabled = true
        phoneText.isUserInteractionEnabled = true
        dateAndTimeText.isUserInteractionEnabled = true
        
        buttonsView.isHidden = false
        checkMark.isHidden = true
        summaryText.isHidden = true
        summaryLabel.isHidden = true
        reserveButton.isHidden = false
        iptalView.isHidden = true
        
        activityIndicator.stopAnimating()
        
        
    
    }
 
    
    func  updateReservationUI(){
        
        let userInfo = userDate.dictionary(forKey: "userInformation")
        
       
        
        nameText.text = userInfo!["name"] as? String
        phoneText.text = userInfo!["phoneNumber"] as? String
        dateAndTimeText.text = userInfo!["tarih"] as? String
        berberName =  (userInfo!["berberAd"] as? String)!
        
        summaryText.text = "İsim Soyad : \(nameText.text ?? "nil")"+"\n"+"Berber : \(berberName)"+"\n"+"Tarih : \(dateAndTimeText.text ?? "nil")"
        
        nameText.isUserInteractionEnabled = false
        phoneText.isUserInteractionEnabled = false
        dateAndTimeText.isUserInteractionEnabled = false
        
        checkMark.isHidden = false
        summaryText.isHidden = false
        summaryLabel.isHidden = false
        reserveButton.isHidden = true
        buttonsView.isHidden = true
        iptalView.isHidden = false
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
        
        self.dateAndTimeText.text = dateFormatter.string(from: datePicker.date)
        
        
        let split =  dateAndTimeText.text!.split(separator: " ")
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
        if summaryText.text == "" || nameText.text == "" || berberName == "" {
            
            makeAllert(titleInput: "Uyarı", messageInput: "Eksik bilgi girdiniz")
            activityIndicator.stopAnimating()
            
        }else{
            
            reserveButton.isEnabled = false
            checkAvalibility(name: nameText.text ?? "nil", berber: berberName, date: dateAndTimeText.text ?? "nil", phoneNumber: phoneText.text ?? "nil")
            
            userDate.set(datePicker.date, forKey: "Date")//Reservasyon tarihini userDefaults'a kaydetme işlemi.
            
            summaryText.text = "İsim Soyad : \(nameText.text ?? "nil")"+"\n"+"Berber : \(berberName)"+"\n"+"Tarih : \(dateAndTimeText.text ?? "nil")"
            
             
            
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
        
        let userobject : [String:String] = ["name":name ,"berberAd":berber ,"tarih":date ,"tamRandevu":tamRandevu,"phoneNumber":phoneNumber]
        
        //MARK:Kullanıcının randevu bilgilerini kaydet
        userDate.set(userobject, forKey: "userInformation")
        //MARK:Kullanıcı Randevu Tarihi
        userDate.set(datePicker.date, forKey: "Date")
        
        let stationsRef = database.child("byMakas") //Eğer yeni bir ref'e eklenicekse. örn xberber "byMakas" ismi değişicek
        stationsRef.child(tamRandevu).setValue(object)
        updateReservationUI()
      
        checkMark.loadGif(name: "giphy")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4.2) {
            self.checkMark.image = UIImage(named: "checkMArk")
        }
       
        activityIndicator.stopAnimating()
        
        
    }
    
    ///Gerekli bilgiler eksik mi değil mi kontrolü
    func doneButtonEmptyCheck(){
        if summaryText.text == "" || nameText.text == "" || berberName == "" {
            makeAllert(titleInput: "Uyarı", messageInput: "Eksik bilgi girdiniz")
        }else{
            summaryText.text = "İsim Soyad : \(nameText.text ?? "nil")"+"\n"+"Berber : \(berberName)"+"\n"+"Tarih : \(dateAndTimeText.text ?? "nil")"
            
        }
    }
    
    func makeAllert(titleInput :String,messageInput:String){
            let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: When user press done in toolbar Dismiss toolbar
    @objc func doneBerberListPressed(){
        
        view.endEditing(true)
    }
    func configureReserveButton(){
        reserveButton.layer.cornerRadius = 5
        reserveButton.layer.masksToBounds = true
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

extension UITextView {

    func addShadowToTextField(color: UIColor = UIColor.black) {

   
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 4.0, height: 3.0)
        self.layer.shadowOpacity = 0.3
   
    
   }
}
extension String {

    func split(regex pattern: String) -> [String] {

        guard let re = try? NSRegularExpression(pattern: pattern, options: [])
            else { return [] }

        let nsString = self as NSString // needed for range compatibility
        let stop = "<SomeStringThatYouDoNotExpectToOccurInSelf>"
        let modifiedString = re.stringByReplacingMatches(
            in: self,
            options: [],
            range: NSRange(location: 0, length: nsString.length),
            withTemplate: stop)
        return modifiedString.components(separatedBy: stop)
    }
}
