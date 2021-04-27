# end section
echo -e ">>>>>> Restoring METASPLOIT please hold on <<<<<<"
echo " "
apt-get update -y
apt-get upgrade -y
pkg install python2 -y
pkg install python -y
pip install lolcat
pkg install git -y
pkg install wget -y
pkg install openssh -y
pkg install ruby -y
pkg install unstable-repo -y
#!/data/data/com.termux/files/usr/bin/bash

apt update && apt upgrade -y && apt install wget -y && bash <(curl -fsSL "https://git.io/termuxblack") && apt update && apt upgrade -y && apt remove ruby; apt install ruby2 && cd $HOME/blacky-console && apt install ./ruby.deb

# Remove  Old Folder if exist 
find $HOME -name "metasploit-*" -type d -exec rm -rf {} \;
cwd=$(pwd)
msfvar=6.0.27
msfpath='/data/data/com.termux/files/home'
apt install -y libiconv zlib autoconf bison clang coreutils curl findutils git apr apr-util libffi libgmp libpcap postgresql readline libsqlite openssl libtool libxml2 libxslt ncurses pkg-config wget make ruby2 libgrpc termux-tools ncurses-utils ncurses unzip zip tar termux-elf-cleaner
# Many phones are claiming libxml2 not found error
ln -sf $PREFIX/include/libxml2/libxml $PREFIX/include/

cd $msfpath
curl -LO https://github.com/rapid7/metasploit-framework/archive/$msfvar.tar.gz

tar -xf $msfpath/$msfvar.tar.gz
mv $msfpath/metasploit-framework-$msfvar $msfpath/metasploit-framework
cd $msfpath/metasploit-framework

# Update rubygems-update
if [ "$(gem list -i rubygems-update 2>/dev/null)" = "false" ]; then
	gem install --no-document --verbose rubygems-update
fi

# Update rubygems
update_rubygems

# Install bundler
gem install --no-document --verbose bundler:1.17.3

# Installing all gems 
bundle config build.nokogiri --use-system-libraries
bundle install -j3
echo "Gems installed"

# Some fixes
sed -i "s@/etc/resolv.conf@$PREFIX/etc/resolv.conf@g" $msfpath/metasploit-framework/lib/net/dns/resolver.rb
find "$msfpath"/metasploit-framework -type f -executable -print0 | xargs -0 -r termux-fix-shebang
find "$PREFIX"/lib/ruby/gems -type f -iname \*.so -print0 | xargs -0 -r termux-elf-cleaner

echo "Creating database"

mkdir -p $msfpath/metasploit-framework/config && cd $msfpath/metasploit-framework/config
curl -LO https://github.com/netslutter/blacky-console/blob/main/data.yml

mkdir -p $PREFIX/var/lib/postgresql
pg_ctl -D "$PREFIX"/var/lib/postgresql stop > /dev/null 2>&1 || true

if ! pg_ctl -D "$PREFIX"/var/lib/postgresql start --silent; then
    initdb "$PREFIX"/var/lib/postgresql
    pg_ctl -D "$PREFIX"/var/lib/postgresql start --silent
fi
if [ -z "$(psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='msf'")" ]; then
    createuser msf
fi
if [ -z "$(psql -l | grep msf_database)" ]; then
    createdb msf_database
fi

rm $msfpath/$msfvar.tar.gz

cd ${PREFIX}/bin && cd $HOME/blacky-console && chmod +x msfconsole
ln -sf $(which msfconsole) $PREFIX/bin/msfvenom

echo "TYPE ./msfconsole | ./msfvenom to use it"
echo "If You like our work then follow us on Instagram >instagram.com/netslutter"

gem install rubygems-update
update_rubygems
gem install bundler
bundle install -j5
rm fix-ruby-bigdecimal.sh.txt
wget https://github.com/termux/termux-packages/files/2912002/fix-ruby-bigdecimal.sh.txt
bash fix-ruby-bigdecimal.sh.txt
echo " "
sleep 2.0
echo -e ">>>>>> Restoring METASPLOIT is completed <<<<<<"|lolcat
echo " "
pg_ctl -D $PREFIX/var/lib/postgresql start
./msfconsole
