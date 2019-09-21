//
//  ViewController.swift
//  PencilKitDemo
//
//  Created by gree_mini on 2019/09/22.
//  Copyright © 2019 gree. All rights reserved.
//

import UIKit
import PencilKit

  class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

      var canvas: PKCanvasView!

      var tresImage:UIImageView!

      override func viewDidLoad() {
          super.viewDidLoad()
          // Do any additional setup after loading the view.
          canvas = PKCanvasView(frame: UIScreen.main.bounds)
          view.addSubview(canvas)
          canvas.tool = PKInkingTool(.pen, color: .black, width: 30)

          tresImage = UIImageView()

          tresImage.frame = UIScreen.main.bounds

          view.insertSubview(tresImage, belowSubview: canvas)

          //キャンバスを透過させます。
          canvas.isOpaque = false
          //キャンバスをホワイトにします。
          canvas.backgroundColor = .white

          addButton()
      }
      override func viewDidAppear(_ animated: Bool) {
          if let window = view?.window, let toolPicker =

          PKToolPicker.shared(for: window) {

              toolPicker.setVisible(true, forFirstResponder: canvas)

              toolPicker.addObserver(canvas)

              canvas.becomeFirstResponder()
          }
      }

      @objc func saveImageEvent(_ sender: UIButton) {

          //画像を取得
          let canvasImage = canvas.drawing

          let frame = UIScreen.main.bounds

          //範囲とスケール
          let saveImage = canvasImage.image(from: frame, scale: 1)

          //イメージを端末に保存
          UIImageWriteToSavedPhotosAlbum(saveImage, self, nil, nil)

      }
      func addButton(){

          let saveImageButton = UIButton(type: UIButton.ButtonType.system)
        
          saveImageButton.addTarget(self,action: #selector(saveImageEvent(_:)),for: UIControl.Event.touchUpInside)
        
          saveImageButton.setTitle("SaveImage", for: UIControl.State.normal)
        
          saveImageButton.sizeToFit()
        
          saveImageButton.layer.position = CGPoint(x: view.frame.width/4 * 3, y: view.frame.height/10)
        
          self.view.addSubview(saveImageButton)


          let saveCanvasButton = UIButton(type: UIButton.ButtonType.system)
          let loadCanvasButton = UIButton(type: UIButton.ButtonType.system)
        
          saveCanvasButton.addTarget(self,action: #selector(saveCanvasEvent(_:)),for: UIControl.Event.touchUpInside)
          loadCanvasButton.addTarget(self,action: #selector(loadCanvasEvent(_:)),for: UIControl.Event.touchUpInside)
        
          saveCanvasButton.setTitle("SaveCanvas", for: UIControl.State.normal)
          loadCanvasButton.setTitle("LoadCanvas", for: UIControl.State.normal)
        
          saveCanvasButton.sizeToFit()
          loadCanvasButton.sizeToFit()
        
          saveCanvasButton.layer.position = CGPoint(x: view.frame.width/4 * 2,y: view.frame.height/10)
          loadCanvasButton.layer.position = CGPoint(x: view.frame.width/4 * 2,y: view.frame.height/10 * 2)
        
          self.view.addSubview(saveCanvasButton)
          self.view.addSubview(loadCanvasButton)


          let pickerButton = UIButton(type: UIButton.ButtonType.system)
          let deleteButton = UIButton(type: UIButton.ButtonType.system)

          pickerButton.addTarget(self, action: #selector(pickerEvent(_:)),for: UIControl.Event.touchUpInside)
          deleteButton.addTarget(self, action: #selector(deleteEvent(_:)),for: UIControl.Event.touchUpInside)

          pickerButton.setTitle("GetTres", for: UIControl.State.normal)
          deleteButton.setTitle("DeleteTres", for: UIControl.State.normal)

          pickerButton.sizeToFit()
          deleteButton.sizeToFit()

          pickerButton.layer.position = CGPoint(x: view.frame.width/4,y: view.frame.height/10)
          deleteButton.layer.position = CGPoint(x: view.frame.width/4,y: view.frame.height/10 * 2)

          self.view.addSubview(pickerButton)
          self.view.addSubview(deleteButton)

      }

      private var saveURL: URL {

          let paths = FileManager.default.urls(for: .documentDirectory,

          in: .userDomainMask)

          let documentsDirectory = paths.first!

          return documentsDirectory.appendingPathComponent("Canvas.data")

      }

      @objc func saveCanvasEvent(_ sender: UIButton) {

          var dataModel = DataModel()

          dataModel.drawingImage = canvas.drawing

          let url = saveURL

          do {
              let encoder = PropertyListEncoder()
              let data = try encoder.encode(dataModel)
              try data.write(to: url)
          } catch {
              print("error")
          }
      }

      @objc func loadCanvasEvent(_ sender: UIButton) {

          let url = saveURL

          if FileManager.default.fileExists(atPath: url.path){
            print("exists")
          }else{
            print("none")
          }
          var dataModel = DataModel()

          if FileManager.default.fileExists(atPath: url.path) {
            do {
                let decoder = PropertyListDecoder()
                let data = try Data(contentsOf: url)
                dataModel = try decoder.decode(DataModel.self, from: data)
                  print("decorder")
                } catch {
                  print("decorder")
                }
          } else {
            print("else")
          }
          canvas.drawing = dataModel.drawingImage
      }
      @objc func pickerEvent(_ sender: UIButton) {

          let picker = UIImagePickerController()

          picker.delegate = self

          present(picker, animated: true)

      }
      func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

            dismiss(animated: true, completion: nil)

      }

      func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo
        info:[UIImagePickerController.InfoKey : Any]) {
        
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            tresImage.image = image
            canvas.backgroundColor = .clear
            dismiss(animated: true, completion: nil)
      }
    
      @objc func deleteEvent(_ sender: UIButton) {
        tresImage.image = nil
        canvas.backgroundColor = .white
      }

  }

  struct DataModel: Codable {

    var drawingImage = PKDrawing()

  }
