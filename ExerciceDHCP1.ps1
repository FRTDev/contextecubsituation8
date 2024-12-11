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
}else {
    exit
}


Add-DhcpServerv4Scope -Name $nomEtendue -StartRange $premierAdd -EndRange $dernierAdd -SubnetMask $masqueReseau
Set-DhcpServerv4OptionDefinition -OptionId 3 -DefaultValue $passerelle
Set-DhcpServerv4Scope -ScopeId $reseauAdd -Name $nomEtendue -State Active


 


Add-DhcpServerv4Scope -name "$nomEtendue" -StartRange $premierAdd -EndRange $dernierAdd -SubnetMask $masqueReseau -State Active
Set-DhcpServerv4OptionValue -OptionID 3 -Value $passerelle -ScopeID $reseauAdd









<#
- Add-DhcpServerv4Scope : Création de l'étendue

- Add-DhcpServerv4ExclusionRange : Ajouter l'exclusion de certaines adresses dans une étendue

- Set-DhcpServerv4OptionDefinition : Configurer les options comme le DNS, un suffixe DNS, la passerelle par défaut, etc.

- Get-DhcpServerv4Scope : Lister les scopes DHCP
#>

