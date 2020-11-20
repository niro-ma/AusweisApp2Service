//
//  AusweisApp2Service.swift
//  AusweisApp2PoC
//
//  Created by Niroshan Maheswaran on 28.11.20.
//

import Foundation
import AusweisApp2

/// Extension on Notifcation.
extension Notification {
    
    /// Notifcation name for AusweisApp2 result messages.
    static let ausweisApp2Messages = Notification.Name("AusweisApp2Messages")
}

public struct AusweisApp2Result {
    let message: Message
    let resultURL: String?
}

/// Messages returned by AusweissApp2SDK.
public enum Message: String {
    
    /// Will be send once the authentication is started by RUN_AUTH command and the SDK got the certificate from the service.
    /// When receiving this message SET_ACCESS_RIGHTS or GET_CERTIFICATE command can be send.
    /// Workflow will then continue when sending ACCEPT command or CANCEL command to abort whole workflow.
    case accessRights = "ACCESS_RIGHTS"
    
    /// Will be send when GET_API_LEVEL command was send to SDK.
    case apiLevel = "API_LEVEL"
    
    /// Will be send if an authentication is initally started. Next message should be ACCESS_RIGHTS or AUTH again if authentication throws an error.
    /// If authentication was successful the message contains a result and an URL parameter to indicate end of authentication.
    case auth = "AUTH"
    
    /// Previous send command was invaid. Some commands can only be send if certain 'state' is reached in workflow to obtain the corresponding result.
    /// For example GET_CERTIFICATE command cannot be send if there is no authentication.
    /// Then this message will be returned.
    case badState = "BAD_STATE"
    
    /// Provides information about the used certificate.
    case certificate = "CERTIFICATE"
    
    /// Will be send if a change PIN workflow is initially started.
    case changePin = "CHANGE_PIN"
    
    /// Indicates that a CAN is required to continue workflow.
    case enterCan = "ENTER_CAN"
    
    /// Indicates that a PIN is required to continue workflow.
    case enterPin = "ENTER_PIN"
    
    /// Indicates that a new PIN is required to continue workflow.
    case enterNewPin = "ENTER_NEW_PIN"
    
    /// Indicates that a PUK is required to continue workflow.
    case enterPuk = "ENTER_PUK"
        
    /// Provides information about the AusweisApp2SDK.
    case info = "INFO"
    
    /// Indicates that the AusweisApp2SDK requires a card to continue.
    case insertCard = "INSERT_CARD"
    
    /// Indicates an internal error. Bug of AusweisApp2SDK.
    case internalError = "INTERNAL_ERROR"
    
    /// Indicates a broken JSON which was send before.
    case invalid = "INVALID"
    
    /// Provides information about a connected or disconnected card reader.
    case reader = "READER"
    
    /// Provides information about all connected card readers.
    case readerList = "READER_LIST"
    
    /// Indicates that the command type is unknown.
    case unknown = "UNKNOWN_COMMAND"
}

/// Commands accepted by AusweisApp2SDK.
public enum Command {
    case changePin
    
    /// Information about current installation of AusweisApp2.
    case getInfo
    
    /// Returns information about current available API level.
    case getApiLevel
    
    /// Sets supported API level for this application.
    case setApiLevel(level: Int)
    
    /// Returns information about the request reader.
    case getReader(name: String)
    
    /// Returns information about all connected readers.
    case getReaderList
    
    /// Starts an authentication.
    case runAuth
    
    /// Starts a change PIN workflow.
    case runChangePin
    
    /// Returns information about the requested access rights.
    case getAccessRights
    
    /// Sets effective access rights.
    /// When sending empty array all access rights are disabled.
    /// List of all access rights see AusweisApp2SDK documentation p.26.
    case setAccessRights(accessRights: [String])
    
    /// Returns certificate of current authentication.
    case getCertificate
    
    /// Cancel the whole workflow.
    case cancel
    
    /// Accept the current state.
    /// For example the command ACCESS_RIGHTS was send, then the user has two options: accept (ACCEPT) or deny (CANCEL).
    /// The workflow is paused until this command has been send.
    case accept
    
    /// Sets PIN of inserted card.
    /// This command has to be sent when the SDK returns the message ENTER_PIN.
    case setPin(pin: String)
    
    /// Sets new PIN of inserted card.
    /// This command has to be sent when the SDK returns the message ENTER_NEW_PIN.
    case setNewPin(newPin: String)
    
    /// Sets CAN of inserted card.
    /// This command has to be sent when the SDK returns the message ENTER_CAN.
    case setCan(can: String)
    
