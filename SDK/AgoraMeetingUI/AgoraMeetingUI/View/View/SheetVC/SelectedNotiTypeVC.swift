//
//  SelectedNotiTypeVC.swift
//  VideoConference
//
//  Created by ZYP on 2021/2/17.
//  Copyright © 2021 agora. All rights reserved.
//

import UIKit
import Presentr

protocol SelectedNotiTypeVCDelegate: NSObject {
    func selectedNotiTypeVCDidTapSureButton(type: InOutNotiRestrictedType)
}

public class SelectedNotiTypeVC: UIViewController {
    weak var delegate: SelectedNotiTypeVCDelegate?
    let dataList: [InOutNotiRestrictedType] = [.never, .n10, .n20, .n30, .n40, .n50, .n60, .n70, .n80, .n90, .n100, .always]
    var defaultSelected: InOutNotiRestrictedType = .never
    private let contentView = Bundle.meetingUI().loadNibNamed("SelectedNotiTypeView", owner: nil, options: nil)?.first as! SelectedNotiTypeView
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
        contentView.pickerView.selectRow(defaultSelected.indexValue,
                                         inComponent: 0,
                                         animated: true)
    }
    
    func show(in vc: UIViewController,
              selected: InOutNotiRestrictedType) {
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

