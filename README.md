# GNU Tools Built for macOS Mojave 10.14.6 18G9323 x86_64

## Preamble

Unfortunately/unsurprisingly Homebrew no longer works for Mojave, though some of us for whatever reason still want to use GNU Tools and other things in that operating system.

I specifically use a Mojave laptop as a print server for a Canon printer which only has drivers for some version of Windows and Mojave. I'd like some basic GNU tools for this old thing, so I compiled my own.

I'm releasing the binaries, but I'm probably never going to recompile them. You can follow my instructions if you want to build your own.

## How To Use

This installs everything in `/opt`, I did this to keep all of this completely separate from the base files. You can try putting stuff elsewhere, your mileage may vary.

### Option 1: Easy

* Clone the repo
* Run `pre-install.sh` script, don't run as root/sudo.
* Move everything from the clone into `/opt`
* Run `post-install.sh` script, again not as root/sudo.
* Open a new terminal.

### Option 2: DIY

Follow my instructions below and build everything yourself. Harder and takes WAY longer, better for DIY folks or people who are trying to get this going for older versions which homebrew does not support.

## Bash Note

If you want to use the included bash, you can edit the `/etc/shells` file. Don't do this before you install or... well I'm not actually sure what will happen, but I don't expect it'll be good.

```bash
echo "/opt/bin/bash" | sudo tee -a /etc/shells
chsh -s /opt/bin/bash
```

Then next time you open a terminal it'll be using the `/opt/bin/bash` shell.

## .bashrc / .profile

There's some difference as to when macOS uses one or the other. As far as I can tell it uses `.profile` for terminal sessions and ssh'ing into the host. It uses `.bashrc` if you use screen. My workaround is just adding `source ~/.profile` to the `.bashrc` file. You could also symlink them or whatever.

I also like to add some nice-to-haves in mine.

```bash
# Parses the git brach, if there is one.
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Parses term or tty
# I use this to determine if I'm in a screen or logged in
parse_term_or_tty() {
    if [ $STY ]
    then
        echo " [$STY]"
    else
        echo " [$TERM]"
    fi
}

# Custom PS1 prompt      
#                         +-- terminal or tty name
#                         V
# pjobson@macprintserver [xterm-256color]
# ~/code/project (main) $ 
#                ^
#                +-- branch name
export PS1="\[$(tput setaf 2)\]\u\[$(tput setaf 7)\]@\[$(tput setaf 165)\]\h\e[31m\]\$(parse_term_or_tty)\n\[\e[94m\]\w\[\e[m\]\[\e[33m\]\$(parse_git_branch)\[\e[m\] \\$ "
```

## Setup

Run my `pre-install.sh` and `post-install.sh` scripts or do it manually.

### Pre-Install

```bash
xcode-select --install

sudo mkdir -p /opt

mkdir -p ~/.local/bin
mkdir ~/code
cd ~/code

# Add to ~/.profile
echo "export DYLD_LIBRARY_PATH=/opt/lib" >> ~/.profile
echo "export LD_LIBRARY_PATH=/opt/lib" >> ~/.profile
echo "export PATH=/opt/bin:\$PATH" >> ~/.profile

source ~/.profile

echo "source ~/.profile" >> ~/.bashrc
```

### Post-Install

```bash
echo "MANDATORY_MANPATH /opt/share/man" >> ~/.manpath

echo "export SSL_CERT_FILE=/opt/ssl/certs/cacert.pem" >> ~/.profile

sudo ln -s /opt/bin/wget2 /opt/bin/wget

sudo ln -sf libtoolize /opt/bin/glibtoolize
sudo ln -sf libtoolize ~/.local/bin/glibtoolize

ln -sf /opt/bin/libtoolize ~/.local/bin/glibtoolize
ln -sf /opt/bin/libtool    ~/.local/bin/glibtool

sudo ln -s /opt/bin/python3.14 /opt/bin/python
sudo ln -s /opt/bin/python3.14 /opt/bin/python3

source ~/.profile
```

## M4-1.4.21

```bash
curl -O https://mirror.team-cymru.com/gnu/m4/m4-1.4.21.tar.gz
tar xzvf m4-1.4.21.tar.gz
cd ~/code/m4-1.4.21
./configure --prefix=/opt
make -j"$(sysctl -n hw.ncpu)"
sudo make install
cd ~/code
rm -rf m4*
```

## Ncurses-6.6

```bash
curl -O https://ftp.gnu.org/gnu/ncurses/ncurses-6.6.tar.gz
tar xzvf ncurses-6.6.tar.gz
cd ~/code/ncurses-6.6
./configure --prefix=/opt \
  --with-shared \
  --with-cxx-shared
make -j"$(sysctl -n hw.ncpu)"
sudo make install
cd ~/code
rm -rf ncurses*
```