    /// Sets PUK of inserted card.
    /// This command has to be sent when the SDK returns the message ENTER_PUK.
    case setPuk(puk: String)
    
    /// String which will be send to the SDK.
    public var commandString: String {
        var cmd: [String: Any] = [:]
        var commandString: String = ""
        
        switch self {
        case .getInfo:
            cmd = [
                "cmd": "GET_INFO"
            ]
            
        case .getApiLevel:
            cmd = [
                "cmd": "GET_API_LEVEL"
            ]
            
        case .setApiLevel(let level):
            cmd = [
                "cmd": "SET_API_LEVEL",
                "level": level
            ]
            
        case .getReader(let name):
            cmd = [
                "cmd": "GET_READER",
                "name": name
            ]
            
        case .getReaderList:
            cmd = [
                "cmd": "GET_READER_LIST"
            ]
            
        case .runAuth:
            cmd = [
                "cmd": "RUN_AUTH",
                "tcTokenURL": "https://test.governikus-eid.de/Autent-DemoApplication/RequestServlet?provider=demo_epa_20&redirect=true"
            ]
            
        case .runChangePin:
            cmd = [
                "cmd": "RUN_CHANGE_PIN"
            ]
            
        case .getAccessRights:
            cmd = [
                "cmd": "GET_ACCESS_RIGHTS"
            ]
            
        case .setAccessRights(let accessRights):
            cmd = [
                "cmd": "GET_ACCESS_RIGHTS",
                "chat": accessRights
            ]
            
        case .getCertificate:
            cmd = [
                "cmd": "GET_CERTIFICATE"
            ]
            
        case .cancel:
            cmd = [
                "cmd": "CANCEL"
            ]
            
        case .accept:
            cmd = [
                "cmd": "ACCEPT"
            ]
            
        case .setPin(let pin):
            cmd = [
                "cmd": "SET_PIN",
                "value": pin
            ]
            
        case .setNewPin(let newPin):
            cmd = [
                "cmd": "SET_NEW_PIN",
                "value": newPin
            ]
            
        case .setCan(let can):
            cmd = [
                "cmd": "SET_CAN",
                "value": can
            ]
            
        case .setPuk(let puk):
            cmd = [
                "cmd": "SET_PUK",
                "value": puk
            ]
            
        default:
            break
        }
        
        do {
            let cmdData = try JSONSerialization.data(withJSONObject: cmd, options: .prettyPrinted)
            if let stringValue = String(data: cmdData, encoding: .utf8) {
                commandString = stringValue
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return commandString
    }
}

public class AusweisApp2Service {
    
    // MARK: - Public properties
    
    /// Shared instance.
    public static let shared = AusweisApp2Service()
    
    // MARK: - Private properties
    
    private let notificationCenter = NotificationCenter.default
    
    // MARK: - Public methods
    
    /// Starts the AusweisApp2SDK so that it can accepts commands.
    public func start() {
        let callback: AusweisApp2Callback = { value in
            if let value = value {
                AusweisApp2Service.shared.parseMessage(value)
            }
        }
        
        let result = ausweisapp2_init(callback)
        
        result
            ? print("AusweisApp2SDK is ready to receive commands.")
            : print("AusweisApp2SDK could not be initialized.")
    }
    
    /// Sends command to AusweisApp2SDK.
    public func sendCommand(_ command: Command) {
        ausweisapp2_send(command.commandString)
    }
    
    /// Parses message received from AusweisApp2SDK.
    fileprivate func parseMessage(_ value: UnsafePointer<Int8>) {
        guard let stringData = String(cString: value).data(using: .utf8) else {
            return
        }
        
        do {
            let dict = try JSONSerialization.jsonObject(with: stringData, options: []) as? [String: Any]
            if let message = dict?["msg"] as? String, let messageCommand = Message(rawValue: message) {
                if messageCommand == .auth {
                    receivedAuthMessage(payload: dict)
                    return
                }
                
                notificationCenter.post(
                    name: Notification.ausweisApp2Messages,
                    object: nil,
                    userInfo: ["msg": AusweisApp2Result(message: messageCommand, resultURL: nil)]
                )
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func receivedAuthMessage(payload: [String: Any]?) {
        if let url = payload?["url"] as? String {
            notificationCenter.post(
                name: Notification.ausweisApp2Messages,
                object: nil,
                userInfo: ["msg": AusweisApp2Result(message: .auth, resultURL: url)]
            )
        } else {
            notificationCenter.post(
                name: Notification.ausweisApp2Messages,
                object: nil,
                userInfo: ["msg": AusweisApp2Result(message: .auth, resultURL: nil)]
            )
        }
    }
}
