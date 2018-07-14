//
//  ViewController.swift
//  AR-OnDemand-Advertise
//
//  Created by kumar reddy on 14/07/18.
//  Copyright © 2018 Swiggy. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var videoPosition: SCNVector3?
    var defaultVideoPosition: SCNVector3?
    @IBOutlet weak var topView: UIVisualEffectView!
    @IBOutlet weak var bottomView: UIVisualEffectView!
    @IBOutlet weak var topViewTopConstarint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!
    
    
    let cricketVideoPlayer: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "Cricket", withExtension: "mp4") else {
            return AVPlayer()
        }
        return AVPlayer(url: url)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.showsStatistics = true
        let scene = SCNScene()
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.vertical]
        sceneView.session.run(configuration)
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.addVideoNode()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            print("plane detection")
            defaultVideoPosition = SCNVector3(planeAnchor.center.x, 0 , planeAnchor.center.z)
            /*let plane = SCNPlane(width: 0.6, height: 0.5)
            plane.firstMaterial?.diffuse.contents = cricketVideoPlayer
            cricketVideoPlayer.play()
            let videoNode = SCNNode(geometry: plane)
            videoNode.eulerAngles.x = -.pi/2
            videoNode.position = SCNVector3(planeAnchor.center.x, 0 , planeAnchor.center.z)
            node.addChildNode(videoNode)*/
        }
    }
    
    func findPositionForVideo() -> SCNVector3? {
        let point = view.center
        let hitResults = sceneView.hitTest(point, types: ARHitTestResult.ResultType.existingPlaneUsingExtent)
        if hitResults.count > 0, let hitResult = hitResults.first {
            print("hit test position")
            return SCNVector3(hitResult.worldTransform.columns.3.x,
                                       hitResult.worldTransform.columns.3.y,
                                       hitResult.worldTransform.columns.3.z)
            
        }
        return nil
    }
    
    func addVideoNode() {
        let plane = SCNPlane(width: 0.6, height: 0.4)
        plane.firstMaterial?.diffuse.contents = cricketVideoPlayer
        cricketVideoPlayer.play()
        let videoNode = SCNNode(geometry: plane)
        //videoNode.eulerAngles.x = -.pi/2
        videoNode.position = findPositionForVideo() ?? defaultVideoPosition ?? SCNVector3Zero
        sceneView.scene.rootNode.addChildNode(videoNode)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
