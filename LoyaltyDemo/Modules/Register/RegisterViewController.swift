//
//  RegisterViewController.swift
//  LoyaltyExample
//
//  Created by Huy on 16/04/2021.
//

import UIKit
import Apollo
import LoyaltyCore
import LoyaltyModel
import LoyaltyUI

class RegisterViewController: UIViewController {
    @IBOutlet weak var header: ApolloHeader!
    
    @IBOutlet weak var nameFormField: ApolloFormField!
    @IBOutlet weak var emailFormField: ApolloFormField!
    @IBOutlet weak var addressFormField: ApolloFormField!
    @IBOutlet weak var dobPicker: ApolloDateTimePicker!
    @IBOutlet weak var genderDropdown: ApolloDropdown!
    @IBOutlet weak var idNumberFormField: ApolloFormField!
    @IBOutlet weak var passportFormField: ApolloFormField!
    @IBOutlet weak var idCitizenFormField: ApolloFormField!
    @IBOutlet weak var registerButton: ApolloButton!
    
    let genders = RegisterRequestParam.Gender.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header.title = "Register"
        header.addLeftItem(.init(icon: ApolloIcon.Outline24.Back) {
            _ in
            self.navigationController?.popViewController(animated: true)
        })
        
        nameFormField.placeholder = "Name"
        emailFormField.placeholder = "Email"
        addressFormField.placeholder = "Address"
        genderDropdown.dropdownDataSource = self
        genderDropdown.placeholder = "Gender"
        idNumberFormField.placeholder = "Id card number"
        passportFormField.placeholder = "Passport"
        idCitizenFormField.placeholder = "Id citizen number"
        registerButton.type = .primary
        
        nameFormField.text = "Le Vu Huy"
        emailFormField.text = "dsadsads@gmail.com"
    }

    @IBAction func registerButtonWasTapped(_ sender: Any) {
        guard let name = nameFormField.text,
              let email = emailFormField.text else { return }
        var date: String?
        if let selectedDate = dobPicker.selectedDate {
            date = DateUtil.dateToString(date: selectedDate, format: "yyyy-MM-dd")
        }
        var gender: RegisterRequestParam.Gender?
        if let selectedIndex = genderDropdown.selectedIndex {
            gender = RegisterRequestParam.Gender(rawValue: genders[selectedIndex].rawValue)
        }
        let param = RegisterRequestParam(name: name,
                                         email: email,
                                         address: addressFormField.text,
                                         dateOfBirth: date,
                                         gender: gender,
                                         idCardNumber: idNumberFormField.text,
                                         idCitizenNumber: idCitizenFormField.text,
                                         passportNumber: passportFormField.text)
        
        loyaltyApp?.register(param: param) { [weak self] result in
            switch result {
            case .success(let response):
                self?.alertJson(title: "Register member",
                                member: response.result!.member!)
            case .failure(let error):
                self?.alertMessage(title: "Register member", message: String(describing: error))
            }
        }
    }
    
    func alertJson(title: String, member: MemberInfo) {
        let message = String(data: try! JSONEncoder().encode(member), encoding: .utf8)!
        alertMessage(title: title, message: message)
    }
    
    func alertMessage(title: String, message: String) {
        let alert = ApolloAlertConfirmation(title: title, message: message , actions: [
            AlertAction(title: "OK", type: .primary)
        ])
        present(alert, animated: true)
    }
}

extension RegisterViewController: DropdownDatasource {
    func dropdown(_ dropdown: ApolloDropdown, dataForRowAt index: Int) -> DropdownItem {
        return DropdownItem(text: genders[index].rawValue)
    }

    func numberOfRows(in dropdown: ApolloDropdown) -> Int {
        return genders.count
    }
}

