//
//  SetView.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/17.
//

import Foundation

protocol SettingViewDelegate: NSObject {
    func settingViewDidTapVideoPermission(value: Bool)
    func settingViewDidTapAudioPermission(value: Bool)
    func settingViewDidSelectedUploadLogItem()
    func settingViewDidSelectedNotiTypeItem()
}

class SettingView: UIView {
    let tableView = UITableView(frame: .zero,
                                style: .grouped)
    var info = Info.empty
    weak var delegate: SettingViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        backgroundColor = .white
        
        let setImageCellNib = UINib(nibName: SetImageCell.idf(), bundle: .meetingUI())
        let setTextCellNib = UINib(nibName: SetTextFieldCell.idf(), bundle: .meetingUI())
        let setSwitchCellNib = UINib(nibName: SetSwitchCell.idf(), bundle: .meetingUI())
        let setCenterTextCellNib = UINib(nibName: SetCenterTextCell.idf(), bundle: .meetingUI())
        let setLabelCellNib = UINib(nibName: SetLabelCell.idf(), bundle: .meetingUI())
        
        tableView.register(setImageCellNib, forCellReuseIdentifier: SetImageCell.idf())
        tableView.register(setTextCellNib, forCellReuseIdentifier: SetTextFieldCell.idf())
        tableView.register(setSwitchCellNib, forCellReuseIdentifier: SetSwitchCell.idf())
        tableView.register(setCenterTextCellNib, forCellReuseIdentifier: SetCenterTextCell.idf())
        tableView.register(setLabelCellNib, forCellReuseIdentifier: SetLabelCell.idf())
        
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func commonInit() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func updateInfo(info: Info) {
        self.info = info
        tableView.reloadData()
    }
}

