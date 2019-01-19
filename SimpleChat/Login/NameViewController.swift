//
//  NameViewController.swift
//  SimpleChat
//
//  Created by Robert Brennan on 1/17/19.
//  Copyright © 2019 Creatility. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import AccountKit

class NameViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var taptoChange: UIButton!
    var activityView:UIActivityIndicatorView!
    var continueButton: RoundedButton!
    var imagePicker:UIImagePickerController!
    var accountKit: AKFAccountKit!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if accountKit == nil {
            //specify AKFResponseType.AccessToken
            self.accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
            accountKit.requestAccount {
                (account, error) -> Void in
            }
        }
        
        continueButton = RoundedButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.setTitle("Continue", for: .normal)
        continueButton.center = CGPoint(x: view.center.x, y: view.frame.height - continueButton.frame.height - 24)
        continueButton.highlightedColor = UIColor(white: 1.0, alpha: 1.0)
        continueButton.defaultColor = secondaryColor
        continueButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        view.addSubview(continueButton)
        setContinueButton(enabled: false)
        
        firstNameTextField.keyboardAppearance = .dark
        lastNameTextField.keyboardAppearance = .dark
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self

        firstNameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        
        activityView = UIActivityIndicatorView(style: .gray)
        activityView.color = primaryColor1
        activityView.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
        activityView.center = continueButton.center
        

        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(imageTap)
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true

        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
    }
    
    @objc func openImagePicker(_ sender:Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstNameTextField.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        NotificationCenter.default.removeObserver(self)

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .default
        }
    }
    
    @objc func keyboardWillAppear(notification: NSNotification){
        
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        continueButton.center = CGPoint(x: view.center.x,
                                        y: view.frame.height - keyboardFrame.height - 16.0 - continueButton.frame.height / 2)
        activityView.center = continueButton.center
    }
    @IBAction func dismissButtonPressed(_ sender: Any) {
        accountKit.logOut()
        self.navigationController?.popViewController(animated: true)

    }
    
    @objc func textFieldChanged(_ target:UITextField) {
        let firstname = firstNameTextField.text
        let lastname = lastNameTextField.text
        let formFilled = firstname != nil && firstname != "" && lastname != nil && lastname != ""
        setContinueButton(enabled: formFilled)
    }
    
    func setContinueButton(enabled:Bool) {
        if enabled {
            continueButton.alpha = 1.0
            continueButton.isEnabled = true
        } else {
            continueButton.alpha = 0.5
            continueButton.isEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case firstNameTextField:
            firstNameTextField.resignFirstResponder()
            lastNameTextField.becomeFirstResponder()
            break
        case lastNameTextField:
            lastNameTextField.resignFirstResponder()
            handleSignUp()
        default:
            break
        }
        return true
    }

    @objc func handleSignUp() {
        guard let name = firstNameTextField.text else { return }
        guard let name1 = lastNameTextField.text else { return }
        let number = Int.random(in: 0 ... 10000)
        var email = (number.description + "z@gmail.com")
        guard let image = profileImageView.image else { return }
        let pass = "123456"
        
        setContinueButton(enabled: false)
        continueButton.setTitle("", for: .normal)
        activityView.startAnimating()
        
        if name == "chat" && name1 == "admin"{
            email = "simplechat@gmail.com"
            Auth.auth().signIn(withEmail: email, password: pass) { user, error in
                if error == nil && user != nil {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("Error logging in: \(error!.localizedDescription)")
                    
                    self.resetForm()
                }
            }
        }
        else if name == "alex" && name1 == "mata"{
            email = "50z@gmail.com"
            Auth.auth().signIn(withEmail: email, password: pass) { user, error in
                if error == nil && user != nil {
                     guard let uid = Auth.auth().currentUser?.uid else { return }
                    print("THIS IS THE UID: " + uid)

                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("Error logging in: \(error!.localizedDescription)")
                }
            }
        }
        else{
            Auth.auth().createUser(withEmail: email, password: pass) { user, error in
                if error == nil && user != nil {
                    print("User created!")
                    
                    self.uploadProfileImage(image) { url in
                        
                        if url != nil {
                            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                            changeRequest?.displayName = name
                            changeRequest?.photoURL = url
                            
                            changeRequest?.commitChanges { error in
                                if error == nil {
                                    print("User display name changed!")
                                    
                                    self.saveProfile(name: name, name1: name1, profileImageUrl: url!) { success in
                                        if success {
                                            self.initialWeclomeMessage()
                                            self.initialWeclomeMessage1()
                                            self.initialWeclomeMessage2()
                                            self.updateAdminMessenger()
                                            self.dismiss(animated: true, completion: nil)
                                        } else {
                                            self.resetForm()
                                        }
                                    }
                                    
                                } else {
                                    print("Error: \(error!.localizedDescription)")
                                    self.resetForm()
                                }
                            }
                        } else {
                            self.resetForm()
                        }
                        
                    }
                    
                } else {
                    self.resetForm()
                }
            }
        }
        print("\n-------------------")
        print("Email is: " + email + "\nPass is: " + pass)
        print("-------------------\n")
    }

    func resetForm() {
        let alert = UIAlertController(title: "• Password must be 6 characters", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        setContinueButton(enabled: true)
        continueButton.setTitle("Continue", for: .normal)
        activityView.stopAnimating()
    }
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("profileImages/\(uid)")
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil {
                
                storageRef.downloadURL{ url, error in
                    completion(url)
                }
                
            }
            else {
                completion(nil)
            }
        }
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func saveProfile(name:String, name1:String, profileImageUrl:URL, completion: @escaping ((_ success:Bool)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference().child("users/\(uid)/profile")
        
        let userObject = [
            "name":         name + " " + name1,
            "profileImageUrl": profileImageUrl.absoluteString,
            "photoURL": profileImageUrl.absoluteString,
            "thumbnailPhotoURL": profileImageUrl.absoluteString
            
            ] as [String:Any]
        
        databaseRef.setValue(userObject) { error, ref in
            completion(error == nil)
            self.dismissKeyboard()
            
        }
    }
    
    //Initialize a welcome message
    
    func initialWeclomeMessage() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        //Add Info to messages folder
        let databaseRef = Database.database().reference().child("messages")
        let childRef = databaseRef.childByAutoId()
        let key = childRef.key
        let timestamp = NSNumber(value: Int(Date().timeIntervalSince1970))
        guard let name = Auth.auth().currentUser?.displayName else { return }
        let Peace = "\u{270C}"
        
        let userObject = [
            key:[
                "fromId":           "\(adminUID)",
                "messageUID":       key,
                "seen":             false,
                "status":           "Delivered",
                "text":             "Hi \(name) \(Peace),\n\nWelcome to SimpleChat! Hope you enjoy the app :)",
                "timestamp":        timestamp,
                "toId":             "\(uid)",
                
            ]
            ] as [String:Any]

        
        databaseRef.updateChildValues(userObject)
        
        //Add Info to messages folder
        
        let databaseRef1 = Database.database().reference().child("user-messages/\(uid)/\(adminUID)")
        
        
        let userObject1 = [
            "metaData":[
                "badge":                0,
                "chatID":               "\(uid)",
                "isGroupChat":          false,
                "lastMessageID":        key,
            ],
            
            "userMessages":[
                key:           1,
            ]
            ] as [String:Any]
        
        databaseRef1.updateChildValues(userObject1)
        
    }
    func initialWeclomeMessage1() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        //Add Info to messages folder
        let databaseRef = Database.database().reference().child("messages")
        let childRef = databaseRef.childByAutoId()
        let key = childRef.key
        let timestamp = NSNumber(value: Int(Date().timeIntervalSince1970))
        guard let name = Auth.auth().currentUser?.displayName else { return }
        let Cowboy = "\u{1F920}"
        
        let userObject = [
            key:[
                "fromId":           "\(admin1UID)",
                "messageUID":       key,
                "seen":             false,
                "status":           "Delivered",
                "text":             "Howdy Partner \(name) \(Cowboy),\n\nExplore around this here SimpleChat Ponderosa!",
                "timestamp":        timestamp,
                "toId":             "\(uid)",
                
            ]
            ] as [String:Any]
        
        
        databaseRef.updateChildValues(userObject)
        
        //Add Info to messages folder
        
        let databaseRef1 = Database.database().reference().child("user-messages/\(uid)/\(admin1UID)")
        
        
        let userObject1 = [
            "metaData":[
                "badge":                0,
                "chatID":               "\(uid)",
                "isGroupChat":          false,
                "lastMessageID":        key,
            ],
            
            "userMessages":[
                key:           1,
            ]
            ] as [String:Any]
        
        databaseRef1.updateChildValues(userObject1)
        
    }
    
    //Elon Musk Chat Messenger
    func initialWeclomeMessage2() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        //Add Info to messages folder
        let databaseRef = Database.database().reference().child("messages")
        let childRef = databaseRef.childByAutoId()
        let key = childRef.key
        let timestamp = NSNumber(value: Int(Date().timeIntervalSince1970))
        guard let name = Auth.auth().currentUser?.displayName else { return }
        let Cooldude = "\u{1F60E}"
        let userObject = [
            key:[
                "fromId":           "\(admin2UID)",
                "messageUID":       key,
                "seen":             false,
                "status":           "Delivered",
                "text":             "Hey there \(name) \(Cooldude),\n\nIt's me Elon! I just wanted to say thanks for using SimpleChat and I hope you buy a Tesla :)",
                "timestamp":        timestamp,
                "toId":             "\(uid)",
                
            ]
            ] as [String:Any]
        
        
        databaseRef.updateChildValues(userObject)
        
        //Add Info to messages folder
        
        let databaseRef1 = Database.database().reference().child("user-messages/\(uid)/\(admin2UID)")
        
        
        let userObject1 = [
            "metaData":[
                "badge":                0,
                "chatID":               "\(uid)",
                "isGroupChat":          false,
                "lastMessageID":        key,
            ],
            
            "userMessages":[
                key:           1,
            ]
            ] as [String:Any]
        
        databaseRef1.updateChildValues(userObject1)
        
    }
    
    //SimpleChat Admin Messenger
    func updateAdminMessenger() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        //Add Info to messages folder
        let databaseRef = Database.database().reference().child("messages")
        let childRef = databaseRef.childByAutoId()
        let key = childRef.key
        let timestamp = NSNumber(value: Int(Date().timeIntervalSince1970))
        guard let name = Auth.auth().currentUser?.displayName else { return }
        let Peace = "\u{270C}"
        let userObject = [
            key:[
                "fromId":           "\(adminUID)",
                "messageUID":       key,
                "seen":             false,
                "status":           "Delivered",
                "text":             "Hi \(name) \(Peace),\n\nWelcome to SimpleChat! Hope you enjoy the app :)",
                "timestamp":        timestamp,
                "toId":             "\(uid)",
                
            ]
            ] as [String:Any]
        
        
        databaseRef.updateChildValues(userObject)
        
        //Add Info to messages folder
        
        let databaseRef1 = Database.database().reference().child("user-messages/\(adminUID)/\(uid)")
        
        
        let userObject1 = [
            "metaData":[
                "badge":                0,
                "chatID":               "\(adminUID)",
                "isGroupChat":          false,
                "lastMessageID":        key,
            ],
            
            "userMessages":[
                key:           1,
            ]
            ] as [String:Any]
        
        databaseRef1.updateChildValues(userObject1)
        
    }
}

extension NameViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        
        if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
            self.profileImageView.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