## Bash-5.3

```bash
curl -O https://ftp.gnu.org/gnu/bash/bash-5.3.tar.gz
tar xzvf bash-5.3.tar.gz
cd bash-5.3
./configure --prefix=/opt
make -j"$(sysctl -n hw.ncpu)"
sudo make install
cd ~/code
rm -rf bash*
```

## Autoconf-2.72e

```bash
curl -O https://alpha.gnu.org/pub/gnu/autoconf/autoconf-2.72e.tar.gz
tar xzvf autoconf-2.72e.tar.gz
cd autoconf-2.72e
./configure --prefix=/opt
make -j"$(sysctl -n hw.ncpu)"
sudo make install
cd ~/code
rm -rf autoconf*
```

## gettext-1.0

```bash
curl -O https://ftp.gnu.org/pub/gnu/gettext/gettext-1.0.tar.gz
tar xzvf gettext-1.0.tar.gz
cd gettext-1.0
./configure --prefix=/opt
make -j"$(sysctl -n hw.ncpu)"
sudo make install
cd ~/code
rm -rf gettext*
```

## Libtool-2.5.4

```bash
curl -O https://mirror.cs.odu.edu/gnu/libtool/libtool-2.5.4.tar.gz
tar xzvf libtool-2.5.4.tar.gz
cd libtool-2.5.4
./configure --prefix=/opt
make -j"$(sysctl -n hw.ncpu)"
sudo make install
sudo ln -sf libtoolize /opt/bin/glibtoolize
sudo ln -sf libtoolize ~/.local/bin/glibtoolize
cd ~/code
rm -rf libtool*
```

## Automake-1.18

```bash
curl -O https://ftp.gnu.org/gnu/automake/automake-1.18.tar.gz
tar xzvf automake-1.18.tar.gz
cd automake-1.18
./configure --prefix=/opt
make -j"$(sysctl -n hw.ncpu)"
sudo make install
cd ~/code
rm -rf automake*
```

## XZ-5.8.3

```bash
curl https://codeload.github.com/tukaani-project/xz/zip/refs/tags/v5.8.3 -o xz-5.8.3.zip
unzip xz-5.8.3.zip
cd xz-5.8.3/
./autogen.sh
./configure --prefix=/opt
make -j"$(sysctl -n hw.ncpu)"
sudo make install
cd ~/code
rm -rf xz*
```

## Texinfo-7.3

```bash
curl -O https://ftp.gnu.org/gnu/texinfo/texinfo-7.3.tar.gz
tar xzvf texinfo-7.3.tar.gz
cd texinfo-7.3
./configure --prefix=/opt
make -j"$(sysctl -n hw.ncpu)"
sudo make install
cd ~/code
rm -rf texinfo*
```

## OpenSSL-4.0

```bash
curl https://codeload.github.com/openssl/openssl/zip/refs/tags/openssl-4.0.0 -o openssl-4.0.0.zip
unzip openssl-4.0.0.zip
cd openssl-openssl-4.0.0
# Note: Configure script uses capital C
./Configure --prefix=/opt
make -j"$(sysctl -n hw.ncpu)"
sudo make install
cd ~/code
rm -rf openssl*

mkdir -p /opt/ssl/certs
curl -O https://curl.se/ca/cacert.pem
sudo mv cacert.pem /opt/ssl/certs/
echo "export SSL_CERT_FILE=/opt/ssl/certs/cacert.pem" >> ~/.profile
source ~/.profile
```

## Libpcre2-10.47

```bash
curl https://codeload.github.com/PCRE2Project/pcre2/zip/refs/tags/pcre2-10.47 -o pcre2-10.47.zip
unzip pcre2-10.47.zip
cd pcre2-pcre2-10.47/
./autogen.sh
./configure --prefix=/opt
make -j"$(sysctl -n hw.ncpu)"
sudo make install
cd ~/code
rm -rf pcre2*
```

## Wget2-2.2.1

```bash
curl -O https://ftp.gnu.org/gnu/wget/wget2-2.2.1.tar.gz
tar xzvf wget2-2.2.1.tar.gz
cd wget2-2.2.1
CPPFLAGS='-I/opt/include' \
  LDFLAGS='-L/opt/lib -Wl,-rpath,/opt/lib' \
  ./configure --prefix=/opt \
    --with-ssl=openssl
make -j"$(sysctl -n hw.ncpu)"
sudo make install
sudo ln -s /opt/bin/wget2 /opt/bin/wget
cd ~/code
rm -rf wget*
```

