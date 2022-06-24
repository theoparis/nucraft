#!/bin/nu
use src/auth.nu [ authenticate ]

def main [
  --mcjar: string,
  --mainclass: string,
] {
  let-env MOJANG_AUTH_SERVER = "https://authserver.mojang.com"

  let access_token = (authenticate $env.MINECRAFT_USERNAME $env.MINECRAFT_PASSWORD | get accessToken)

  echo $access_token | save token.txt

  mkdir run
  cd run
  java -cp $mcjar $mainclass --version 1.19 --accessToken $access_token
}
