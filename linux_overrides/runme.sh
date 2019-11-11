pacman -S --noconfirm dnsmasq unbound llvm lldb
unbound-anchor -a /etc/unbound/root.key
systemctl enable unbound
systemctl enable dnsmasq