## Coreutils-9.11

```bash
curl -O https://ftp.gnu.org/gnu/coreutils/coreutils-9.11.tar.gz
tar xzvf coreutils-9.11.tar.gz
cd coreutils-9.11
./bootstrap
# ignore warning
./configure --prefix=/opt
make -j"$(sysctl -n hw.ncpu)"
sudo make install
cd ~/code
rm -rf coreutils*
```

## Binutils-2.46.0

*As Needed*

```bash
curl -O https://ftp.gnu.org/gnu/binutils/binutils-2.46.0.tar.gz
tar xzvf binutils-2.46.0.tar.gz
cd binutils-2.46.0
./configure --prefix=/opt
make -j"$(sysctl -n hw.ncpu)"
sudo make install
cd ~/code
rm -rf binutils*
```

These should be moved to gnu-* unless specifically needed, they can cause things to not compile properly below.

```bash
sudo mv /opt/bin/addr2line /opt/bin/gnu-addr2line
sudo mv /opt/bin/ar        /opt/bin/gnu-ar
sudo mv /opt/bin/c++filt   /opt/bin/gnu-c++filt
sudo mv /opt/bin/nm        /opt/bin/gnu-nm
sudo mv /opt/bin/objcopy   /opt/bin/gnu-objcopy
sudo mv /opt/bin/objdump   /opt/bin/gnu-objdump
sudo mv /opt/bin/ranlib    /opt/bin/gnu-ranlib
sudo mv /opt/bin/readelf   /opt/bin/gnu-readelf
sudo mv /opt/bin/size      /opt/bin/gnu-size
sudo mv /opt/bin/strings   /opt/bin/gnu-strings
sudo mv /opt/bin/strip     /opt/bin/gnu-strip
```

## Curl-8.20.0

```bash
curl https://codeload.github.com/curl/curl/zip/refs/tags/curl-8_20_0 -o curl-8.20.0.zip
unzip curl-8.20.0.zip
cd curl-curl-8_20_0/
autoreconf -fi
CPPFLAGS='-I/opt/include' \
  LDFLAGS='-L/opt/lib -Wl,-rpath,/opt/lib' \
  ./configure --prefix=/opt \
    --with-openssl=/opt \
    --without-libpsl --without-libssh2 \
    --without-libidn2 --without-brotli \
    --without-zstd --without-nghttp2
make -j"$(sysctl -n hw.ncpu)"
sudo make install
cd ~/code
rm -rf curl*
```

## Diffutils-3.12

```bash
curl -O https://ftp.gnu.org/gnu/diffutils/diffutils-3.12.tar.gz
tar xzvf diffutils-3.12.tar.gz
cd diffutils-3.12
./configure --prefix=/opt
make -j"$(sysctl -n hw.ncpu)"
sudo make install
cd ~/code
rm -rf diffutils*
```

## Git-2.54.0

```bash
curl https://codeload.github.com/git/git/zip/refs/tags/v2.54.0 -o git-2.54.0.zip
unzip git-2.54.0.zip
cd git-2.54.0/
autoreconf -fi
./configure --prefix=/opt
make -j"$(sysctl -n hw.ncpu)"
sudo make install
cd ~/code
rm -rf git*
```

## OpenSSH-10.3p1

```bash
curl -O https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-10.3p1.tar.gz
tar xzvf openssh-10.3p1.tar.gz
cd openssh-10.3p1/
CPPFLAGS='-I/opt/include' \
  LDFLAGS='-L/opt/lib -Wl,-rpath,/opt/lib' \
  ./configure --prefix=/opt \
    --with-openssl=/opt
make -j"$(sysctl -n hw.ncpu)"
sudo make install
cd ~/code
rm -rf openssh*
```

## Findutils-4.10.0

```bash
curl -O https://ftp.gnu.org/gnu/findutils/findutils-4.10.0.tar.xz
tar xvf findutils-4.10.0.tar.xz
cd findutils-4.10.0/
./configure --prefix=/opt
make -j"$(sysctl -n hw.ncpu)"
sudo make install
sudo /opt/bin/updatedb
cd ~/code
rm -rf findutils*
```

## Gawk-5.4.0

```bash
curl -O https://ftp.gnu.org/gnu/gawk/gawk-5.4.0.tar.gz
tar xzvf gawk-5.4.0.tar.gz
cd gawk-5.4.0
./configure --prefix=/opt
make -j"$(sysctl -n hw.ncpu)"
sudo make install
cd ~/code
rm -rf gawk*
```

## Grep-3.12

