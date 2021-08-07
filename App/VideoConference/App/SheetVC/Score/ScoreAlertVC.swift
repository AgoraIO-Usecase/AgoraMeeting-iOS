//
//  ASScoreAlertVC.swift
//  AgoraSceneUI
//
//  Created by ZYP on 2021/1/13.
//

import UIKit
import Presentr

class ScoreAlertVC: UIViewController {
    
    typealias SubmitBlock = (ASScore) -> (Void)
    typealias DismissBlock = () -> ()
    private let contentView = ScoreView()
    var submitBlock: SubmitBlock?
    var dismissBlock: DismissBlock?
    let presenter = Presentr(presentationType: .custom(width: .custom(size: Float(UIScreen.main.bounds.width)),
                                                       height: .custom(size: Float(UIScreen.main.bounds.height)),
                                                       center: .center))
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        let bg = UIButton()
        bg.backgroundColor = .clear
        view.addSubview(bg)
        bg.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([bg.leftAnchor.constraint(equalTo: view.leftAnchor),
                                     bg.rightAnchor.constraint(equalTo: view.rightAnchor),
                                     bg.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     bg.topAnchor.constraint(equalTo: view.topAnchor)])
        
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     contentView.heightAnchor.constraint(equalToConstant: 417),
                                     contentView.widthAnchor.constraint(equalToConstant: 280)])
        
        contentView.sureButton.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        bg.addTarget(self,
                     action: #selector(dismissTap),
                     for: .touchUpInside)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func buttonTap() {
        view.endEditing(true)
        
        let score = ASScore()
        score.value1 = contentView.starView1.value
        score.value2 = contentView.starView2.value
        score.value3 = contentView.starView3.value
        score.text = contentView.commentTextView.text
        submitBlock?(score)
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissTap() {
        dismiss(animated: true, completion: { [weak self] in
            self?.dismissBlock?()
        })
    }
    
    func show(in vc: UIViewController) {
        modalPresentationStyle = .fullScreen
        presenter.roundCorners = true
        presenter.keyboardTranslationType = .moveUp
        presenter.backgroundTap = .passthrough
        vc.customPresentViewController(presenter, viewController: self, animated: true, completion: nil)
    }
}

class ASScore: NSObject {
    var value1: Int = 5
    var value2: Int = 5
    var value3: Int = 5
    var text: String = ""
}


