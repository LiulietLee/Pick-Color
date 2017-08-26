//
//  AboutViewController.swift
//  Pick Color
//
//  Created by Liuliet.Lee on 11/9/2016.
//  Copyright © 2016 Liuliet.Lee. All rights reserved.
//

import UIKit
import MessageUI

class AboutViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var menu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menu.target = self.revealViewController()
        menu.action = #selector(SWRevealViewController.revealToggle(_:))
        view.addGestureRecognizer(revealViewController().panGestureRecognizer())
    }

    private let links = [
        "https://www.facebook.com/liuliet.lee",
        "http://space.bilibili.com/4056345/#!/index",
        "https://plus.google.com/u/0/+LiulietLee",
    ]
    
    private let mailAddress = "lee.liuliet@hotmail.com"

    @IBAction func openLink(associatedWith button: UIButton){
        UIApplication.shared.openURL(URL(string: links[(button.tag < links.count ? button.tag : 0)])!)
    }

    @IBAction func emailButtonTapped() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Write an email", style: .default, handler: { (action) in
            self.sendMail()
        }))
        sheet.addAction(UIAlertAction(title: "Copy emall address", style: .default, handler: { (action) in
            UIPasteboard.general.string = self.mailAddress
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(sheet, animated: true, completion: nil)
    }
    
    fileprivate func sendMail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([mailAddress])
            present(mail, animated: true, completion: nil)
        } else {
            print("cannot send email")
            
            let dialog = LLDialog()
            dialog.title = "Oops"
            dialog.message = "Can't send email now."
            dialog.setNegativeButton(withTitle: "OK", target: nil, action: nil)
            dialog.show()
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
