//
//  PDFViewController.swift
//  jedeye
//
//  Created by Rick Campbell on 7/29/19.
//  Copyright © 2019 Datacom. All rights reserved.
//

import UIKit

class PDFViewController: UIViewController {
    
    @IBOutlet weak var pdfView: UIWebView?
    var datasheetURL: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.datasheetURL!)
        let encodedURL = self.datasheetURL!.replacingOccurrences(of: " ", with: "%20")
        let url = URL(string: encodedURL)
        let request = URLRequest(url: url!)
        self.pdfView!.loadRequest(request)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
