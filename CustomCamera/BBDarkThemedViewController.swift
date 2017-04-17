    //
//  BBDarkThemedViewController.swift
//  CustomCamera
//
//  Created by KingpiN on 10/04/17.
//  Copyright © 2017 KingpiN. All rights reserved.
//

import UIKit

class BBDarkThemedViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName:UIColor.white,NSFontAttributeName: UIFont.systemFont(ofSize: 17)]
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
