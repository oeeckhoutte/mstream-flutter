class Server {
  final String url;
  final String nickname;
  final String username;
  final String password;
  final String jwt;
  final String localname;

  Server(this.url, this.nickname, this.username, this.password, this.jwt, this.localname);

  Server.fromJson(Map<String, dynamic> json)
      : url = json['url'],
        jwt = json['jwt'],
        username = json['username'],
        password = json['password'],
        localname = json['localname'],
        nickname = json['nickname'];

  Map<String, dynamic> toJson() =>
    {
      'url': url,
      'jwt': jwt,
      'nickname': nickname,
      'username': username,
      'password': password,
      'localname': localname,
    };
}
