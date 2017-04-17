//
//  VideoEditorViewController.swift
//  CustomCamera
//
//  Created by KingpiN on 12/04/17.
//  Copyright © 2017 KingpiN. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoEditorViewController: UIViewController {
    
    @IBOutlet weak var videoPlayingView: UIView!
    var assetsURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let player = AVPlayer(url: assetsURL!)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.backgroundColor = UIColor.brown.cgColor
        playerLayer.frame = videoPlayingView.frame
        videoPlayingView.layer.addSublayer(playerLayer)
        player.play()
        view.layoutIfNeeded()
    }
}
