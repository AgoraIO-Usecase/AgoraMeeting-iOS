//
//  TermsAndPolicyView.swift
//  TermsAndPolicyDemo
//
//  Created by LY on 2021/7/9.
//

import UIKit

class TermsAndPolicyView: UIView {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var contentStack: UIStackView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var agreeContents: UIView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var disagreeButton: UIButton!
    @IBOutlet weak var closeContent: UIView!
    @IBOutlet weak var closeButton: UIButton!
    var fromSetting = false
    var haveReadTerms = false
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupViews() {
        backgroundColor = UIColor.white
        agreeContents.isHidden = fromSetting
        closeContent.isHidden = !fromSetting
        agreeButton.isEnabled = haveReadTerms
        checkButton.setImage(TermsAndPolicyVC.getPolicyPopped() ? UIImage(named: "checkBox_unchecked") : UIImage(named: "checkBox_unchecked"), for: .normal)
        let name = getLanguage() ? "privacy_cn" : "privacy_en"
        let url = Bundle.main.url(forResource: name,
                                  withExtension: "html")!
        webView.loadFileURL(url,
                            allowingReadAccessTo: Bundle.main.bundleURL)
        webView.navigationDelegate = self
    }
    @IBAction func haveRead(_ sender: UIButton) {
        haveReadTerms.toggle()
        sender.setImage(self.haveReadTerms ? UIImage(named: "checkBox_checked") : UIImage(named: "checkBox_unchecked"), for: .normal)
        agreeButton.isEnabled = haveReadTerms
    }
    
    func getLanguage() -> Bool {
        guard let code = Locale.current.languageCode else {
            return false
        }
        return code.uppercased().contains("ZH") || code.uppercased().contains("CN")
    }
}

extension TermsAndPolicyView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let scheme = navigationAction.request.url?.scheme else {
            decisionHandler(.cancel)
            return
        }
        
        if scheme == "file" {
            decisionHandler(.allow)
            return
        }
        
        if let url = navigationAction.request.url {
            UIApplication.shared.open(url,
                                      options: [:],
                                      completionHandler: nil)
        }
        decisionHandler(.cancel)
    }
}
