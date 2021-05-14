//
//  CardViewController.swift
//  LoyaltyExample
//
//  Created by Tung Nguyen on 4/15/21.
//

import UIKit
import LoyaltyModel
import LoyaltyUI
import LoyaltyComponent
import Apollo

class CardViewController: UIViewController {

    @IBOutlet weak var header: ApolloHeader!
    @IBOutlet weak var cardView: MemberCardView!
    
    var controller: MemberCardController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header.title = "Member card"
        header.addLeftItem(.init(icon: ApolloIcon.Outline24.Back) {
            _ in
            self.navigationController?.popViewController(animated: true)
        })
        
        let terraApp = (UIApplication.shared.delegate as! AppDelegate).terraApp!
        controller = .init(terraApp: terraApp,
                           view: cardView,
                           memberCard: .init(name: "Tung Nguyen", avatar: nil),
                           delegate: self)
        
        controller?.enable()
    }

}

extension CardViewController: MemberCardViewDelegate {
    
    func onMemberCardError(_ error: LoyaltyError) {
        view.makeToast(String(describing: error))
    }
    
    func onSettingTapped() {
        view.makeToast("Đã bấm vào Setting")
    }
    
    func onRegisterTapped() {
        let vc = RegisterViewController.instantiateFromNib()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func onUseCardTapped() {
        let vc = MembershipViewController.instantiateFromNib()
        vc.terraApp = (UIApplication.shared.delegate as! AppDelegate).terraApp!
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
