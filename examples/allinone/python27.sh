yum -y groupinstall "Development tools"
yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel wget

wget http://python.org/ftp/python/2.7.6/Python-2.7.6.tar.xz
tar xf Python-2.7.6.tar.xz
cd Python-2.7.6

./configure --prefix=/usr/local --enable-unicode=ucs4 --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib"
make && make altinstall

cd ..
wget https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py

/usr/local/bin/python2.7 ez_setup.py
/usr/local/bin/easy_install-2.7 pip

/usr/local/bin/pip2.7 install virtualenv

cd /var/lib/tempest
rm -rf .venv
/usr/local/bin/virtualenv .venv
source .venv/bin/activate
python tools/install_venv.py
