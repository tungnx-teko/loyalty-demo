//
//  RedeemViewController.swift
//  LoyaltyExample
//
//  Created by Tung Nguyen on 4/15/21.
//

import UIKit
//import LoyaltyUI
import LoyaltyModel
import Apollo
import LoyaltyComponent

class RedeemViewController: UIViewController {

    @IBOutlet weak var headerView: ApolloHeader!
    @IBOutlet weak var customCurrencyImage: UIImageView!
    @IBOutlet weak var customPointLabel: UILabel!
    @IBOutlet weak var customTitleLabel: UILabel!
    @IBOutlet weak var customPointView: UIView!
    @IBOutlet weak var redeemPointView: LoyaltyRedeemPointView!
    @IBOutlet weak var amountField: ApolloFormField!
    
    var networkConfig: NetworkConfigResult?
    var memberInfo: MemberInfo?
    
    var componentController: LoyaltyRedeemPointController?
    
    // Controller set to custom view
    var controller: LoyaltyRedeemPointController?
    
    var redeemDelegate: RedeemDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customTitleLabel.text = nil
        customPointLabel.text = nil

        headerView.title = "Member card"
        headerView.addLeftItem(.init(icon: ApolloIcon.Outline24.Back) {
            _ in
            self.navigationController?.popViewController(animated: true)
        })
        
        amountField.delegate = self
        amountField.text = "10000"
        amountField.placeholder = "Nhập số tiền"
        
        // for component view
        componentController = LoyaltyRedeemPointController(
            terraApp: AppDelegate.shared.terraApp,
            orderAmount: Int(amountField.text!)!,
            points: 5000,
            delegate: self
        )
        redeemPointView.setController(componentController!)
        componentController!.enable()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            self.componentController!.setPoints(20000000)
//        }

        
        // for main view
        controller = LoyaltyRedeemPointController(
            terraApp: AppDelegate.shared.terraApp,
            orderAmount: 0,
            delegate: RedeemDelegate()
        )
        self.setController(controller!)
        controller!.enable()
        
        customPointView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openPopup)))
    }

}

extension RedeemViewController: LoyaltyRedeemPointDelegate {
    
    func onRedeemPointChange(data: RedeemPointData?) {
        view.makeToast("Dùng \(String(describing: data?.points ?? 0)) điểm")
    }
    
    func onRedeemPointError(_ error: RedeemPointError) {
        view.makeToast(String(describing: error))
    }
    
}

extension RedeemViewController: LoyaltyRedeemViewProtocol {
    
    func onPrepareLoading() {
        
    }
    
    
    func onUpdateOrderAmount() {
        
    }
    
    @objc func openPopup() {
        let terraApp = (UIApplication.shared.delegate as! AppDelegate).terraApp!
        guard let config = networkConfig, let info = memberInfo else { return }
        let popup = LoyaltyRedeemPointPopupModule.build(
            terraApp: terraApp,
            orderAmount: 12000,
            memberInfo: info,
            config: config,
            delegate: self
        )
        present(popup, animated: false, completion: nil)
    }
    
    func onRedeemPointChange(data: RedeemPointData) {
        
    }
    
    func didGetNetworkConfig(config: NetworkConfigResult) {
        self.networkConfig = config
        DispatchQueue.main.async {
            self.customTitleLabel.text = "Điểm \(config.networkConfig?.currencyName ?? "")"
            self.customCurrencyImage.kf.setImage(with: URL(string: config.networkConfig?.currencyImg ?? ""))
        }
    }
    
    func didGetMemberInfo(memberInfo: MemberInfo?) {
        self.memberInfo = memberInfo
        customPointLabel.text = "\(memberInfo?.point ?? 0)"
    }
    
}

extension RedeemViewController: RedeemPointPopupDelegate {
    
    func onError(error: LoyaltyError) {
        view.makeToast(String(describing: error))
    }
    
    func onUsePoints(data: RedeemPointData) {
        view.makeToast("Sử dụng \(data.points) điểm")
    }
    
    func onMemberInfoUpdate(memberInfo: MemberInfo) {
        self.memberInfo = memberInfo
        customPointLabel.text = "\(memberInfo.point)"
    }
    
}

extension RedeemViewController: FormFieldDelegate {
    
    func formField(_ formField: ApolloFormField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText: NSString = formField.text! as NSString
        let updatedText = currentText.replacingCharacters(in: range, with: string)
        componentController?.setOrderAmount(Int(updatedText) ?? 0)
        return true
    }
    
}

// Redeem point Popup delegate
class RedeemDelegate: LoyaltyRedeemPointDelegate {
    
    func onRedeemPointChange(data: RedeemPointData?) {
        
    }
    
    func onRedeemPointError(_ error: RedeemPointError) {
        
    }
    
}
