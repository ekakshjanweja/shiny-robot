enum MessageType { message, audio, thinking, connected, error, done }

extension MessageTypeId on MessageType {
  String get id {
    switch (this) {
      case MessageType.message:
        return "MESSAGE";
      case MessageType.audio:
        return "AUDIO";
      case MessageType.thinking:
        return "THINKING";
      case MessageType.connected:
        return "CONNECTED";
      case MessageType.error:
        return "ERROR";
      case MessageType.done:
        return "DONE";
    }
  }
}
