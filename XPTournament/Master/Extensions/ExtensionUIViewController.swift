//
//  ExtensionUIViewController.swift
//  Swifty_Master
//
//  Created by Mind-0002 on 28/08/17.
//  Copyright © 2017 Mind. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer
import ObjectiveC
import MessageUI
import PhotosUI

typealias alertActionHandler = ((UIAlertAction) -> ())?
typealias alertTextFieldHandler = ((UITextField) -> ())
typealias apiErrorHandler = ((_ index: Int, _ btnTitle: String) -> ())

// MARK: - Extension of UIViewController For AlertView with Different Numbers of Buttons
extension UIViewController {
    
    /// This Method is used to show AlertView with one Button.
    ///
    /// - Parameters:
    ///   - alertTitle: A String value that indicates the title of AlertView , it is Optional so you can pass nil if you don't want Alert Title.
    ///   - alertMessage: A String value that indicates the title of AlertView , it is Optional so you can pass nil if you don't want alert message.
    ///   - btnOneTitle: A String value - Title of button.
    ///   - btnOneTapped: Button Tapped Handler (Optional - you can pass nil if you don't want any action).
    func presentAlertViewWithOneButton(alertTitle:String? , alertMessage:String? , btnOneTitle:String , btnOneTapped:alertActionHandler) {
        
        let alertController = UIAlertController(title: alertTitle ?? "", message: alertMessage ?? "", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: btnOneTitle, style: .default, handler: btnOneTapped))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// This Method is used to show AlertView with two Buttons.
    ///
    /// - Parameters:
    ///   - alertTitle: A String value that indicates the title of AlertView , it is Optional so you can pass nil if you don't want Alert Title.
    ///   - alertMessage: A String value that indicates the title of AlertView , it is Optional so you can pass nil if you don't want alert message.
    ///   - btnOneTitle: A String value - Title of button one.
    ///   - btnOneTapped: Button One Tapped Handler (Optional - you can pass nil if you don't want any action).
    ///   - btnTwoTitle: A String value - Title of button two.
    ///   - btnTwoTapped: Button Two Tapped Handler (Optional - you can pass nil if you don't want any action).
    func presentAlertViewWithTwoButtons(alertTitle:String? , alertMessage:String? , btnOneTitle:String , btnOneTapped:alertActionHandler , btnTwoTitle:String , btnTwoTapped:alertActionHandler) {
        
        GCDMainThread.async {
            let alertController = UIAlertController(title: alertTitle ?? "", message: alertMessage ?? "", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: btnOneTitle, style: .default, handler: btnOneTapped))
            
            alertController.addAction(UIAlertAction(title: btnTwoTitle, style: .default, handler: btnTwoTapped))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func presentAlertWithAPIErrorTitle(title: String, message: String, handler:@escaping apiErrorHandler) {
        self.presentAlertViewWithTwoButtons(alertTitle: title, alertMessage: message, btnOneTitle: CBtnRetry, btnOneTapped: { (retryAction) in
            handler(0, CBtnRetry)
        }, btnTwoTitle: CBtnCancel) { (cancelAction) in
            handler(1, CBtnCancel)
        }
    }
    
    /// This Method is used to show AlertView with three Buttons.
    ///
    /// - Parameters:
    ///   - alertTitle: A String value that indicates the title of AlertView , it is Optional so you can pass nil if you don't want Alert Title.
    ///   - alertMessage: A String value that indicates the title of AlertView , it is Optional so you can pass nil if you don't want alert message.
    ///   - btnOneTitle: A String value - Title of button one.
    ///   - btnOneTapped: Button One Tapped Handler (Optional - you can pass nil if you don't want any action).
    ///   - btnTwoTitle: A String value - Title of button two.
    ///   - btnTwoTapped: Button Two Tapped Handler (Optional - you can pass nil if you don't want any action).
    ///   - btnThreeTitle: A String value - Title of button three.
    ///   - btnThreeTapped: Button Three Tapped Handler (Optional - you can pass nil if you don't want any action).
    func presentAlertViewWithThreeButtons(alertTitle:String? , alertMessage:String? , btnOneTitle:String , btnOneTapped:alertActionHandler , btnTwoTitle:String , btnTwoTapped:alertActionHandler , btnThreeTitle:String , btnThreeTapped:alertActionHandler) {
        
        let alertController = UIAlertController(title: alertTitle ?? "", message: alertMessage ?? "", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: btnOneTitle, style: .default, handler: btnOneTapped))
        
        alertController.addAction(UIAlertAction(title: btnTwoTitle, style: .default, handler: btnTwoTapped))
        
        alertController.addAction(UIAlertAction(title: btnThreeTitle, style: .default, handler: btnThreeTapped))
        
        self.present(alertController, animated: true, completion: nil)
    }
}


