dirs=($(find /serverdata/steamServers/starbound/steamapps/workshop/content/211820/* -type d))
for dir in "${dirs[@]}"; do
  (cd "$dir"
  echo ${PWD##*/}
  cp -f ./contents.pak /serverdata/steamServers/starbound/mods/${PWD##*/}.pak )
done