```bash
curl -O https://ftp.gnu.org/gnu/grep/grep-3.12.tar.gz
tar xzvf grep-3.12.tar.gz
cd grep-3.12/
./configure --prefix=/opt
make -j"$(sysctl -n hw.ncpu)"
sudo make install
cd ~/code
rm -rf grep*
```

## Gzip-1.14

```bash
curl -O https://ftp.gnu.org/gnu/gzip/gzip-1.14.tar.gz
tar xzvf gzip-1.14.tar.gz
cd gzip-1.14
./configure --prefix=/opt
make -j"$(sysctl -n hw.ncpu)"
sudo make install
cd ~/code
rm -rf gzip*
```

## Sed-4.10

```bash
curl -O https://ftp.gnu.org/gnu/sed/sed-4.10.tar.gz
tar xzvf sed-4.10.tar.gz
cd sed-4.10/
./configure --prefix=/opt
make -j"$(sysctl -n hw.ncpu)"
sudo make install
cd ~/code
rm -rf sed*
```

## Tar-1.35

```bash
curl -O https://ftp.gnu.org/gnu/tar/tar-1.35.tar.gz
tar xzvf tar-1.35.tar.gz
cd tar-1.35
./configure --prefix=/opt \
  CPPFLAGS='-I/opt/include' \
  LDFLAGS='-L/opt/lib' \
  LIBS='-lintl -liconv'
make -j"$(sysctl -n hw.ncpu)"
sudo make install
cd ~/code
rm -rf tar*
```

## Bison-3.8

```bash
curl -O https://ftp.gnu.org/gnu/bison/bison-3.8.tar.gz
tar xzvf bison-3.8.tar.gz
cd bison-3.8
./configure --prefix=/opt
make -j"$(sysctl -n hw.ncpu)"
sudo make install
cd ~/code
rm -rf bison*
```

## Pkg-config-0.29.2

```bash
curl https://gitlab.freedesktop.org/pkg-config/pkg-config/-/archive/pkg-config-0.29.2/pkg-config-pkg-config-0.29.2.tar.gz?ref_type=tags \
  -o pkg-config-pkg-config-0.29.2.tar.gz
tar xzvf pkg-config-pkg-config-0.29.2.tar.gz
cd pkg-config-pkg-config-0.29.2/
autoreconf -fi
./configure --prefix=/opt --with-internal-glib
make -j"$(sysctl -n hw.ncpu)"
sudo make install
cd ~/code
rm -rf pkg-config*
```

## Util-Linux-2.42

### Note: Partial Install

This only builds the following tools as the rest are not supported in Darwin.

**`/opt/sbin` (15)**

| | | |
|---|---|---|
| blkid | fsck.minix | mkswap |
| cfdisk | mkfs | nologin |
| fdisk | mkfs.bfs | sfdisk |
| findfs | mkfs.cramfs | swaplabel |
| fsck.cramfs | mkfs.minix | wipefs |

**`/opt/bin` (28)**

| | | |
|---|---|---|
| cal | logger | scriptreplay |
| colcrt | look | setpgid |
| colrm | mcookie | setsid |
| column | mesg | ul |
| flock | namei | uuidgen |
| getopt | newgrp | uuidparse |
| hardlink | pg | wall |
| hexdump | rename | whereis |
| isosize | renice | |
| line | rev | |

### Install

```bash
ln -sf /opt/bin/libtoolize ~/.local/bin/glibtoolize
ln -sf /opt/bin/libtool    ~/.local/bin/glibtool

curl https://codeload.github.com/util-linux/util-linux/zip/refs/tags/v2.42 -o util-linux-2.42.zip
unzip util-linux-2.42.zip
cd util-linux-2.42/

#########################################
# patch pidfd-utils.c
#########################################
sed -i.orig '/^#include <sys\/vfs.h>/i\
#ifdef __linux__
' lib/pidfd-utils.c

cat >> lib/pidfd-utils.c <<'EOF'
#else
#include <sys/types.h>
int pfd_is_pidfs(int p __attribute__((unused))) { return 0; }
ino_t pidfd_get_inode(int p __attribute__((unused))) { return 0; }
int ul_get_valid_pidfd_or_err(pid_t p __attribute__((unused)), uint64_t i __attribute__((unused))) { return -1; }
int ul_get_valid_pidfd(pid_t p __attribute__((unused)), uint64_t i __attribute__((unused))) { return -1; }
#endif
EOF
#########################################

./autogen.sh
./configure --prefix=/opt \
  --disable-libmount --disable-asciidoc \
  --enable-line --enable-newgrp --enable-pg
make -j"$(sysctl -n hw.ncpu)"
sudo make install-strip
cd ~/code
rm -rf util-linux*
```

