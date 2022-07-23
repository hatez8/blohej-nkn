apt update -y
apt-mark hold linux-image-generic linux-headers-generic openssh-server
apt upgrade -y
apt -y install unzip vnstat htop screen mc

username="nkn"
benaddress="NKNSFptfVAZL5hyxmzimM8hbiRkFXyuBC5Wo"
config="http://blohejmining.ru/myblohej-nkn/config.tar"
keys="http://blohejmining.ru/myblohej-nkn/blonode115.tar"

useradd -m -p "pass" -s /bin/bash "$username" > /dev/null 2>&1
usermod -a -G sudo "$username" > /dev/null 2>&1

printf "Downloading........................................... "
cd /home/$username > /dev/null 2>&1
wget --quiet --continue --show-progress https://commercial.nkn.org/downloads/nkn-commercial/linux-amd64.zip > /dev/null 2>&1
printf "DONE!\n"

printf "Installing............................................ "
unzip linux-amd64.zip > /dev/null 2>&1
mv linux-amd64 nkn-commercial > /dev/null 2>&1
chown -c $username:$username nkn-commercial/ > /dev/null 2>&1
/home/$username/nkn-commercial/nkn-commercial -b $benaddress -d /home/$username/nkn-commercial/ -u $username install > /dev/null 2>&1
printf "DONE!\n"
printf "sleep 180"

sleep 180

DIR="/home/$username/nkn-commercial/services/nkn-node/"

systemctl stop nkn-commercial.service > /dev/null 2>&1
sleep 20
cd $DIR > /dev/null 2>&1
rm wallet.json > /dev/null 2>&1
rm wallet.pswd > /dev/null 2>&1
rm config.json > /dev/null 2>&1
rm -Rf ChainDB > /dev/null 2>&1
wget -O - "$keys" -q --show-progress | tar -xf -
wget -O - "$config" -q --show-progress | tar -xf -
chown -R $username:$username wallet.* > /dev/null 2>&1
chown -R $username:$username config.* > /dev/null 2>&1
printf "Downloading.......................................... DONE!\n"
systemctl start nkn-commercial.service > /dev/null 2>&1
