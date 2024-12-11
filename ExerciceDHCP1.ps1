<#
==========================================================================
Description : Gérer le service DHCP

Auteur : Noah Froment
Date : 11/12/2024

Version : 1
==========================================================================
#>


$nomEtendue = [string](Read-Host "Le nom de l'étendue")
$reseauAdd = [ipaddress](Read-Host "L'adresse IP du réseau")
$masqueReseau = [ipaddress](Read-Host "Le masque du réseau")
$passerelle = [ipaddress](Read-Host "La passerelle du réseau")
$premierAdd = [ipaddress](Read-Host "Le premier Host du réseau")
$dernierAdd = [ipaddress](Read-Host "Le dernier host du réseau")

Write-Output "
--------------------------------------------------------------
Voici les informations de l'étendue que vous voulez ajouter !

            Nom de l'étendue : $nomEtendue

            Adresse Réseau : $reseauAdd
            Masque : $masqueReseau
            Passerelle :$passerelle

            Premier Hôte : $premierAdd
            Dernier Hôte : $dernierAdd

--------------------------------------------------------------
                    Ajouter ? y/n
"

if ([string](Read-Host) -eq "y"){
    Write-Output "Ajout de l'étendue en cours ..."
    Add-DhcpServerv4Scope -name $nomEtendue -StartRange $premierAdd -EndRange $dernierAdd -SubnetMask $masqueReseau -State Active
    Set-DhcpServerv4OptionValue -Router $passerelle
} else {
    exit
}