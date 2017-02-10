//
//  PhotoDetailsViewController.swift
//  myApp
//
//  Created by Enzo Ames on 2/8/17.
//  Copyright © 2017 Enzo Ames. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {

    //var post: NSDictionary!
    
    @IBOutlet weak var posterView: UIImageView!
    
    var photo: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        posterView.image = photo
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
