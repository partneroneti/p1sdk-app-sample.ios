import UIKit
import Foundation
import FaceTecSDK

open class LivenessCheckProcessor: NSObject, Processor, FaceTecFaceScanProcessorDelegate, URLSessionTaskDelegate {
  var latestNetworkRequest: URLSessionTask!
  var success = false
  var fromViewController: FacialScanViewController!
  var faceScanResultCallback: FaceTecFaceScanResultCallback!
  
  public var faceScan: String = ""
  var helper = PartnerHelper()
  
  init(sessionToken: String, fromViewController: FacialScanViewController) {
    self.fromViewController = fromViewController
    super.init()
    
    let livenessCheckViewController = FaceTec.sdk.createSessionVC(faceScanProcessorDelegate: self, sessionToken: sessionToken)
    fromViewController.present(livenessCheckViewController, animated: true, completion: nil)
  }
  
  public func processSessionWhileFaceTecSDKWaits(sessionResult: FaceTecSessionResult, faceScanResultCallback: FaceTecFaceScanResultCallback) {

          if sessionResult.status != FaceTecSessionStatus.sessionCompletedSuccessfully {
            if latestNetworkRequest != nil {
              latestNetworkRequest.cancel()
        }
      
            faceScanResultCallback.onFaceScanResultCancel()
            return
          }
    
      self.helper.faceScan=(sessionResult.faceScanBase64 ?? "")
    self.helper.auditTrailImage=(sessionResult.auditTrailCompressedBase64?[0] ?? "")
    self.helper.lowQualityAuditTrailImage=(sessionResult.lowQualityAuditTrailCompressedBase64?[0] ?? "")
    
    fromViewController.setLatestSessionResult(sessionResult: sessionResult)
    
    self.faceScanResultCallback = faceScanResultCallback
    self.fromViewController.processorResponse?()
    
    print("@! >>> Escaneamento facial feito. Fazendo checagem...")
      
    
//    if sessionResult.status != FaceTecSessionStatus.sessionCompletedSuccessfully {
//      if latestNetworkRequest != nil {
//        latestNetworkRequest.cancel()
//      }
//
//      faceScanResultCallback.onFaceScanResultCancel()
//      return
//    }

    
//    let BaseURL = "https://digital-id.webdatadome.com/api"
//    var parameters: [String : Any] = [:]
//    parameters["transactionId"] = Config.TransactionID
//    parameters["faceScan"] = sessionResult.faceScanBase64
//    parameters["auditTrailImage"] = sessionResult.auditTrailCompressedBase64![0]
//    parameters["lowQualityAuditTrailImage"] = sessionResult.lowQualityAuditTrailCompressedBase64![0]
//    parameters["sessionId"] = helper.createUserAgentForSession()
//    parameters["deviceKey"] = "dioxhbQHfJHmnHTzJ40hCiUm3FR0IkXY"
//
//    var request = URLRequest(url: NSURL(string: Config.BaseURL + "/liveness")! as URL)
//    request.httpMethod = "POST"
//    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions(rawValue: 0))
//
//
//    let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
//    latestNetworkRequest = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
//
//      guard let data = data else {
//        faceScanResultCallback.onFaceScanResultCancel()
//        return
//      }
//
//      guard let responseJSON = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject] else {
//        faceScanResultCallback.onFaceScanResultCancel()
//        return
//      }
//
//      guard let scanResultBlob = responseJSON["scanResultBlob"] as? String,
//            let wasProcessed = responseJSON["wasProcessed"] as? Bool else {
//        faceScanResultCallback.onFaceScanResultCancel()
//        return;
//      }
//
//      if wasProcessed == true {
//        FaceTecCustomization.setOverrideResultScreenSuccessMessage("Liveness\nConfirmed")
//        self.success = faceScanResultCallback.onFaceScanGoToNextStep(scanResultBlob: scanResultBlob)
//      } else {
//        faceScanResultCallback.onFaceScanResultCancel()
//        return;
//      }
//    })
//
//    latestNetworkRequest.resume()
//
//    DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
//      if self.latestNetworkRequest.state == .completed { return }
//      let uploadMessage: NSMutableAttributedString = NSMutableAttributedString.init(string: "Still Uploading...")
//      faceScanResultCallback.onFaceScanUploadMessageOverride(uploadMessageOverride: uploadMessage)
//    }
    
      PartnerHelper.livenessCallBack!(sessionResult.faceScanBase64 ?? "" ,
                                sessionResult.auditTrailCompressedBase64?[0] ?? "", sessionResult.lowQualityAuditTrailCompressedBase64?[0] ?? "")
      faceScanResultCallback.onFaceScanResultCancel()
      
      
  }
  
  public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
    let uploadProgress: Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
    faceScanResultCallback.onFaceScanUploadProgress(uploadedPercent: uploadProgress)
  }
  
  public func onFaceTecSDKCompletelyDone() {
    self.fromViewController.onComplete();
  }
  
  func isSuccess() -> Bool {
    return success
  }
}
