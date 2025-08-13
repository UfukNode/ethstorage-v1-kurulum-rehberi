#!/bin/bash

# EthStorage Trusted Setup Ceremony Otomatik Kurulum Scripti
# Kullanım: bash ethstorage_ceremony.sh

set -e 

# Renkli çıktılar için
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}======================================${NC}"
    echo -e "${BLUE} UFUKDEGEN TARAFINDAN HAZIRLANMIŞTIR  ${NC}"
    echo -e "${BLUE}======================================${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

wait_user() {
    echo ""
    echo -e "${YELLOW}Devam etmek için Enter tuşuna basın...${NC}"
    read
}

check_github_requirements() {
    print_info "GitHub hesap gereksinimlerinizi kontrol edin:"
    echo "• En az 1 aylık hesap"
    echo "• En az 1 genel repo"
    echo "• En az 5 kişiyi takip etmek"
    echo "• En az 1 takipçi"
    echo ""
    echo -e "${YELLOW}Bu gereksinimleri karşılıyor musunuz? (y/n):${NC}"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        print_error "Önce GitHub hesabınızı gereksinimlerine uygun hale getirin!"
        exit 1
    fi
}

install_dependencies() {
    print_info "Sistem güncelleniyor ve gerekli paketler kuruluyor..."
    sudo apt-get update && sudo apt-get upgrade -y
    sudo apt install curl screen iptables build-essential git wget lz4 jq make gcc nano automake autoconf tmux htop nvme-cli libgbm1 pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip ca-certificates -y
    print_success "Sistem paketleri kuruldu"
}

# buraya NVM kontrolü ekledim NVM kurulu sunucularda hata verip yarıda kesiliyor
install_nvm() {
    print_info "NVM kontrol ediliyor..."
    export NVM_DIR="$HOME/.nvm"

    if [ -d "$NVM_DIR" ]; then
        print_success "NVM zaten kurulu, shell'e yükleniyor..."
    else
        print_info "NVM kuruluyor..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        print_success "NVM kuruldu"
    fi

    # NVM'i mevcut shell'e yükle
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

# aynı şekilde buraya kontrolü ekledim
install_nodejs() {
    print_info "Node.js kontrol ediliyor..."
    if command -v node >/dev/null 2>&1; then
        print_success "Node.js zaten kurulu: $(node -v)"
    else
    print_info "Node.js 18 kuruluyor..."
    # NVM'in yüklü olduğundan emin ol
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        
    nvm install 18
    nvm use 18
    nvm alias default 18
    
    print_success "Node.js 18 kuruldu"
    fi
}

setup_ceremony() {
    print_info "Ceremony klasörü oluşturuluyor..."
    mkdir -p ~/trusted-setup-tmp
    cd ~/trusted-setup-tmp
    print_success "Klasör oluşturuldu: ~/trusted-setup-tmp"
    
    print_info "Phase2CLI kuruluyor..."
    npm install -g @p0tion/phase2cli
    print_success "Phase2CLI kuruldu"
}

github_auth() {
    print_info "GitHub kimlik doğrulaması başlatılıyor..."
    echo ""
    echo -e "${YELLOW}1. Terminal'de gösterilen kodu kopyalayın${NC}"
    echo -e "${YELLOW}2. https://github.com/login/device adresine gidin${NC}"
    echo -e "${YELLOW}3. Kodu yapıştırın ve 'Authorize ethstorage' butonuna tıklayın${NC}"
    echo ""
    wait_user
    
    cd ~/trusted-setup-tmp
    phase2cli auth
    
    print_success "GitHub kimlik doğrulaması tamamlandı"
}

start_ceremony() {
    print_info "Ceremony başlatılıyor..."
    echo ""
    echo -e "${YELLOW}Screen oturumu açılıyor. Ceremony saatlerce sürebilir.${NC}"
    echo -e "${YELLOW}Screen komutları:${NC}"
    echo "• Screen'den çıkmak: Ctrl+A+D"
    echo "• Screen'e girmek: screen -r ceremony"
    echo "• Ceremony'i durdurmak: Ctrl+C"
    echo ""
    wait_user
    
    cd ~/trusted-setup-tmp
    
    # Screen oturumu içinde ceremony başlat
    screen -dmS ceremony bash -c "
        echo 'Ceremony başlıyor...';
        echo 'Rastgele değer için Enter, manuel için istediğiniz karakterleri girin';
        phase2cli contribute -c ethstorage-v1-trusted-setup-ceremony;
        echo 'Ceremony tamamlandı! Bu pencereyi kapatabilirsiniz.';
        exec bash
    "
    
    print_success "Ceremony başlatıldı!"
    echo ""
    echo -e "${GREEN}Screen oturumu 'ceremony' adıyla açıldı${NC}"
    echo -e "${BLUE}Kuyruktaki sıranızı takip etmek için: ${YELLOW}screen -r ceremony${NC}"
    echo -e "${BLUE}Bağlantı kopması durumunda yukarıdaki komutu kullanın${NC}"
}

show_final_instructions() {
    echo ""
    echo -e "${GREEN}================================${NC}"
    echo -e "${GREEN} KURULUM TAMAMLANDI!${NC}"
    echo -e "${GREEN}================================${NC}"
    echo ""
    echo -e "${YELLOW}Ceremony durumu için:${NC}"
    echo "screen -r ceremony"
    echo ""
    echo -e "${YELLOW}Eğer ceremony durursa:${NC}"
    echo "1. screen -r ceremony"
    echo "2. cd ~/trusted-setup-tmp"
    echo "3. phase2cli contribute -c ethstorage-v1-trusted-setup-ceremony"
    echo ""
    echo -e "${YELLOW}Screen komutları:${NC}"
    echo "• Screen'den çıkmak: Ctrl+A+D"
    echo "• Aktif screen'ler: screen -ls"
    echo "• Screen silmek: screen -XS ceremony quit"
    echo ""
    echo -e "${GREEN}Ceremony tamamlandığında sosyal medyada paylaşım yapıp etiket yapmayı unutmayın.${NC}"
}

# Ana fonksiyon
main() {
    print_header
    
    check_github_requirements
    
    print_info "Kurulum başlıyor..."
    sleep 2
    
    install_dependencies
    install_nvm
    install_nodejs
    setup_ceremony
    
    echo ""
    print_info "Şimdi GitHub kimlik doğrulaması yapılacak..."
    github_auth
    
    echo ""
    print_info "Son adım: Ceremony başlatılıyor..."
    start_ceremony
    
    show_final_instructions
}

# Script'i çalıştır
main "$@"
