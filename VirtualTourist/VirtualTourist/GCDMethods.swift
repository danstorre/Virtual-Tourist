//
//  GCDMethods.swift
//  VirtualTourist
//
//  Created by Daniel Torres on 1/12/17.
//  Copyright © 2017 Daniel Torres. All rights reserved.
//

import UIKit

extension UIViewController {
    func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
}
