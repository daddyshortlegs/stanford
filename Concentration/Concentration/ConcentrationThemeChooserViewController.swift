//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by Andy Smith on 8/19/19.
//  Copyright © 2019 Andy Smith. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {

  let themes = [
    "Sports":"⚽️🏀🏈⚾️🎾🏐🏉🎱🏓⛷🎳⛳️",
    "Animals":"🐶🐔🦊🐼🦀🐪🐓🐋🐙🦄🐵",
    "Faces":"😀😁🤣😍😝🤩😎🤓🤪☹️😤🥶",
  ]
  
  override func awakeFromNib() {
    splitViewController?.delegate = self
  }
  
  func splitViewController(_ splitViewController: UISplitViewController,
                           collapseSecondary secondaryViewController: UIViewController,
                           onto primaryViewController: UIViewController) -> Bool {
    if let cvc = secondaryViewController as? ConcentrationViewControler {
      if cvc.theme == nil {
        return true
      }
    }
    return false
  }
  
  @IBAction func changeTheme(_ sender: Any) {
    if let cvc = splitViewDetailConcentrationViewController {
      if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
        cvc.theme = theme
      }
    } else if let cvc = lastSeguedToConcentrationViewController {
      if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
        cvc.theme = theme
      }
      navigationController?.pushViewController(cvc, animated: true)
    } else {
      performSegue(withIdentifier: "Choose Theme", sender: sender)
    }
  }
  
  private var splitViewDetailConcentrationViewController: ConcentrationViewControler? {
    return splitViewController?.viewControllers.last as? ConcentrationViewControler
  }
  
  private var lastSeguedToConcentrationViewController: ConcentrationViewControler?
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "Choose Theme" {
      if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
        if let cvc = segue.destination as? ConcentrationViewControler {
          cvc.theme = theme
          lastSeguedToConcentrationViewController = cvc
        }
      }

    }
  }

}