## Screen-5.0.1

```bash
curl -O https://ftp.gnu.org/gnu/screen/screen-5.0.1.tar.gz
tar xzvf screen-5.0.1.tar.gz
cd screen-5.0.1
./configure --prefix=/opt
make -j"$(sysctl -n hw.ncpu)"
sudo make install
echo "alias screen='screen -l'" >> ~/.profile
cd ~/code
rm -rf screen*
```

## Make-4.4

```bash
curl -O https://ftp.gnu.org/gnu/make/make-4.4.tar.gz
tar xzvf make-4.4.tar.gz
cd make-4.4
./configure --prefix=/opt
make -j"$(sysctl -n hw.ncpu)"
sudo make install
cd ~/code
rm -rf make*
```

## GMP-6.3.0 + MPFR-4.2.2 + MPC-1.3.1

```bash
curl -O https://ftp.gnu.org/gnu/gmp/gmp-6.3.0.tar.gz
curl -O https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.2.tar.gz
curl -O https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz

tar xzvf gmp-6.3.0.tar.gz
tar xzvf mpfr-4.2.2.tar.gz
tar xzvf mpc-1.3.1.tar.gz

cd gmp-6.3.0
./configure --prefix=/opt
make -j"$(sysctl -n hw.ncpu)"
sudo make install

cd ~/code/mpfr-4.2.2
./configure --prefix=/opt \
  CPPFLAGS="-I/opt/include" \
  LDFLAGS="-L/opt/lib"
make -j"$(sysctl -n hw.ncpu)"
sudo make install

cd ~/code/mpc-1.3.1
./configure --prefix=/opt \
  CPPFLAGS="-I/opt/include" \
  LDFLAGS="-L/opt/lib"
make -j"$(sysctl -n hw.ncpu)"
sudo make install

mkdir ~/code
rm -rf gmp* mpfr* mpc*
```

## Python-3.14.5

```bash
curl -O https://www.python.org/ftp/python/3.14.5/Python-3.14.5.tgz
tar xzvf Python-3.14.5.tgz
cd Python-3.14.5/

##########################################
# patch _ssl.c
##########################################
sed -i.orig '/^\/\* OpenSSL API 1\.1\.0+ does not include version methods \*\/$/i\
#if OPENSSL_VERSION_NUMBER >= 0x40000000L\
#define OPENSSL_NO_SSL3_METHOD 1\
#define OPENSSL_NO_TLS1_METHOD 1\
#define OPENSSL_NO_TLS1_1_METHOD 1\
#define OPENSSL_NO_TLS1_2_METHOD 1\
#endif
' Modules/_ssl.c

sed -i.bak2 's|^#if defined(SSL3_VERSION) && !defined(OPENSSL_NO_SSL3)$|& \&\& !defined(OPENSSL_NO_SSL3_METHOD)|' Modules/_ssl.c
##########################################

./configure --prefix=/opt \
  --enable-optimizations \
  --with-openssl=/opt \
  --with-openssl-rpath=auto

# ignore errors about missing libraries
make -j"$(sysctl -n hw.ncpu)"
sudo make altinstall

sudo ln -s /opt/bin/python3.14 /opt/bin/python
sudo ln -s /opt/bin/python3.14 /opt/bin/python3

cd ~/code
sudo rm -rf Python*
```

## Perl5-5.42.2

```bash
curl https://codeload.github.com/Perl/perl5/zip/refs/tags/v5.42.2 -o perl5-5.42.2.zip
unzip perl5-5.42.2.zip
cd perl5-5.42.2/
./configure.gnu --prefix=/opt
make -j"$(sysctl -n hw.ncpu)"
sudo make install
cd ~/code
rm -rf perl*
```

## Which-2.23

```bash
curl -O https://ftp.gnu.org/gnu/which/which-2.23.tar.gz
tar xzvf which-2.23.tar.gz
cd which-2.23/
./configure --prefix=/opt
make -j"$(sysctl -n hw.ncpu)"
sudo make install
cd ~/code
rm -rf which*
```

## Htop-3.5.1

```bash
curl https://codeload.github.com/htop-dev/htop/zip/refs/tags/3.5.1 -o htop-3.5.1.zip
unzip htop-3.5.1.zip
cd htop-3.5.1/
./autogen.sh
./configure --prefix=/opt
make -j"$(sysctl -n hw.ncpu)"
sudo make install
sudo ln -s /opt/bin/htop /opt/bin/top
cd ~/code
rm -rf htop*
```

