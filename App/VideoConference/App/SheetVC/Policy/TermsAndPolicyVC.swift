//
//  TermsAndPolicyViewController.swift
//  TermsAndPolicyDemo
//
//  Created by LY on 2021/7/9.
//

import UIKit
import Presentr

class TermsAndPolicyVC: UIViewController {
    static var storeKey = "TermsRead"
    var fromSetting = false
    private let presenter = Presentr(presentationType: .popup)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let content = self.view as? TermsAndPolicyView {
            content.fromSetting = fromSetting
            content.setupViews()
        }
    }
    
    @IBAction func closeView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func agreed(_ sender: Any) {
        TermsAndPolicyVC.setPolicyPopped(true)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func disagree(_ sender: UIButton) {
        TermsAndPolicyVC.setPolicyPopped(false)
        exit(0)
    }
    
    func show(in vc: UIViewController) {
        presenter.backgroundTap = .noAction
        vc.customPresentViewController(presenter,
                                       viewController: self,
                                       animated: true,
                                       completion: nil)
    }
}

extension TermsAndPolicyVC {
    static func loadFromStoryboard(_ storyBoardName: String, _ identifier: String) -> Self? {
        let storyboardVC = UIStoryboard(name: storyBoardName, bundle: nil).instantiateViewController(withIdentifier: identifier)
        return storyboardVC as? Self
    }
    
    static func getPolicyPopped() -> Bool {
        return UserDefaults.standard.bool(forKey: storeKey)
    }
    
    static func setPolicyPopped(_ state: Bool) {
        return UserDefaults.standard.setValue(state, forKey: storeKey)
    }
}
