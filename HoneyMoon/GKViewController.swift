//
//  GKViewController.swift
//  SpriteKitGame
//
//  Created by Mat on 12/7/14.
//  Copyright (c) 2014 Mat. All rights reserved.
//

import SpriteKit

public class GKViewController: UIViewController, GKSceneDelegate {
    var incoming: SKView?
    var outgoing: SKView?

    let cachedkeyCommands = [
        UIKeyCommand(input: "w", modifierFlags: nil, action: "didReceiveKeyW"),
        UIKeyCommand(input: "a", modifierFlags: nil, action: "didReceiveKeyA"),
        UIKeyCommand(input: "s", modifierFlags: nil, action: "didReceiveKeyS"),
        UIKeyCommand(input: "d", modifierFlags: nil, action: "didReceiveKeyD"),
        UIKeyCommand(input: "r", modifierFlags: nil, action: "didReceiveKeyR"),
        UIKeyCommand(input: "f", modifierFlags: nil, action: "didReceiveKeyF"),
    ]

    override public var keyCommands: [AnyObject]? {
        return cachedkeyCommands
    }

    public func presentScene(sceneClass: GKScene.Type) {
        outgoing = incoming

        let incomingScene = sceneClass.unarchiveFromFile()
        println("GKViewController: presentScene: \(incomingScene.filename)")
        incomingScene.scaleMode = .AspectFit
        incomingScene.sceneDelegate = self
        incoming = SKView(frame: view.frame)
        incoming?.ignoresSiblingOrder = true

        // Default behavior is to remove the outgoing view, but in more sophisticated transitions we might want to keep
        // both incoming and outgoing views alive for a while.
        outgoing?.removeFromSuperview()
        view.addSubview(incoming!)
        view.sendSubviewToBack(incoming!)

        incoming?.presentScene(incomingScene)
    }

    // MARK: - GKSceneDelegate

    public func didFinishForScene(scene: GKScene, nextSceneClass: GKScene.Type) {
        println("GKViewController: didFinishForScene: \(scene.filename) -> \(nextSceneClass.classFilename)")
        presentScene(nextSceneClass)
    }

    // MARK: - UIViewController boilerplate

    override public func shouldAutorotate() -> Bool {
        return true
    }

    override public func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override public func prefersStatusBarHidden() -> Bool {
        return true
    }

    override public func canBecomeFirstResponder() -> Bool {
        return true
    }

    func didReceiveKeyW() {
        forwardKey("w")
    }

    func didReceiveKeyA() {
        forwardKey("a")
    }

    func didReceiveKeyS() {
        forwardKey("s")
    }

    func didReceiveKeyD() {
        forwardKey("d")
    }

    func didReceiveKeyR() {
        forwardKey("r")
    }

    func didReceiveKeyF() {
        forwardKey("f")
    }

    func forwardKey(key: String) {
        (incoming?.scene as? GKScene)?.didReceiveKey(key)
    }
}
