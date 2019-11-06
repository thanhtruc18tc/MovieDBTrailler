//
//  BaseViewController.swift
//  Moviedb
//
//  Created by Henry on 11/5/19.
//  Copyright © 2019 Truc Tran. All rights reserved.
//

import NVActivityIndicatorView
import Reachability

class BaseViewController: ViewController, NVActivityIndicatorViewable {
    
    let loadingView: NVActivityIndicatorView = {
        let type: NVActivityIndicatorType = .circleStrokeSpin
        let color = UIColor.white
        let padding: CGFloat = 30
        let frame = CGRect(x: UIScreen.main.bounds.width/2 - 10, y: UIScreen.main.bounds.height/2 - 10, width: 20, height: 20)
        let animation = NVActivityIndicatorView(frame: frame, type: type, color: color, padding: padding)
        return animation
    }()
    
    var time : Timer?
    let reach : Reachability = Reachability.init(hostname: "www.google.com")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Connectivity.isConnectedToInternet() == false{
            setAlter()
        }
        
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
        DispatchQueue.global().async {
            NotificationCenter.default.addObserver(self, selector: #selector(self.networkChanged(note:)), name: .reachabilityChanged, object: nil)
            do {
                try self.reach.startNotifier()
            }
            catch{
                print("errror")
            }
        }
    }
    
    @objc func networkChanged(note: NSNotification){
            let reachability = note.object as! Reachability
            switch reachability.connection {
            case .wifi, .cellular:
                print("have internet discover")
                reconected()
            case .none:
                print("no internet")
                self.loadingView.startAnimating()
                setAlter()
            }
    }
    
    func reconected() {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged , object: nil)
        reach.stopNotifier()
    }
    
    @objc func setAlter(){
        let alert = UIAlertController(title: "No internet connection!", message: "Please connect the internet", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
