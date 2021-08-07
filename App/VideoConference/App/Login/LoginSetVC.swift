//
//  LoginSetVC.swift
//
//
//  Created by ZYP on 2021/2/17.
//  Copyright © 2021 agora. All rights reserved.
//

import UIKit
import AgoraMeetingUI
import AgoraMeetingContext
import AgoraMeetingCore

class LoginSetVC: BaseViewController {
    
    var userLimitName = StorageManager.inOutNotiRestrictedType.description
    let tableView = UITableView(frame: .zero,
                                style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false,
                                                     animated: animated)
        navigationItem.backButtonTitle = ""
    }
    
    func setup() {
        title = NSLocalizedString("loginSet_t1", comment: "")
        tableView.frame = view.bounds
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    func showAboutVC() {
        let vc = AboutVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showSelectedNotiTypeVC() {
        let selected = StorageManager.inOutNotiRestrictedType
        let vc = SelectedNotiTypeVC()
        vc.delegate = self
        vc.show(in: self,
                selected: selected)
    }
}

extension LoginSetVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let textColor = UIColor(red: 0.254675,
                                green: 0.302331,
                                blue: 0.349586,
                                alpha: 1)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .value1, reuseIdentifier: "cell")
        cell.textLabel?.textColor = textColor
        if indexPath.row == 0 {
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
            cell.textLabel?.text = NSLocalizedString("loginSet_t3", comment: "")
            cell.detailTextLabel?.text = userLimitName
            cell.accessoryType = .none
            cell.detailTextLabel?.textColor = UIColor(hex: 0x268CFF)
        }
        else {
            cell.textLabel?.text = NSLocalizedString("loginSet_t2", comment: "")
            cell.textLabel?.textColor = UIColor.text()
            cell.detailTextLabel?.text = ""
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath,
                              animated: true)
        
        if indexPath.row == 1  {
            showAboutVC()
        }
        
        if indexPath.row == 0 {
            showSelectedNotiTypeVC()
        }
    }
}

extension LoginSetVC: SelectedNotiTypeVCDelegate {
    func selectedNotiTypeVCDidTapSureButton(type: InOutNotiRestrictedType) {
        StorageManager.inOutNotiRestrictedType = type
        userLimitName = StorageManager.inOutNotiRestrictedType.description
        tableView.reloadData()
    }
}
