//
//  CassiniViewController.swift
//  Cassini
//
//  Created by Andy Smith on 22/08/2019.
//  Copyright © 2019 Andy Smith. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController {

    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if let url = DemoURLs.NASA[identifier] {
                if let imageVC = segue.destination.contents as? ImageViewController {
                    imageVC.imageURL = url
                    imageVC.title = (sender as? UIButton)?.currentTitle
                    
                }
            }
        }
    }

}

extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}
