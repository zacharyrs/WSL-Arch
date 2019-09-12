pacman -S --noconfirm dnsmasq unbound
unbound-control-setup
unbound-anchor -a /etc/unbound/root.key
systemctl enable unbound
