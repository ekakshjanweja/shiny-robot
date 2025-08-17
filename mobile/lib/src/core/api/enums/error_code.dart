enum ErrorCode {
  unknownError,
  invalidInput,
  unAuthorized,
  internalServerError,
  authError,
}

extension ErrorCodeId on ErrorCode {
  String get id {
    switch (this) {
      case ErrorCode.unknownError:
        return "UNKNOWN_ERROR";
      case ErrorCode.invalidInput:
        return "INVALID_INPUT";
      case ErrorCode.unAuthorized:
        return "UNAUTHORIZED";
      case ErrorCode.internalServerError:
        return "INTERNAL_SERVER_ERROR";
      case ErrorCode.authError:
        return "AUTH_ERROR";
    }
  }
}

extension ErrorCodeMessage on ErrorCode {
  String get message {
    switch (this) {
      case ErrorCode.unknownError:
        return "An unknown error occurred. Please try again later.";
      case ErrorCode.invalidInput:
        return "The input provided is invalid. Please check and try again.";
      case ErrorCode.unAuthorized:
        return "You are not authorized to perform this action. Please log in again.";
      case ErrorCode.internalServerError:
        return "An internal server error occurred. Please try again later.";
      case ErrorCode.authError:
        return "Authentication error. Please check your credentials and try again.";
    }
  }
}
