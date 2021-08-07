//
//  BoardVM.swift
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/14.
//

import Foundation
import AgoraMeetingContext
import Whiteboard

protocol BoardVMDelegate: NSObject {
    func boardVM(vm: BoardVM,
                 didUpdate permission: BoardPermission)
    func boardVMDidCloseBoard(vm: BoardVM)
}

class BoardVM: BaseVM {
    let boardContext: BoardContext
    var delegate: BoardVMDelegate?
    
    init(boardContext: BoardContext) {
        self.boardContext = boardContext
        super.init()
        commonInit()
    }
    
    func commonInit() {
        boardContext.registerEventHandler(self)
    }
    
    deinit {
        boardContext.unregisterEventHandler(self)
        Log.info(text: "BoardVM",
                 tag: "deinit")
    }
    
    func getPermission() -> BoardPermission {
        return boardContext.getBoardPermission()
    }
    
    func render(view: UIView,
                canWrite: Bool) {
        let error = boardContext.renderBoardView(view: view,
                                                 canWrite: canWrite)
        if let e = error {
            Log.info(text: "\(e.message)",
                     tag: "render")
        }
    }
    
    func changeStrokeColor(color: [Int]) {
        
    }
    
    func setAppliance(appliance: String) {
        let error = boardContext.setAppliance(appliance: appliance)
        if let e = error {
            Log.info(text: "\(e.message)",
                     tag: "setAppliance")
        }
    }
    
    func closeBoardShare() {
        boardContext.closeBoardSharing(success: {}, fail: { [weak self](error) in
            self?.invokeShouldShowTip(text: error.localizedMessage)
        })
    }
    
    func applyBoardInteract() {
        boardContext.applyBoardInteract(success: {}, fail: { [weak self](error) in
            self?.invokeShouldShowTip(text: error.localizedMessage)
        })
    }
    
    func cancelBoardInteract() {
        boardContext.cancelBoardInteract(success: {}, fail: { [weak self](error) in
            self?.invokeShouldShowTip(text: error.localizedMessage)
        })
    }
    
    func setStrokeColor(color: [Int]) {
        let error = boardContext.changeStrokeColor(color: color)
        if let e = error {
            Log.info(text: "\(e.message)",
                     tag: "changeStrokeColor")
        }
    }
    
    func setApplianceAction(action: Action) {
        setAppliance(appliance: action.rawValue)
    }
    
    func setWritable(writable: Bool) {
        let error = boardContext.setWritable(writable: writable)
        if let e = error {
            Log.info(text: "\(e.message)",
                     tag: "setWritable")
        }
    }
    
    func cleanBoard() {
        let error = boardContext.cleanBoard()
        if let e = error {
            Log.info(text: "\(e.message)",
                     tag: "cleanBoard")
        }
    }
}

extension BoardVM: BoardEventHandler {
    func onBoardPermissionUpdated(permission: BoardPermission) {
        invokeBoardVMDidUpdatePermission(permission: permission)
    }
    
    func onBoardStateUpdated(isOpen: Bool) {
        if !isOpen {
            invokeBoardVMDidCloseBoard()
        }
    }
}

extension BoardVM {
    func invokeBoardVMDidUpdatePermission(permission: BoardPermission) {
        if Thread.isMainThread {
            delegate?.boardVM(vm: self,
                              didUpdate: permission)
            return
        }
        
        DispatchQueue.main.sync { [weak self] in
            guard let `self` = self else { return }
            delegate?.boardVM(vm: self,
                              didUpdate: permission)
        }
    }
    
    func invokeBoardVMDidCloseBoard() {
        if Thread.isMainThread {
            delegate?.boardVMDidCloseBoard(vm: self)
            return
        }
        
        DispatchQueue.main.sync { [weak self] in
            guard let `self` = self else { return }
            delegate?.boardVMDidCloseBoard(vm: self)
        }
    }
}

extension BoardVM { /** info **/
    enum Action: String {
        case select = "selector"
        case pan = "pencil"
        case text = "text"
        case eraser = "eraser"
        case rectangle = "rectangle"
        case ellipse = "ellipse"
    }
}
