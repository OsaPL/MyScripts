timestamp="$(date +"%Y-%m-%d--%H-%M-%S")"
sudo systemctl stop mcServer

mkdir ../mcBackups/$timestamp

tar cf - --exclude=web --exclude=logs --exclude=cache --exclude=crash-reports . | (cd "../mcBackups/$timestamp" && tar xvf - )

sudo systemctl start mcServer