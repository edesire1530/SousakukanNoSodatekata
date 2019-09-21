//
//  ViewController.swift
//  RealityKitDemo
//
//  Created by gree_mini on 2019/09/22.
//  Copyright © 2019 gree. All rights reserved.
//

import UIKit
import RealityKit

class ViewController: UIViewController {
    
    var arView:ARView!
    var scene:Experience.Scene!
    var tokuten = 0
    var label:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        arView = ARView(frame: UIScreen.main.bounds)

        self.view.addSubview(arView)

        //"Experience.rcproject"の"scene"を読み込む
        scene = try! Experience.loadScene()

        arView.scene.anchors.append(scene)

        //得点を表示させるラベルを生成
        label = UILabel();
        label.layer.position = CGPoint(x: view.frame.width/2, y: view.frame.height/8)
        label.text = "000"
        label.sizeToFit()
        self.view.addSubview(label);

        //Composerのアクションシーケンスで登録した"tap"を受け取る
        scene.actions.tap.onAction = { entity in
            self.tap()
        }
    }
    
    func tap() {

      self.tokuten += 1

      self.label.text = self.tokuten.description

      //"balloon"オブジェクトを取得します。
      let ball = scene.balloon

      let v = Float.random(in: -1 ..< 1)

      let y = Float.random(in: 0 ..< 1)

      ball?.transform.translation = simd_make_float3(v,y,v)

    }

}