// MARK: - Extension of UIViewController For AlertView with Different Numbers of UITextField and with Two Buttons.
extension UIViewController {
    
    /// This Method is used to show AlertView with one TextField and with Two Buttons.
    ///
    /// - Parameters:
    ///   - alertTitle: A String value that indicates the title of AlertView , it is Optional so you can pass nil if you don't want Alert Title.
    ///   - alertMessage: A String value that indicates the title of AlertView , it is Optional so you can pass nil if you don't want alert message.
    ///   - alertFirstTextFieldHandler: TextField Handler , you can directlly get the object of UITextField.
    ///   - btnOneTitle: A String value - Title of button one.
    ///   - btnOneTapped: Button One Tapped Handler (Optional - you can pass nil if you don't want any action).
    ///   - btnTwoTitle: A String value - Title of button two.
    ///   - btnTwoTapped: Button Two Tapped Handler (Optional - you can pass nil if you don't want any action).
    func presentAlertViewWithOneTextField(alertTitle:String? , alertMessage:String? , alertFirstTextFieldHandler:@escaping alertTextFieldHandler , btnOneTitle:String , btnOneTapped:alertActionHandler , btnTwoTitle:String , btnTwoTapped:alertActionHandler) {
        
        let alertController = UIAlertController(title: alertTitle ?? "", message: alertMessage ?? "", preferredStyle: .alert)
        
        alertController.addTextField { (alertTextField) in
            alertFirstTextFieldHandler(alertTextField)
        }
        
        alertController.addAction(UIAlertAction(title: btnOneTitle, style: .default, handler: btnOneTapped))
        
        alertController.addAction(UIAlertAction(title: btnTwoTitle, style: .default, handler: btnTwoTapped))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    /// This Method is used to show AlertView with two TextField and with Two Buttons.
    ///
    /// - Parameters:
    ///   - alertTitle: A String value that indicates the title of AlertView , it is Optional so you can pass nil if you don't want Alert Title.
    ///   - alertMessage: A String value that indicates the title of AlertView , it is Optional so you can pass nil if you don't want alert message.
    ///   - alertFirstTextFieldHandler: First TextField Handeler , you can directlly get the object of First UITextField.
    ///   - alertSecondTextFieldHandler: Second TextField Handeler , you can directlly get the object of Second UITextField.
    ///   - btnOneTitle: A String value - Title of button one.
    ///   - btnOneTapped: Button One Tapped Handler (Optional - you can pass nil if you don't want any action).
    ///   - btnTwoTitle: A String value - Title of button two.
    ///   - btnTwoTapped: Button Two Tapped Handler (Optional - you can pass nil if you don't want any action).
    func presentAlertViewWithTwoTextFields(alertTitle:String? , alertMessage:String? , alertFirstTextFieldHandler:@escaping alertTextFieldHandler , alertSecondTextFieldHandler:@escaping alertTextFieldHandler , btnOneTitle:String , btnOneTapped:alertActionHandler , btnTwoTitle:String , btnTwoTapped:alertActionHandler) {
        
        let alertController = UIAlertController(title: alertTitle ?? "", message: alertMessage ?? "", preferredStyle: .alert)
        
        alertController.addTextField { (alertFirstTextField) in
            alertFirstTextFieldHandler(alertFirstTextField)
        }
        
        alertController.addTextField { (alertSecondTextField) in
            alertSecondTextFieldHandler(alertSecondTextField)
        }
        
        alertController.addAction(UIAlertAction(title: btnOneTitle, style: .default, handler: btnOneTapped))
        
        alertController.addAction(UIAlertAction(title: btnTwoTitle, style: .default, handler: btnTwoTapped))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// This Method is used to show AlertView with three TextField and with Two Buttons.
    ///
    /// - Parameters:
    ///   - alertTitle: A String value that indicates the title of AlertView , it is Optional so you can pass nil if you don't want Alert Title.
    ///   - alertMessage: A String value that indicates the title of AlertView , it is Optional so you can pass nil if you don't want alert message.
    ///   - alertFirstTextFieldHandler: First TextField Handeler , you can directlly get the object of First UITextField.
    ///   - alertSecondTextFieldHandler: Second TextField Handeler , you can directlly get the object of Second UITextField.
    ///   - alertThirdTextFieldHandler: Third TextField Handeler , you can directlly get the object of Third UITextField.
    ///   - btnOneTitle:  A String value - Title of button one.
    ///   - btnOneTapped: Button One Tapped Handler (Optional - you can pass nil if you don't want any action).
    ///   - btnTwoTitle:  A String value - Title of button two.
    ///   - btnTwoTapped: Button Two Tapped Handler (Optional - you can pass nil if you don't want any action).
    func presentAlertViewWithThreeTextFields(alertTitle:String? , alertMessage:String? , alertFirstTextFieldHandler:@escaping alertTextFieldHandler , alertSecondTextFieldHandler:@escaping alertTextFieldHandler , alertThirdTextFieldHandler:@escaping alertTextFieldHandler , btnOneTitle:String , btnOneTapped:alertActionHandler , btnTwoTitle:String , btnTwoTapped:alertActionHandler) {
        
        let alertController = UIAlertController(title: alertTitle ?? "", message: alertMessage ?? "", preferredStyle: .alert)
        
        alertController.addTextField { (alertFirstTextField) in
            alertFirstTextFieldHandler(alertFirstTextField)
        }
        
        alertController.addTextField { (alertSecondTextField) in
            alertSecondTextFieldHandler(alertSecondTextField)
        }
        
        alertController.addTextField { (alertThirdTextField) in
            alertThirdTextFieldHandler(alertThirdTextField)
        }
        
        alertController.addAction(UIAlertAction(title: btnOneTitle, style: .default, handler: btnOneTapped))
        
        alertController.addAction(UIAlertAction(title: btnTwoTitle, style: .default, handler: btnTwoTapped))
        
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Extension of UIViewController For Actionsheet with Different Numbers of Buttons
extension UIViewController {
    
    /// This Method is used to show ActionSheet with One Button and with One(by Default) "Cancel Button" , While Using this method you don't need to add "Cancel Button" as its already there in ActionSheet.
    ///
    /// - Parameters:
    ///   - actionSheetTitle: A String value that indicates the title of ActionSheet , it is Optional so you can pass nil if you don't want ActionSheet Title.
    ///   - actionSheetMessage: A String value that indicates the ActionSheet message.
    
    ///   - btnOneTitle: A String value - Title of button one.
    ///   - btnOneStyle: A Enum value of "UIAlertActionStyle" , don't pass .cancel as it is already there in ActionSheet(By Default) , If you are passing this value as .cancel then application will crash
    ///   - btnOneTapped: Button One Tapped Handler (Optional - you can pass nil if you don't want any action).
    func presentActionsheetWithOneButton(actionSheetTitle:String? , actionSheetMessage:String? , btnOneTitle:String  , btnOneStyle:UIAlertAction.Style , btnOneTapped:alertActionHandler) {
        
        let alertController = UIAlertController(title: actionSheetTitle, message: actionSheetMessage, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: btnOneTitle, style: btnOneStyle, handler: btnOneTapped))
        
        alertController.addAction(UIAlertAction(title: CBtnCancel, style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// This Method is used to show ActionSheet with Two Buttons and with One(by Default) "Cancel Button" , While Using this method you don't need to add "Cancel Button" as its already there in ActionSheet.
    ///
    /// - Parameters:
    ///   - actionSheetTitle: A String value that indicates the title of ActionSheet , it is Optional so you can pass nil if you don't want ActionSheet Title.
    ///   - actionSheetMessage: A String value that indicates the ActionSheet message.
    ///   - btnOneTitle: A String value - Title of button one.
    ///   - btnOneStyle: A Enum value of "UIAlertActionStyle" , don't pass .cancel as it is already there in ActionSheet(By Default) , If you are passing this value as .cancel then application will crash
    ///   - btnOneTapped: Button One Tapped Handler (Optional - you can pass nil if you don't want any action).
    ///   - btnTwoTitle: A String value - Title of button two.
    ///   - btnTwoStyle: A Enum value of "UIAlertActionStyle" , don't pass .cancel as it is already there in ActionSheet(By Default) , If you are passing this value as .cancel then application will crash
    ///   - btnTwoTapped: Button Two Tapped Handler (Optional - you can pass nil if you don't want any action).
    func presentActionsheetWithTwoButtons(actionSheetTitle:String? , actionSheetMessage:String? , btnOneTitle:String  , btnOneStyle:UIAlertAction.Style , btnOneTapped:alertActionHandler , btnTwoTitle:String  , btnTwoStyle:UIAlertAction.Style , btnTwoTapped:alertActionHandler) {
        
        let alertController = UIAlertController(title: actionSheetTitle, message: actionSheetMessage, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: btnOneTitle, style: btnOneStyle, handler: btnOneTapped))
        
        alertController.addAction(UIAlertAction(title: btnTwoTitle, style: btnTwoStyle, handler: btnTwoTapped))
        
        alertController.addAction(UIAlertAction(title: CBtnCancel, style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// This Method is used to show ActionSheet with Three Buttons and with One(by Default) "Cancel Button" , While Using this method you don't need to add "Cancel Button" as its already there in ActionSheet.
    ///
    /// - Parameters:
    ///   - actionSheetTitle: A String value that indicates the title of ActionSheet , it is Optional so you can pass nil if you don't want ActionSheet Title.
    ///   - actionSheetMessage: A String value that indicates the ActionSheet message.
    ///   - btnOneTitle: A String value - Title of button one.
    ///   - btnOneStyle: A Enum value of "UIAlertActionStyle" , don't pass .cancel as it is already there in ActionSheet(By Default) , If you are passing this value as .cancel then application will crash
    ///   - btnOneTapped: Button One Tapped Handler (Optional - you can pass nil if you don't want any action).
    ///   - btnTwoTitle: A String value - Title of button two.
    ///   - btnTwoStyle: A Enum value of "UIAlertActionStyle" , don't pass .cancel as it is already there in ActionSheet(By Default) , If you are passing this value as .cancel then application will crash
    ///   - btnTwoTapped: Button Two Tapped Handler (Optional - you can pass nil if you don't want any action).
    ///   - btnThreeTitle: A String value - Title of button three.
    ///   - btnThreeStyle: A Enum value of "UIAlertActionStyle" , don't pass .cancel as it is already there in ActionSheet(By Default) , If you are passing this value as .cancel then application will crash
    ///   - btnThreeTapped: Button Three Tapped Handler (Optional - you can pass nil if you don't want any action).
    func presentActionsheetWithThreeButton(actionSheetTitle:String? , actionSheetMessage:String? , btnOneTitle:String  , btnOneStyle:UIAlertAction.Style , btnOneTapped:alertActionHandler , btnTwoTitle:String  , btnTwoStyle:UIAlertAction.Style , btnTwoTapped:alertActionHandler , btnThreeTitle:String  , btnThreeStyle:UIAlertAction.Style , btnThreeTapped:alertActionHandler) {
        
        let alertController = UIAlertController(title: actionSheetTitle, message: actionSheetMessage, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: btnOneTitle, style: btnOneStyle, handler: btnOneTapped))
        
        alertController.addAction(UIAlertAction(title: btnTwoTitle, style: btnTwoStyle, handler: btnTwoTapped))
        
        alertController.addAction(UIAlertAction(title: btnThreeTitle, style: btnThreeStyle, handler: btnThreeTapped))
        
        alertController.addAction(UIAlertAction(title: CBtnCancel, style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

typealias popUpCompletionHandler = (() -> ())

extension UIViewController {
    
    func presentPopUp(view:UIView , shouldOutSideClick:Bool , type:MIPopUpOverlay.MIPopUpPresentType , completionHandler:popUpCompletionHandler?) {
        
        guard let miPopUpOverlay = MIPopUpOverlay.shared else { return }
        
        if self.navigationController != nil {
            self.navigationController?.view.addSubview(miPopUpOverlay)
        } else {
            self.view.addSubview(miPopUpOverlay)
        }
        
        view.tag = 151
        miPopUpOverlay.shouldOutSideClick = shouldOutSideClick
        miPopUpOverlay.type = type
        miPopUpOverlay.addSubview(view)
        
        miPopUpOverlay.presentPopUpOverlayView(view: view, completionHandler: completionHandler)
    }
    
    func dismissPopUp(view:UIView , completionHandler:popUpCompletionHandler?) {
        
        guard let miPopUpOverlay = MIPopUpOverlay.shared else { return }
        
        miPopUpOverlay.dismissPopUpOverlayView(view: view, completionHandler: completionHandler)
    }
    
}


typealias imagePickerControllerCompletionHandler = ((_ image:UIImage? , _ info:[UIImagePickerController.InfoKey : Any]?) -> ())

// MARK: - Extension of UIViewController For UIImagePickerController - Select Image From Camera OR PhotoLibrary
extension UIViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    /// This Private Structure is used to create all AssociatedObjectKey which will be used within this extension.
    private struct AssociatedObjectKey {
        
        static var imagePickerController = "imagePickerController"
        static var imagePickerControllerCompletionHandler = "imagePickerControllerCompletionHandler"
    }
    
    /// A Computed Property of UIImagePickerController , If its already in memory then return it OR not then create new one and store it in memory reference.
    private var imagePickerController:UIImagePickerController? {
        
        if let imagePickerController = objc_getAssociatedObject(self, &AssociatedObjectKey.imagePickerController) as? UIImagePickerController {
            
            return imagePickerController
        } else {
            return self.addImagePickerController()
        }
    }
    
    /// A Private method used to create a UIImagePickerController and store it in a memory reference.
    ///
    /// - Returns: return a newly created UIImagePickerController.
    private func addImagePickerController() -> UIImagePickerController? {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        objc_setAssociatedObject(self, &AssociatedObjectKey.imagePickerController, imagePickerController, .OBJC_ASSOCIATION_RETAIN)
        
        return imagePickerController
    }
    
    /// A Private method used to set the sourceType of UIImagePickerController
    ///
    /// - Parameter sourceType: A Enum value of "UIImagePickerControllerSourceType"
    private func setImagePickerControllerSourceType(sourceType:UIImagePickerController.SourceType) {
        
        self.imagePickerController?.sourceType = sourceType
    }
    
    /// A Private method used to set the Bool value for allowEditing OR Not on UIImagePickerController.
    ///
    /// - Parameter allowEditing: Bool value for allowEditing OR Not on UIImagePickerController.
    private func setAllowEditing(allowEditing:Bool) {
        self.imagePickerController?.allowsEditing = allowEditing
    }
    
    /// This method is used to present the UIImagePickerController on CurrentController for select the image from Camera or PhotoLibrary.
    ///
    /// - Parameters:
    ///   - allowEditing: Pass the Bool value for allowEditing OR Not on UIImagePickerController.
    ///   - imagePickerControllerCompletionHandler: This completionHandler contain selected image AND info Dictionary to let you help in CurrentController. Both image AND info Dictionary might be nil , in this case to prevent the crash please use if let OR guard let.
    func presentImagePickerController(allowEditing:Bool , imagePickerControllerCompletionHandler:@escaping imagePickerControllerCompletionHandler) {
        
        self.presentActionsheetWithTwoButtons(actionSheetTitle: nil, actionSheetMessage: nil, btnOneTitle: CLocalize(text: "Take A Photo"), btnOneStyle: .default, btnOneTapped: { (action) in
            
            self.takeAPhoto()
            
        }, btnTwoTitle: CLocalize(text: "Choose From Phone"), btnTwoStyle: .default) { (action) in
            
            self.chooseFromPhone(allowEditing:allowEditing)
        }
        
        objc_setAssociatedObject(self, &AssociatedObjectKey.imagePickerControllerCompletionHandler, imagePickerControllerCompletionHandler, .OBJC_ASSOCIATION_RETAIN)
    }
    
    func presentImagePickerControllerForCamera(imagePickerControllerCompletionHandler:@escaping imagePickerControllerCompletionHandler) {
        self.takeAPhoto()
        objc_setAssociatedObject(self, &AssociatedObjectKey.imagePickerControllerCompletionHandler, imagePickerControllerCompletionHandler, .OBJC_ASSOCIATION_RETAIN)
    }
    
    /// A private method used to select the image from camera.
    private func takeAPhoto() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            self.setImagePickerControllerSourceType(sourceType: .camera)
            self.setAllowEditing(allowEditing: false)
            
            self.present(self.imagePickerController!, animated: true, completion: nil)
            
        } else {
            
            self.presentAlertViewWithOneButton(alertTitle: nil, alertMessage: "Your device does not support camera", btnOneTitle: CBtnOk, btnOneTapped: nil)
        }
    }
    
    /// A private method used to select the image from photoLibrary.
    ///
    /// - Parameter allowEditing: Bool value for allowEditing OR Not on UIImagePickerController.
    private func chooseFromPhone(allowEditing:Bool) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            self.setImagePickerControllerSourceType(sourceType: .photoLibrary)
            self.setAllowEditing(allowEditing: allowEditing)
            
            self.present(self.imagePickerController!, animated: true, completion: nil)
            
        } else {}
    }
    
    /// A Delegate method of UIImagePickerControllerDelegate.
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        
        picker.dismiss(animated: true) {
            
            if let allowEditing = self.imagePickerController?.allowsEditing {
                
                var image:UIImage?
                
                if allowEditing {
                    image = info[.editedImage] as? UIImage
                } else {
                    image = info[.originalImage] as? UIImage
                }
                
                if let imagePickerControllerCompletionHandler = objc_getAssociatedObject(self, &AssociatedObjectKey.imagePickerControllerCompletionHandler) as? imagePickerControllerCompletionHandler {
                    
                    imagePickerControllerCompletionHandler(image, info)
                }
            }
        }
    }
    
    /// A Delegate method of UIImagePickerControllerDelegate.
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true) {
            
            if let imagePickerControllerCompletionHandler = objc_getAssociatedObject(self, &AssociatedObjectKey.imagePickerControllerCompletionHandler) as? imagePickerControllerCompletionHandler {
                
                imagePickerControllerCompletionHandler(nil, nil)
            }
        }
    }
    
}

enum PHAssetType : Int {
    case unknown
    case image
    case video
    case audio
}


typealias phAssetControllerHandler = ((_ mediaItemCollection:PHFetchResult<PHAsset>?) -> ())
// MARK: - Extension of UIViewController For MPMediaPickerController - Select Video/Image From gallery
extension UIViewController {
    /// This Private Structure is used to create all AssociatedAssetKey which will be used within this extension.
    private struct AssociatedAssetKey {
        static var phAssetControllerHandler = "phAssetControllerHandler"
    }
    
    func phAssetController(_ type : PHAssetType?, phAssetControllerHandler:@escaping phAssetControllerHandler){
        
        objc_setAssociatedObject(self, &AssociatedAssetKey.phAssetControllerHandler, phAssetControllerHandler, .OBJC_ASSOCIATION_RETAIN)
        
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                let fetchOptions = PHFetchOptions()
                var arrAssets = PHFetchResult<PHAsset>()
                switch type
                {
                case .unknown?:
                    arrAssets = PHAsset.fetchAssets(with: .unknown, options: fetchOptions)

                case .image?:
                    arrAssets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                    
                case .video?:
                    arrAssets = PHAsset.fetchAssets(with: .video, options: fetchOptions)

                case .audio?:
                    arrAssets = PHAsset.fetchAssets(with: .audio, options: fetchOptions)

                default:
                    break

                }
                
                
                print("Found \(arrAssets.count) assets")
                
                if let phAssetControllerHandler = objc_getAssociatedObject(self, &AssociatedAssetKey.phAssetControllerHandler) as? phAssetControllerHandler {
                    phAssetControllerHandler(arrAssets)
                }
                
            case .denied, .restricted:
                print("Not allowed")
            case .notDetermined:
                // Should not see this when requesting
                print("Not determined yet")
            }
        }
        
    }
}


typealias mediaPickerControllerHandler = ((_ mediaItemCollection:MPMediaItemCollection?) -> ())
// MARK: - Extension of UIViewController For MPMediaPickerController - Select Music/Video From gallery
extension UIViewController:MPMediaPickerControllerDelegate{
    
