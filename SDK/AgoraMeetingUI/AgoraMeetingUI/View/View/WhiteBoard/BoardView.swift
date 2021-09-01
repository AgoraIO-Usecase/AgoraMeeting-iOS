//
//  BoardView.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/14.
//

import Foundation

class BoardView: UIView {
    let whiteBoardView = UIView()
    let leftView = Bundle.meetingUI()
        .loadNibNamed("EEWhiteboardToolView",
                      owner: nil,
                      options: nil)!
        .first! as! EEWhiteboardToolView
    let colorView = Bundle.meetingUI()
        .loadNibNamed("EEColorShowView",
                      owner: nil,
                      options: nil)!
        .first! as! EEColorShowView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        whiteBoardView.isHidden = false
        whiteBoardView.backgroundColor = .white
        addSubview(whiteBoardView)
        whiteBoardView.translatesAutoresizingMaskIntoConstraints = false
        whiteBoardView.leftAnchor
            .constraint(equalTo: leftAnchor)
            .isActive = true
        whiteBoardView.rightAnchor
            .constraint(equalTo: rightAnchor)
            .isActive = true
        whiteBoardView.topAnchor
            .constraint(equalTo: topAnchor)
            .isActive = true
        whiteBoardView.bottomAnchor
            .constraint(equalTo: bottomAnchor)
            .isActive = true
        
        addSubview(leftView)
        leftView.translatesAutoresizingMaskIntoConstraints = false
        leftView.leftAnchor
            .constraint(equalTo: leftAnchor, constant: 10)
            .isActive = true
        leftView.heightAnchor
            .constraint(equalToConstant: 318)
            .isActive = true
        leftView.topAnchor
            .constraint(equalTo: topAnchor, constant: 150)
            .isActive = true
        leftView.widthAnchor
            .constraint(equalToConstant: 46)
            .isActive = true
        
        colorView.isHidden = true
        addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.leftAnchor
            .constraint(equalTo: leftAnchor, constant: 70)
            .isActive = true
        colorView.heightAnchor
            .constraint(equalToConstant: 120)
            .isActive = true
        colorView.topAnchor
            .constraint(equalTo: topAnchor, constant: 350)
            .isActive = true
        colorView.widthAnchor
            .constraint(equalToConstant: 180)
            .isActive = true
    }
}
