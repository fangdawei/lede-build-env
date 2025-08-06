FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y ca-certificates

RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak

RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-security main restricted universe multiverse" >> /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y sudo zsh curl git iputils-ping

ENV USER="david"
ENV PASSWD="david"

RUN useradd -m ${USER} && echo "${USER}:${PASSWD}" | chpasswd

RUN usermod -aG sudo ${USER}

RUN echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ${USER}
WORKDIR /home/${USER}

ENV GIT_USER="fangdawei"
ENV GIT_EMAIL="fangdawei.www@gmail.com"

RUN git config --global user.name ${GIT_USER} && \
    git config --global user.email ${GIT_EMAIL}

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

RUN git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

RUN sed -i 's/^plugins=.*/plugins=(git zsh-autosuggestions)/' ~/.zshrc

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

RUN echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections && \ 
    echo "msmtp msmtp/use_apparmor boolean true" | sudo debconf-set-selections && \
    echo "tzdata tzdata/Areas select Asia" | sudo debconf-set-selections && \
    echo "tzdata tzdata/Zones/Asia select Shanghai" | sudo debconf-set-selections

RUN sudo apt update -y && sudo apt full-upgrade -y

RUN sudo apt install -y tzdata ack antlr3 asciidoc autoconf automake autopoint binutils bison build-essential \
bzip2 ccache clang cmake cpio curl device-tree-compiler flex gawk gcc-multilib g++-multilib gettext \
genisoimage git gperf haveged help2man intltool libc6-dev-i386 libelf-dev libfuse-dev libglib2.0-dev \
libgmp3-dev libltdl-dev libmpc-dev libmpfr-dev libncurses5-dev libncursesw5-dev libpython3-dev \
libreadline-dev libssl-dev libtool llvm lrzsz msmtp ninja-build p7zip p7zip-full patch pkgconf \
python3 python3-pyelftools python3-setuptools qemu-utils rsync scons squashfs-tools subversion \
swig texinfo uglifyjs upx-ucl unzip vim wget xmlto xxd zlib1g-dev