//
//  ViewController.swift
//  reproductor
//
//  Created by Sergio Albarran on 13/02/16.
//  Copyright © 2016 Sergio Albarran. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let textCellIdentifier = "TextCell"
    private var reproductor : AVAudioPlayer!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var label_pausa: UIButton!
    @IBOutlet weak var volVal: UILabel!
    @IBOutlet weak var volume: UISlider!
    @IBOutlet weak var cover: UIImageView!
    let tracks = [["Broken Heart", "cover.jpg"], ["Preparation for Battle", "cover2.jpg"], ["Moonlight", "cover3.jpg"], ["Platinum Medal Jingle", "cover4.jpg"], ["Gold Medal Jingle", "cover.jpg"], ["Verse Result", "cover2.jpg"]]
    @IBOutlet weak var songs: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        songs.delegate = self
        songs.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    // MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        let row = indexPath.row
        cell.textLabel?.text = tracks[row][0]
        
        return cell
    }
    
    // MARK:  UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        name.text = tracks[row][0]
        cover.image = UIImage(named: tracks[row][1])
        label_pausa.setTitle("Pause", forState: .Normal)
        
        let sonidoURL = NSBundle.mainBundle().URLForResource(tracks[row][0], withExtension: "mp3")
        do{
            try reproductor = AVAudioPlayer(contentsOfURL: sonidoURL!)
            if !reproductor.playing{
                reproductor.play()
            }
        }catch _ {
        
        }
    }
    
    @IBAction func stop(sender: AnyObject) {
        label_pausa.setTitle("Play", forState: .Normal)
        reproductor.play()
        
        if let reproductor = reproductor {
        if reproductor.playing{
            reproductor.stop()
            reproductor.currentTime = 0.0
        }
        }
    }
    
    @IBAction func pausa(sender: AnyObject) {
        if let reproductor = reproductor {
        if reproductor.playing{
            reproductor.pause()
            label_pausa.setTitle("Play", forState: .Normal)
        }else{
            label_pausa.setTitle("Pause", forState: .Normal)
            reproductor.play()
        }
        }
    }
    
    @IBAction func play() {
        if let reproductor = reproductor {
        if !reproductor.playing{
            reproductor.play()
        }
        }
    }
    
    @IBAction func random() {
        let row = Int(arc4random_uniform(UInt32(tracks.count)))
        name.text = tracks[row][0]
        cover.image = UIImage(named: tracks[row][1])
        
        let sonidoURL = NSBundle.mainBundle().URLForResource(tracks[row][0], withExtension: "mp3")
        do{
            try reproductor = AVAudioPlayer(contentsOfURL: sonidoURL!)
            if !reproductor.playing{
                reproductor.play()
            }
        }catch _ {
            
        }
    }

    @IBAction func updateSeekBar(){
        if let reproductor = reproductor {
            let progress = self.volume.value
            reproductor.volume = progress
            let formatter = NSNumberFormatter()
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 0
            volVal.text = "\((formatter.stringFromNumber(progress*100))!) %"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