    /// This Private Structure is used to create all AssociatedMediaKey which will be used within this extension.
    private struct AssociatedMediaKey {
        static var mediaPickerControllerHandler = "mediaPickerControllerHandler"
    }
    
    func presentMediaPickerController(allowsPickingMultipleItems:Bool,showsCloudItems:Bool , mediaPickerControllerHandler:@escaping mediaPickerControllerHandler) {
        let mediaPicker = MPMediaPickerController(mediaTypes: .music)
        mediaPicker.delegate = self
        mediaPicker.allowsPickingMultipleItems = allowsPickingMultipleItems
        mediaPicker.showsCloudItems = showsCloudItems
        self.present(mediaPicker, animated: true, completion: nil)
        
        objc_setAssociatedObject(self, &AssociatedMediaKey.mediaPickerControllerHandler, mediaPickerControllerHandler, .OBJC_ASSOCIATION_RETAIN)
    }
    
    public func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        self.dismiss(animated: true) {
            if let mediaPickerControllerHandler = objc_getAssociatedObject(self, &AssociatedMediaKey.mediaPickerControllerHandler) as? mediaPickerControllerHandler {
                mediaPickerControllerHandler(nil)
            }
        }
    }
    
    func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        self.dismiss(animated: true) {
            if let mediaPickerControllerHandler = objc_getAssociatedObject(self, &AssociatedMediaKey.mediaPickerControllerHandler) as? mediaPickerControllerHandler {
                mediaPickerControllerHandler(mediaItemCollection)
            }
        }
    }
}

