class SearchTicketRequest {
  final int eventId;

  SearchTicketRequest({required this.eventId});

  Map<String, dynamic> toJson() {
    return {
      'event': {
        'event_id': eventId,
      },
    };
  }
}

class SearchEventRequest {
  final String name;

  SearchEventRequest({required this.name});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class SearchUserRequest {
  final String email;

  SearchUserRequest({required this.email});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}
