//
//  UserListUIController.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/4.
//

import UIKit

protocol UserListViewDelegate: NSObject {
    func userListView(view: UserListView,
                      didSelecteInfo info: UserListView.Info)
    func userListView(view: UserListView,
                      didCahngeMode mode: UserListView.Mode)
    func userListView(view: UserListView,
                      shouldSearch text: String?)
    func userListView(view: UserListView,
                      shouldUpdateNavBarRightButton button: UIBarButtonItem)
    func userListView(view: UserListView,
                      shouldUpdateNavBarTitleView titleView: UIView)
}

class UserListView: UIView {
    weak var delegate: UserListViewDelegate?
    private var dataList = [Info]()
    private var mode: Mode = .normal
    private var rightButtonSearch: UIBarButtonItem!
    private var rightButtonCancle: UIBarButtonItem!
    private let titleLabel = UILabel()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let searchBar = UISearchBar()
    private let emptyLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layoutView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        invokeUpdateNavBarView()
    }
    
    private func setup() {
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.text = MeetingUILocalizedString("mem_t1", comment: "") + "(\(dataList.count))"
        titleLabel.frame = CGRect(x: UIScreen.width/2 - 150, y: 0, width: 300, height: 20)
        titleLabel.textAlignment = .center
        
        rightButtonSearch = UIBarButtonItem(barButtonSystemItem: .search,
                                            target: self,
                                            action: #selector(self.barButtonTap(btn:)))
        rightButtonCancle = UIBarButtonItem(title: MeetingUILocalizedString("mem_t3", comment: ""),
                                            style: .plain,
                                            target: self,
                                            action: #selector(self.barButtonTap(btn:)))
        rightButtonCancle.tintColor = UIColor(hex: 0x4DA1FF)
        
        searchBar.setApperance()
        searchBar.placeholder = MeetingUILocalizedString("mem_t7", comment: "")
        searchBar.delegate = self
        
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(hex: 0xF8F9FB)
        let nib = UINib(nibName: UserCell.idf,
                        bundle: .meetingUI())
        tableView.register(nib,
                           forCellReuseIdentifier: UserCell.idf)
        tableView.dataSource = self
        tableView.delegate = self
        
        emptyLabel.isHidden = true
    }
    
    private func layoutView() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor
            .constraint(equalTo: safeAreaLayoutGuide.topAnchor)
            .isActive = true
        tableView.leadingAnchor
            .constraint(equalTo: leadingAnchor)
            .isActive = true
        tableView.trailingAnchor
            .constraint(equalTo: trailingAnchor)
            .isActive = true
        tableView.bottomAnchor
            .constraint(equalTo: bottomAnchor)
            .isActive = true
        
        addSubview(emptyLabel)
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.centerYAnchor
            .constraint(equalTo: centerYAnchor)
            .isActive = true
        emptyLabel.centerXAnchor
            .constraint(equalTo: centerXAnchor)
            .isActive = true
    }
    
    func update(dataList: [Info]) {
        dataList.count == 0 ? showEmpty() : hiddenEmpty()
        self.dataList = dataList
        titleLabel.text = MeetingUILocalizedString("mem_t1", comment: "") + "(\(dataList.count))"
        tableView.reloadData()
        invokeUpdateNavBarView()
    }
    
    private func invokeUpdateNavBarView() {
        let button = mode == .normal ? rightButtonSearch! : rightButtonCancle!
        delegate?.userListView(view: self, shouldUpdateNavBarRightButton: button)
        let titleView = mode == .normal ? titleLabel : searchBar
        delegate?.userListView(view: self, shouldUpdateNavBarTitleView: titleView)
    }
    
    @objc func barButtonTap(btn: UIBarButtonItem) {
        if btn == rightButtonSearch {
            mode = .searching
            invokeUpdateNavBarView()
            delegate?.userListView(view: self, didCahngeMode: mode)
            return
        }
        mode = .normal
        invokeUpdateNavBarView()
        delegate?.userListView(view: self, didCahngeMode: mode)
    }
    
    func showEmpty() {
        emptyLabel.text = MeetingUILocalizedString("mem_t14", comment: "")
        emptyLabel.isHidden = false
    }
    
    func hiddenEmpty() {
        emptyLabel.isHidden = true
    }
    
}

extension UISearchBar {
    fileprivate func setApperance() {
        if let searchField = value(forKey: "searchField") as? UITextField {
            searchField.layer.borderWidth = 1.0
            searchField.layer.borderColor = UIColor(hex: 0x4DA1FF).cgColor
            searchField.layer.cornerRadius = 7
            searchField.layer.masksToBounds = true
            searchField.font = UIFont.systemFont(ofSize: 13)
            searchField.textColor = UIColor(hex: 0x333333)
            searchField.tintColor = UIColor(hex: 0x4DA1FF)
        }
    }
}

extension UserListView: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.idf, for: indexPath) as! UserCell
        let info = dataList[indexPath.row]
        cell.setInfo(info: info.cellInfo)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let info = dataList[indexPath.row]
        delegate?.userListView(view: self, didSelecteInfo: info)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
}

extension UserListView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        delegate?.userListView(view: self,
                               shouldSearch: searchBar.text)
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        delegate?.userListView(view: self, shouldSearch: searchBar.text)
    }
}

extension UserListView {
    struct Info {
        let userId: String
        var cellInfo: UserCell.Info!
        var actions: [ActionType]
        let isMe: Bool
        
        enum ActionType: UInt8 {
            case abandonHost
            case beHost
            case setAsHost
            case closeCamera
            case closeMic
            case kickOut
        }
    }
    
    enum Mode {
        case normal
        case searching
    }
}
