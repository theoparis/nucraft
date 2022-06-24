export def authenticate [
  username,
  password,
] {
  post -t application/json $"($env.MOJANG_AUTH_SERVER)/authenticate" {
    username: $username, password: $password,
    agent: {
      name: "Minecraft",
      version: 1
    }
  }
}