typealias blockHandler = ((_ data:Any? , _ error:String?) -> ())

// MARK: - Extension of UIViewController set the Block and getting back with some data(Any Type of Data) AND error message(String).
extension UIViewController {
    
    /// This Private Structure is used to create all AssociatedObjectKey which will be used within this extension.
    private struct blockKey {
        static var blockHandler = "blockHandler"
    }
    
    /// A Computed Property (only getter) of blockHandler(data , error) , Both data AND error are optional so you can pass nil if you don't want to share anything. This Computed Property is optional , it might be return nil so please use if let OR guard let.
    var block:blockHandler? {
        
        guard let block = objc_getAssociatedObject(self, &blockKey.blockHandler) as? blockHandler else { return nil }
        
        return block
    }
    
    /// This method is used to set the block on CurrentController for getting back with some data(Any Type of Data) AND error message(String).
    ///
    /// - Parameter block: This block contain data(Any Type of Data) AND error message(String) to let you help in CurrentController. Both data AND error might be nil , in this case to prevent the crash please use if let OR guard let.
    func setBlock(block:@escaping blockHandler) {
        
        objc_setAssociatedObject(self, &blockKey.blockHandler, block, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
}

// MARK: - Extension of UIViewController.
extension UIViewController {
    
    /// This static method is used for initialize the UIViewController with nibName AND bundle.
    /// - Returns: This Method returns instance of UIViewController.
    static func initWithNibName() -> UIViewController {
        return self.init(nibName: "\(self)", bundle: nil)
    }
    
    var isVisible:Bool {
        return self.isViewLoaded && (self.view.window != nil)
    }
    
    var isPresentted:Bool {
        return self.isBeingPresented || self.isMovingToParent
    }
    
    var isDismissed:Bool {
        return self.isBeingDismissed || self.isMovingFromParent
    }
    
}

extension UIViewController {
    
    func openInSafari(strUrl:String) {
        
        var newStr:String = strUrl
        
        if strUrl.lowercased().hasPrefix("http://") || strUrl.lowercased().hasPrefix("https://") {
            
        } else {
            newStr = "http://" + strUrl
        }
        
        if let url = newStr.toURL {
            
            if CSharedApplication.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    CSharedApplication.open(url, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    CSharedApplication.openURL(url)
                }
            }
            
        } else {
            print("Master Log ::--> Unable to Convert the String to URL")
        }
    }
    
}

// MARK: - --------------- MFMailComposeViewController
extension UIViewController:MFMailComposeViewControllerDelegate{
    func openMailComposer(email : String?, body : String?)  {
        
        GCDMainThread.async {
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                
                if email != nil{
                    mail.setToRecipients([email!])
                }
                
                if body != nil{
                    mail.setMessageBody(body!, isHTML: true)
                }
                
                self.present(mail, animated: true)
            } else {
                self.presentAlertViewWithOneButton(alertTitle: "", alertMessage: "Sorry, your device is not support mail", btnOneTitle: CBtnOk, btnOneTapped: nil)
            }
        }
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}



//MARK:- Custom alertview

extension UIViewController {
    
