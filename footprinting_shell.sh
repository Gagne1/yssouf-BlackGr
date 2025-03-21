#!/bin/bash

# Vérification des arguments s'ils existent
if [ "$#" -ne 1 ]; then
    echo "Utilisation: $0 <domaine-cible>"
    exit 1
fi

cible=$1
rep_principal="footprinting"
rep_sorti="$rep_principal/footprinting_$cible"
mkdir -p "$rep_sorti"

echo -e "\033[1;34m[+] Début du footprinting pour $cible\033[0m"

# 1. Recherche DNS de base
echo -e "\033[1;32m[+] Recherche DNS (nslookup/dig)...\033[0m"
nslookup $cible > "$rep_sorti/dns_nslookup.txt"
dig $cible ANY > "$rep_sorti/dns_dig.txt"

# 2. Analyse DNS  avec dnsrecon
echo -e "\033[1;32m[+] Analyse dnsrecon...\033[0m"
dnsrecon -d $cible > "$rep_sorti/dnsrecon.txt" 2>/dev/null

# 3. Recherche WHOIS
echo -e "\033[1;32m[+] Recherche WHOIS...\033[0m"
whois $cible > "$rep_sorti/whois.txt"

# 4. Récupération d'informations avec theHarvester c'est a dire les emais,reseaux sociaux et hotes associés
echo -e "\033[1;32m[+] Collecte de données avec theHarvester...\033[0m"
theHarvester -d $cible -b all -f "$rep_sorti/theharvester" >/dev/null 2>&1

# 5. Énumération des sous-domaines
echo -e "\033[1;32m[+] Recherche de sous-domaines...\033[0m"
sublist3r -d $cible -o "$rep_sorti/sublist3r.txt" >/dev/null 2>&1

# 6. Scan de ports
echo -e "\033[1;32m[+] Scan de ports...\033[0m"
nmap -F -T3 $cible > "$rep_sorti/nmap_scan.txt"

# 7. Vérification SSL/TLS
echo -e "\033[1;32m[+] Vérification SSL/TLS...\033[0m"
openssl s_client -connect $cible:443 -showcerts < /dev/null 2>/dev/null > "$rep_sorti/ssl_certificates.txt"

# 8. Recherche de répertoires
echo -e "\033[1;32m[+] Recherche de répertoires...\033[0m"
gobuster dir -u https://$cible -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -t 30 -o "$rep_sorti/gobuster.txt" >/dev/null 2>&1

# 9. Téléchargement de l'index
echo -e "\033[1;32m[+] Téléchargement de l'index...\033[0m"
curl -s -L $cible > "$rep_sorti/index.html"

echo -e "\033[1;34m\n[+] Footprinting terminé. Résultats dans: $rep_sorti/\033[0m"
