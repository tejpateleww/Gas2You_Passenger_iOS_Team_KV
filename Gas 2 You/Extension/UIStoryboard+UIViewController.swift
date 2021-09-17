//
//  UIView+Extension.swift
//  MVVMDemo
//
//  Created by Gaurang on 02/09/21.
//
import UIKit

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController: StoryboardIdentifiable { }

extension UIStoryboard {
    /// The uniform place where we state all the storyboard we have in our application

    enum Storyboard: String {
        case main = "Main"
        case auth = "Auth"

        var filename: String {
            return rawValue
        }

        var instance: UIStoryboard {
            return UIStoryboard(storyboard: self)
        }
    }

    // MARK: - Convenience Initializers

    convenience init(storyboard: Storyboard) {
        self.init(name: storyboard.filename, bundle: nil)
    }

    // MARK: - Class Functions

    class func storyboard(_ storyboard: Storyboard) -> UIStoryboard {
        return UIStoryboard(name: storyboard.filename, bundle: nil)
    }

    // MARK: - View Controller Instantiation from Generics

    func instantiate<T: UIViewController>() -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
        }

        return viewController
    }
}
// usage
// let viewController: ArticleViewController = UIStoryboard(storyboard: .news).instantiateViewController()
//MARK: - View controllers with navigation controller
extension UIViewController {

    func push(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }

    func goBack() {
        navigationController?.popViewController(animated: true)
    }

    func bindToNavigation(isHidden: Bool = true) -> UINavigationController {
        let navVC = NavigationController(rootViewController: self)
        navVC.isNavigationBarHidden = isHidden
        return navVC
    }

    func setNavigationBarHidden(_ isHidden: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
