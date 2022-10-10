//
//  UIView+Extension.swift
//  Gas 2 You
//
//  Created by Gaurang on 03/09/21.
//

import UIKit
import Foundation


extension UIView {
    // MARK: Loads instance from nib with the same name
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }

    func setAllSideContraints(_ insets: UIEdgeInsets) {
        guard let view = superview else {
            return
        }
        topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top).isActive = true
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: insets.left).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor, constant: insets.right).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom).isActive = true
    }
    
    
}

extension UIView {
    func addTopShadow(shadowColor : UIColor, shadowOpacity : Float,shadowRadius : CGFloat,offset:CGSize){
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
        self.clipsToBounds = false
    }
}

extension UIView {
    
    func AddShadowToView(view : UIView){
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.masksToBounds = false
        view.layer.shadowRadius = 4
        view.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.cornerRadius = 14
        view.layer.shadowOpacity = 0.15
    }
    
}

extension UITableView {
  func animateCells<Cell: UITableViewCell>(cells: [Cell],
                                           duration: TimeInterval,
                                           delay: TimeInterval = 0,
                                           dampingRatio: CGFloat = 0,
                                           configure: @escaping (Cell) -> (prepare: () -> Void, animate: () -> Void)?,
                                           completion: @escaping () -> Void) {
    var cellDelay: TimeInterval = 0
    var completionCount: Int = 0

    for cell in cells {
      if let callbacks = configure(cell) {
        callbacks.prepare()

        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: dampingRatio)

        animator.addAnimations(callbacks.animate)

        let completionTime = cellDelay + (duration * TimeInterval(dampingRatio))

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + completionTime) {
          completionCount += 1
          if completionCount == cells.count {
            completion()
          }
        }

        animator.startAnimation(afterDelay: cellDelay)

        cellDelay += delay
      } else {
        completionCount += 1
      }
    }
  }
}

extension UIView {

    @IBInspectable
    var cornerRadius1: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable
    var borderColor1: UIColor? {
        get {
            let color = UIColor.init(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    @IBInspectable
    var shadowRadius1: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {

            layer.shadowRadius = newValue
        }
    }
    @IBInspectable
    var shadowOffset : CGSize{

        get{
            return layer.shadowOffset
        }set{

            layer.shadowOffset = newValue
        }
    }

    @IBInspectable
    var shadowColor1 : UIColor{
        get{
            return UIColor.init(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    @IBInspectable
    var shadowOpacity : Float {

        get{
            return layer.shadowOpacity
        }
        set {

            layer.shadowOpacity = newValue

        }
    }
}


extension UIScrollView {
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        setContentOffset(bottomOffset, animated: true)
    }
}
