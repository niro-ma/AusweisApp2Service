# AusweisApp2Service
Service class for the AusweissApp2 SDK of Governikus KG. The AusweissApp2 provides an online identification process with the german ID card.
For more details use following URL https://www.ausweisapp.bund.de/ausweisapp2/

The Service class is a Singleton, which provides following features:

* Starts the AusweissApp2 SDK and handles all incoming messages.
* Sends commands to the SDK.

# Usage
Following are the commands which needs to be done to start working with the SDK. 
A list of commands can be found here https://www.ausweisapp.bund.de/sdk/commands.html.
A list of the messages can be found here https://www.ausweisapp.bund.de/sdk/messages.html.

### Setup
It is mandatory to subscribe to the `Notification.ausweisApp2Messages` to receive the message of the SDK.

``` Swift
override func viewDidLoad() {
   super.viewDidLoad()
   NotificationCenter.default.addObserver(
       self,
       selector: #selector(receivedAusweisServiceMessage(_:)),
       name: Notification.ausweisApp2Messages,
       object: nil
   )
}
```

### Start Authentication

``` Swift
AusweisApp2Service.shared.sendCommand(Command.runAuth)
```

### Enter PIN

``` Swift
AusweisApp2Service.shared.sendCommand(Command.setPin(pin: 123456))
```
