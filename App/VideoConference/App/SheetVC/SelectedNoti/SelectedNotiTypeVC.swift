//
//  SelectedNotiTypeSheetVC.swift
//  VideoConference
//
//  Created by ZYP on 2021/7/16.
//  Copyright © 2021 agora. All rights reserved.
//

import Foundation
import UIKit
import Presentr

protocol SelectedNotiTypeVCDelegate: NSObject {
    func selectedNotiTypeVCDidTapSureButton(type: InOutNotiRestrictedType)
}

class SelectedNotiTypeVC: UIViewController {
    public weak var delegate: SelectedNotiTypeVCDelegate?
    let dataList: [InOutNotiRestrictedType] = [.never, .n10, .n20, .n30, .n40, .n50, .n60, .n70, .n80, .n90, .n100, .always]
    var defaultSelected: InOutNotiRestrictedType = .never
    private let contentView = Bundle.main.loadNibNamed("SelectedNotiTypeView", owner: nil, options: nil)?.first as! SelectedNotiTypeView
    private let presenter = Presentr(presentationType: .bottomHalf)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        contentView.pickerView.dataSource = self
        contentView.pickerView.delegate = self
        
        let bottomBgView = UIView()
        bottomBgView.backgroundColor = .white
        view.addSubview(bottomBgView)
        bottomBgView.translatesAutoresizingMaskIntoConstraints = false
        bottomBgView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomBgView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomBgView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomBgView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 398).isActive = true
        
        contentView.cancleButton.addTarget(self, action: #selector(buttonTap(button:)), for: .touchUpInside)
        contentView.sureButton.addTarget(self, action: #selector(buttonTap(button:)), for: .touchUpInside)
        
        contentView.pickerView.reloadComponent(0)
        contentView.pickerView.selectRow(defaultSelected.indexValue, inComponent: 0, animated: true)
    }
    
    func show(in vc: UIViewController, selected: InOutNotiRestrictedType) {
        defaultSelected = selected
        presenter.backgroundTap = .dismiss
        vc.customPresentViewController(presenter,
                                       viewController: self,
                                       animated: true,
                                       completion: nil)
    }
    
    @objc func buttonTap(button: UIButton) {
        if button == contentView.cancleButton {
            dismiss(animated: true, completion: nil)
            return
        }
        
        let index = contentView.pickerView.selectedRow(inComponent: 0)
        let selectedItem = dataList[index]
        delegate?.selectedNotiTypeVCDidTapSureButton(type: selectedItem)
        dismiss(animated: true, completion: nil)
    }
    
}

extension SelectedNotiTypeVC: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView,
                           numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }
    
    public func pickerView(_ pickerView: UIPickerView,
                           titleForRow row: Int,
                           forComponent component: Int) -> String? {
        return dataList[row].description
    }
}

enum InOutNotiRestrictedType: Int, CustomStringConvertible {
    case never = 0
    case n10 = 10
    case n20 = 20
    case n30 = 30
    case n40 = 40
    case n50 = 50
    case n60 = 60
    case n70 = 70
    case n80 = 80
    case n90 = 90
    case n100 = 100
    case always = -1
    
    var description: String {
        switch self {
        case .never:
            return NSLocalizedString("noti_t1", comment: "")
        case .n10:
            return "10" + NSLocalizedString("noti_t2", comment: "")
        case .n20:
            return "20" + NSLocalizedString("noti_t2", comment: "")
        case .n30:
            return "30" + NSLocalizedString("noti_t2", comment: "")
        case .n40:
            return "40" + NSLocalizedString("noti_t2", comment: "")
        case .n50:
            return "50" + NSLocalizedString("noti_t2", comment: "")
        case .n60:
            return "60" + NSLocalizedString("noti_t2", comment: "")
        case .n70:
            return "70" + NSLocalizedString("noti_t2", comment: "")
        case .n80:
            return "80" + NSLocalizedString("noti_t2", comment: "")
        case .n90:
            return "90" + NSLocalizedString("noti_t2", comment: "")
        case .n100:
            return "100" + NSLocalizedString("noti_t2", comment: "")
        case .always:
            return NSLocalizedString("noti_t3", comment: "")
        }
    }
    
    var indexValue: Int {
        switch self {
        case .never:
            return 0
        case .n10:
            return 1
        case .n20:
            return 2
        case .n30:
            return 3
        case .n40:
            return 4
        case .n50:
            return 5
        case .n60:
            return 6
        case .n70:
            return 7
        case .n80:
            return 8
        case .n90:
            return 9
        case .n100:
            return 10
        case .always:
            return 11
        }
    }
    
}

