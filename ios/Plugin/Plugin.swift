import Foundation
import Capacitor
import LocalAuthentication

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitor.ionicframework.com/docs/plugins/ios
 */
@objc(FaceId)
public class FaceId: CAPPlugin {
    
    @objc func isAvailable(_ call: CAPPluginCall) {
        if #available(iOS 11, *) {
            let authContext = LAContext()
            
            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch(authContext.biometryType) {
            case .none:
                call.resolve([
                    "value": "None"
                ])
            case .touchID:
                call.resolve([
                    "value": "TouchId"
                ])
            case .faceID:
                call.resolve([
                    "value": "FaceId"
                ])
            default:
                call.resolve([
                    "value": "None"
                ])
            }
        } else {
            call.success([
                "value": "None"
            ])
        }
    }
    
    @objc func auth(_ call: CAPPluginCall) {
        let authContext = LAContext()
        
        authContext.touchIDAuthenticationAllowableReuseDuration = 0;
        
        let reason = call.getString("reason") ?? "Access requires authentication"
        authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason ) { success, error in
            if success {
                DispatchQueue.main.async {
                    call.resolve()
                }
            } else {
                call.reject(error?.localizedDescription ?? "Failed to authenticate")
            }
        }
    }
    
    
}
