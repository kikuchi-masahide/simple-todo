class Token {
  final String token;
  final int id;
  final DateTime limit;
  Token(this.token, this.id, this.limit);
  Token.fromJson(Map<String, dynamic> json)
      : token = json["token"],
        id = json["id"],
        limit = DateTime.tryParse(json["limit"]) as DateTime;
  Map<String, dynamic> toJson() => {
        "token": token,
        "id": id,
        "limit": limit.toString(),
      };
}