extension SettingView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 2 }
        if section == 1 { return 3 }
        if section == 2 { return 2 }
        if section == 3 { return 3 }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SetLabelCell.idf(), for: indexPath) as! SetLabelCell
            let temp = UITableViewCell(style: .value1, reuseIdentifier: "cell")
            cell.valueText?.textColor = temp.detailTextLabel?.textColor
            cell.valueText?.font = temp.detailTextLabel?.font
            cell.tipText?.font = temp.textLabel?.font
            cell.tipText?.textColor = .text()
            cell.tipText?.text = row == 0 ? MeetingUILocalizedString("set_t11", comment: "") : MeetingUILocalizedString("set_t8", comment: "")
            cell.valueText?.text = row == 0 ? info.roomName : info.roomPsd
            return cell
        }
        
        if section == 1 {
            if row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: SetImageCell.idf(), for: indexPath) as! SetImageCell
                cell.tipText?.text = MeetingUILocalizedString("set_t19", comment: "")
                cell.tipText?.textColor = .text()
                cell.imgView?.image = UIImage.meetingUIImageName(info.headImageName)
                cell.selectionStyle = .none
                return cell
            }
            else if row == 1 {
                var cell  = tableView.dequeueReusableCell(withIdentifier: "cell")
                if cell == nil {
                    cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
                }
                cell!.textLabel?.text = MeetingUILocalizedString("set_t13", comment: "")
                cell!.textLabel?.textColor = .text()
                cell?.accessoryType = .none
                cell!.detailTextLabel?.text = info.userName
                return cell!
            }
            else {
                var cell  = tableView.dequeueReusableCell(withIdentifier: "cell")
                if cell == nil {
                    cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
                }
                cell!.textLabel?.text = MeetingUILocalizedString("set_t16", comment: "")
                cell!.textLabel?.textColor = .text()
                cell!.detailTextLabel?.text = info.roleName
                cell?.selectionStyle = .none
                return cell!
            }
        }
        
        if section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SetSwitchCell.idf(), for: indexPath) as! SetSwitchCell
            cell.switchBtn?.isEnabled = true
            if row == 0 {
                let temp = UITableViewCell(style: .value1, reuseIdentifier: "cell")
                cell.tipText?.font = temp.textLabel?.font
                cell.tipText?.text = MeetingUILocalizedString("set_t9", comment: "")
                cell.tipText?.textColor = .text()
                cell.switchBtn?.isOn = info.openVideoShoudApprove
                cell.switchBtn?.isEnabled = info.videoPermissionEnable
                cell.selectionStyle = .none
                cell.indexPath = indexPath
                cell.delegate = self
                return cell
            }
            else {
                cell.tipText?.textColor = .text()
                cell.tipText?.text = MeetingUILocalizedString("set_t10", comment: "")
                cell.switchBtn?.isOn = info.openAudioShoudApprove
                cell.switchBtn?.isEnabled = info.audioPermissionEnable
                cell.selectionStyle = .none
                cell.indexPath = indexPath
                cell.delegate = self
                return cell
            }
        }
        
        if section == 3 {
            if row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: SetSwitchCell.idf(), for: indexPath) as! SetSwitchCell
                cell.tipText?.text = MeetingUILocalizedString("set_t20", comment: "")
                cell.tipText?.textColor = .text()
                cell.switchBtn?.isOn = false
                cell.switchBtn?.isEnabled = false
                cell.selectionStyle = .none
                return cell
            }
            else if row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: SetSwitchCell.idf(), for: indexPath) as! SetSwitchCell
                cell.tipText?.text = MeetingUILocalizedString("set_t23", comment: "")
                cell.tipText?.textColor = .text()
                cell.switchBtn?.isOn = false
                cell.switchBtn?.isEnabled = false
                cell.selectionStyle = .none
                return cell
            }
            else  {
                var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
                if cell == nil {
                    cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
                }
                cell!.textLabel?.text = MeetingUILocalizedString("set_t5", comment: "")
                cell!.textLabel?.textColor = .text()
                cell!.detailTextLabel?.text = info.inOutNotiRestrictedName
                cell!.accessoryType = .none
                cell!.detailTextLabel?.textColor = UIColor(hex: 0x268CFF)
                return cell!
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SetCenterTextCell.idf(), for: indexPath) as! SetCenterTextCell
        cell.tipText?.text = MeetingUILocalizedString("set_t2", comment: "")
        cell.tipText?.textColor = UIColor(hex: 0x323C47)
        cell.selectionStyle = info.isUploading ? .none : .gray
        cell.setLoadingState(info.isUploading)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 3, indexPath.row == 2 {
            delegate?.settingViewDidSelectedNotiTypeItem()
        }
        
        if indexPath.section == 4 {
            delegate?.settingViewDidSelectedUploadLogItem()
        }
    }
}

extension SettingView: SetSwitchCellDelegate {
    func setSwitchCellSwitchValueDidChange(_ on: Bool,
                                           at indexPath: IndexPath) {
        if indexPath.section == 2, indexPath.row == 0 {
            delegate?.settingViewDidTapVideoPermission(value: on)
            return
        }
        
        if indexPath.section == 2, indexPath.row == 1 {
            delegate?.settingViewDidTapAudioPermission(value: on)
            return
        }
    }
}

extension SettingView {
    struct Info {
        let roomName: String
        var roomPsd: String
        var userName: String
        let roleName: String
        let headImageName: String
        var openVideoShoudApprove: Bool
        var openAudioShoudApprove: Bool
        var videoPermissionEnable: Bool
        var audioPermissionEnable: Bool
        let beauty: Bool = false
        let ai: Bool = false
        var inOutNotiRestrictedName: String
        var isUploading: Bool
        
        static var empty: Info {
            Info(roomName: "",
                 roomPsd: "",
                 userName: "",
                 roleName: "",
                 headImageName: "",
                 openVideoShoudApprove: false,
                 openAudioShoudApprove: false,
                 videoPermissionEnable: false,
                 audioPermissionEnable: false,
                 inOutNotiRestrictedName: "",
                 isUploading: false)
        }
    }
}
