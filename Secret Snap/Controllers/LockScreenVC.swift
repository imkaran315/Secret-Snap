//
//  LockScreenVC.swift
//  Secret Snap
//
//  Created by Karan Verma on 18/10/24.
//

import UIKit

class LockScreenVC: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.delegate = self
        passwordField.becomeFirstResponder()
    }
}

extension LockScreenVC {
    func moveToHome() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar")
        UIApplication.shared.windows.first?.rootViewController = vc
    }
}

extension LockScreenVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = passwordField.text ?? ""
        print(text + string)
        if text + string == "1234" {
            moveToHome()
        }
        return true
    }
}
