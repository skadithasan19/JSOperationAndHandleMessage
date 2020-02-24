//
//  Utilities.swift
//  JumboProject
//
//  Created by Hasan, MdAdit on 2/24/20.
//  Copyright © 2020 Hasan, MdAdit. All rights reserved.
//

import UIKit

extension UIViewController {

  func presentAlert(withTitle title: String, message : String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default) { action in
        print("You've pressed OK Button")
    }
    alertController.addAction(OKAction)
    self.present(alertController, animated: true, completion: nil)
  }
}
