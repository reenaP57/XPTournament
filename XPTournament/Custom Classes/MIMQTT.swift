//
//  MIMQTT.swift
//  Sevenchats
//
//  Created by mac-0005 on 18/01/19.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import CocoaMQTT
import AVKit

let CPublishJudgeResult                             = 2
let CPublishPlayerResult                            = 3
let CPublishPauseResumeTable                        = 4
let CPublishStartTournament                         = 5
let CPublishPauseResumeTournament                   = 6
let CPublishFinishTournament                        = 9
let CPublishDropUserFromTournament                  = 10


let CPublishType = "publish_type"
let CMQTTUSERTOPIC = "xp/tournament/"
let CMQTTUSERTOPICSTARTTOURNAMENT = "xp/tournament/start/"
let CMQTTUSERTOPICSEEDINGTOURNAMENT = "xp/tournament/seeding/"
let CMQTTUSERTOPICPAUSEMYTOURNAMENT = "xp/tournament/pause/"
let CMQTTUSERNAME = ""
let CMQTTPASSWORD = ""
let CMQTTHOST =  "itrainacademy.in"
let cMQTTPort = UInt16(3000)
//let ClientID  = "ios-" + String(ProcessInfo().processIdentifier) + "-\(appDelegate.loginUser?.user_id ?? Int64(0.0))"  //ios-RANDOMNUMBER(10)-USERID
let ClientID = String(ProcessInfo().processIdentifier)


// MQTTDelegate Methods
@objc protocol MQTTDelegate: class {
    @objc optional func didReceiveAcknowledgment(_ payload: [String : Any]?)
    @objc optional func mqttConnection(_ connected: Bool)
}


class MIMQTT: NSObject {
    weak var mqttDelegate: MQTTDelegate?
    
    var objMQTTClient : CocoaMQTT?
    
    private override init() {
        super.init()
    }
    
    private static var mqtt: MIMQTT = {
        let mqtt = MIMQTT()
        return mqtt
    }()
    
    static func shared() ->MIMQTT {
        return mqtt
    }
}

// MARK:- ------- MQTT Configuration
// MARK:-

extension MIMQTT {
    
    // MQTT initialization..
    func MQTTInitialSetup() {
        
        if appDelegate.loginUser == nil {
            return
        }
        
        if objMQTTClient == nil {
            objMQTTClient = CocoaMQTT(clientID: ClientID, host:CMQTTHOST, port: cMQTTPort)
        }
        
        objMQTTClient?.username = CMQTTUSERNAME
        objMQTTClient?.password = CMQTTPASSWORD
        objMQTTClient?.willMessage = CocoaMQTTWill(topic: "/will", message: "dieout")
        objMQTTClient?.keepAlive = 60
        objMQTTClient?.delegate = self
        objMQTTClient?.connect()
    }
    
    // Publish message here...
    func MQTTPublishWithTopic(_ payload: [String: Any], _ topic: String?) {
        
        // mchat/userId
        let jsonData = try? JSONSerialization.data(withJSONObject: payload, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        objMQTTClient?.publish(topic!, withString: jsonString!)
    }
    
    // Subscribe topic here..
    func MQTTSubscribeWithTopic(_ id: Any?, topicPrefix: String?) {
        print("MQTTSubscribeWithTopic ======= \(topicPrefix ?? "")\(id ?? "")")
        objMQTTClient?.subscribe("\(topicPrefix ?? "")\(id ?? "")")
    }
    
    // Unsubscribe topic here..
    func MQTTUnsubscribeWithTopic(_ id: Any?, topicPrefix: String?) {
        objMQTTClient?.unsubscribe("\(topicPrefix ?? "")\(id ?? "")")
    }
}

// MARK:- ------- CocoaMQTTDelegate
// MARK:-

extension MIMQTT: CocoaMQTTDelegate {
    
