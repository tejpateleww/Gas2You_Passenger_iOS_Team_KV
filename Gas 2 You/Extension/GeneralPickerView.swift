//
//  GeneralPickerView.swift
//  Gas 2 You
//
//  Created by MacMini on 13/08/21.
//

import UIKit

protocol GeneralPickerViewDelegate: AnyObject {
    func didTapDone()
    func didTapCancel()
}


class GeneralPickerView: UIPickerView {
    
    public private(set) var toolbar: UIToolbar?
    public weak var generalPickerDelegate: GeneralPickerViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        //toolBar.tintColor = .black
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)


        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        self.toolbar = toolBar
    }

    @objc func doneTapped() {
        self.generalPickerDelegate?.didTapDone()
    }

    
}