    func showAlertConfirmationView(_ message: String?, okTitle: String?, cancleTitle: String?, type: AlertType, completion: ((Bool) -> Void)?) {
        
        for objView in (appDelegate.window.subviews)
        {
            if objView.isKind(of: CustomAlertView.classForCoder())
            {
                objView.removeFromSuperview()
            }
        }
        
        if let alertView = CustomAlertView.initAlertView() as? CustomAlertView {
            
            GCDMainThread.async {
                alertView.btnOk.setTitle(okTitle, for: .normal)
                alertView.btnCancel.setTitle(cancleTitle, for: .normal)
                alertView.lblMsg.text = message
            }
            
            appDelegate.window.addSubview(alertView)
            
            alertView.btnOk.touchUpInside { (sender) in
                alertView.removeFromSuperview()
                if let handler = completion {
                    handler(true)
                }
            }
            alertView.btnCancel.touchUpInside { (sender) in
                alertView.removeFromSuperview()
                if let handler = completion {
                    handler(false)
                }
            }
        }
    }
    
    func showAlertView(_ message: String?, completion: ((Bool) -> Void)?) {
        
        for objView in (appDelegate.window.subviews)
        {
            if objView.isKind(of: CustomAlertView.classForCoder())
            {
                objView.removeFromSuperview()
            }
        }
        
        if let alertView = CustomAlertView.initAlertView() as? CustomAlertView {
            
            GCDMainThread.async {
                alertView.btnAlertOk.isHidden = false
                alertView.lblMsg.text = message
            }
            
            appDelegate.window.addSubview(alertView)
            alertView.btnAlertOk.touchUpInside { (sender) in
                alertView.removeFromSuperview()
                if let handler = completion {
                    handler(true)
                }
            }
        }
    }
    
}

// MARK:- GSImageViewerController
// MARK:-

import GSImageViewerController

extension UIViewController {
    func zoomGSImageViewer(_ imageView: UIImageView) {
        if let img = imageView.image {
            GCDMainThread.async {
                let imageInfo      = GSImageInfo(image: img, imageMode: .aspectFit, imageHD: nil)
                let transitionInfo = GSTransitionInfo(fromView: imageView)
                let imageViewer    = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
                self.present(imageViewer, animated: true, completion: nil)
            }
        }
    }
}