    // DID CONNECT HERE.....
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("DId CONNECTED ====== ")
        if self.mqttDelegate != nil {
            self.mqttDelegate?.mqttConnection?(true)
        }
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        print("mqttDidPing ======= ")
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        print("mqttDidReceivePong ======== ")
    }
    
    // DID DISCONECT HERE.....
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        print("mqttDidDisconnect ======== ")
        if self.mqttDelegate != nil {
            self.mqttDelegate?.mqttConnection?(false)
        }
        
    }
    
    // DID PUBLISH MESSAGE HERE.....
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("DID PUBLISH MESSAGE ==== ")
    }
    
    // DID PUBLISH ACK HERE...
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("DID PUBLISH ACK ==== ")
    }
    
    // DID RECEIVED MESSGE HERE.....
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        print("Message received in topic \(message.topic) with payload \(message.string!)")
        
        // Convert Json into dictionay here.....
        let payloadInfo = self.convertToDictionary(text: message.string!)
        if self.mqttDelegate != nil {
            self.mqttDelegate?.didReceiveAcknowledgment?(payloadInfo)
        }

    }
    
    // DID SUBSCRIBE TOPIC HERE...
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        print("DID SUBSCRIBE TOPIC  ==== ")
    }
    
    // DID UNSUBSCRIBE TOPIC HERE...
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        print("DID UNSUBSCRIBE TOPIC ==== ")
    }
}

// MARK:- ------- Helper Functions
// MARK:-
extension MIMQTT {
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
    
// MARK:- ------- Message Publish functions
// MARK:-
extension MIMQTT {
   /*
    func messagePaylaod(arrUser: [String?], channelId: String?, message: String?, messageType: MessageType?, chatType: ChatType?,  groupID: String?) {
        
        var dicPayload = [String : Any]()
        dicPayload[CSender_Id] = appDelegate.loginUser?.user_id
        dicPayload[CMessage] = message
        dicPayload[CMsg_type] = messageType?.rawValue
        dicPayload[CChat_type] = chatType?.rawValue
        dicPayload[CMessage_id] = (UIDevice.current.identifierForVendor?.uuidString)!.replacingOccurrences(of: "-", with: "") + "\(Int(Date().timeIntervalSince1970 * 1000))"
        dicPayload[CChannel_id] = channelId
        dicPayload[CFullName] = (appDelegate.loginUser?.first_name)! + " " + (appDelegate.loginUser?.last_name)!
        dicPayload[CProfileImage] = appDelegate.loginUser?.profile_img
        dicPayload[CUsers] = (arrUser as NSArray).componentsJoined(by: ",")
        dicPayload[CPublishType] = CPUBLISHMESSAGETYPE
        dicPayload[CCreated_at] = DateFormatter.shared().currentGMTTimestampInMilliseconds()?.toInt
        dicPayload[CGroupId] = groupID != nil ? groupID : ""
        dicPayload[CThumb_Url] = ""
        dicPayload[CThumb_Name] = ""
        dicPayload[CMedia_Name] = ""
        
        
        if chatType == .user {
            // FOR OTO CHAT Reciver id is always front user...
            if let index = arrUser.index(where: { $0 != "\(appDelegate.loginUser?.user_id ?? 0)"}) {
                dicPayload[CRecv_id] = arrUser[index]
            }
            
            // Publish Text message directly
            if messageType == .text {
                for userId in arrUser {
                    MIMQTT.shared().MQTTPublishWithTopic(dicPayload, CMQTTUSERTOPIC + "\(userId ?? "0")")
                }
            }
        }else {
            // FOR Group CHAT
            for userId in arrUser {	
                dicPayload[CRecv_id] = userId
                
                // Publish Text message directly
                if messageType == .text {
                    MIMQTT.shared().MQTTPublishWithTopic(dicPayload, CMQTTUSERTOPIC + "\(userId ?? "0")")
                }
            }
        }
        
        self.saveMessageToLocal(messageInfo: dicPayload, msgDeliveredStatus: 1, localPayload: true)
    }
*/
}





